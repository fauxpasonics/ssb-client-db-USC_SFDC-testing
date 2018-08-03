SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[Merge_Transaction_Detail__c]

AS
BEGIN 

merge into dbo.Transaction_Detail__c as target
using  src.Transaction_Detail__c as SOURCE 
on target.hashkey = source.hashkey
when not matched by Target then
INSERT 
(
Customer__c
,HashKey
,Item__c
,Item_Discount_Amount__c
,Item_Price__c
,Min_Pmt_Date__C
,Order_Quantity__c
,Order_Total__C
,Paid_Customer__c
,Paid_Total__c
,Price_Level__c
,Price_Type__c
,Season__c
,changetype
,dblastupdated
) 
VALUES 
(
source.Customer__c
,source.HashKey
,source.Item__c
,source.Item_Discount_Amount__c
,source.Item_Price__c
,source.Min_Pmt_Date__C
,source.Order_Quantity__c
,source.Order_Total__C
,source.Paid_Customer__c
,source.Paid_Total__c
,source.Price_Level__c
,source.Price_Type__c
,source.Season__c
,'c'
,getdate()
)
when not matched by source then update 
set  changetype = 'd'
,target.dblastupdated = getdate();

      
END











GO
