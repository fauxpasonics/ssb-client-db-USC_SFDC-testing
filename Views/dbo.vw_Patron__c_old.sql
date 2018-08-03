SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_Patron__c_old]
 as 
(
select 
 case when patron.fullname is null then ' ' when patron.fullname = '' then ' ' end  as name
,acct.salesforce_id as Account__c
,patron.patron  as Patron_ID__c
,cast(acct.contactid  as varchar(100))+ ':' + patron.patron as zid__c
,cast(acct.contactid as varchar(50)) as DW_ContactID__c 
,CONVERT(datetime, patron.dblastupdated, 126) as Export_datetime__c
,patron.dbLastUpdated 
,pin as PIN__c, substring(tags ,1,255) as Customer_Tags__c, patron.CustomerTypeCode as Customer_Type__c  , 
patron.CD_PersonalEmail as Email_Address__c
 From dbo.patron__c patron join [dbo].Account acct
 on patron.contactid = acct.contactid
)

GO
