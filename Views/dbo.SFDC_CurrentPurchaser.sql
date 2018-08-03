SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[SFDC_CurrentPurchaser] 
AS

WITH FootballSeason (Season, PrevSeason)
AS
(
SELECT (SELECT MAX([SEASON]) 
		FROM [USC].[dbo].[vwTIReportBase] 
		WHERE [SEASON] LIKE 'F%'
		) Season
, (SELECT MAX([SEASON]) PrevSeason 
	FROM [USC].[dbo].[vwTIReportBase] WHERE [SEASON] LIKE 'F%' 
	AND SEASON NOT IN (SELECT MAX([SEASON]) 
						FROM [USC].[dbo].[vwTIReportBase] 
						WHERE [SEASON] LIKE 'F%')
	) PrevSeason
)
,
MenBBSeason (Season, PrevSeason)

AS 
(
SELECT (SELECT MAX([SEASON]) 
		FROM [USC].[dbo].[vwTIReportBase] 
		WHERE [SEASON] LIKE 'B%'
		) Season
, (SELECT MAX([SEASON]) PrevSeason 
	FROM [USC].[dbo].[vwTIReportBase] 
	WHERE [SEASON] LIKE 'B%' 
	AND SEASON NOT IN (SELECT MAX([SEASON]) 
						FROM [USC].[dbo].[vwTIReportBase] 
						WHERE [SEASON] LIKE 'B%')
	) PrevSeason
)



SELECT Customer Customer__c
, Item
, I_PT
, [I_PRICE]
, SUM(ORDQTY) QTY
, CASE WHEN [SEASON] IN (SELECT Season FROM [FootballSeason]) THEN 'FBCurrSeason' 
														WHEN [SEASON] IN (SELECT PrevSeason FROM [FootballSeason]) THEN 'FBPrevSeason' 
														WHEN [SEASON] IN (SELECT Season FROM [MenBBSeason]) THEN 'MBBCurrSeason' 
														WHEN [SEASON] IN (SELECT PrevSeason FROM [MenBBSeason]) THEN 'MBBPrevSeason' 
														ELSE 'UNKNOWN' END SeasonType
FROM [USC].[dbo].[vwTIReportBase]
WHERE Season IN (SELECT Season FROM [FootballSeason] 
					UNION ALL 
				SELECT PrevSeason FROM [FootballSeason]
					UNION ALL 
				SELECT Season FROM [MenBBSeason] 
					UNION ALL 
				SELECT PrevSeason FROM [MenBBSeason] )
AND ((Item LIKE '%FSN%' OR Item = 'F8') OR ITEM = 'BM' ) --OR I_PT LIKE 'M%' )
GROUP BY
Customer 
,SEASON
, Item
, I_PT
, [I_PRICE]

UNION ALL

SELECT Customer C
, Item
, I_PT
, [I_PRICE]
,SUM(ORDQTY) QTY
, CASE WHEN [SEASON] IN (SELECT Season FROM [FootballSeason]) THEN 'FBCurrSeason' 
														WHEN [SEASON] IN (SELECT PrevSeason FROM [FootballSeason]) THEN 'FBPrevSeason' 
														WHEN [SEASON] IN (SELECT Season FROM [MenBBSeason]) THEN 'MBBCurrSeason' 
														WHEN [SEASON] IN (SELECT PrevSeason FROM [MenBBSeason]) THEN 'MBBPrevSeason' 
														ELSE 'UNKNOWN' END SeasonType
FROM [USC].[dbo].[vwTIReportBase]
WHERE Season IN (SELECT Season FROM [FootballSeason] 
					UNION ALL 
				SELECT PrevSeason FROM [FootballSeason]
					UNION ALL 
				SELECT Season FROM [MenBBSeason] 
					UNION ALL 
				SELECT PrevSeason FROM [MenBBSeason] )
AND ( I_PT LIKE 'M%' )
GROUP BY
Customer 
,SEASON
, Item
, I_PT
, [I_PRICE]




GO
