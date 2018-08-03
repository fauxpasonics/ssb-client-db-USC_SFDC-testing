SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--SELECT * FROM [dbo].[vwSFDCLoad_Transactions] ORDER BY Order_Date__c ASC


CREATE VIEW  [dbo].[vwSFDCLoad_Transactions]  AS 

SELECT a.[SEASON] Season_Code__c
, a.[ORDER_LINE_ID] Order_Line_ID__c
, a.[ORDER_SEQUENCE] Sequence__c
, a.[CUSTOMER] Patron_ID__c
, a.[BASIS] Basis__c
, a.[I_DISP] Disposition_Code__c
, a.[EVENT] Event_Code__c
, a.[ITEM] Item_Code__c
, a.[I_PL] Price_Level__c
, a.[I_PT] Price_Type__c
, a.[I_PRICE] Item_Price__c
, a.[ORDER_DATE] Order_Date__c
, a.[I_OQTY] Order_Quantity__c
, a.[ORDER_TOTAL] Order_Total__c
, a.[I_PAY] Amount_Paid__c
, a.[ORIG_SALECODE] Orig_Salecode__c
, a.[PROMO] Promo_Code__c
, a.[I_MARK] Rep_Code__c
, a.[INREFSOURCE] Inrefsource__c
, a.[INREFDATA] Inrefdata__c
, a.[SEAT_BLOCK] Seat_Block__c
, a.[CopyLoadDate] Export_Datetime__c
, season.[Name] Season_Name__c
, item.[Name] Item_Title__c
, origSC.[Name] Orig_Salecode_Name__c
, promo.Name Promo_Code_Name__c
, c.[salesforce_ID] Account__c
--Select *
FROM dbo.stgSFDCLoad_Transactions_Prep a
--INNER JOIN (SELECT Order_Line_ID__c, MAX(Export_Datetime__c) MaxDate FROM src.Transactions__c GROUP BY Order_Line_ID__c) b 
--					ON b.Order_Line_ID__c = a.Order_Line_ID__c AND a.Export_Datetime__c = b.MaxDate
INNER JOIN dbo.stgSFDCLoad_Transactions_PrepPatron z ON a.[CUSTOMER] = z.[CUSTOMER]
INNER JOIN dbo.Account c ON z.[SSB_CRMSYSTEM_ACCT_ID] = c.[SSB_CRMSYSTEM_ACCT_ID]
LEFT JOIN dbo.[SFDC_Season] season ON a.[SEASON] = season.[Season__c]
LEFT JOIN dbo.[SFDC_SalesCode] origSC ON a.[ORIG_SALECODE] = [origSC].[Salecode__c]
LEFT JOIN dbo.[SFDC_PromoCode] promo ON a.[PROMO] = promo.[Promo__c]
LEFT JOIN dbo.[SFDC_Item] item ON a.[ITEM] = item.[Item__c] AND a.[SEASON] = item.season__c
WHERE LEN(c.[salesforce_ID]) = 18
AND [a].[Order_Date] >= DATEADD(DAY,-730,GETDATE()) -- ADDED BY AMEITIN 10/23/2017



GO
