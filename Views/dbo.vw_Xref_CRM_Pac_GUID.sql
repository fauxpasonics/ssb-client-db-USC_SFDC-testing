SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_Xref_CRM_Pac_GUID]
as

select 
	 
	  cast (pc.Patron as varchar (20) ) as PaciolanID
	, ac.ContactId
	

	from dbo.Patron__c  pc with (nolock) 
	left join dbo.Account ac with (nolock) on pc.ContactId = ac.ContactId

GO
