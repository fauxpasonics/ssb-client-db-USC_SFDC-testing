SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================




CREATE PROCEDURE [dbo].[MergePT_Name_CStageToDbo] 


AS

BEGIN
	SET NOCOUNT ON;

--peform merege ..update records in dbo table.
MERGE INTO [dbo].[PT_Name_C]  AS target
USING (SELECT ZID__c, Season__c, Price_Type__c, Name, MAX(Export_Datetime__c) Export_Datetime__c, MAX(CopyLoadDate) CopyLoadDate from [stg].[PT_Name_C] 
GROUP BY ZID__c, Season__c, Price_Type__c, Name) AS SOURCE 
ON target.[ZID__c]=source.[ZID__c] 
WHEN MATCHED THEN UPDATE SET
target.[ZID__c]=source.[ZID__c]
,target.[Season__c]=source.[Season__c]
,target.[Price_Type__c]=source.[Price_Type__c]
,target.[Name]=source.[Name]
,target.[Export_Datetime__c]=source.[Export_Datetime__c]
, target.[CopyLoadDate] = GETDATE()
WHEN NOT MATCHED THEN 
INSERT 
(
[ZID__c],
[Season__c],
[Price_Type__c],
[Name],
[Export_Datetime__c],
[CopyLoadDate]
)

VALUES
(
source.[ZID__c]
,source.[Season__c]
,source.[Price_Type__c]
,source.[Name]
,source.[Export_Datetime__c]
, GETDATE()
);

END


GO
