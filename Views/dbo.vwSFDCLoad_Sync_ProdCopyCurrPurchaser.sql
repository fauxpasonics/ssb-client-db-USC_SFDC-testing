SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwSFDCLoad_Sync_ProdCopyCurrPurchaser] 

AS 

SELECT [a].[SSB_CRMSYSTEM_ACCT_ID__c] 
, ISNULL(b.[Football_Full__c],0) Football_Full__c
, ISNULL(b.[Football_Rookie__c],0) [Football_Rookie__c]
, ISNULL(b.[Football_Partial__c],0) [Football_Partial__c]
, ISNULL(b.[Men_s_Basketball_Full__c],0) [Men_s_Basketball_Full__c]
, ISNULL(b.[Men_s_Basketball_Partial__c],0) [Men_s_Basketball_Partial__c] 
, ISNULL(b.[Men_s_Basketball_Rookie__c],0) [Men_s_Basketball_Rookie__c]
, Id
--SELECT *
FROM 
	(SELECT * 
	 FROM USC_Reporting.ProdCopy.[vw_Account] 
	 WHERE ([Men_s_Basketball_Full__c] = 1 
	 OR [Football_Partial__c] = 1 
	 OR [Football_Rookie__c] = 1 
	 OR [Men_s_Basketball_Full__c] = 1 
	 OR [Men_s_Basketball_Partial__c] = 1 
	 OR [Men_s_Basketball_Rookie__c] = 1)
	 ) a
LEFT JOIN [dbo].[vwSFDCLoad_CurrentPurchaser] b ON [a].[SSB_CRMSYSTEM_ACCT_ID__c] = b.[SSB_CRMSYSTEM_ACCT_ID]
WHERE ((a.[Football_Full__c] <> b.[Football_Full__c] 
OR [a].[Football_Partial__c] <> [b].[Football_Partial__c] 
OR [a].[Football_Rookie__c] <> [b].[Football_Rookie__c])
OR ([a].[Men_s_Basketball_Full__c] <> [b].[Men_s_Basketball_Full__c] 
OR [a].[Men_s_Basketball_Partial__c] <> b.[Men_s_Basketball_Partial__c] 
OR a.[Men_s_Basketball_Rookie__c] <> b.[Men_s_Basketball_Rookie__c])
OR b.[SSB_CRMSYSTEM_ACCT_ID] IS NULL)
--AND [id] = '001G000001FSXbOIAX'



GO
