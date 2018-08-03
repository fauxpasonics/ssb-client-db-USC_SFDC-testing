SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [src].[vw_Transactions__c] AS 

SELECT a.* FROM src.Transactions__c a
INNER JOIN (SELECT Order_Line_ID__c, MAX(Export_Datetime__c) MaxDate FROM src.Transactions__c GROUP BY Order_Line_ID__c) b 
					ON b.Order_Line_ID__c = a.Order_Line_ID__c AND a.Export_Datetime__c = b.MaxDate
GO
