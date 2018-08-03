SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [api].[GetDonations_zzz]
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

-- EXEC api.GetDonations @SSB_CRMSYSTEM_CONTACT_ID = 'B0BD7036-3A5D-488F-BAD4-D9FB49DB726B', @RowsPerPage = 500, @PageNumber = 0, @DisplayTable = 0

SET @SSB_CRMSYSTEM_CONTACT_ID = CASE WHEN @SSB_CRMSYSTEM_CONTACT_ID IN ('None','Test') THEN @SSB_CRMSYSTEM_ACCT_ID ELSE @SSB_CRMSYSTEM_CONTACT_ID END

/*
Declare 	@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = '0001A499-0256-4D7F-A969-9D5156DC2CE2',
	@RowsPerPage  INT = 500,
	@PageNumber   INT = 0,
	@DisplayTable int = 0
*/

DECLARE @PatronID VARCHAR(MAX)

-- Init vars needed for API
DECLARE @totalCount         INT,
	@xmlDataNode        XML,
	@recordsInResponse  INT,
	@remainingCount     INT,
	@rootNodeName       NVARCHAR(100),
	@responseInfoNode   NVARCHAR(MAX),
	@finalXml           XML

-- Cap returned results at 1000
IF @RowsPerPage > 1000
BEGIN
	SET @RowsPerPage = 1000;
END

SELECT DimCustomerId 
INTO #CustomerIDs 
FROM dbo.[vwDimCustomer_ModAcctId] WITH(NOLOCK) WHERE SSB_CRMSYSTEM_CONTACT_ID = 
--'4E361DD3-6DF1-4C15-ACAE-1A4692086575'
@SSB_CRMSYSTEM_CONTACT_ID
--'4E361DD3-6DF1-4C15-ACAE-1A4692086575'
-- DROP TABLE #CustomerIDs

IF @@ROWCOUNT = 0
BEGIN
	INSERT INTO #CustomerIDs
	SELECT dimcustomerid FROM [USC].mdm.SSB_ID_History a   WITH (NOLOCK)
	INNER JOIN dbo.[vwDimCustomer_ModAcctId] b  WITH (NOLOCK)
	ON a.ssid = b.ssid AND a.sourcesystem = b.SourceSystem
	WHERE a.ssb_crmsystem_contact_id = @SSB_CRMSYSTEM_CONTACT_ID;

END

--SELECT * FROM [#CustomerIDs]

SELECT a.[SSID] 
INTO #PatronList
FROM dbo.[vwDimCustomer_ModAcctId] (nolock) a
INNER JOIN #CustomerIDs b ON a.DimCustomerId = b.DimCustomerId
WHERE a.SourceSystem = 'USC_Advantage'
--AND a.SSID = '27182'
--AND b.SSB_CRMSYSTEM_CONTACT_ID = '56EB030F-2BE8-4C8F-A153-AF2A949C13B1'
-- DROP TABLE [#PatronList]

--SELECT * FROM [#PatronList]

SET @PatronID = (SELECT SUBSTRING(
(SELECT ',' + s.SSID
FROM [#PatronList] s
ORDER BY s.SSID
FOR XML PATH('')),2,200000) AS CSV)

SELECT
contact.ADNumber
,contact.ContactID
, header.TransID
,header.TransYear
,header.TransDate
,header.TransGroup
,program.ProgramCode
,program.ProgramName
,program.ProgramGroup
, header.TransType
, lineitem.TransAmount
--,SUM(CASE WHEN TransType LIKE '%pledge%' THEN lineItem.TransAmount ELSE 0 END) Pledge
--,SUM(CASE WHEN TransType LIKE '%receipt%' OR TransType LIKE '%CR Correction%' THEN lineItem.TransAmount ELSE 0 END) Donation
INTO #tmpA
--Drop Table #tmpA
--SELECT Donor, COUNT(*) COUNT
FROM USC.dbo.ADV_Contact contact WITH (NOLOCK)
	 JOIN USC.dbo.ADV_ContactTransHeader header WITH (NOLOCK)
		  ON contact.ContactID = header.ContactID
	 JOIN USC.dbo.ADV_ContactTransLineItems lineItem WITH (NOLOCK)
		  ON header.TransID = lineitem.transID
	 JOIN USC.dbo.ADV_Program program WITH (NOLOCK)
		  ON lineitem.ProgramID = program.ProgramID
WHERE contact.ContactID IN (SELECT * FROM [#PatronList])
and ProgramGroup = 'Trojan Athletic Fund'
--GROUP BY contact.ADNumber
--,contact.ContactID
--,header.TransYear
--,header.TransDate
--,header.TransGroup
--,program.ProgramCode
--,program.ProgramName
--,program.ProgramGroup

 SET @totalCount = @@ROWCOUNT
 
SELECT ADNumber Donor
,TransYear _Year
,Convert(varchar(50),CAST(TransDate AS DATE),101) _Date
, TransID Trans_ID
--,TransGroup Trans_Group
,TransAmount Amount
,TransType Transaction_Type
, ProgramName _Name
--,PaymentType Payment_Type
--,ProgramCode Program_Code
INTO #ReturnSet
FROM #tmpA a
ORDER BY TransDate DESC
OFFSET (@PageNumber) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY
--DROP TABLE #ReturnSet
--SELECT * FROM [#ReturnSet]

SET @recordsInResponse  = (SELECT COUNT(*) FROM #ReturnSet)

SELECT TransYear _Year
,SUM(CASE WHEN TransType LIKE '%pledge%' THEN TransAmount ELSE 0 END) Pledge_Total
,SUM(CASE WHEN TransType LIKE '%receipt%' OR TransType LIKE '%CR Correction%' THEN TransAmount ELSE 0 END) Cash_Total
, SUM(CASE WHEN TransType LIKE '%pledge%' THEN TransAmount ELSE 0 END) - SUM(CASE WHEN TransType LIKE '%receipt%' OR TransType LIKE '%CR Correction%' THEN TransAmount ELSE 0 END) as Balance
INTO #TopGroup
FROM #tmpA
GROUP BY TransYear

SELECT TransYear _Year
, ProgramName _Name
,SUM(CASE WHEN TransType LIKE '%pledge%' THEN TransAmount ELSE 0 END) Pledge_Total
,SUM(CASE WHEN TransType LIKE '%receipt%' OR TransType LIKE '%CR Correction%' THEN TransAmount ELSE 0 END) Cash_Total
, SUM(CASE WHEN TransType LIKE '%pledge%' THEN TransAmount ELSE 0 END) - SUM(CASE WHEN TransType LIKE '%receipt%' OR TransType LIKE '%CR Correction%' THEN TransAmount ELSE 0 END) as Balance
INTO #SecGroup
FROM #tmpA
GROUP BY TransYear, ProgramName

-- Create XML response data node
SET @xmlDataNode = (
--SELECT [ParentValue] Season , [ParentLabel] AS [Season_Name]
--, CASE WHEN SIGN(ISNULL([AggregateValue] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([AggregateValue])), '0.00') AS [Order_Value],
--CASE WHEN SIGN(ISNULL([AggregateValue1] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([AggregateValue1])), '0.00') AS [Order_Balance],
SELECT _Year
, CASE WHEN SIGN(ISNULL(p.Pledge_Total ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS(p.[Pledge_Total])), '0.00') as Pledge_Total_
, CASE WHEN SIGN(ISNULL(p.Cash_Total ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS(p.[Cash_Total])), '0.00') as Cash_Total_
, CASE WHEN SIGN(ISNULL(p.Balance ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS(p.[Balance])), '0.00') as Balance_
, (
	SELECT _Year
	, _Name
	, CASE WHEN SIGN(ISNULL(c.Pledge_Total ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS(c.[Pledge_Total])), '0.00') as Pledge_Total_
	, CASE WHEN SIGN(ISNULL(c.Cash_Total ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([c].[Cash_Total])), '0.00') as Cash_Total_
	, CASE WHEN SIGN(ISNULL(c.Balance ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([c].[Balance])), '0.00') as Balance_
, (
	SELECT Donor
	, _Date
	, Transaction_Type
	, CASE WHEN SIGN(ISNULL(Amount,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( Amount )), '0.00') AS Amount
	FROM #ReturnSet i
		WHERE i._Year = c._Year AND i._Name = c._Name
		ORDER BY Donor ASC, _Date ASC, Transaction_Type ASC
		FOR XML PATH ('Infant'), TYPE) AS 'Infants'
	FROM #SecGroup c
	WHERE c._Year = p._Year
	ORDER BY Pledge_Total_ DESC, _Name ASC
	FOR XML PATH ('Child'), TYPE) AS 'Children'
FROM #TopGroup AS p  
ORDER BY _Year
FOR XML PATH ('Parent'), ROOT('Parents')
)


SET @rootNodeName = 'Parents'

-- Calculate remaining count
SET @remainingCount = @totalCount - (@RowsPerPage * (@PageNumber + 1))
IF @remainingCount < 0
BEGIN
	SET @remainingCount = 0
END

-- Wrap response info and data, then return	
IF @xmlDataNode IS NULL
BEGIN
	SET @xmlDataNode = '<' + @rootNodeName + ' />' 
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

SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'

IF ISNULL(@DisplayTable,0) = 0
BEGIN
SELECT CAST(@finalXml AS XML)
END
ELSE 
BEGIN
SELECT * FROM [#ReturnSet]
END

DROP TABLE [#tmpA]
DROP TABLE [#ReturnSet]
DROP TABLE [#CustomerIDs]
DROP TABLE [#PatronList]
DROP TABLE [#TopGroup]
DROP TABLE [#SecGroup]

END
GO
