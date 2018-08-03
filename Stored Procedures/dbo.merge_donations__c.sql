SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE PROCEDURE [dbo].[merge_donations__c] as BEGIN 
MERGE dbo.Donation__c AS myTarget USING (SELECT * FROM src.Donation__c ) mySource ON mySource.zid__c = myTarget.zid__c
WHEN MATCHED and 
(
   isnull(Cash_Pledge__c,-1) <> isnull(mySource.Cash_Pledge__c,-2) 
or isnull(Cash_Receipt__c,-1) <> isnull(mySource.Cash_Receipt__c,-2)
)
THEN UPDATE SET
Name = mySource.Name,
Patron_ID__c = mySource.Patron_ID__c,
Drive_Year__c = mySource.Drive_Year__c,
Program_Group__c = mySource.Program_Group__c,
Program_Name__c = mySource.Program_Name__c,
Cash_Pledge__c = mySource.Cash_Pledge__c,
Cash_Receipt__c = mySource.Cash_Receipt__c,
LoadDate = mySource.LoadDate,
changetype = 'c',
dblastupdated = getdate(),
SFDC_loadDate = null,
salesforce_id = null
WHEN NOT MATCHED THEN INSERT (
ZID__c
, Name
, Patron_ID__c
, Drive_Year__c
, Program_Group__c
, Program_Name__c
, Cash_Pledge__c
, Cash_Receipt__c
, LoadDate
, changetype
, dblastupdated
, SFDC_loadDate
, salesforce_id
) VALUES (
mySource.ZID__c
, mySource.Name
, mySource.Patron_ID__c
, mySource.Drive_Year__c
, mySource.Program_Group__c
, mySource.Program_Name__c
, mySource.Cash_Pledge__c
, mySource.Cash_Receipt__c
, mySource.LoadDate
,'c'
, getdate()
,null
, null
)
when not matched by source 
THEN UPDATE SET
changetype = 'd',
dblastupdated = getdate()
; END
GO
