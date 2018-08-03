SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW  [dbo].[vwSFDCLoad_CurrentPurchaser]
AS

-- Football Season Ticket All
--SELECT [a].[Customer__c]
SELECT pvt.[SSB_CRMSYSTEM_CONTACT_ID] [SSB_CRMSYSTEM_ACCT_ID]
, CASE WHEN SUM(ISNULL(FB_STH_ALL,0)) > 0 THEN 1 ELSE 0 END [Football_Full__c]
, CASE WHEN SUM(ISNULL(FB_STH_NEW,0)) > 0 THEN 1 ELSE 0 END [Football_Rookie__c]
, CASE WHEN SUM(ISNULL(FB_Mini,0)) > 0 THEN 1 ELSE 0 END [Football_Partial__c]
, CASE WHEN SUM(ISNULL(MBB_STH_ALL,0)) > 0 THEN 1 ELSE 0 END [Men_s_Basketball_Full__c]
, CASE WHEN SUM(ISNULL(MBB_STH_NEW,0)) > 0 THEN 1 ELSE 0 END [Men_s_Basketball_Rookie__c]
, CASE WHEN SUM(ISNULL(MBB_Mini,0)) > 0 THEN 1 ELSE 0 END [Men_s_Basketball_Partial__c]
FROM (
--Football Season Ticket Holder
SELECT [a].[SSB_CRMSYSTEM_CONTACT_ID], 'FB_STH_All' Type, 1 Ticket
FROM stg.[SFDC_CurrentPurchaser] y 
INNER JOIN stg.SFDC_CurrentPurchaser_SeasonBreakdown a ON y.[Customer__c] = a.[Customer__c] 
WHERE a.[SEASONType] = 'FBCurrSeason' AND ([a].[FB_FSN] = 1)
GROUP BY [a].[SSB_CRMSYSTEM_CONTACT_ID]
UNION ALL
-- Football Season Ticket New
SELECT a.[SSB_CRMSYSTEM_CONTACT_ID], 'FB_STH_New' Type, 1 Ticket
FROM stg.[SFDC_CurrentPurchaser] y
INNER JOIN stg.SFDC_CurrentPurchaser_SeasonBreakdown a ON y.[Customer__c] = a.[Customer__c] 
WHERE y.[SeasonType] = 'FBCurrSeason' AND [a].[FB_FSN] = 1
AND y.[I_PRICE] > 0 
AND y.I_PT NOT LIKE '%TAF%'
AND a.[SSB_CRMSYSTEM_CONTACT_ID] NOT IN (SELECT [SSB_CRMSYSTEM_CONTACT_ID] 
											FROM stg.SFDC_CurrentPurchaser_SeasonBreakdown 
											WHERE [SeasonType] = 'FBPrevSeason' AND [FB_FSN] = 1)
AND a.[SSB_CRMSYSTEM_CONTACT_ID] NOT IN (select DISTINCT SSB_CRMSYSTEM_CONTACT_ID
										from USC.dbo.TK_CUSTOMER c WITH(NOLOCK)
										INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc on dc.SourceSystem = 'TI USC' and dc.SSID = c.CUSTOMER
										WHERE UD4 IS NOT NULL) --Added 6/19/2017 by AMEITIN to exclude all Trojan Club Members
AND a.[SSB_CRMSYSTEM_CONTACT_ID] NOT IN (select DISTINCT SSB_CRMSYSTEM_ACCT_ID__c from USC_Reporting.[prodcopy].[vw_Account]
										where Trustee_Flag__c = 1) --Added 8/9/2017 by AMEITIN to exclude all Trustees
AND a.[SSB_CRMSYSTEM_CONTACT_ID] NOT IN (SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID --Added 10/3/2017  by AMEITIN to exclude Brokers
										FROM stg.SFDC_CurrentPurchaser_SeasonBreakdown
										WHERE SeasonType = 'FBCurrSeason'
										AND (FB_F8 = '1' OR FB_FSN = '1')
										GROUP BY SSB_CRMSYSTEM_CONTACT_ID
										HAVING SUM(QTY) > '20'
										)

GROUP BY a.[SSB_CRMSYSTEM_CONTACT_ID]

--Basketball Season Ticket Holder
UNION ALL 
SELECT [a].[SSB_CRMSYSTEM_CONTACT_ID], 'MBB_STH_All' Type, 1 Ticket
FROM stg.[SFDC_CurrentPurchaser] y 
INNER JOIN stg.SFDC_CurrentPurchaser_SeasonBreakdown a ON y.[Customer__c] = a.[Customer__c] 
WHERE a.[SEASONType] = 'MBBCurrSeason' AND [a].[MBB_BM] = 1
--AND [z].[SSB_CRMSYSTEM_PRIMARY_FLAG] = 1
--GROUP BY [a].[Customer__c]
GROUP BY [a].[SSB_CRMSYSTEM_CONTACT_ID]
UNION ALL
-- Basketball Season Ticket New
SELECT a.[SSB_CRMSYSTEM_CONTACT_ID], 'MBB_STH_New' Type, 1 Ticket
FROM stg.[SFDC_CurrentPurchaser] y
INNER JOIN stg.SFDC_CurrentPurchaser_SeasonBreakdown a ON y.[Customer__c] = a.[Customer__c] 
WHERE y.[SeasonType] = 'MBBCurrSeason' AND [a].[MBB_BM] = 1
AND y.[I_PRICE] > 0
AND a.[SSB_CRMSYSTEM_CONTACT_ID] NOT IN (SELECT [SSB_CRMSYSTEM_CONTACT_ID] FROM stg.SFDC_CurrentPurchaser_SeasonBreakdown WHERE stg.SFDC_CurrentPurchaser_SeasonBreakdown.[SeasonType] = 'MBBPrevSeason' AND stg.SFDC_CurrentPurchaser_SeasonBreakdown.[MBB_BM] = 1)
GROUP BY a.[SSB_CRMSYSTEM_CONTACT_ID]
UNION ALL
--Football Mini Plans
SELECT a.[SSB_CRMSYSTEM_CONTACT_ID], 'FB_Mini' Type, 1 Ticket
FROM stg.[SFDC_CurrentPurchaser] y
INNER JOIN stg.SFDC_CurrentPurchaser_SeasonBreakdown a ON y.[Customer__c] = a.[Customer__c] 
WHERE y.[SeasonType] = 'FBCurrSeason' AND [a].[FB_MINI] = 1
GROUP BY a.[SSB_CRMSYSTEM_CONTACT_ID]
UNION ALL
--Basketball Mini Plans
SELECT a.[SSB_CRMSYSTEM_CONTACT_ID], 'FB_Mini' Type, 1 Ticket
FROM stg.[SFDC_CurrentPurchaser] y
INNER JOIN stg.SFDC_CurrentPurchaser_SeasonBreakdown a ON y.[Customer__c] = a.[Customer__c] 
WHERE y.[SeasonType] = 'MBBCurrSeason' AND [a].[MBB_MINI] = 1
GROUP BY a.[SSB_CRMSYSTEM_CONTACT_ID]
) z
PIVOT (SUM(Ticket) FOR TYPE IN ([FB_STH_ALL],[FB_STH_NEW],[FB_Mini],[MBB_STH_ALL],[MBB_STH_NEW],[MBB_Mini])) PVT 
GROUP BY PVT.[SSB_CRMSYSTEM_CONTACT_ID]









GO
