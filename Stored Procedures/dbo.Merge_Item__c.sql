SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[Merge_Item__c] 

AS
BEGIN 

merge into dbo.Item__c as target
using  src.Item__c as SOURCE 
on target.zid__c = source.zid__c
when matched 
and  (isnull(target.EXPORT_DATETIME__c,'1900-01-01') <> isnull(source.EXPORT_DATETIME__c,'1900-01-02'))
then 
UPDATE SET target.[NAME] = source.name 
, changetype = 'c',
 target.EXPORT_DATETIME__c = source.EXPORT_DATETIME__c, target.dblastupdated = getdate()
when not matched by Target then
INSERT (season__c, item__c, name,EXPORT_DATETIME__c,changetype,ZID__c,dblastupdated) 
VALUES (SOURCE.season__c, SOURCE.item__c, SOURCE.name, source.EXPORT_DATETIME__c, 'c',ZID__c,getdate())
when not matched by source then update set [EXPORT_DATETIME__c] = getdate() , changetype = 'd',target.dblastupdated = getdate();

      
END









GO
