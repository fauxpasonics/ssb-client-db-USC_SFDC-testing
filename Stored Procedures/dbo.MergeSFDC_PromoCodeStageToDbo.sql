SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================




CREATE PROCEDURE [dbo].[MergeSFDC_PromoCodeStageToDbo] 


AS

BEGIN
	SET NOCOUNT ON;

--peform merege ..update records in dbo table.
MERGE INTO [dbo].[SFDC_PromoCode]  AS target
USING [stg].[SFDC_PromoCode]  AS SOURCE 
ON target.[ZID__c]=source.[ZID__c] 
WHEN MATCHED THEN UPDATE SET
target.[ZID__c]=source.[ZID__c]
,target.[Name]=source.[Name]
,target.[Export_Datetime__c]=source.[Export_Datetime__c]
,target.[Promo__c]=source.[Promo__c]
, target.[CopyLoadDate] = GETDATE()
WHEN NOT MATCHED THEN 
INSERT 
(
[ZID__c],
[Name],
[Export_Datetime__c],
[Promo__c],
[CopyLoadDate]

)

VALUES
(
source.[ZID__c]
,source.[Name]
,source.[Export_Datetime__c]
,source.[Promo__c]
, GETDATE()
);

END


GO
