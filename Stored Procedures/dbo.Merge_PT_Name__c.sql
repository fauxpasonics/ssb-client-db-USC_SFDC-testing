SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE PROCEDURE [dbo].[Merge_PT_Name__c]

AS
BEGIN 

merge into dbo.PT_Name__c as target
using  src.PT_Name__c as SOURCE 
on target.zid__c = source.zid__c
when matched 
and  
(
(isnull(target.EXPORT_DATETIME__c,'1900-01-01') <> isnull(source.EXPORT_DATETIME__c,'1900-01-02'))
)
then 
UPDATE 
SET 
target.NAME = source.NAME 
, target.EXPORT_DATETIME__c = source.EXPORT_DATETIME__c
, changetype = 'c'
,target.dblastupdated = getdate()

when not matched by Target then
INSERT (SEASON__c, Price_Type__c,            NAME, EXPORT_DATETIME__c,changetype,zid__c,dblastupdated) 
VALUES (SOURCE.SEASON__c, SOURCE.Price_Type__c, NAME,source.EXPORT_DATETIME__c, 'c',zid__c,getdate())
when not matched by source then update set 
Export_Datetime__c = getdate() 
, changetype = 'd'
,target.dblastupdated = getdate()
;


      
END












GO
