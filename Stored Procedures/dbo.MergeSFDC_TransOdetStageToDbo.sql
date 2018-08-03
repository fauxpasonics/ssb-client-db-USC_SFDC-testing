SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[MergeSFDC_TransOdetStageToDbo] 

AS

BEGIN
	SET NOCOUNT ON;

UPDATE a
SET CurrentHash = HASHBYTES( 'SHA2_256', ISNULL([SEASON],'')
+ ISNULL([ORDER_LINE_ID],'')
+ ISNULL(CAST([ORDER_SEQUENCE] AS VARCHAR(50)),'')
+ ISNULL([CUSTOMER],'')
+ ISNULL([BASIS],'')
+ ISNULL([I_DISP],'')
+ ISNULL([EVENT],'')
+ ISNULL([ITEM],'')
+ ISNULL([I_PL],'')
+ ISNULL([I_PT],'')
+ ISNULL(CAST([I_PRICE] AS VARCHAR(50)),'')
+ ISNULL(CAST([ORDER_DATE] AS VARCHAR(50)),'')
+ ISNULL(CAST([I_OQTY] AS VARCHAR(50)),'')
+ ISNULL(CAST([ORDER_TOTAL] AS VARCHAR(50)),'')
+ ISNULL(CAST([I_PAY] AS VARCHAR(50)),'')
+ ISNULL(CAST([MINPMTDATE] AS VARCHAR(50)),'')
+ ISNULL([ORIG_SALECODE],'')
+ ISNULL([PROMO],'')
+ ISNULL([I_MARK],'')
+ ISNULL([INREFSOURCE],'')
+ ISNULL([INREFDATA],'')
+ ISNULL([SEAT_BLOCK],'')
+ ISNULL(CAST([ODET_EXPORT_DATETIME] AS VARCHAR(50)),'')
+ ISNULL(CAST([ITEM_EXPORT_DATETIME] AS varchar(50)),'')
+ ISNULL(CAST([maxchangedate] AS varchar(50)),''))
FROM stg.[SFDC_TransOdet] a

--TRUNCATE TABLE dbo.[SFDC_TransOdet]

--peform merege ..update records in dbo table.
MERGE INTO [dbo].[SFDC_TransOdet]  AS target
USING [stg].[SFDC_TransOdet]  AS SOURCE 
ON target.[SEASON]=source.[SEASON] AND target.[ORDER_LINE_ID]=source.[ORDER_LINE_ID]
WHEN MATCHED AND TARGET.CurrentHash <> SOURCE.CurrentHash THEN UPDATE SET
target.SourceSystem = 'USC'
,target.[SEASON]=source.[SEASON]
,target.[ORDER_LINE_ID]=source.[ORDER_LINE_ID]
,target.[ORDER_SEQUENCE]=source.[ORDER_SEQUENCE]
,target.[CUSTOMER]=source.[CUSTOMER]
,target.[BASIS]=source.[BASIS]
,target.[I_DISP]=source.[I_DISP]
,target.[EVENT]=source.[EVENT]
,target.[ITEM]=source.[ITEM]
,target.[I_PL]=source.[I_PL]
,target.[I_PT]=source.[I_PT]
,target.[I_PRICE]=source.[I_PRICE]
,target.[ORDER_DATE]=source.[ORDER_DATE]
,target.[I_OQTY]=source.[I_OQTY]
,target.[ORDER_TOTAL]=source.[ORDER_TOTAL]
,target.[I_PAY]=source.[I_PAY]
,target.[MINPMTDATE]=source.[MINPMTDATE]
,target.[ORIG_SALECODE]=source.[ORIG_SALECODE]
,target.[PROMO]=source.[PROMO]
,target.[I_MARK]=source.[I_MARK]
,target.[INREFSOURCE]=source.[INREFSOURCE]
,target.[INREFDATA]=source.[INREFDATA]
,target.[SEAT_BLOCK]=source.[SEAT_BLOCK]
,target.[ODET_EXPORT_DATETIME]=source.[ODET_EXPORT_DATETIME]
,target.[ITEM_EXPORT_DATETIME]=source.[ITEM_EXPORT_DATETIME]
,target.[maxchangedate]=source.[maxchangedate]
, target.[CopyLoadDate] = GETDATE()
, target.currenthash = SOURCE.currenthash
WHEN NOT MATCHED THEN 
INSERT 
(
[SourceSystem],
[SEASON],
[ORDER_LINE_ID],
[ORDER_SEQUENCE],
[CUSTOMER],
[BASIS],
[I_DISP],
[EVENT],
[ITEM],
[I_PL],
[I_PT],
[I_PRICE],
[ORDER_DATE],
[I_OQTY],
[ORDER_TOTAL],
[I_PAY],
[MINPMTDATE],
[ORIG_SALECODE],
[PROMO],
[I_MARK],
[INREFSOURCE],
[INREFDATA],
[SEAT_BLOCK],
[ODET_EXPORT_DATETIME],
[ITEM_EXPORT_DATETIME],
[maxchangedate],
[CopyLoadDate],
CurrentHash
)

VALUES
(
'USC'
,source.[SEASON]
,source.[ORDER_LINE_ID]
,source.[ORDER_SEQUENCE]
,source.[CUSTOMER]
,source.[BASIS]
,source.[I_DISP]
,source.[EVENT]
,source.[ITEM]
,source.[I_PL]
,source.[I_PT]
,source.[I_PRICE]
,source.[ORDER_DATE]
,source.[I_OQTY]
,source.[ORDER_TOTAL]
,source.[I_PAY]
,source.[MINPMTDATE]
,source.[ORIG_SALECODE]
,source.[PROMO]
,source.[I_MARK]
,source.[INREFSOURCE]
,source.[INREFDATA]
,source.[SEAT_BLOCK]
,source.[ODET_EXPORT_DATETIME]
,source.[ITEM_EXPORT_DATETIME]
,source.[maxchangedate]
, GETDATE()
, CurrentHash
);

END



GO
