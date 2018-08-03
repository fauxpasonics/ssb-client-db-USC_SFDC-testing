SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [dbo].[vw_AdobeCustomer]
AS

SELECT  CAST(a.SSB_CRMSYSTEM_CONTACT_ID AS VARCHAR(100)) AS [guid],
a.[SSB_CRMSYSTEM_PRIMARY_FLAG] Contact_PrimaryFlag,
a.SourceSystem, a.SSID AS PatronID, --replace(replace(a.Patron_ID__c,'A',''),'E','') as patron, --should we keep the first letter in order to identify source system?
a.EmailPrimary AS email,
acct.Id AS crmId,
a.FirstName, a.LastName, 
a.AddressPrimaryStreet BillingStreet, a.AddressPrimaryCity BillingCity, a.AddressPrimaryState BillingState, a.AddressPrimaryZip BillingPostalCode, 
a.PhoneCell PersonMobilePhone, a.PhoneHome PersonHomePhone, a.PhonePrimary Phone,
a.UpdatedDate
FROM  USC.dbo.vwDimCustomer_ModAcctID (NOLOCK)  a
	LEFT JOIN (
					SELECT SSB_CRMSYSTEM_ACCT_ID__c
					,Id
					, ROW_NUMBER() OVER(PARTITION BY SSB_CRMSYSTEM_ACCT_ID__c ORDER BY LastModifiedDate DESC, CreatedDate) xRank
					FROM [USC_Reporting].[ProdCopy].[Account] acct (NOLOCK) 
					WHERE acct.IsDeleted = '0') acct ON a.SSB_CRMSYSTEM_CONTACT_ID = acct.SSB_CRMSYSTEM_ACCT_ID__c AND acct.xRank = 1

--WHERE a.[SourceSystem] NOT LIKE '%USC SFDC%' --12/20/2016 AMEITIN removed causing duplicates
WHERE a.[SourceSystem] = 'TI USC' --12/20/2016 AMEITIN added until we can review criteria with FanOne

--where salesforce_ID is not null --check with Bryan: load only salesforce customers or all customers







GO
