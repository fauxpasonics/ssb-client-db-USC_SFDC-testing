SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================




CREATE PROCEDURE [dbo].[MergeSFDC_PatronStageToDbo] 


AS

BEGIN
	SET NOCOUNT ON;

--peform merege ..update records in dbo table.
MERGE INTO [dbo].[Patron_C]  AS target
USING [stg].[Patron_C]  AS SOURCE 
ON target.[Patron]=source.[Patron] 
WHEN MATCHED THEN UPDATE SET
target.[Patron]=source.[Patron]
,target.[FullName]=source.[FullName]
,target.[Title]=source.[Title]
,target.[Suffix]=source.[Suffix]
,target.[PatronStatusCode]=source.[PatronStatusCode]
,target.[VIP]=source.[VIP]
,target.[internet_profile]=source.[internet_profile]
,target.[PatronStatus]=source.[PatronStatus]
,target.[CustomerTypeCode]=source.[CustomerTypeCode]
,target.[comments]=source.[comments]
,target.[ud1]=source.[ud1]
,target.[CustomerType]=source.[CustomerType]
,target.[CustomerStatus]=source.[CustomerStatus]
,target.[PriorityPtsTix]=source.[PriorityPtsTix]
,target.[PacCreateDate]=source.[PacCreateDate]
,target.[PrimaryAddressType]=source.[PrimaryAddressType]
,target.[PrimaryAddressStreet]=source.[PrimaryAddressStreet]
,target.[PrimaryAddressCity]=source.[PrimaryAddressCity]
,target.[PrimaryAddressState]=source.[PrimaryAddressState]
,target.[PrimaryAddressZipCode]=source.[PrimaryAddressZipCode]
,target.[PrimaryAddressCountry]=source.[PrimaryAddressCountry]
,target.[Address2Type]=source.[Address2Type]
,target.[Address2Street]=source.[Address2Street]
,target.[Address2City]=source.[Address2City]
,target.[Address2State]=source.[Address2State]
,target.[Address2ZipCode]=source.[Address2ZipCode]
,target.[Address2Country]=source.[Address2Country]
,target.[Address3Type]=source.[Address3Type]
,target.[Address3Street]=source.[Address3Street]
,target.[Address3City]=source.[Address3City]
,target.[Address3State]=source.[Address3State]
,target.[Address3ZipCode]=source.[Address3ZipCode]
,target.[Address3Country]=source.[Address3Country]
,target.[HomePhone]=source.[HomePhone]
,target.[CellPhone]=source.[CellPhone]
,target.[BusinessPhone]=source.[BusinessPhone]
,target.[Fax]=source.[Fax]
,target.[OtherPhoneType]=source.[OtherPhoneType]
,target.[OtherPhone]=source.[OtherPhone]
,target.[EvEmail]=source.[EvEmail]
,target.[PersonalEmail]=source.[PersonalEmail]
,target.[BusinessEmail]=source.[BusinessEmail]
,target.[OtherEmailType]=source.[OtherEmailType]
,target.[OtherEmail]=source.[OtherEmail]
,target.[TAGS]=source.[TAGS]
,target.[PIN]=source.[PIN]
,target.[Donor_ID__c]=source.[Donor_ID__c]
,target.[Donor_Membership__c]=source.[Donor_Membership__c]
,target.[UpdatedDate]=source.[UpdatedDate]
, target.[CopyLoadDate] = GETDATE()
WHEN NOT MATCHED THEN 
INSERT 
(
[Patron],
[FullName],
[Title],
[Suffix],
[PatronStatusCode],
[VIP],
[internet_profile],
[PatronStatus],
[CustomerTypeCode],
[comments],
[ud1],
[CustomerType],
[CustomerStatus],
[PriorityPtsTix],
[PacCreateDate],
[PrimaryAddressType],
[PrimaryAddressStreet],
[PrimaryAddressCity],
[PrimaryAddressState],
[PrimaryAddressZipCode],
[PrimaryAddressCountry],
[Address2Type],
[Address2Street],
[Address2City],
[Address2State],
[Address2ZipCode],
[Address2Country],
[Address3Type],
[Address3Street],
[Address3City],
[Address3State],
[Address3ZipCode],
[Address3Country],
[HomePhone],
[CellPhone],
[BusinessPhone],
[Fax],
[OtherPhoneType],
[OtherPhone],
[EvEmail],
[PersonalEmail],
[BusinessEmail],
[OtherEmailType],
[OtherEmail],
[TAGS],
[PIN],
[Donor_ID__c],
[Donor_Membership__c],
[UpdatedDate],
[CopyLoadDate]
)

VALUES
(
source.[Patron]
,source.[FullName]
,source.[Title]
,source.[Suffix]
,source.[PatronStatusCode]
,source.[VIP]
,source.[internet_profile]
,source.[PatronStatus]
,source.[CustomerTypeCode]
,source.[comments]
,source.[ud1]
,source.[CustomerType]
,source.[CustomerStatus]
,source.[PriorityPtsTix]
,source.[PacCreateDate]
,source.[PrimaryAddressType]
,source.[PrimaryAddressStreet]
,source.[PrimaryAddressCity]
,source.[PrimaryAddressState]
,source.[PrimaryAddressZipCode]
,source.[PrimaryAddressCountry]
,source.[Address2Type]
,source.[Address2Street]
,source.[Address2City]
,source.[Address2State]
,source.[Address2ZipCode]
,source.[Address2Country]
,source.[Address3Type]
,source.[Address3Street]
,source.[Address3City]
,source.[Address3State]
,source.[Address3ZipCode]
,source.[Address3Country]
,source.[HomePhone]
,source.[CellPhone]
,source.[BusinessPhone]
,source.[Fax]
,source.[OtherPhoneType]
,source.[OtherPhone]
,source.[EvEmail]
,source.[PersonalEmail]
,source.[BusinessEmail]
,source.[OtherEmailType]
,source.[OtherEmail]
,source.[TAGS]
,source.[PIN]
,source.[Donor_ID__c]
,source.[Donor_Membership__c]
,source.[UpdatedDate]
, GETDATE()
);

END


GO
