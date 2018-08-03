SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FixCDIOName]
AS
BEGIN
	SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#fixes') IS NOT NULL
    DROP TABLE #fixes
IF OBJECT_ID('tempdb..#chosenfix') IS NOT NULL
    DROP TABLE #chosenfix


select distinct a.contactid, p.Patron,
dbo.fs_PascalCase(rtrim(ltrim(substring(p.FullName,charindex(',',p.fullname,1) +1, len(p.FullName))))) as Fixed_firstname
,dbo.fs_PascalCase(rtrim(ltrim(substring(p.FullName,1,charindex(',',p.fullname,1) -1 ) ))) as fixed_lastName
,p.FullName
,a.FirstName as oldfirstname
,a.lastname as oldlastname
into #fixes
from dbo.Patron__c  p join dbo.account a 
on p.ContactId = a.ContactId
where a.IsBusinessAccount <> 1
and p.fullname like '%,%'
and dbo.fs_PascalCase(rtrim(ltrim(substring(p.FullName,1,charindex(',',p.fullname,1) -1 ) ))) <> isnull(a.LastName,'')
and dbo.fs_PascalCase(rtrim(ltrim(substring(p.FullName,charindex(',',p.fullname,1) +1, len(p.FullName)))))  not like '%,%'


select max(a.patron) patronmax, a.contactid 
into #chosenfix
from 
#fixes  a join #fixes b
on a.ContactId = b.ContactId
group by a.contactid


update dbo.account
set firstname = Fixed_firstname
,LastName = fixed_lastName
,FullName = Fixed_firstname + ' '+ fixed_lastName
,dbLastUpdated = getdate()
from 
dbo.account acct
,
(
select f.ContactId,f.Fixed_firstname, f.fixed_lastName 
from #fixes f join #chosenfix cf
on f.Patron = cf.patronmax
) fixedname
where acct.ContactId = fixedname.ContactId


END
GO
