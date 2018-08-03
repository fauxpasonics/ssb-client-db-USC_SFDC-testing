SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================




CREATE PROCEDURE [dbo].[MergeSFDCItem_CStageToDbo] 


AS

BEGIN
	SET NOCOUNT ON;

--peform merege ..update records in dbo table.
MERGE INTO [dbo].[SFDC_Item]  AS target
USING [stg].SFDC_Item  AS SOURCE 
ON target.[ZID__c] = source.[ZID__c] 
WHEN MATCHED THEN UPDATE SET
target.[Name]=source.[Name]
,target.[Export_Datetime__c]=source.[Export_Datetime__c]
,target.[Item__c]=source.[Item__c]
,target.[ZID__c]=source.[ZID__c]
,target.[Season__c]=source.[Season__c]
, target.[CopyLoadDate] = GETDATE()
WHEN NOT MATCHED THEN 
INSERT 
(
  
[Name],
[Export_Datetime__c],
[Item__c],
[ZID__c],
[Season__c],
[CopyLoadDate]
	)

VALUES
(

source.[Name]
,source.[Export_Datetime__c]
,source.[Item__c]
,source.[ZID__c]
,source.[Season__c]
, GETDATE()
);

END

GO
