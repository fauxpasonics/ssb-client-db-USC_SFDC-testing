SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [stg].[sp_SFDC_CurrentPurchaser]
AS

TRUNCATE TABLE stg.SFDC_CurrentPurchaser

INSERT INTO stg.SFDC_CurrentPurchaser
SELECT *, GETDATE()
FROM [dbo].[SFDC_CurrentPurchaser]

TRUNCATE TABLE stg.SFDC_CurrentPurchaser_SeasonBreakdown
INSERT INTO stg.SFDC_CurrentPurchaser_SeasonBreakdown
SELECT [Customer__c], [SeasonType], CASE WHEN [SeasonType] IN ('FBCurrSeason','MBBCurrSeason') THEN 1 ELSE 0 END CurrSeason
, I_PRICE
, SUM(QTY) QTY
, [y].[SSB_CRMSYSTEM_CONTACT_ID]
, CASE WHEN [SeasonType] LIKE '%FB%' AND Item LIKE 'F8%' THEN 1 ELSE 0 END FB_F8
, CASE WHEN [SeasonType] LIKE '%FB%' AND (Item LIKE 'FSN%' OR Item LIKE 'F8%') THEN 1 ELSE 0 END FB_FSN
, CASE WHEN [SeasonType] LIKE '%MBB%' AND ITEM LIKE 'BM' THEN 1 ELSE 0 END MBB_BM
, CASE WHEN seasontype = 'FBCurrSeason' AND I_PT LIKE 'M%' THEN 1 ELSE 0 END FB_MINI
, CASE WHEN seasontype = 'MBBCurrSeason' AND I_PT LIKE 'M%' THEN 1 ELSE 0 END MBB_MINI
--, *

FROM stg.[SFDC_CurrentPurchaser] z
INNER JOIN USC.dbo.[vwDimCustomer_ModAcctId] y ON z.[Customer__c] = y.SSID AND y.[SourceSystem] = 'TI USC'
GROUP BY Customer__c
, SeasonType
, I_PRICE
, QTY
, SSB_CRMSYSTEM_CONTACT_ID
, Item
, I_PT
GO
