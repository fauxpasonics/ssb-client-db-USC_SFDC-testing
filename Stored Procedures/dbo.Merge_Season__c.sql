SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Merge_Season__c]

AS
BEGIN 

merge into dbo.Season__c as target
using  src.Season__c as SOURCE 
on target.zid__c = source.zid__c
when matched 
and  
(
(isnull(target.EXPORT_DATETIME__c,'1900-01-01') <> isnull(source.EXPORT_DATETIME__c,'1900-01-02'))
)
then 
UPDATE 
SET target.NAME = source.NAME 
,target.ACTIVITY__c = source.ACTIVITY__c 
,target.STATUS__c = source.STATUS__c 
, changetype = 'c', target.EXPORT_DATETIME__c = source.EXPORT_DATETIME__c,target.dblastupdated = getdate()
when not matched by Target then
INSERT (SEASON__c,NAME,ACTIVITY__c, STATUS__c, EXPORT_DATETIME__c,changetype,zid__c,dblastupdated) 
VALUES (SOURCE.SEASON__c, SOURCE.NAME, SOURCE.ACTIVITY__c,SOURCE.STATUS__c, source.EXPORT_DATETIME__c, 'c',zid__c,getdate())
when not matched by source then update set EXPORT_DATETIME__c = getdate() , changetype = 'd',target.dblastupdated = getdate();


      
END










GO
