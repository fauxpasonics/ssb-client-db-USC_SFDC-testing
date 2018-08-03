SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [api].[GetTransactions_zzz]
(
      @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
	  @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
	  @DisplayTable INT = 0,
	  @RowsPerPage  INT = 500, 
	  @PageNumber   INT = 0
)
WITH RECOMPILE
AS

BEGIN

-- EXEC api.getaccounttransactions @SSB_CRMSYSTEM_CONTACT_ID = '4E361DD3-6DF1-4C15-ACAE-1A4692086575', @RowsPerPage = 500, @PageNumber = 0, @DisplayTable = 0

SET @SSB_CRMSYSTEM_CONTACT_ID = CASE WHEN @SSB_CRMSYSTEM_CONTACT_ID IN ('None','Test') THEN @SSB_CRMSYSTEM_ACCT_ID ELSE @SSB_CRMSYSTEM_CONTACT_ID END

DECLARE @PatronID VARCHAR(MAX)

-- Init vars needed for API
DECLARE @totalCount         INT,
	@xmlDataNode        XML,
	@recordsInResponse  INT,
	@remainingCount     INT,
	@rootNodeName       NVARCHAR(100),
	@responseInfoNode   NVARCHAR(MAX),
	@finalXml           XML
	
DECLARE @baseData TABLE (
	Team nvarchar(255) ,
	[SEASON] [varchar](15) NOT NULL,
	[SEASONNAME] [varchar](128) NULL,
	[ORDERNUMBER] [varchar](48) NULL,
	[ORDERLINE] [bigint] NOT NULL,
	[CUSTOMER] [varchar](20) NOT NULL,
	[BASIS] [varchar](10) NULL,
	[DISPOSITION] [varchar](32) NULL,
	--[EVENT] [varchar](300) NULL,
	[ITEM] [varchar](32) NULL,
	[ITEM_NAME] [varchar](256) NULL,
	[PRICE_TYPE] [varchar](32) NULL,
	[PRICE_TYPE_NAME] [varchar](128) NULL,
	[PRICE_LEVEL] [varchar](10) NULL,
	[PRICE_LEVEL_NAME] [varchar](128) NULL,
	[TICKET_PRICE] [numeric](18, 2) NULL,
	[ORDER_DATE] [datetime] NULL,
	[ORDER_QTY] [bigint] NULL,
	[ORDER_AMT] [numeric](38, 2) NULL,
	[Total_Paid] [numeric](18, 2) NULL,
	[BALANCE_REMAINING] [numeric](38, 2) NULL,
	[MINPMTDATE] [datetime] NULL,
	[ORIG_SALECODE] [varchar](32) NULL,
	[ORIG_SALECODE_NAME] [varchar](32) NULL,
	[PROMO] [varchar](32) NULL,
	[PROMO_NAME] [varchar](128) NULL,
	[MARK_CODE] [varchar](32) NULL,
	[INREFSOURCE] [varchar](128) NULL,
	[INREFDATA] [varchar](128) NULL,
	[SEAT_BLOCK] [varchar](8000) NULL,
	[ODET_EXPORT_DATETIME] [datetime] NULL,
	[ITEM_EXPORT_DATETIME] [datetime] NULL,
	[PAYMENTPLAN] VARCHAR(500) NULL,
	[maxchangedate] [datetime] NULL
)


CREATE TABLE #Trans (
	[SEASON] [varchar](15) NOT NULL,
	[SEASONNAME] [varchar](128) NULL,
	[ORDER_LINE_ID] [varchar](48) NULL,
	[ORDER_SEQUENCE] [bigint] NOT NULL,
	[CUSTOMER] [varchar](20) NOT NULL,
	[BASIS] [varchar](10) NULL,
	[DISPOSITION] [varchar](32) NULL,
	--[EVENT] [varchar](300) NULL,
	[ITEM] [varchar](32) NULL,
	[ITEM_NAME] [varchar](256) NULL,
	[PRICE_TYPE] [varchar](32) NULL,
	[PRICE_TYPE_NAME] [varchar](128) NULL,
	[PRICE_LEVEL] [varchar](10) NULL,
	[PRICE_LEVEL_NAME] [varchar](128) NULL,
	[TICKET_PRICE] [numeric](18, 2) NULL,
	[ORDER_DATE] [datetime] NULL,
	[ORDER_QTY] [bigint] NULL,
	[ORDER_AMT] [numeric](38, 2) NULL,
	[Total_Paid] [numeric](18, 2) NULL,
	[BALANCE_REMAINING] [numeric](38, 2) NULL,
	[MINPMTDATE] [datetime] NULL,
	[ORIG_SALECODE] [varchar](32) NULL,
	[ORIG_SALECODE_NAME] [varchar](32) NULL,
	[PROMO] [varchar](32) NULL,
	[PROMO_NAME] [varchar](128) NULL,
	[MARK_CODE] [varchar](32) NULL,
	[INREFSOURCE] [varchar](128) NULL,
	[INREFDATA] [varchar](128) NULL,
	[SEAT_BLOCK] [varchar](8000) NULL,
	[ODET_EXPORT_DATETIME] [datetime] NULL,
	[ITEM_EXPORT_DATETIME] [datetime] NULL,
	[PAYMENTPLAN] VARCHAR(500) NULL,
	[maxchangedate] [datetime] NULL
)

DECLARE @Parent TABLE 
(
	ParentValue VARCHAR(500)
	, ParentLabel VARCHAR(500)
	, AggregateValue MONEY
	, AggregateValue1 MONEY
)

DECLARE @ssbcontactid VARCHAR(50)=CONVERT(VARCHAR(50),@SSB_CRMSYSTEM_CONTACT_ID)


SELECT DimCustomerId INTO #CustomerIDs FROM dbo.[vwDimCustomer_ModAcctId] WITH(NOLOCK) WHERE SSB_CRMSYSTEM_CONTACT_ID = @ssbcontactid
--'4E361DD3-6DF1-4C15-ACAE-1A4692086575'

IF @@ROWCOUNT = 0
BEGIN
	INSERT INTO #CustomerIDs
	SELECT dimcustomerid FROM USC.mdm.SSB_ID_History a   WITH (NOLOCK)
	INNER JOIN USC.dbo.dimcustomer b  WITH (NOLOCK)
	ON a.ssid = b.ssid AND a.sourcesystem = b.SourceSystem
	WHERE ssb_crmsystem_contact_id = @ssbcontactid;

End

--SELECT * FROM [#CustomerIDs]

SELECT a.[SSID] 
INTO #PatronList
FROM dbo.[vwDimCustomer_ModAcctId] (nolock) a
INNER JOIN #CustomerIDs b ON a.DimCustomerId = b.DimCustomerId
WHERE a.SourceSystem = 'TI USC'
--AND b.SSB_CRMSYSTEM_CONTACT_ID = '56EB030F-2BE8-4C8F-A153-AF2A949C13B1'
-- DROP TABLE [#PatronList]

SET @PatronID = (SELECT SUBSTRING(
(SELECT ',' + s.SSID
FROM [#PatronList] s
ORDER BY s.SSID
FOR XML PATH('')),2,200000) AS CSV)

--DECLARE cSixers CURSOR
--    FOR SELECT * FROM #PatronList
--OPEN cSixers
--FETCH NEXT FROM cSixers
--INTO @PatronID

--WHILE @@FETCH_STATUS = 0
--BEGIN
 	
--SET @	

--FETCH NEXT FROM cSixers
--INTO @SixersPatron

--END 
--CLOSE cSixers;
--DEALLOCATE cSixers;
PRINT @PatronID
DECLARE @execstring NVARCHAR(2000) = 'Select *
FROM OPENROWSET(''SQLNCLI'', ''Server=172.31.17.15;Database=USC;uid=SSB_DirectConnect;pwd=Gsd2Em7Kqj'',''Select * from dbo.fn_APIView_Trans ( ''''' + @PatronID + ''''')'' )'

--'SELECT * FROM OPENROWSET(''SQLNCLI'', ''Server=172.31.17.15;Database=USC;uid=SSB_DirectConnect;pwd=Gsd2Em7Kqj'',''EXEC [dbo].[rpt_APIView_Trans] @Customers = ''''' + @PatronID + ''''''')'

IF @DisplayTable = 1
BEGIN
	PRINT @execstring
END

 INSERT INTO #Trans
 exec(@execstring)

 INSERT INTO @Parent
         ( [ParentValue] ,
           [ParentLabel] ,
           [AggregateValue],
		   [AggregateValue1]
         )
 SELECT [SEASON], SeasonName ParentLabel, SUM([ORDER_AMT]) Order_Value, SUM([BALANCE_REMAINING]) Balance FROM [#Trans] GROUP BY Season, [SEASONNAME] ORDER BY SEASON DESC

-- Cap returned results at 1000
IF @RowsPerPage > 1000
BEGIN
	SET @RowsPerPage = 1000;
END
	
-- Pull total count
SELECT @totalCount = COUNT(*)
FROM #Trans


-- Load base data
INSERT INTO @baseData
SELECT 'USC' Team, *
FROM #Trans
ORDER BY Order_Date DESC, [ORDER_LINE_ID]
OFFSET (@PageNumber) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY


-- Set records in response
SET @recordsInResponse  = (SELECT COUNT(*) FROM @baseData)

-- Create XML response data node
SET @xmlDataNode = (
SELECT [ParentValue] Season, [ParentLabel] Season_Name
, CASE WHEN SIGN(ISNULL([AggregateValue] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([AggregateValue])), '0.00') AS Order_Value,
CASE WHEN SIGN(ISNULL([AggregateValue1] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([AggregateValue1])), '0.00') AS Order_Balance,
	(SELECT 
	ISNULL(CUSTOMER,'') AS CUSTOMER ,
	CONVERT(DATE, ISNULL([ORDER_DATE],''),102) AS [ORDER_DATE] ,
	ISNULL([ITEM_NAME],'') AS [ITEM_NAME] ,
	ISNULL([ITEM],'') AS [ITEM] ,
	ISNULL([PRICE_TYPE_NAME],'') AS [PRICE_TYPE_NAME] ,
	REPLACE(ISNULL([PRICE_TYPE_NAME],'') + ' (' + ISNULL([PRICE_TYPE],'') + ')','()','') AS [PRICE_TYPE] ,
	ISNULL([PRICE_LEVEL_NAME],'') AS [PRICE_LEVEL_NAME] ,
	REPLACE(ISNULL([PRICE_LEVEL_NAME],'') + ' (' + ISNULL([PRICE_LEVEL],'') + ')','()','') AS [PRICE_LEVEL] ,
	ISNULL([ORDER_QTY],0) AS [ORDER_QTY] ,
	CASE WHEN SIGN(ISNULL([TICKET_PRICE],'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([TICKET_PRICE])), '0.00') AS [TICKET_PRICE] ,
	CASE WHEN SIGN(ISNULL([ORDER_AMT],0)) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS(ORDER_AMT)), '0.00') AS [ORDER_AMT] ,
	CASE WHEN SIGN(ISNULL([Total_Paid],0)) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([Total_Paid])), '0.00')  AS [TOTAL_PAID] ,
	CASE WHEN SIGN(ISNULL([BALANCE_REMAINING],0)) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([BALANCE_REMAINING])), '0.00') AS [BALANCE_REMAINING] ,
	ISNULL(PaymentPlan,'') AS PaymentPlan ,
	ISNULL([PROMO_NAME],'') AS [PROMO_NAME] ,
	ISNULL([PROMO],'') AS [PROMO] ,
	ISNULL([MARK_CODE],'') AS [MARK_CODE] ,
	ISNULL([DISPOSITION],'') AS [DISPOSITION] ,
	ISNULL([ORIG_SALECODE_NAME],'') AS [ORIG_SALECODE_NAME] ,
	ISNULL([ORIG_SALECODE],'') AS [ORIG_SALECODE] ,
	ISNULL([SEAT_BLOCK],'') AS [SEAT_BLOCK] ,
	ISNULL([ORDERNUMBER],'') AS [ORDERNUMBER] ,
	ISNULL([ORDERLINE],'') AS [ORDERLINE] ,
	ISNULL([BASIS],'') AS [BASIS] , 
	--ISNULL([EVENT],'') AS [EVENT] ,
	ISNULL([MINPMTDATE],'') AS [MINPMTDATE] ,
	--ISNULL([INREFSOURCE],'') AS [INREFSOURCE] ,
	--ISNULL([INREFDATA],'') AS [INREFDATA] ,
	--, ISNULL([ODET_EXPORT_DATETIME],'') AS [ODET_EXPORT_DATETIME] ,
	--ISNULL([ITEM_EXPORT_DATETIME],'') AS [ITEM_EXPORT_DATETIME] ,
	--ISNULL([maxchangedate],'') AS [maxchangedate] 
	'' [BREAK]
	FROM @baseData c
	WHERE c.season = p.ParentValue
	ORDER BY ORDER_DATE DESC, ORDERNUMBER DESC, ORDERLINE DESC
	FOR XML PATH ('Child'), TYPE) AS 'Children'
FROM @Parent AS p  
FOR XML PATH ('Parent'), ROOT('Parents'))

SET @rootNodeName = 'Parents'
	

-- Calculate remaining count
SET @remainingCount = @totalCount - (@RowsPerPage * (@PageNumber + 1))
IF @remainingCount < 0
BEGIN
	SET @remainingCount = 0
END


-- Create response info node
SET @responseInfoNode = ('<ResponseInfo>'
	+ '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20)) + '</TotalCount>'
	+ '<RemainingCount>' + CAST(@remainingCount AS NVARCHAR(20)) + '</RemainingCount>'
	+ '<RecordsInResponse>' + CAST(@recordsInResponse AS NVARCHAR(20)) + '</RecordsInResponse>'
	+ '<PagedResponse>true</PagedResponse>'
	+ '<RowsPerPage>' + CAST(@RowsPerPage AS NVARCHAR(20)) + '</RowsPerPage>'
	+ '<PageNumber>' + CAST(@PageNumber AS NVARCHAR(20)) + '</PageNumber>'
	+ '<RootNodeName>' + @rootNodeName + '</RootNodeName>'
	+ '</ResponseInfo>')

	
-- Wrap response info and data, then return	
IF @xmlDataNode IS NULL
BEGIN
	SET @xmlDataNode = '<' + @rootNodeName + ' />' 
END
		
SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'

If @DisplayTable = 0
BEGIN
SELECT CAST(@finalXml AS XML)
END
Else 
BEGIN
Select * from @baseData
END

END
GO
