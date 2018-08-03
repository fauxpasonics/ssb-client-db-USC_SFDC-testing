SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


CREATE  PROCEDURE [dbo].[MergeSFDC_TransOutputStageToDbo] 


AS

BEGIN
	SET NOCOUNT ON;

--peform merege ..update records in dbo table.
MERGE INTO [dbo].[SFDC_TransOutput]  AS target
USING [stg].[SFDC_TransOutput]  AS SOURCE 
ON target.[SEASON]=source.[SEASON] AND target.[CUSTOMER]=source.[CUSTOMER] AND target.[ITEM]=source.[ITEM] AND target.[E_PL]=source.[E_PL] AND target.[I_PT]=source.[I_PT] AND target.[I_PRICE]=source.[I_PRICE]
WHEN MATCHED THEN UPDATE SET
target.[SEASON]=source.[SEASON]
,target.[CUSTOMER]=source.[CUSTOMER]
,target.[ITEM]=source.[ITEM]
,target.[E_PL]=source.[E_PL]
,target.[I_PT]=source.[I_PT]
,target.[I_PRICE]=source.[I_PRICE]
,target.[I_DAMT]=source.[I_DAMT]
,target.[ORDQTY]=source.[ORDQTY]
,target.[ORDTOTAL]=source.[ORDTOTAL]
,target.[PAIDCUSTOMER]=source.[PAIDCUSTOMER]
,target.[MINPAYMENTDATE]=source.[MINPAYMENTDATE]
,target.[PAIDTOTAL]=source.[PAIDTOTAL]
,target.[CopyLoadDate] = GETDATE()
WHEN NOT MATCHED THEN 
INSERT 
(
[SEASON],
[CUSTOMER],
[ITEM],
[E_PL],
[I_PT],
[I_PRICE],
[I_DAMT],
[ORDQTY],
[ORDTOTAL],
[PAIDCUSTOMER],
[MINPAYMENTDATE],
[PAIDTOTAL],
[CopyLoadDate]
)

VALUES
(
source.[SEASON]
,source.[CUSTOMER]
,source.[ITEM]
,source.[E_PL]
,source.[I_PT]
,source.[I_PRICE]
,source.[I_DAMT]
,source.[ORDQTY]
,source.[ORDTOTAL]
,source.[PAIDCUSTOMER]
,source.[MINPAYMENTDATE]
,source.[PAIDTOTAL]
, GETDATE()
);

END



GO
