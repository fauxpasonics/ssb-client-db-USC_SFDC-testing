SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwSFDCLoad_Account_PersonBusiness_Convert]
AS
SELECT 
salesforce_ID Id
, BusinessRT.Id RecordTypeId
, NULL Description
, NULL PersonMobilePhone
, NULL PersonHomePhone
, NULL PersonOtherPhone
, NULL PersonEmail
, NULL PersonBirthdate
, NULL Contact_2_First_Name__c
, NULL Contact_2_Last_Name__c
, NULL Contact_2_Phone__c
, NULL Contact_2_Home_Phone__c
, NULL Contact_2_Mobile_Phone__c
, NULL Contact_2_Other_Phone__c
, NULL Contact_2_Email__c
, NULL Contact_3_First_Name__c
, NULL Contact_3_Last_Name__c
, NULL Contact_3_Phone__c
, NULL Contact_3_Home_Phone__c
, NULL Contact_3_Mobile_Phone__c
, NULL Contact_3_Other_Phone__c
, NULL Contact_3_Email__c
FROM dbo.vwSFDCLoad_Account_Prep a
JOIN ProdCopy.RecordType BusinessRT ON BusinessRT.DeveloperName = 'Business_Account'
WHERE 1=1 
--AND a.IsBusinessAccount = 0
AND LEN(ISNULL(a.salesforce_id,0)) = 18
AND a.BusiPerson_ChgFlag = 'ChgToBusiness'

GO
