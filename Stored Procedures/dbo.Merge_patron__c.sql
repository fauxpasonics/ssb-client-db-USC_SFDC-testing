SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[Merge_patron__c] 

AS
BEGIN 


truncate table [src].[TI_vwSFDC_PATRON_Delta]

insert into [src].[TI_vwSFDC_PATRON_Delta]
(
ActionType, deleted_Address2City, inserted_Address2City, deleted_Address2Country, inserted_Address2Country, deleted_Address2State, inserted_Address2State, deleted_Address2Street, inserted_Address2Street, deleted_Address2Type, inserted_Address2Type, deleted_Address2ZipCode, inserted_Address2ZipCode, deleted_Address3City, inserted_Address3City, deleted_Address3Country, inserted_Address3Country, deleted_Address3State, inserted_Address3State, deleted_Address3Street, inserted_Address3Street, deleted_Address3Type, inserted_Address3Type, deleted_Address3ZipCode, inserted_Address3ZipCode, deleted_BusinessEmail, inserted_BusinessEmail, deleted_BusinessPhone, inserted_BusinessPhone, deleted_CellPhone, inserted_CellPhone, deleted_CustomerStatus, inserted_CustomerStatus, deleted_CustomerType, inserted_CustomerType, deleted_CustomerTypeCode, inserted_CustomerTypeCode, deleted_EvEmail, inserted_EvEmail, deleted_Fax, inserted_Fax, deleted_FullName, inserted_FullName, deleted_Hashkey, inserted_Hashkey, deleted_HomePhone, inserted_HomePhone, deleted_OtherEmail, inserted_OtherEmail, deleted_OtherEmailType, inserted_OtherEmailType, deleted_OtherPhone, inserted_OtherPhone, deleted_OtherPhoneType, inserted_OtherPhoneType, deleted_PacCreateDate, inserted_PacCreateDate, deleted_Patron, inserted_Patron, deleted_PatronStatus, inserted_PatronStatus, deleted_PatronStatusCode, inserted_PatronStatusCode, deleted_PersonalEmail, inserted_PersonalEmail, deleted_PrimaryAddressCity, inserted_PrimaryAddressCity, deleted_PrimaryAddressCountry, inserted_PrimaryAddressCountry, deleted_PrimaryAddressState, inserted_PrimaryAddressState, deleted_PrimaryAddressStreet, inserted_PrimaryAddressStreet, deleted_PrimaryAddressType, inserted_PrimaryAddressType, deleted_PrimaryAddressZipCode, inserted_PrimaryAddressZipCode, deleted_PriorityPtsTix, inserted_PriorityPtsTix, deleted_Suffix, inserted_Suffix, deleted_Title, inserted_Title, deleted_UpdatedDate, inserted_UpdatedDate,srcPatronID)
select 
Actiontype, deleted_Address2City, inserted_Address2City, deleted_Address2Country, inserted_Address2Country, deleted_Address2State, inserted_Address2State, deleted_Address2Street, inserted_Address2Street, deleted_Address2Type, inserted_Address2Type, deleted_Address2ZipCode, inserted_Address2ZipCode, deleted_Address3City, inserted_Address3City, deleted_Address3Country, inserted_Address3Country, deleted_Address3State, inserted_Address3State, deleted_Address3Street, inserted_Address3Street, deleted_Address3Type, inserted_Address3Type, deleted_Address3ZipCode, inserted_Address3ZipCode, deleted_BusinessEmail, inserted_BusinessEmail, deleted_BusinessPhone, inserted_BusinessPhone, deleted_CellPhone, inserted_CellPhone, deleted_CustomerStatus, inserted_CustomerStatus, deleted_CustomerType, inserted_CustomerType, deleted_CustomerTypeCode, inserted_CustomerTypeCode, deleted_EvEmail, inserted_EvEmail, deleted_Fax, inserted_Fax, deleted_FullName, inserted_FullName, deleted_Hashkey, inserted_Hashkey, deleted_HomePhone, inserted_HomePhone, deleted_OtherEmail, inserted_OtherEmail, deleted_OtherEmailType, inserted_OtherEmailType, deleted_OtherPhone, inserted_OtherPhone, deleted_OtherPhoneType, inserted_OtherPhoneType, deleted_PacCreateDate, inserted_PacCreateDate, deleted_Patron, inserted_Patron, deleted_PatronStatus, inserted_PatronStatus, deleted_PatronStatusCode, inserted_PatronStatusCode, deleted_PersonalEmail, inserted_PersonalEmail, deleted_PrimaryAddressCity, inserted_PrimaryAddressCity, deleted_PrimaryAddressCountry, inserted_PrimaryAddressCountry, deleted_PrimaryAddressState, inserted_PrimaryAddressState, deleted_PrimaryAddressStreet, inserted_PrimaryAddressStreet, deleted_PrimaryAddressType, inserted_PrimaryAddressType, deleted_PrimaryAddressZipCode, inserted_PrimaryAddressZipCode, deleted_PriorityPtsTix, inserted_PriorityPtsTix, deleted_Suffix, inserted_Suffix, deleted_Title, inserted_Title, deleted_UpdatedDate, inserted_UpdatedDate,srcpatronid
from 
(
merge into dbo.Patron__c as target
using  src.Patron__c as SOURCE 
on target.patron = source.patron
when matched 
and target.hashkey <> source.hashkey
then 
UPDATE SET 
target.Address2City = source.Address2City
,target.Address2Country = source.Address2Country
,target.Address2State = source.Address2State
,target.Address2Street = source.Address2Street
,target.Address2Type = source.Address2Type
,target.Address2ZipCode = source.Address2ZipCode
,target.Address3City = source.Address3City
,target.Address3Country = source.Address3Country
,target.Address3State = source.Address3State
,target.Address3Street = source.Address3Street
,target.Address3Type = source.Address3Type
,target.Address3ZipCode = source.Address3ZipCode
,target.BusinessEmail = source.BusinessEmail
,target.BusinessPhone = source.BusinessPhone
,target.CellPhone = source.CellPhone
,target.Cust_comments = source.Cust_comments
,target.cust_UD1 = source.cust_UD1
,target.CustomerStatus = source.CustomerStatus
,target.CustomerType = source.CustomerType
,target.CustomerTypeCode = source.CustomerTypeCode
,target.EvEmail = source.EvEmail
,target.Fax = source.Fax
,target.FullName = source.FullName
,target.HashKey = source.HashKey
,target.HomePhone = source.HomePhone
,target.Internet_profile = source.Internet_profile
,target.OtherEmail = source.OtherEmail
,target.OtherEmailType = source.OtherEmailType
,target.OtherPhone = source.OtherPhone
,target.OtherPhoneType = source.OtherPhoneType
,target.PacCreateDate = source.PacCreateDate
,target.Patron = source.Patron
,target.PatronStatus = source.PatronStatus
,target.PatronStatusCode = source.PatronStatusCode
,target.PersonalEmail = source.PersonalEmail
,target.PrimaryAddressCity = source.PrimaryAddressCity
,target.PrimaryAddressCountry = source.PrimaryAddressCountry
,target.PrimaryAddressState = source.PrimaryAddressState
,target.PrimaryAddressStreet = source.PrimaryAddressStreet
,target.PrimaryAddressType = source.PrimaryAddressType
,target.PrimaryAddressZipCode = source.PrimaryAddressZipCode
,target.PriorityPtsTix = source.PriorityPtsTix
,target.Suffix = source.Suffix
,target.Title = source.Title
,target.UpdatedDate = source.UpdatedDate
,target.VIP = source.VIP
,target.pin = source.pin
,target.tags = source.tags
,target.changetype = 'c'
,target.dblastupdated = getdate()
,target.Donor_ID__c = source.Donor_ID__c
,target.Donor_Membership__c = source.Donor_Membership__c
when not matched by Target then
INSERT 
(
Address2City
,Address2Country
,Address2State
,Address2Street
,Address2Type
,Address2ZipCode
,Address3City
,Address3Country
,Address3State
,Address3Street
,Address3Type
,Address3ZipCode
,BusinessEmail
,BusinessPhone
,CellPhone
,Cust_comments
,cust_UD1
,CustomerStatus
,CustomerType
,CustomerTypeCode
,EvEmail
,Fax
,FullName
,HashKey
,HomePhone
,Internet_profile
,OtherEmail
,OtherEmailType
,OtherPhone
,OtherPhoneType
,PacCreateDate
,Patron
,PatronStatus
,PatronStatusCode
,PersonalEmail
,PrimaryAddressCity
,PrimaryAddressCountry
,PrimaryAddressState
,PrimaryAddressStreet
,PrimaryAddressType
,PrimaryAddressZipCode
,PriorityPtsTix
,Suffix
,Title
,UpdatedDate
,VIP
,dblastupdated
,changetype
,pin
,tags
,Donor_ID__c
,Donor_Membership__c
) 
VALUES 
(
source.Address2City
,source.Address2Country
,source.Address2State
,source.Address2Street
,source.Address2Type
,source.Address2ZipCode
,source.Address3City
,source.Address3Country
,source.Address3State
,source.Address3Street
,source.Address3Type
,source.Address3ZipCode
,source.BusinessEmail
,source.BusinessPhone
,source.CellPhone
,source.Cust_comments
,source.cust_UD1
,source.CustomerStatus
,source.CustomerType
,source.CustomerTypeCode
,source.EvEmail
,source.Fax
,source.FullName
,source.HashKey
,source.HomePhone
,source.Internet_profile
,source.OtherEmail
,source.OtherEmailType
,source.OtherPhone
,source.OtherPhoneType
,source.PacCreateDate
,source.Patron
,source.PatronStatus
,source.PatronStatusCode
,source.PersonalEmail
,source.PrimaryAddressCity
,source.PrimaryAddressCountry
,source.PrimaryAddressState
,source.PrimaryAddressStreet
,source.PrimaryAddressType
,source.PrimaryAddressZipCode
,source.PriorityPtsTix
,source.Suffix
,source.Title
,source.UpdatedDate
,source.VIP
,getdate()
,'c'
,source.pin
,source.tags
,source.Donor_ID__c
,source.Donor_Membership__c
)
when not matched by source then update set  changetype = 'd',target.dblastupdated = getdate()
output
$action, deleted.Address2City, inserted.Address2City, deleted.Address2Country, inserted.Address2Country, deleted.Address2State
, inserted.Address2State, deleted.Address2Street, inserted.Address2Street, deleted.Address2Type, inserted.Address2Type
, deleted.Address2ZipCode, inserted.Address2ZipCode, deleted.Address3City, inserted.Address3City
, deleted.Address3Country, inserted.Address3Country, deleted.Address3State, inserted.Address3State
, deleted.Address3Street, inserted.Address3Street, deleted.Address3Type, inserted.Address3Type
, deleted.Address3ZipCode, inserted.Address3ZipCode, deleted.BusinessEmail, inserted.BusinessEmail
, deleted.BusinessPhone, inserted.BusinessPhone, deleted.CellPhone, inserted.CellPhone
, deleted.CustomerStatus, inserted.CustomerStatus, deleted.CustomerType, inserted.CustomerType, deleted.CustomerTypeCode
, inserted.CustomerTypeCode, deleted.EvEmail, inserted.EvEmail, deleted.Fax, inserted.Fax, deleted.FullName, inserted.FullName
, deleted.Hashkey, inserted.Hashkey, deleted.HomePhone, inserted.HomePhone, deleted.OtherEmail, inserted.OtherEmail
, deleted.OtherEmailType, inserted.OtherEmailType, deleted.OtherPhone, inserted.OtherPhone, deleted.OtherPhoneType
, inserted.OtherPhoneType, deleted.PacCreateDate, inserted.PacCreateDate, deleted.Patron, inserted.Patron
, deleted.PatronStatus, inserted.PatronStatus, deleted.PatronStatusCode, inserted.PatronStatusCode
, deleted.PersonalEmail, inserted.PersonalEmail, deleted.PrimaryAddressCity
, inserted.PrimaryAddressCity, deleted.PrimaryAddressCountry, inserted.PrimaryAddressCountry
, deleted.PrimaryAddressState, inserted.PrimaryAddressState, deleted.PrimaryAddressStreet
, inserted.PrimaryAddressStreet, deleted.PrimaryAddressType, inserted.PrimaryAddressType
, deleted.PrimaryAddressZipCode, inserted.PrimaryAddressZipCode, deleted.PriorityPtsTix
, inserted.PriorityPtsTix, deleted.Suffix, inserted.Suffix, deleted.Title, inserted.Title, deleted.UpdatedDate, inserted.UpdatedDate, source.patron) 
as changeval (ActionType,deleted_Address2City, inserted_Address2City, deleted_Address2Country, inserted_Address2Country, deleted_Address2State, inserted_Address2State, deleted_Address2Street, inserted_Address2Street, deleted_Address2Type, inserted_Address2Type, deleted_Address2ZipCode, inserted_Address2ZipCode, deleted_Address3City, inserted_Address3City, deleted_Address3Country, inserted_Address3Country, deleted_Address3State, inserted_Address3State, deleted_Address3Street, inserted_Address3Street, deleted_Address3Type, inserted_Address3Type, deleted_Address3ZipCode, inserted_Address3ZipCode, deleted_BusinessEmail, inserted_BusinessEmail, deleted_BusinessPhone, inserted_BusinessPhone, deleted_CellPhone, inserted_CellPhone, deleted_CustomerStatus, inserted_CustomerStatus, deleted_CustomerType, inserted_CustomerType, deleted_CustomerTypeCode, inserted_CustomerTypeCode, deleted_EvEmail, inserted_EvEmail, deleted_Fax, inserted_Fax, deleted_FullName, inserted_FullName, deleted_Hashkey, inserted_Hashkey, deleted_HomePhone, inserted_HomePhone, deleted_OtherEmail, inserted_OtherEmail, deleted_OtherEmailType, inserted_OtherEmailType, deleted_OtherPhone, inserted_OtherPhone, deleted_OtherPhoneType, inserted_OtherPhoneType, deleted_PacCreateDate, inserted_PacCreateDate, deleted_Patron, inserted_Patron, deleted_PatronStatus, inserted_PatronStatus, deleted_PatronStatusCode, inserted_PatronStatusCode, deleted_PersonalEmail, inserted_PersonalEmail, deleted_PrimaryAddressCity, inserted_PrimaryAddressCity, deleted_PrimaryAddressCountry, inserted_PrimaryAddressCountry, deleted_PrimaryAddressState, inserted_PrimaryAddressState, deleted_PrimaryAddressStreet, inserted_PrimaryAddressStreet, deleted_PrimaryAddressType, inserted_PrimaryAddressType, deleted_PrimaryAddressZipCode, inserted_PrimaryAddressZipCode, deleted_PriorityPtsTix, inserted_PriorityPtsTix, deleted_Suffix, inserted_Suffix, deleted_Title, inserted_Title, deleted_UpdatedDate, inserted_UpdatedDate,srcPatronID);

--bmackley - 1/8/2015
-- Adding any missing records (mismatch Patron to dbo.Account) so they can be run through CD again.
insert into [src].[TI_vwSFDC_PATRON_Delta]
(
ActionType, deleted_Address2City, inserted_Address2City, deleted_Address2Country, inserted_Address2Country, deleted_Address2State, inserted_Address2State, deleted_Address2Street
, inserted_Address2Street, deleted_Address2Type, inserted_Address2Type, deleted_Address2ZipCode, inserted_Address2ZipCode, deleted_Address3City, inserted_Address3City, deleted_Address3Country
, inserted_Address3Country, deleted_Address3State, inserted_Address3State, deleted_Address3Street, inserted_Address3Street, deleted_Address3Type, inserted_Address3Type, deleted_Address3ZipCode
, inserted_Address3ZipCode, deleted_BusinessEmail, inserted_BusinessEmail, deleted_BusinessPhone, inserted_BusinessPhone, deleted_CellPhone, inserted_CellPhone, deleted_CustomerStatus
, inserted_CustomerStatus, deleted_CustomerType, inserted_CustomerType, deleted_CustomerTypeCode, inserted_CustomerTypeCode, deleted_EvEmail, inserted_EvEmail, deleted_Fax, inserted_Fax, deleted_FullName
, inserted_FullName, deleted_Hashkey, inserted_Hashkey, deleted_HomePhone, inserted_HomePhone, deleted_OtherEmail, inserted_OtherEmail, deleted_OtherEmailType, inserted_OtherEmailType, deleted_OtherPhone
, inserted_OtherPhone, deleted_OtherPhoneType, inserted_OtherPhoneType, deleted_PacCreateDate, inserted_PacCreateDate, deleted_Patron, inserted_Patron, deleted_PatronStatus
, inserted_PatronStatus, deleted_PatronStatusCode, inserted_PatronStatusCode, deleted_PersonalEmail, inserted_PersonalEmail, deleted_PrimaryAddressCity, inserted_PrimaryAddressCity
, deleted_PrimaryAddressCountry, inserted_PrimaryAddressCountry, deleted_PrimaryAddressState, inserted_PrimaryAddressState, deleted_PrimaryAddressStreet, inserted_PrimaryAddressStreet
, deleted_PrimaryAddressType, inserted_PrimaryAddressType, deleted_PrimaryAddressZipCode, inserted_PrimaryAddressZipCode, deleted_PriorityPtsTix, inserted_PriorityPtsTix, deleted_Suffix, inserted_Suffix
, deleted_Title, inserted_Title, deleted_UpdatedDate, inserted_UpdatedDate,srcPatronID)
select 
'UPDATE', NULL deleted_Address2City, b.Address2City inserted_Address2City, NULL deleted_Address2Country, b.Address2Country inserted_Address2Country, NULL deleted_Address2State, b.Address2State inserted_Address2State, NULL deleted_Address2Street
, b.Address2Street inserted_Address2Street, NULL deleted_Address2Type, b.Address2Type inserted_Address2Type, NULL deleted_Address2ZipCode, b.Address2ZipCode inserted_Address2ZipCode, NULL deleted_Address3City, b.Address3City inserted_Address3City, NULL deleted_Address3Country
, b.Address3Country inserted_Address3Country, NULL deleted_Address3State, b.Address3State inserted_Address3State, NULL deleted_Address3Street, b.Address3Street inserted_Address3Street, NULL deleted_Address3Type, b.Address3Type inserted_Address3Type, NULL deleted_Address3ZipCode
, b.Address3ZipCode inserted_Address3ZipCode, NULL deleted_BusinessEmail, b.BusinessEmail inserted_BusinessEmail, NULL deleted_BusinessPhone, b.BusinessPhone inserted_BusinessPhone, NULL deleted_CellPhone, b.CellPhone inserted_CellPhone, NULL deleted_CustomerStatus
, b.CustomerStatus inserted_CustomerStatus, NULL deleted_CustomerType, b.CustomerType inserted_CustomerType, NULL deleted_CustomerTypeCode, b.CustomerTypeCode inserted_CustomerTypeCode, NULL deleted_EvEmail, b.EvEmail inserted_EvEmail, NULL deleted_Fax, b.fax	inserted_Fax, NULL deleted_FullName
, b.FullName inserted_FullName, NULL deleted_Hashkey, b.HashKey inserted_Hashkey, NULL deleted_HomePhone, b.HomePhone inserted_HomePhone, NULL deleted_OtherEmail, b.OtherEmail inserted_OtherEmail, NULL deleted_OtherEmailType, b.OtherEmailType inserted_OtherEmailType, NULL deleted_OtherPhone
, b.OtherPhone inserted_OtherPhone, NULL deleted_OtherPhoneType, b.OtherPhoneType inserted_OtherPhoneType, NULL deleted_PacCreateDate, b.PacCreateDate inserted_PacCreateDate, NULL deleted_Patron, b.Patron inserted_Patron, NULL deleted_PatronStatus
, b.PatronStatus inserted_PatronStatus, NULL deleted_PatronStatusCode, b.PatronStatusCode inserted_PatronStatusCode, NULL deleted_PersonalEmail, b.PersonalEmail inserted_PersonalEmail, NULL deleted_PrimaryAddressCity, b.PrimaryAddressCity inserted_PrimaryAddressCity
, NULL deleted_PrimaryAddressCountry, b.PrimaryAddressCountry inserted_PrimaryAddressCountry, NULL deleted_PrimaryAddressState, b.PrimaryAddressState inserted_PrimaryAddressState, NULL deleted_PrimaryAddressStreet, b.PrimaryAddressStreet inserted_PrimaryAddressStreet
, NULL deleted_PrimaryAddressType, b.PrimaryAddressType inserted_PrimaryAddressType, NULL deleted_PrimaryAddressZipCode, b.PrimaryAddressZipCode inserted_PrimaryAddressZipCode, NULL deleted_PriorityPtsTix, b.PriorityPtsTix inserted_PriorityPtsTix, NULL deleted_Suffix, b.Suffix inserted_Suffix
, NULL deleted_Title, b.Title inserted_Title, NULL deleted_UpdatedDate, b.UpdatedDate inserted_UpdatedDate,b.Patron srcpatronid
-- Select COUNT(*)
FROM dbo.Account a
INNER JOIN dbo.Patron__c b ON a.Patron = b.Patron
WHERE 1=1
AND b.Patron NOT IN (SELECT inserted_Patron FROM src.TI_vwSFDC_PATRON_Delta)
--AND b.Patron ='370045'
AND ((LEN(ISNULL(a.PrimaryAddressStreet,'')) = 0 AND Len(ISNULL(b.PrimaryAddressStreet,'')) > 0)
OR (LEN(ISNULL(a.HomePhone,'')) < 10 AND LEN(ISNULL(b.HomePhone,'')) >= 10)
OR (CHARINDEX('@',a.PersonalEmail,1) = 0 AND CHARINDEX('@',b.PersonalEmail,1) > 0))
      
END










GO
