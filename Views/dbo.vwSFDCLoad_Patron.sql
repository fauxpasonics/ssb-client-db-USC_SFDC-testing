SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwSFDCLoad_Patron]
AS
SELECT        CASE WHEN a.fullname IS NULL THEN ISNULL(a.FirstName,'') + ' ' + ISNULL(a.LastName,'') ELSE a.FullName END AS Name
, acct.salesforce_ID AS Account__c
, a.SSID AS Patron_ID__c
, a.DimCustomerID AS ZID__c
, CAST(acct.[SSB_CRMSYSTEM_ACCT_ID] AS VARCHAR(50)) AS DW_ContactID__c
, CONVERT(DATETIME, acct.[SFDCProcess_UpdatedDate], 126) AS Export_DateTime__c
FROM USC.dbo.vwDimCustomer_ModAcctID a 
INNER JOIN dbo.account AS acct ON a.[SSB_CRMSYSTEM_CONTACT_ID] = acct.[SSB_CRMSYSTEM_ACCT_ID] --AND a.[SSB_CRMSYSTEM_PRIMARY_FLAG] = 1
WHERE LEN(acct.salesforce_ID) = 18
AND a.SourceSystem = 'TI USC'
GO
