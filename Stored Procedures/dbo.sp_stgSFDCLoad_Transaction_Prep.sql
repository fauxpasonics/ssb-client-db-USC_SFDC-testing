SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_stgSFDCLoad_Transaction_Prep]
@DateAdd INT

AS 

DECLARE @MaxDate DATETIME, @SourceSystem VARCHAR(50)
SET @SourceSystem = 'TI USC'
SET @MaxDate = CAST(DATEADD(DAY, @DateAdd, GETDATE()) AS DATE)
PRINT @MaxDate
-- exec dbo.sp_stgSFDCLoad_Transaction_Prep '1/1/2015'
--SELECT MIN(Order_Date), MAX(Order_Date), COUNT(*) FROM dbo.[stgSFDCLoad_Transactions_Prep]

select DISTINCT ssid, sourcesystem, [ssb_crmsystem_contact_id]
into #tmpSsid
--DROP TABLE [#tmpSsid]
from usc.mdm.SSB_ID_History
where 1=1
AND createddate >= @MaxDate
and sourcesystem = @SourceSystem
union 
select distinct customer, [a].[SourceSystem], b.[SSB_CRMSYSTEM_CONTACT_ID]
from dbo.SFDC_TransOdet a 
INNER JOIN USC.dbo.[vwDimCustomer_ModAcctId] b ON [a].[CUSTOMER] = b.[SSID] AND b.[SourceSystem] = @SourceSystem
where 1=1
--AND [CUSTOMER] = '228713'
AND order_date >= @MaxDate
UNION ALL
SELECT DISTINCT y.[CUSTOMER], [z].[SourceSystem], z.[SSB_CRMSYSTEM_CONTACT_ID]
--, COUNT(y.[ORDER_LINE_ID]) TransCount
FROM ProdCopy.[vw_Account] a WITH(NOLOCK)
INNER JOIN dbo.[vwDimCustomer_ModAcctId] z ON a.SSB_CRMSYSTEM_ACCT_ID__c = z.[SSB_CRMSYSTEM_CONTACT_ID]
INNER JOIN [dbo].[SFDC_TransOdet] y ON z.[SSID] = y.[CUSTOMER] AND z.[SourceSystem] = @SourceSystem and y.[ORDER_DATE] >= '1/1/2011'
LEFT JOIN ProdCopy.[Transactions__c] b ON y.Season + ':' + y.[ORDER_LINE_ID] = b.[Order_Line_ID__c]
WHERE [a].[CreatedDate] > @MaxDate
AND b.id IS NULL
--AND a.createdbyid IN (SELECT id FROM ProdCopy.[User] WHERE name = 'ETL User')
--GROUP BY y.Customer

TRUNCATE TABLE dbo.stgSFDCLoad_Transactions_Prep
TRUNCATE TABLE dbo.stgSFDCLoad_Transactions_PrepPatron

INSERT INTO dbo.stgSFDCLoad_Transactions_Prep
SELECT a.* FROM dbo.[SFDC_TransOdet] a 
INNER JOIN (SELECT * FROM USC.dbo.[vwDimCustomer_ModAcctId] WHERE [SSB_CRMSYSTEM_CONTACT_ID] IN (select [SSB_CRMSYSTEM_CONTACT_ID] FROM #tmpSsid)) b 
			ON a.[CUSTOMER] = b.[SSID] AND b.[SourceSystem] = @SourceSystem

--drop table #tmpSsid

--select * from dbo.SFDC_TransOdet where customer = '386932'

--select * from dbo.stgSFDCLoad_Transactions_Prep where customer = '386932'
--select count(*) from dbo.stgSFDCLoad_Transactions_Prep

INSERT INTO dbo.stgSFDCLoad_Transactions_PrepPatron
SELECT DISTINCT a.[CUSTOMER], z.[SSB_CRMSYSTEM_CONTACT_ID] [SSB_CRMSYSTEM_ACCT_ID] 
FROM dbo.stgSFDCLoad_Transactions_Prep a
INNER JOIN USC.dbo.[vwDimCustomer_ModAcctId] z ON a.[CUSTOMER] = z.[SSID] AND z.[SourceSystem] = @SourceSystem
GO
