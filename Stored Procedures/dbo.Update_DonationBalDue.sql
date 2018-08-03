SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Update_DonationBalDue]
as

begin 

truncate table DonationBalDueFinal

insert into   DonationBalDueFinal
select 
         cast (adnumber as int) adnumber 
       , cast(REPLICATE('0',8-LEN(cast(ADNumber as nvarchar))) + cast(ADNumber as nvarchar) as varchar (50))   as ADNumber_withZeros
       , status 
       , cast (PatronId as varchar (20) ) as PaciolanID
       , ac.SSB_CRMSYSTEM_ACCT_ID ContactId
       , cast (ac.salesforce_ID as varchar (100)) as salesforce_ID
       , cast (transyear as varchar (10) ) as transyear 
       , programname 
       , CashPledges
       , CashReceipts
       , credits
       , case when isnull(CashPledges,0) <= 0 then 0 else isnull(CashPledges,0)  - isnull(CashReceipts,0) end as  bal

       from [172.31.17.15].USC.dbo.[ADV_DonationSummary]   a with (nolock)
       join [172.31.17.15].USC.dbo.ADV_Contact b with (nolock) on a.ContactID = b.ContactID
       join [172.31.17.15].USC.dbo.ADV_Program c with (nolock) on a.ProgramID = c.ProgramID
       left join [dbo].[vwSFDCLoad_Patron] pc with (nolock) on b.PatronId = Cast(Right(pc.Patron_ID__c, Len(pc.Patron_ID__c)-1) as bigint) and Left(pc.Patron_ID__c,1) = 'A'
       left join dbo.Account ac with (nolock) on pc.[DW_ContactID__c] = ac.SSB_CRMSYSTEM_ACCT_ID


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



--------------------------------------------------------------------------------------

--issue found on these guids select distinct * from DonationsBalDue  where adnumber = '5718902'5718902'
--cannot have an issue due to guids... for this interation I just picked a winner and deleted



delete from DonationBalDueFinal where contactid = 'B3406E28-37B7-4502-8231-F4A382976FF0'
delete from DonationBalDueFinal where contactid = '51D4C4CB-9652-44A0-9726-33BDDA5B01D9'

--select 
--adnumber
--, ADNumber_withZeros
--, status
--, PaciolanID
----, ContactId
----, salesforce_ID
--, transyear
--, programname
--, CashPledges
--, CashReceipts
--, credits
--, bal


--from DonationsBalDue
--group by 

--adnumber
--, ADNumber_withZeros
--, status
--, PaciolanID
----, ContactId
----, salesforce_ID
--, transyear
--, programname
--, CashPledges
--, CashReceipts
--, credits
--, bal

--having count (*) > 1 

--Load to TI table 

--use usc 

--truncate table  [dbo].[DonationBalDueFinal]



--select * from [dbo].[DonationBalDueFinal]  where paciolanid is null



end
GO
