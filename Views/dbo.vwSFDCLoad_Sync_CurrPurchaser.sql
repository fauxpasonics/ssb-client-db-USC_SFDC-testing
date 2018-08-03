SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---Trustee Flag exclusions added by AMeitin 2017/09/05

CREATE VIEW [dbo].[vwSFDCLoad_Sync_CurrPurchaser]
AS

SELECT a.SSB_CRMSYSTEM_ACCT_ID
, a.Football_Full__c
, CASE WHEN acct.Trustee_Flag__c = 1 THEN 0 ELSE a.Football_Rookie__c END AS Football_Rookie__c
, a.Football_Partial__c
, a.Men_s_Basketball_Full__c
, CASE WHEN acct.Trustee_Flag__c = 1 THEN 0 ELSE a.Men_s_Basketball_Rookie__c END AS Men_s_Basketball_Rookie__c
, a.Men_s_Basketball_Partial__c
, b.salesforce_id id
FROM dbo.vwSFDCload_CurrentPurchaser a 
INNER JOIN dbo.Account b ON a.SSB_CRMSYSTEM_ACCT_ID = b.SSB_CRMSYSTEM_ACCT_ID
LEFT JOIN (SELECT SSB_CRMSYSTEM_ACCT_ID__c, Trustee_Flag__c
			FROM USC_Reporting.[prodcopy].[vw_Account] acct
			WHERE Trustee_Flag__c = '1') acct on a.SSB_CRMSYSTEM_ACCT_ID = acct.SSB_CRMSYSTEM_ACCT_ID__c
WHERE LEN(Salesforce_ID) = 18
--AND b.[salesforce_ID] = '001G000001FSXbOIAX'
UNION 
SELECT * FROM dbo.vwSFDCLoad_Sync_ProdCopyCurrPurchaser
--WHERE [id] = '001G000001FSXbOIAX'


GO
