SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CleanDataDelta] 
(@sourceID varchar(100))

AS
BEGIN
	SET NOCOUNT ON;

truncate table [dbo].[CD_ProcessQueue]


insert into [dbo].[CD_ProcessQueue]
(SourceSystem, SourceContactId, ContactField, CreatedDate)
select 
SourceSystem, SourceContactId, ContactField, CreatedDate
from 
(

--address Primary
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'PrimaryAddress' as contactfield,getdate() as createdDate from src.TI_vwSFDC_PATROn_delta 
where srcPatronId is not null 
and
(
inserted_PrimaryAddressCity is not null or 
inserted_PrimaryAddressCountry is not null or
inserted_PrimaryAddressState is not null or 
inserted_PrimaryAddressStreet is not null or 
inserted_PrimaryAddressType is not null or 
inserted_PrimaryAddressZipCode is not null
)
and  
(
   isnull(inserted_PrimaryAddressCity,'a')  <> isnull(deleted_PrimaryAddressCity,'b') 
or isnull(inserted_PrimaryAddressCountry,'a') <>  isnull(inserted_PrimaryAddressCountry,'b') 
or isnull(inserted_PrimaryAddressState,'a') <> isnull(inserted_PrimaryAddressState,'b') 
or isnull(inserted_PrimaryAddressStreet,'a') <> isnull(inserted_PrimaryAddressStreet,'b') 
or isnull(inserted_PrimaryAddressType,'a') <> isnull(inserted_PrimaryAddressType,'b') 
or isnull(inserted_PrimaryAddressType,'a') <>  isnull(inserted_PrimaryAddressType,'b')
)
union all 
-- address 2
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'Address2' as contactfield,getdate() as createdDate from src.TI_vwSFDC_PATROn_delta 
where srcPatronId is not null 
and
(
inserted_Address2City is not null or 
inserted_Address2Country is not null or
inserted_Address2State is not null or 
inserted_Address2Street is not null or 
inserted_Address2Type is not null or 
inserted_Address2ZipCode is not null
)
and  
(
   isnull(inserted_Address2City,'a')  <> isnull(deleted_Address2City,'b') 
or isnull(inserted_Address2Country,'a') <>  isnull(inserted_Address2Country,'b') 
or isnull(inserted_Address2State,'a') <> isnull(inserted_Address2State,'b') 
or isnull(inserted_Address2Street,'a') <> isnull(inserted_Address2Street,'b') 
or isnull(inserted_Address2Type,'a') <> isnull(inserted_Address2Type,'b') 
or isnull(inserted_Address2Type,'a') <>  isnull(inserted_Address2Type,'b')
)
union all
--address 3
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'Address3' as contactfield,getdate() as createdDate from src.TI_vwSFDC_PATROn_delta 
where srcPatronId is not null 
and
(
inserted_Address3City is not null or 
inserted_Address3Country is not null or
inserted_Address3State is not null or 
inserted_Address3Street is not null or 
inserted_Address3Type is not null or 
inserted_Address3ZipCode is not null
)
and  
(
   isnull(inserted_Address3City,'a')  <> isnull(deleted_Address3City,'b') 
or isnull(inserted_Address3Country,'a') <>  isnull(inserted_Address3Country,'b') 
or isnull(inserted_Address3State,'a') <> isnull(inserted_Address3State,'b') 
or isnull(inserted_Address3Street,'a') <> isnull(inserted_Address3Street,'b') 
or isnull(inserted_Address3Type,'a') <> isnull(inserted_Address3Type,'b') 
or isnull(inserted_Address3Type,'a') <>  isnull(inserted_Address3Type,'b')
)
union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'BusinessEmail' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_BusinessEmail is not null and  (deleted_BusinessEmail <> inserted_BusinessEmail or deleted_BusinessEmail is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'BusinessPhone' as contactfield,getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_BusinessPhone is not null and  (deleted_BusinessPhone <> inserted_BusinessPhone or deleted_BusinessPhone is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'CellPhone' as contactfield,  getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_CellPhone is not null and  (deleted_CellPhone <> inserted_CellPhone or deleted_CellPhone is null ) union all
--select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'CustomerStatus' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_CustomerStatus is not null and  (deleted_CustomerStatus <> inserted_CustomerStatus or deleted_CustomerStatus is null ) union all
--select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'CustomerType' as contactfield,  getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_CustomerType is not null and  (deleted_CustomerType <> inserted_CustomerType or deleted_CustomerType is null ) union all
--select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'CustomerTypeCode' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_CustomerTypeCode is not null and  (deleted_CustomerTypeCode <> inserted_CustomerTypeCode or deleted_CustomerTypeCode is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'EvEmail' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_EvEmail is not null and  (deleted_EvEmail <> inserted_EvEmail or deleted_EvEmail is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'Fax' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_Fax is not null and  (deleted_Fax <> inserted_Fax or deleted_Fax is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'FullName' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_FullName is not null and  (deleted_FullName <> inserted_FullName or deleted_FullName is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'HomePhone' as contactfield,getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_HomePhone is not null and  (deleted_HomePhone <> inserted_HomePhone or deleted_HomePhone is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'OtherEmail' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_OtherEmail is not null and  (deleted_OtherEmail <> inserted_OtherEmail or deleted_OtherEmail is null ) union all
--select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'OtherEmailType' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_OtherEmailType is not null and  (deleted_OtherEmailType <> inserted_OtherEmailType or deleted_OtherEmailType is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'OtherPhone' as contactfield,getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_OtherPhone is not null and  (deleted_OtherPhone <> inserted_OtherPhone or deleted_OtherPhone is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'OtherPhoneType' as contactfield,getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_OtherPhoneType is not null and  (deleted_OtherPhoneType <> inserted_OtherPhoneType or deleted_OtherPhoneType is null ) union all
--select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'PacCreateDate' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_PacCreateDate is not null and  (deleted_PacCreateDate <> inserted_PacCreateDate or deleted_PacCreateDate is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'PersonalEmail' as contactfield,getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_PersonalEmail is not null and  (deleted_PersonalEmail <> inserted_PersonalEmail or deleted_PersonalEmail is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'Suffix' as contactfield,  getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_Suffix is not null and  (deleted_Suffix <> inserted_Suffix or deleted_Suffix is null ) union all
select @sourceId as sourcesystem, srcpatronID as SourceContactId, 'Title' as contactfield, getdate() as createdDate from src.TI_vwSFDC_PATROn_delta where srcPatronId is not null and  inserted_Title is not null and  (deleted_Title <> inserted_Title or deleted_Title is null ) 
) cleanDataChanges



END







GO
