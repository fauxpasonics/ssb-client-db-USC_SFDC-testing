SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  view [dbo].[vwDonationsBalDue] as 


select 
	  cast (adnumber as int) adnumber 
	, cast(REPLICATE('0',8-LEN(cast(ADNumber as nvarchar))) + cast(ADNumber as nvarchar) as varchar (50))   as ADNumber_withZeros
	, status 
	, cast (PatronId as varchar (20) ) as PaciolanID
	, ac.ContactId
	, cast (ac.salesforce_ID as varchar (100)) as salesforce_ID
	, cast (transyear as varchar (10) ) as transyear 
	, programname 
	, CashPledges
	, CashReceipts
	, credits
	, case when isnull(CashPledges,0) <= 0 then 0 else isnull(CashPledges,0)  - isnull(CashReceipts,0) end as  bal
	
	--Into DonationsBalDue

	from [172.31.17.15].USC.dbo.[ADV_DonationSummary]   a with (nolock)
	join [172.31.17.15].USC.dbo.ADV_Contact b with (nolock) on a.ContactID = b.ContactID
	join [172.31.17.15].USC.dbo.ADV_Program c with (nolock) on a.ProgramID = c.ProgramID
	left join dbo.Patron__c  pc with (nolock) on b.PatronId = pc.Patron
	left join dbo.Account ac with (nolock) on pc.ContactId = ac.ContactId


	where TransYear = '2015' 
	and isnull(CashPledges,0)  - isnull(CashReceipts,0) > 0 
	and programname in 
	(
'Committee'
,'Scholarship Club'
,'Women Of Troy'
,'Cardinal & Gold Premier'
,'Cardinal And Gold'
   )  

  
GO
