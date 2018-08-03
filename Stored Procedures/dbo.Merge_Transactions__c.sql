SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[Merge_Transactions__c]

AS
BEGIN 

merge into dbo.Transactions__c as target
using src.vw_Transactions__c as SOURCE 
on target.Order_Line_ID__c = source.Order_Line_ID__c
when matched 
and  
(
(isnull(target.Export_Datetime__c,'1900-01-01') <> isnull(source.Export_Datetime__c,'1900-01-02'))
)
then 
Update set 
 target.Amount_Paid__c = source.Amount_Paid__c
,target.Basis__c = source.Basis__c
,target.Disposition_Code__c = source.Disposition_Code__c
,target.Event_Code__c = source.Event_Code__c
,target.Export_Datetime__c = source.Export_Datetime__c
,target.Inrefdata__c = source.Inrefdata__c
,target.Inrefsource__c = source.Inrefsource__c
,target.Item_Code__c = source.Item_Code__c
,target.Item_Price__c = source.Item_Price__c
,target.Order_Date__c = source.Order_Date__c
,target.Order_Line_ID__c = source.Order_Line_ID__c
,target.Order_Quantity__c = source.Order_Quantity__c
,target.Order_Total__c = source.Order_Total__c
,target.Orig_Salecode__c = source.Orig_Salecode__c
,target.Patron_ID__c = source.Patron_ID__c
,target.Price_Level__c = source.Price_Level__c
,target.Price_Type__c = source.Price_Type__c
,target.Promo_Code__c = source.Promo_Code__c
,target.Rep_Code__c = source.Rep_Code__c
,target.Season_Code__c = source.Season_Code__c
,target.Seat_Block__c = source.Seat_Block__c
,target.Sequence__c = source.Sequence__c
,Target.[Season_Name__c] = source.[Season_Name__c]
,Target.[Item_Title__c] = source.[Item_Title__c]
,Target.[Orig_Salecode_Name__c] = source.[Orig_Salecode_Name__c]
,Target.[Promo_Code_Name__c] = source.[Promo_Code_Name__c]
,target.changetype = 'c'
,target.dblastupdated = getdate()
when not matched by Target then
INSERT 
(
Amount_Paid__c
,Basis__c
,Disposition_Code__c
,Event_Code__c
,Export_Datetime__c
,Inrefdata__c
,Inrefsource__c
,Item_Code__c
,Item_Price__c
,Order_Date__c
,Order_Line_ID__c
,Order_Quantity__c
,Order_Total__c
,Orig_Salecode__c
,Patron_ID__c
,Price_Level__c
,Price_Type__c
,Promo_Code__c
,Rep_Code__c
,Season_Code__c
,Seat_Block__c
,Sequence__c
,[Season_Name__c]
,[Item_Title__c]
,[Orig_Salecode_Name__c]
,[Promo_Code_Name__c]
,dblastupdated
,changetype)
VALUES 
(
source.Amount_Paid__c
,source.Basis__c
,source.Disposition_Code__c
,source.Event_Code__c
,source.Export_Datetime__c
,source.Inrefdata__c
,source.Inrefsource__c
,source.Item_Code__c
,source.Item_Price__c
,source.Order_Date__c
,source.Order_Line_ID__c
,source.Order_Quantity__c
,source.Order_Total__c
,source.Orig_Salecode__c
,source.Patron_ID__c
,source.Price_Level__c
,source.Price_Type__c
,source.Promo_Code__c
,source.Rep_Code__c
,source.Season_Code__c
,source.Seat_Block__c
,source.Sequence__c
,source.[Season_Name__c]
,source.[Item_Title__c]
,source.[Orig_Salecode_Name__c]
,source.[Promo_Code_Name__c]
,getdate()
,'c')
when not matched by source then 
update set 
  Export_Datetime__c = getdate() 
, changetype = 'd'
, target.dblastupdated = getdate()
;


      
END











GO
