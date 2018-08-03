SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================




CREATE PROCEDURE [dbo].[MergeSFDC_SeasonStageToDbo] 


AS

BEGIN
	SET NOCOUNT ON;

--peform merege ..update records in dbo table.
MERGE INTO [dbo].[SFDC_Season]  AS target
USING [stg].[SFDC_Season]  AS SOURCE 
ON target.[ZID__c]=source.[ZID__c] 
WHEN MATCHED THEN UPDATE SET
target.[ZID__c]=source.[ZID__c]
,target.[Name]=source.[Name]
,target.[Export_Datetime__c]=source.[Export_Datetime__c]
,target.[Season__c]=source.[Season__c]
,target.[Activity__c]=source.[Activity__c]
,target.[Status__c]=source.[Status__c]
,target.[CopyLoadDate] = GETDATE()
WHEN NOT MATCHED THEN 
INSERT 
(
[ZID__c],
[Name],
[Export_Datetime__c],
[Season__c],
[Activity__c],
[Status__c],
[CopyLoadDate]
)

VALUES
(
source.[ZID__c]
,source.[Name]
,source.[Export_Datetime__c]
,source.[Season__c]
,source.[Activity__c]
,source.[Status__c]
, GETDATE()
);

END


GO
