SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [dbo].[vw_CD_CleanDataFileInputAll] as 
(

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast('Primary' as varchar(25)) AddressType, cast(PrimaryAddressStreet as varchar(500)) Address, cast(null as varchar(1)) Address2, cast(PrimaryAddressCity as varchar(200)) City, cast(PrimaryAddressState as varchar(200)) State, cast(PrimaryAddressZipCode as varchar(25)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(PrimaryAddressCountry as varchar(200)) AddressCountry
, cast(null as varchar(25)) PhoneType, cast(null as varchar(25)) Phone, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Match' as varchar(200)) Custom2, cast('PrimaryAddress' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('True' as varchar(5)) RunContactMatch
from src.CD_Account__c p
--left outer join dbo.CD_ProcessQueue cdq on p.Patron = cdq.SourceContactId
where 1=1
and isnull(primaryAddressType, '') <> '' and isnull(PrimaryAddressStreet,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast('Address2' as varchar(25)) AddressType, cast(Address2Street as varchar(500)) Address, cast(null as varchar(1)) Address2, cast(Address2City as varchar(200)) City, cast(Address2State as varchar(200)) State, cast(Address2ZipCode as varchar(25)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(Address2Country as varchar(200)) AddressCountry
, cast(null as varchar(25)) PhoneType, cast(null as varchar(25)) Phone, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('Address2' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(Address2Type, '') <> '' and isnull(Address2Street,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast('Address3' as varchar(25)) AddressType, cast(Address3Street as varchar(500)) Address, cast(null as varchar(1)) Address3, cast(Address3City as varchar(200)) City, cast(Address3State as varchar(200)) State, cast(Address3ZipCode as varchar(25)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(Address3Country as varchar(200)) AddressCountry
, cast(null as varchar(25)) PhoneType, cast(null as varchar(25)) Phone, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('Address3' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(Address3Type, '') <> '' and isnull(Address3Street,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, 'HomePhone' PhoneType, cast(HomePhone as varchar(25)) Phone
, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('HomePhone' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(HomePhone, '') <> '' and isnull(HomePhone,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, 'CellPhone' PhoneType, cast(CellPhone as varchar(25)) Phone
, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('CellPhone' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(CellPhone, '') <> '' and isnull(CellPhone,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, 'BusinessPhone' PhoneType, cast(BusinessPhone as varchar(25)) Phone
, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('BusinessPhone' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(BusinessPhone, '') <> '' and isnull(BusinessPhone,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, 'Fax' PhoneType, cast(Fax as varchar(25)) Phone
, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('Fax' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(Fax, '') <> '' and isnull(Fax,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, 'OtherPhone' PhoneType, cast(OtherPhone as varchar(25)) Phone
, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('OtherPhone' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(OtherPhone, '') <> '' and isnull(OtherPhone,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, cast(null as varchar(1)) PhoneType, cast(null as varchar(25)) Phone
, cast('EvEmail' as varchar(25)) EmailType, cast(EvEmail as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('EvEmail' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(EvEmail, '') <> '' and isnull(EvEmail,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, cast(null as varchar(1)) PhoneType, cast(null as varchar(25)) Phone
, cast('PersonalEmail' as varchar(25)) EmailType, cast(PersonalEmail as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('PersonalEmail' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(PersonalEmail, '') <> '' and isnull(PersonalEmail,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, cast(null as varchar(1)) PhoneType, cast(null as varchar(25)) Phone
, cast('BusinessEmail' as varchar(25)) EmailType, cast(BusinessEmail as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('BusinessEmail' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(BusinessEmail, '') <> '' and isnull(BusinessEmail,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, cast(null as varchar(1)) PhoneType, cast(null as varchar(25)) Phone
, cast('OtherEmail' as varchar(25)) EmailType, cast(OtherEmail as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('OtherEmail' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(OtherEmail, '') <> '' and isnull(OtherEmail,'') <> ''

	union all

select 
patron SourceContactId, cast(null as varchar(1)) Prefix, cast(null as varchar(1)) FirstName, cast(null as varchar(1)) MiddleName, null LastName, cast(null as varchar(1)) Suffix, FullName
, cast(null as varchar(1)) AddressType, cast(null as varchar(1)) Address, cast(null as varchar(1)) Address2, cast(null as varchar(1)) City, cast(null as varchar(1)) State, cast(null as varchar(1)) ZipCode, cast(null as varchar(1)) AddressCounty, cast(null as varchar(1)) AddressCountry
, cast(null as varchar(25)) PhoneType, cast(null as varchar(25)) Phone, cast(null as varchar(25)) EmailType, cast(null as varchar(256)) Email
, 1 SourcePriorityRank, isnull(convert(varchar(25), PacCreateDate, 101), '01/01/1900') SourceCreateDate
, cast('TI' as varchar(200)) Custom1, cast('Clean' as varchar(200)) Custom2, cast('FullName' as varchar(200)) Custom3, cast(null as varchar(1)) Custom4, cast(null as varchar(1)) Custom5
, cast('False' as varchar(5)) RunContactMatch
from src.CD_Account__c p
where 1=1
and isnull(FullName, '') <> '' and isnull(FullName,'') <> ''

)








GO
