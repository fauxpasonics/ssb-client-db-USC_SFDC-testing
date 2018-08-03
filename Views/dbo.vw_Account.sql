SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE view [dbo].[vw_Account] as 
(
select 
r.id as RecordtypeId
, cast(ContactId as nvarchar(50)) as DW_ContactId__c
 ,contactid
, case when FullName is null then ' ' when fullname = '' then ' ' else FullName end as FullName
, FirstName as FirstName
,case when IsBusinessAccount = 1 then fullname else LastName end as LastName
, Patron as Patron_ID__c
, PatronStatus as Patron_Status__c
, CustomerType as Customer_Type__c
, CustomerStatus as Customer_Status__c
, Address2Street as BillingStreet
, Address2City as BillingCity
, Address2State as BillingState
, Address2ZipCode as BillingPostalCode
, Address2Country as BillingCountry
, Address3Street as PersonMailingStreet
, Address3City as PersonMailingCity
, Address3State as PersonMailingState
, Address3ZipCode as PersonMailingPostalCode
, Address3Country as PersonMailingCountry
, HomePhone as PersonHomePhone
, CellPhone as PersonMobilePhone
, BusinessPhone as Phone
, Fax as Fax
, EvEmail as eVenue_Email__c
, PersonalEmail as PersonEmail
, VIP as VIP_Code__c
, Internet_profile as Internet_Profile__c
, substring(Cust_comments,1,255) as Customer_Comments__c
,cast( substring(Donor_ID__c,1,50) as varchar(50)) as Donor_ID__c
,substring(Donor_Membership__c,1,50) as Donor_Membership__c
,CONVERT(datetime, dblastupdated, 126) as Export_Datetime__c
,dbLastUpdated
,IsBusinessAccount
,a.salesforce_ID
 from [dbo].[Account] a left join [dbo].[SFDC_Recordtype] r
 on case when a.isBusinessAccount = 1 then 'Business Account' else 'Person Account' end = 
 r.name
 )





GO
