SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- =============================================
-- Author:                         <Author,,Name>
-- Create date: <Create Date,,>
-- Description:   <Description,,>
-- =============================================
--exec wrk.MergeDimCustomertoAccount

CREATE PROCEDURE [wrk].[MergeDimCustomertoAccount]

AS

BEGIN
              SET NOCOUNT ON;
-- EXEC wrk.MergeDimCustomertoContact
----clear last run
TRUNCATE TABLE wrk.customerWorkingList;
TRUNCATE TABLE stg.account;
-- truncate table dbo.account

--Clean up Deleted Accounts via error msg from last run
DELETE 
-- Select * 
FROM dbo.Account
WHERE LastSFDCLoad_Error LIKE '%deleted%'

DELETE a
--SELECT COUNT(*)
FROM dbo.[Account] a
LEFT JOIN USC.dbo.[vwDimCustomer_ModAcctId] b ON [b].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_ACCT_ID]
WHERE b.[DimCustomerId] IS NULL

DELETE a
-- SELECT COUNT(*)
FROM dbo.[Account] a
LEFT JOIN [dbo].[SFDCProcess_DistinctContacts] b ON [b].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_ACCT_ID]
WHERE b.[SSB_CRMSYSTEM_CONTACT_ID] IS NULL

UPDATE a 
SET [salesforce_ID] = [SSB_CRMSYSTEM_ACCT_ID]
FROM dbo.[Account] a
WHERE LEFT([salesforce_ID],18) = LEFT([SSB_CRMSYSTEM_ACCT_ID],18)

UPDATE a
SET [a].[salesforce_ID] = a.[SSB_CRMSYSTEM_ACCT_ID]
FROM dbo.[Account] a
LEFT JOIN USC_Reporting.ProdCopy.[vw_Account] b ON a.[salesforce_ID] = b.[Id]
WHERE LEN([a].[salesforce_ID]) = 18
AND b.id IS null



---******* CLEANING UP OLD GUIDS
-- Identify Acct_IDs no longer existing
SELECT a.SSB_CRMSYSTEM_ACCT_ID Old_Acct_ID, salesforce_id 
INTO #tmpA
FROM dbo.Account a
LEFT JOIN USC.dbo.vwDimCustomer_ModAcctId b ON b.[SSB_CRMSYSTEM_CONTACT_ID] = a.SSB_CRMSYSTEM_ACCT_ID
WHERE b.ssid IS NULL    
--DROP TABLE #tmpA

-- Find the SSIDs affected
SELECT DISTINCT SSID, SourceSystem, b.Old_Acct_ID
INTO #tmpNewSSIDs
FROM [USC].[mdm].[SSB_ID_History] a
INNER JOIN (
SELECT [SSB_CRMSYSTEM_CONTACT_ID] Old_Acct_ID, MAX(b.createddate) CreatedDate 
FROM #tmpA a
INNER JOIN  [USC].[mdm].[SSB_ID_History]  b ON a.Old_Acct_ID = ISNULL(b.ssb_crmsystem_acct_id, b.ssb_crmsystem_contact_id)
GROUP BY [SSB_CRMSYSTEM_CONTACT_ID]
) b ON [SSB_CRMSYSTEM_CONTACT_ID] = b.Old_Acct_ID AND a.createddate = b.CreatedDate

-- Lookup Old AcctID and New AcctID
SELECT DISTINCT Old_Acct_Id, a.SSB_CRMSYSTEM_ACCT_ID New_Acct_Id
INTO #tmpGUIDLookup
--SELECT * 
FROM USC.dbo.vwDimCustomer_ModAcctId a
--WHERE SSID = '1078358:33-31974'
INNER JOIN #tmpNewSSIDs b ON a.SSID = b.SSID AND a.SourceSystem = b.sourceSystem
WHERE a.[SSB_CRMSYSTEM_CONTACT_ID] IS NOT NULL


-- Prep Archive Load
SELECT DISTINCT a.SSB_CRMSYSTEM_ACCT_ID, a.salesforce_id, b.New_Acct_Id, 0 AS Deleted, CAST(0 AS INT) Processed, c.CreatedDate SFDC_CreatedDate, GETDATE() Updated_DateTime 
INTO #tmpGUIDResults
FROM dbo.Account a (NOLOCK)
INNER JOIN #tmpGUIDLookup b ON a.SSB_CRMSYSTEM_ACCT_ID = b.Old_Acct_ID
INNER JOIN USC_Reporting.ProdCopy.Account c (NOLOCK) ON a.salesforce_id = c.id


-- MERGE INTO Archived_Account 
MERGE INTO dbo.Archived_Account AS TARGET
USING #tmpGUIDResults AS Source
ON target.SSB_CRMSYSTEM_ACCT_ID = source.SSB_CRMSYSTEM_ACCT_ID AND target.New_Acct_Id = source.New_Acct_Id
WHEN MATCHED THEN UPDATE SET
TARGET.Updated_DateTime = GETDATE()
, TARGET.Processed = 0
, TARGET.Deleted = 0
WHEN NOT MATCHED THEN INSERT 
(
SSB_CRMSYSTEM_ACCT_ID
, salesforce_id
, New_Acct_id
, Deleted
, Processed
, Updated_DateTime
, SFDC_CreatedDate
)
VALUES
(
SOURCE.SSB_CRMSYSTEM_ACCT_ID
, SOURCE.salesforce_Id
, SOURCE.New_Acct_ID
, 0 -- Deleted
, 0 -- Processed
, GETDATE() --Updated_DateTime
, source.SFDC_CreatedDate
);

-- Delete from dbo.Account to prep for load
DELETE a 
-- Select *
FROM dbo.Account a
INNER JOIN dbo.Archived_Account b ON b.SSB_CRMSYSTEM_ACCT_ID = a.SSB_CRMSYSTEM_ACCT_ID
WHERE b.Deleted = 0
--************//CLEANING UP GUIDs

-- Load Primary Accounts based on date/time
DECLARE @LastLoadDate AS DATETIME, @HourDiff AS INT , @MDMChgCount bigint
DECLARE @DateTable TABLE (
vDate dateTime
)
INSERT INTO @DateTAble (vDate)
SELECT * FROM (SELECT ISNULL(MAX(MDM_UpdatedDate),'1/1/3000') vDate FROM dbo.Account
                                                                        UNION ALL
                                                                        SELECT ISNULL(MAX(SFDC_LoadDate),'1/1/3000') FROM dbo.Account
                                                                        UNION ALL
                                                                        SELECT '1/1/3000') z

SET @LastLoadDate = (SELECT CASE WHEN MIN(vDate) = '1/1/3000' THEN '1/1/1900' ELSE MIN(vDate) END FROM @DateTable)
PRINT @LastLoadDate
SET @HourDiff = -4
SET @LastLoadDate = DateAdd(HOUR,@HourDiff,@LastLoadDate)
SET @MDMChgCount = (SELECT COUNT(Distinct IsNull(SSB_CRMSYSTEM_ACCT_ID,SSB_CRMSYSTEM_CONTACT_ID)) FROM USC.[mdm].[compositerecord] Where UpdatedDate >= @LastLoadDate)
PRINT @MDMChgCount

Truncate Table wrk.CustomerWorkingList

INSERT INTO wrk.customerWorkingList (DimCustomerID, SSB_CRMSYSTEM_ACCT_ID, IsPersonAccount, IsBusinessAccount, MDM_UpdatedDate, SFDCProcess_UpdatedDate, SSID_Winner, SourceSystem)
SELECT   a.dimcustomerid
, a.[SSB_CRMSYSTEM_CONTACT_ID] ssb_crmsystem_acct_id 
, CASE WHEN a.IsBusiness = 1 THEN 0 ELSE 1 END IsPersonAccount
, CASE WHEN a.IsBusiness = 1 THEN 1 ELSE 0 END IsBusinessAccount
, a.UpdatedDate MDM_LastUpdated
, GETDATE() ProcessUpdatedDate
, CASE WHEN a.[SourceSystem] LIKE '%SFDC%' THEN '' 
	ELSE 
        CASE WHEN a.SourceSystem = 'TI USC' THEN 'USC' 
        WHEN a.sourcesystem = 'USC_AdobeForm' THEN 'Adobe'
		WHEN a.sourcesystem = 'USC_Advantage' THEN 'Advantage'
         ELSE 'Unknown' END + ' - ' + a.SSID END SSID_Winner
, a.SourceSystem
--SELECT COUNT(*)
--INTO #tmpTest
from USC.dbo.vwDimCustomer_ModAcctId a
where a.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
--AND a.IsBusiness = 1
AND a.[SSB_CRMSYSTEM_CONTACT_ID] IN (SELECT [SSB_CRMSYSTEM_CONTACT_ID] FROM [dbo].[vwSFDCProcess_DistinctContacts_CriteriaMet])
--AND a.UpdatedDate >= @LastLoadDate
--AND a.SSB_CRMSYSTEM_ACCT_ID IN (SELECT Distinct ISNULL(SSB_CRMSYSTEM_ACCT_ID,SSB_CRMSYSTEM_CONTACT_ID) FROM PSP.mdm.compositerecord  WHERE UpdatedDate >= @LastLoadDate)
AND a.SourceSystem NOT LIKE '%Lead%'
--AND a.SSB_CRMSYSTEM_ACCT_ID <> 'FAB75E8E-6F9C-44F1-AFD2-28E60BA53D9B'

-- Load Remaining Primary Accounts
INSERT INTO wrk.customerWorkingList (DimCustomerID, SSB_CRMSYSTEM_ACCT_ID, IsPersonAccount, IsBusinessAccount, MDM_UpdatedDate, SFDCProcess_UpdatedDate, SSID_Winner, SourceSystem)
SELECT  a.dimcustomerid
, a.[SSB_CRMSYSTEM_CONTACT_ID] ssb_crmsystem_acct_id 
, CASE WHEN a.IsBusiness = 1 THEN 0 ELSE 1 END IsPersonAccount
, CASE WHEN a.IsBusiness = 1 THEN 1 ELSE 0 END IsBusinessAccount
, a.UpdatedDate MDM_LastUpdated
, GETDATE() ProcessUpdatedDate
, CASE WHEN a.[SourceSystem] LIKE '%SFDC%' THEN '' 
	ELSE 
        CASE WHEN a.SourceSystem = 'TI USC' THEN 'USC' 
        WHEN a.sourcesystem = 'Adobe' THEN 'Adobe' --changed from USC_AdobeForm 2017-10-12 AMEITIN
		WHEN a.sourcesystem = 'USC_Advantage' THEN 'Advantage'
         ELSE 'Unknown' END + ' - ' + a.SSID END SSID_Winner
, a.SourceSystem
--SELECT COUNT(*)
--INTO #tmpTest
from USC.dbo.vwDimCustomer_ModAcctId a
where a.SSB_CRMSYSTEM_PRIMARY_FLAG = 1
--AND a.IsBusiness = 1
AND a.[SSB_CRMSYSTEM_CONTACT_ID] IN (SELECT [SSB_CRMSYSTEM_CONTACT_ID] FROM [dbo].[vwSFDCProcess_DistinctContacts_CriteriaMet])
AND [SSB_CRMSYSTEM_CONTACT_ID] NOT IN (SELECT SSB_CRMSYSTEM_ACCT_ID FROM wrk.customerWorkingList)
AND [SSB_CRMSYSTEM_CONTACT_ID] NOT IN (SELECT SSB_CRMSYSTEM_ACCT_ID FROM dbo.Account)
AND a.SourceSystem NOT LIKE '%Lead%'

SELECT DISTINCT b.[SSB_CRMSYSTEM_ACCT_ID]--, b.SSB_CRMSYSTEM_CONTACT_ID
, b.USC_Losers,b.DimCustID_Losers 
, b.MDM_UpdatedDate
INTO #tmpRedoSSIDs_Acct
-- DROP TABLE #tmpRedoSSIDs_Acct
FROM wrk.customerWorkingList b
WHERE 1=1
--SELECT * FROM #tmpRedoSSIDs_Acct

SELECT        [SSB_CRMSYSTEM_CONTACT_ID] SSB_CRMSYSTEM_ACCT_ID , CAST(DimCustomerId AS VARCHAR(100)) AS DimCustomerID, CAST(SSID AS VARCHAR(50)) AS SSID
, a.SourceSystem
INTO #tmpDimCustIDs
--DROP table #tmpDimCustIDs
FROM            USC.dbo.vwDimCustomer_ModAcctId AS a
WHERE        (1 = 1) 
--AND a.SourceSystem NOT LIKE 'Lead_%'
--AND a.[SSB_CRMSYSTEM_CONTACT_ID] = '1892FEFB-0818-4CEC-87B6-40EE18E4EC79'
AND a.[SSB_CRMSYSTEM_CONTACT_ID] IN (SELECT SSB_CRMSYSTEM_ACCT_ID FROM #tmpRedoSSIDs_Acct)
-- AND a.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG = 0
-- DROP TABLE #tmpDimCustIDs
-- SELECT * FROM #tmpDimCustIDs

TRUNCATE TABLE stg.USC_NonWinners

INSERT INTO stg.USC_NonWinners
SELECT SSB_CRMSYSTEM_ACCT_ID, DimCustomerID, CAST(a.ssid as varchar(50))  as ssidwithsrc 
FROM #tmpDimCustIDs a 
WHERE 1=1
AND a.SourceSystem LIKE '%TI%'


SELECT 
SSB_CRMSYSTEM_ACCT_ID
,STUFF((    SELECT  ', ' + ssidwithsrc  AS [text()]
FROM stg.USC_NonWinners USC
WHERE USC.[GUID] = z.SSB_CRMSYSTEM_ACCT_ID
ORDER BY ssidwithsrc
FOR XML PATH('')), 1, 1, '') as USC_LoserString
,STUFF((    SELECT  ', ' + DimCustomerID  AS [text()]
FROM #tmpDimCustIDs DimCust
WHERE DimCust.SSB_CRMSYSTEM_ACCT_ID = z.SSB_CRMSYSTEM_ACCT_ID
ORDER BY [DimCustomerID]
FOR XML PATH('')), 1, 1, '' ) as DimCustID_LoserString
INTO #LoserSSIDs
FROM (SELECT DISTINCT SSB_CRMSYSTEM_ACCT_ID FROM #tmpRedoSSIDs_Acct
--WHERE SSB_CRMSYSTEM_ACCT_ID NOT IN (SELECT GUID FROM #tmpDimCustIDs)
) z
-- Drop Table #LoserSSIDs
-- SELECT * FROM #LoserSSIDs Where USC_LoserString IS NOT NULL

UPDATE a
SET USC_Losers = ISNULL(LTRIM(USC_LoserString),'')
, DimCustID_Losers = ISNULL(LTRIM(DimCustID_LoserString),'')
-- SELECT b.* 
FROM wrk.customerWorkingList a
INNER JOIN #LoserSSIDs b ON a.SSB_CRMSYSTEM_ACCT_ID = b.SSB_CRMSYSTEM_ACCT_ID
WHERE ( LEN(ISNULL(b.USC_LoserString,'')) + Len(ISNULL(b.DimCustID_LoserString,'')))  > 0


TRUNCATE TABLE stg.Account
INSERT into stg.account
(
SSB_CRMSYSTEM_ACCT_ID
,SSID_Winner
, USC_Losers 
, DimCustID_Losers
, IsBusinessAccount
, FullName
, FirstName
, LastName
, Title
, PrimaryAddressType
, BillingStreet
, BillingCity
, BillingState
, BillingPostalCode
, BillingCountry
, Address2Type
, ShippingStreet
, ShippingCity
, ShippingState
, ShippingPostalCode
, ShippingCountry
, Address3Type
, PersonOtherStreet
, PersonOtherCity
, PersonOtherState
, PersonOtherPostalCode
, PersonOtherCountry
, Address4Type
, PersonMailingStreet
, PersonMailingCity
, PersonMailingState
, PersonMailingPostalCode
, PersonMailingCountry
, PersonHomePhone
, PersonMobilePhone
, Phone
, Fax
, Email 
, SecondaryEmail
,USC_Flag
,USC_SeasonTicket_Years
, Brand
,Customer_Status
,eVenue_Email
, Donor_Status
,Donor_Type
,Donor_Level
,Internet_Profile
, eVenue_Pin
,VIP_Code
,Customer_Type
,Donor_ID
,TAG
,Customer_Comments
, MDM_UpdatedDate
, SFDCProcess_UpdatedDate
,C_PRIORITY
,Attribute
,Note
,Donor_Comments
,MembershipLevel
)
select 
wrlist.SSB_CRMSYSTEM_ACCT_ID
,SSID_Winner
 ,USC_Losers 
, DimCustID_Losers
, IsBusinessAccount
, COALESCE(CASE WHEN dc.IsBusiness = 1 THEN CompanyName ELSE NULL END,FullName, ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'')) FullName
, FirstName
, LastName
, prefix as Title
, 'P' as PrimaryAddressType
, AddressPrimaryStreet + ' ' + [dc].[AddressPrimarySuite] as BillingStreet
, AddressPrimaryCity as BillingCity
, AddressPrimaryState as BillingState
, AddressPrimaryZip as BillingPostalCode
, AddressPrimaryCountry as BillingCountry
, 's' as Address2Type
, AddressOneStreet + ' ' + dc.[AddressOneSuite] AS ShippingStreet
, AddressOneCity as ShippingCity
, AddressOneState as ShippingState
, AddressOneZip as ShippingPostalCode
, AddressOneCountry as ShippingCountry
, 'h' as Address3Type
, AddressTwoStreet + ' ' + [dc].[AddressTwoSuite] AS PersonOtherStreet
, AddressTwoCity as PersonOtherCity
, AddressTwoState as PersonOtherState
, AddressTwoZip as PersonOtherPostalCode
, AddressTwoCountry as PersonOtherCountry
, 'b' as Address4Type
, AddressThreeStreet + ' ' + [dc].[AddressThreeSuite] AS PersonMailingStreet
, AddressThreeCity as PersonMailingCity
, AddressThreeState as PersonMailingState
, AddressThreeZip as PersonMailingPostalCode
, AddressThreeCountry as PersonMailingCountry
, PhoneHome as PersonHomePhone
, PhoneCell as PersonMobilePhone
, dc.PhonePrimary AS Phone
, PhoneFax as Fax
, dc.[EmailPrimary] AS Email
, dc.EmailTwo AS SecondaryEmail
, da.USC_Flag
, da.USC_SeasonTicket_Years
, da.Brand
,CustomerStatus AS Customer_Status
, [dc].[EmailOne] as eVenue_Email
, ExtAttribute2 as DonorStatus
, ExtAttribute6 as Donor_Type
, ExtAttribute5 as Donor_Level
, ExtAttribute7 as Internet_Profile
, ExtAttribute11 as eVenue_Pin
, ExtAttribute3 as VIP_Code
,CustomerType AS Customer_Type
, ExtAttribute1 as DonorID
, ExtAttribute31 as TAG
, ExtAttribute32 as Customer_Comments
, MDM_UpdatedDate as MDM_UpdatedDate
, GETDATE() AS SFDCProcess_UpdatedDate
,ExtAttribute4 AS C_PRIORITY
,ExtAttribute8 AS Attribute
,ExtAttribute9 AS Note
,ExtAttribute33 as Donor_Comments
,ExtAttribute10 AS MembershipLevel
--SELECT * 
FROM  USC.dbo.vwDimCustomer_ModAcctId dc 
INNER JOIN  wrk.customerWorkingList wrlist ON dc.DimCustomerID = wrlist.DimCustomerID
INNER JOIN dbo.SFDCProcess_DistinctContacts da ON wrlist.SSB_CRMSYSTEM_ACCT_ID = da.[SSB_CRMSYSTEM_CONTACT_ID]

--peform merge ..update all contact ids that are eligible and cross them
MERGE INTO dbo.account AS target
USING  stg.account AS SOURCE 
ON target.SSB_CRMSYSTEM_ACCT_ID = source.SSB_CRMSYSTEM_ACCT_ID
WHEN MATCHED THEN UPDATE SET
target.SSID_Winner=source.SSID_Winner
,target. USC_Losers =source. USC_Losers 
,target. DimCustID_Losers=source. DimCustID_Losers
,target. IsBusinessAccount=source. IsBusinessAccount
,target. FullName=source. FullName
,target. FirstName=source. FirstName
,target. LastName=source. LastName
,target. Title=source. Title
,target. PrimaryAddressType=source. PrimaryAddressType
,target. BillingStreet=source. BillingStreet
,target. BillingCity=source. BillingCity
,target. BillingState=source. BillingState
,target. BillingPostalCode=source. BillingPostalCode
,target. BillingCountry=source. BillingCountry
,target. Address2Type=source. Address2Type
,target. ShippingStreet=source. ShippingStreet
,target. ShippingCity=source. ShippingCity
,target. ShippingState=source. ShippingState
,target. ShippingPostalCode=source. ShippingPostalCode
,target. ShippingCountry=source. ShippingCountry
,target. Address3Type=source. Address3Type
,target. PersonOtherStreet=source. PersonOtherStreet
,target. PersonOtherCity=source. PersonOtherCity
,target. PersonOtherState=source. PersonOtherState
,target. PersonOtherPostalCode=source. PersonOtherPostalCode
,target. PersonOtherCountry=source. PersonOtherCountry
,target. Address4Type=source. Address4Type
,target. PersonMailingStreet=source. PersonMailingStreet
,target. PersonMailingCity=source. PersonMailingCity
,target. PersonMailingState=source. PersonMailingState
,target. PersonMailingPostalCode=source. PersonMailingPostalCode
,target. PersonMailingCountry=source. PersonMailingCountry
,target. PersonHomePhone=source. PersonHomePhone
,target. PersonMobilePhone=source. PersonMobilePhone
,target. Phone=source. Phone
,target. Fax=source. Fax
,target. Email =source. Email 
,target. SecondaryEmail =source. SecondaryEmail 
,target.USC_Flag=source.USC_Flag
,target.USC_SeasonTicket_Years=source.USC_SeasonTicket_Years
,target. Brand=source. Brand
,target. MDM_UpdatedDate=source. MDM_UpdatedDate
,target. SFDCProcess_UpdatedDate=source. SFDCProcess_UpdatedDate
--,target. changeType=source. changeType
--,target. ContactId=source. ContactId
,target.Customer_Status=source.Customer_Status
--,target.SS_CreatedDate=source.SS_CreatedDate
,target.eVenue_Email=source.eVenue_Email
,target. Donor_Status=source. Donor_Status
,target.Donor_Type=source.Donor_Type
,target.Donor_Level=source.Donor_Level
,target.Internet_Profile=source.Internet_Profile
,target. eVenue_Pin=source. eVenue_Pin

,target.VIP_Code=source.VIP_Code
,target.Customer_Type=source.Customer_Type
,target.Donor_ID=source.Donor_ID
,target.TAG=source.TAG
,target.Customer_Comments=source.Customer_Comments
,target.C_PRIORITY=source.C_PRIORITY
,target.Attribute=source.Attribute
,target.Note=source.Note
,target.Donor_Comments=source.Donor_Comments
,target.MembershipLevel = SOURCE.MembershipLevel
, TARGET.BusiPerson_ChgFlag = CASE WHEN SOURCE.IsBusinessAccount <> TARGET.IsBusinessAccount AND TARGET.IsBusinessAccount = 1 THEN 'ChgToPerson'
									WHEN SOURCE.IsBusinessAccount <> TARGET.IsBusinessAccount AND TARGET.IsBusinessAccount = 0 THEN 'ChgToBusiness'
									ELSE 'NoChange' END
,target.[salesforce_ID] = CASE WHEN LEN(target.[salesforce_ID]) > 18 THEN CAST(source.[SSB_CRMSYSTEM_ACCT_ID] AS VARCHAR(50)) ELSE target.[salesforce_ID] END

WHEN NOT MATCHED THEN 
INSERT 
(
SSB_CRMSYSTEM_ACCT_ID
,SSID_Winner
, USC_Losers 
, DimCustID_Losers
, IsBusinessAccount
, FullName
, FirstName
, LastName
, Title
, PrimaryAddressType
, BillingStreet
, BillingCity
, BillingState
, BillingPostalCode
, BillingCountry
, Address2Type
, ShippingStreet
, ShippingCity
, ShippingState
, ShippingPostalCode
, ShippingCountry
, Address3Type
, PersonOtherStreet
, PersonOtherCity
, PersonOtherState
, PersonOtherPostalCode
, PersonOtherCountry
, Address4Type
, PersonMailingStreet
, PersonMailingCity
, PersonMailingState
, PersonMailingPostalCode
, PersonMailingCountry
, PersonHomePhone
, PersonMobilePhone
, Phone
, Fax
, Email 
, SecondaryEmail
,USC_Flag
,USC_SeasonTicket_Years
, Brand
, MDM_UpdatedDate
, SFDCProcess_UpdatedDate
--, changeType
--, ContactId
,Customer_Status
--,SS_CreatedDate
,eVenue_Email
,Donor_Status
,Donor_Type
,Donor_Level
,Internet_Profile
, eVenue_Pin
--,UpdatedDate
--, changeType
--,salesforce_ID
--,SFDC_loadDate
--,dbLastUpdated
,VIP_Code
,Customer_Type
,Donor_ID
,TAG
,Customer_Comments
, C_PRIORITY
, Attribute
, Note
,Donor_Comments
,MembershipLevel
, salesforce_id
)
VALUES
(
source.SSB_CRMSYSTEM_ACCT_ID
,source.SSID_Winner
 ,source. USC_Losers 
,source. DimCustID_Losers
,source. IsBusinessAccount
,source. FullName
,source. FirstName
,source. LastName
,source. Title
,source. PrimaryAddressType
,source. BillingStreet
,source. BillingCity
,source. BillingState
,source. BillingPostalCode
,source. BillingCountry
,source. Address2Type
,source. ShippingStreet
,source. ShippingCity
,source. ShippingState
,source. ShippingPostalCode
,source. ShippingCountry
,source. Address3Type
,source. PersonOtherStreet
,source. PersonOtherCity
,source. PersonOtherState
,source. PersonOtherPostalCode
,source. PersonOtherCountry
,source. Address4Type
,source. PersonMailingStreet
,source. PersonMailingCity
,source. PersonMailingState
,source. PersonMailingPostalCode
,source. PersonMailingCountry
,source. PersonHomePhone
,source. PersonMobilePhone
,source. Phone
,source. Fax
,source. Email 
,source. SecondaryEmail
,source.USC_Flag
,source.USC_SeasonTicket_Years
,source. Brand
,source. MDM_UpdatedDate
,source. SFDCProcess_UpdatedDate
--,source. changeType
--,source. ContactId
,source.Customer_Status
--,source.SS_CreatedDate
,source.eVenue_Email
,source.Donor_Status
,source.Donor_Type
,source.Donor_Level
,source.Internet_Profile
,source. eVenue_Pin
--,source.UpdatedDate
--,source. changeType
--,source.salesforce_ID
--,source.SFDC_loadDate
--,source.dbLastUpdated
,source.VIP_Code
,source.Customer_Type
,source.Donor_ID
,source.TAG
,source.Customer_Comments
,source.C_PRIORITY
,source.Attribute
,source.Note
,source.Donor_Comments
,source.MembershipLevel
, source.SSB_CRMSYSTEM_ACCT_ID
);

BEGIN TRY
-- Update the New GUIDs to the old SF ID
UPDATE a
SET salesforce_id = COALESCE(c.salesforce_id, e.id, NULL)
, SFDC_LoadDate = '1/1/1900'
-- SELECT c.*, a.[LastSFDCLoad_Error], a.[LastSFDCLoad_AttemptDate], d.id, e.id
FROM dbo.account a
INNER JOIN (SELECT New_Acct_ID, MAX(z.SFDC_CreatedDate) SFDC_CreatedDate FROM dbo.Archived_Account z
                                           WHERE 1=1
                                           AND Processed = 0
                                           AND z.salesforce_id IS NOT NULL
            --AND z.new_acct_Id = 'FA482A0F-8F82-4FDF-AD3A-72354283748D'
                                           GROUP BY z.New_Acct_Id) b ON b.New_Acct_Id = a.SSB_CRMSYSTEM_ACCT_ID
INNER JOIN dbo.Archived_Account c ON c.New_Acct_Id = b.New_Acct_Id AND c.SFDC_CreatedDate = b.SFDC_CreatedDate
LEFT JOIN USC_Reporting.ProdCopy.Account d ON c.salesforce_Id = d.id
LEFT JOIN (SELECT SSB_CRMSYSTEM_ACCT_ID__c, MIN(Id) Id from USC_Reporting.ProdCopy.Account GROUP BY SSB_CRMSYSTEM_ACCT_ID__c) e ON c.new_acct_id = e.SSB_CRMSYSTEM_ACCT_ID__c
END TRY

BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

BEGIN TRY
-- Update any failed updates for missing salesforce_ids
UPDATE a 
SET salesforce_id = x.id
--SELECT x.id, a.salesforce_id, a.SSB_CRMSYSTEM_ACCT_ID, a.LastSFDCLoad_Error, a.LastSFDCLoad_AttemptDate
FROM dbo.Account a
INNER JOIN (
SELECT z.id, z.SSB_CRMSYSTEM_ACCT_ID__c FROM USC_Reporting.ProdCopy.[Account] z INNER JOIN
(SELECT [SSB_CRMSYSTEM_ACCT_ID__c], MIN(CreatedDate) MinDate FROM USC_Reporting.ProdCopy.vw_Account GROUP BY [SSB_CRMSYSTEM_ACCT_ID__c]) y ON z.SSB_CRMSYSTEM_ACCT_ID__c = y.SSB_CRMSYSTEM_ACCT_ID__c AND z.[CreatedDate] = y.[MinDate]
) x ON a.[SSB_CRMSYSTEM_ACCT_ID] = x.[SSB_CRMSYSTEM_ACCT_ID__c]
WHERE LEN(a.salesforce_id) > 18
--AND a.[SSB_CRMSYSTEM_ACCT_ID] IN ('ACF3AF5A-49BF-488B-97B4-0993C4CF8FE9')
--AND (SSB_CRMSYSTEM_ACCT_ID NOT IN ('10B1009C-7CCD-4F9A-BE68-D944C606F5B8','74275B70-1023-4571-ADF4-7F824AA34AC7'))
END TRY

BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

BEGIN TRY
--Delete bad records and re-use the new values.
SELECT SSID_Winner, MIN([salesforce_ID]) KeepSFID, MAX([salesforce_ID]) NewGUID
INTO #tmpSaveSFIDs
FROM dbo.[Account] a 
GROUP BY [SSID_Winner] HAVING COUNT(*) > 1
AND MIN([SFDCProcess_UpdatedDate]) < MAX([SFDCProcess_UpdatedDate])
AND LEN(MAX([salesforce_ID])) > 18

DELETE b FROM [#tmpSaveSFIDs] a 
INNER JOIN dbo.[Account] b ON a.[KeepSFID] = b.[salesforce_ID]

UPDATE a 
SET [a].[salesforce_ID] = b.[KeepSFID]
FROM [dbo].[Account] a 
INNER JOIN [#tmpSaveSFIDs] b ON a.[SSB_CRMSYSTEM_ACCT_ID] = b.[NewGUID]

END TRY

BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

-- Reset SalesforceID when ID not longer exists
UPDATE a
SET salesforce_id = a.SSB_CRMSYSTEM_ACCT_ID
--SELECT COUNT(*)
FROM dbo.account a
LEFT JOIN USC_Reporting.prodcopy.vw_account b ON a.salesforce_id = b.Id
where b.id IS NULL AND (sfdc_loaddate IS NULL OR datediff(d, sfdc_loaddate, GETDATE()) > 1)
AND LEN(a.salesforce_id) = 18

-- Reset SalesforceID when AcctIDs don't match
UPDATE a
SET salesforce_id =  a.[SSB_CRMSYSTEM_ACCT_ID]
--SELECT COUNT(*) 
FROM dbo.[Account] a
INNER JOIN USC_Reporting.prodcopy.[vw_Account] b ON a.[salesforce_ID] = b.id
WHERE a.[SSB_CRMSYSTEM_ACCT_ID] <> b.[SSB_CRMSYSTEM_ACCT_ID__c]
AND LEN(a.[salesforce_ID]) = 18

-- Fix IDs when IDs match ProdCopy
UPDATE a
SET salesforce_id = b.id
--SELECT COUNT(*)
FROM dbo.account a
INNER JOIN USC_Reporting.prodcopy.vw_account b
ON a.SSB_CRMSYSTEM_ACCT_ID = b.SSB_CRMSYSTEM_ACCT_ID__c
WHERE isnull(a.salesforce_id, '') != b.id
AND b.id NOT IN (SELECT salesforce_ID FROM dbo.account)
AND LEN(a.salesforce_id) = 18

-- Fix IDs that are in ProdCopy
UPDATE a 
SET [a].[salesforce_ID] = b .id
-- SELECT *
FROM dbo.[Account] a
INNER JOIN USC_Reporting.ProdCopy.[vw_Account] b ON [a].[SSB_CRMSYSTEM_ACCT_ID] = b.[SSB_CRMSYSTEM_ACCT_ID__c]
WHERE LEN([salesforce_ID]) > 18
AND [a].[salesforce_ID] NOT IN (SELECT [salesforce_ID] FROM dbo.[Account] WHERE LEN([salesforce_ID]) = 18)
--AND b.id = '001G000001FSQ0qIAH'

--SELECT DISTINCT [SourceSystem] FROM USC.dbo.[vwDimCustomer_ModAcctId]
--Fix IDs from MDM when not in ProdCopy Correctly
UPDATE a
SET salesforce_id =  b.ssid 
-- Select COUNT(*)
FROM dbo.account a
INNER JOIN USC.dbo.dimcustomerssbid b
ON a.SSB_CRMSYSTEM_ACCT_ID = b.[SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.SourceSystem = 'USC SFDC Account' AND ISNULL(a.salesforce_id, '') != b.ssid
AND b.ssid NOT IN (SELECT salesforce_id FROM dbo.account WHERE LEN([salesforce_ID]) = 18)
AND LEN([a].[salesforce_ID]) > 18

UPDATE a
SET Deleted = 1
-- Select *
FROM dbo.Archived_Account a 
WHERE a.SSB_CRMSYSTEM_ACCT_ID NOT IN (SELECT SSB_CRMSYSTEM_ACCT_ID FROM dbo.Account)

UPDATE a
SET Processed = 1
-- Select *
FROM dbo.Archived_Account a 
WHERE a.New_Acct_Id IN (SELECT SSB_CRMSYSTEM_ACCT_ID FROM dbo.Account)

--SELECT * INTO dbo.Account_PostGUIDChange FROM dbo.Account
--TRUNCATE TABLE dbo.Account
--INSERT INTO dbo.Account
--SELECT * FROM dbo.Account_Backup_20150203

-- Prep for the wOwner query
TRUNCATE TABLE [dbo].[SFDCLoad_Account_ProcessLoad_Criteria]

INSERT INTO [dbo].[SFDCLoad_Account_ProcessLoad_Criteria]
SELECT SSB_CRMSYSTEM_ACCT_ID, MAX(IDIsNull) IDIsNull  
FROM (
-- Account/Contact from wrk table
SELECT b.SSB_CRMSYSTEM_ACCT_ID, 0 IDIsNull 
FROM wrk.customerWorkingList a 
INNER JOIN dbo.Account b ON b.SSB_CRMSYSTEM_ACCT_ID = a.SSB_CRMSYSTEM_ACCT_ID
UNION ALL
-- Not pushed up for any reason or errored last time
SELECT DISTINCT SSB_CRMSYSTEM_ACCT_ID, CASE WHEN salesforce_ID IS NULL THEN 1 ELSE 0 END IDIsNull
FROM dbo.Account
WHERE salesforce_ID IS NULL OR LEN(ISNULL(LastSFDCLoad_Error,'')) > 0
) z
GROUP BY z.SSB_CRMSYSTEM_ACCT_ID

DROP TABLE #tmpA
DROP TABLE #tmpNewSSIDs
DROP TABLE #tmpGUIDLookup
DROP TABLE #tmpGUIDResults
DROP TABLE #LoserSSIDs
DROP TABLE #tmpRedoSSIDs_Acct


END



GO
