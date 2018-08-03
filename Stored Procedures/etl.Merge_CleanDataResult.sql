SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[Merge_CleanDataResult] 

as
BEGIN 

	DECLARE @ExtractDate datetime

	set @ExtractDate = (
		select DATEADD(HOUR, -12, getdate()) ExtractDate
		--select dateadd(MINUTE, -5, max(run_export_datetime)) ExtractDate
		--from SSIS_Config.dbo.SourceExtractControl
		--where DestinationTable = 'dbo.Patron__c' and Source = 'TI_Cal'
	)

	--Insert the unprocessed recrods into a temp data set
	SELECT * INTO #CD_DataSet
	FROM src.CD_CleanDataResult 
	WHERE IsMerged = 0 --or BatchId = 2147		

	select * into #CD_Name
	from (
		select cd.SourceContactId, cd.Prefix, cd.FirstName, cd.MiddleName, cd.LastName, cd.Suffix, cd.Salutation, cd.NameStatus, cd.Input_FullName, cd.CleanDataResultId
		, ROW_NUMBER() OVER(PARTITION BY cd.SourceContactId ORDER BY case when cd.Input_Custom3 = 'FullName' then 0 else 1 end, CleanDataResultId) MergeRank	
		from #CD_DataSet cd	
	) a
	where MergeRank = 1


	update p
	set p.IsBusinessAccount = case when d.Input_FullName like '%,%' then 0 else 1 end
	, p.CD_Prefix = d.Prefix
	, p.CD_FirstName = d.FirstName
	, p.CD_MiddleName = d.MiddleName
	, p.CD_LastName = d.LastName
	, p.CD_Suffix = d.Suffix
	, p.CD_Salutation = d.Salutation	
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_Name d on p.Patron = d.SourceContactId


	--Upadate the patron records with the clean data results
	update p
	set 
	p.ContactId = 
	case 
		when p.ContactId is not null then p.ContactId 
		when p.ContactId is null and d.ContactId <> '00000000-0000-0000-0000-000000000000' then d.ContactId
		else newid() 
	end 
	, p.CD_PrimaryAddressType = d.AddressType
	, p.CD_PrimaryAddress = d.Address
	, p.CD_PrimaryAddress2 = d.Address2
	, p.CD_PrimaryAddressSuite = d.Suite
	, p.CD_PrimaryAddressCity = d.City
	, p.CD_PrimaryAddressState = d.State
	, p.CD_PrimaryAddressZipCode = d.ZipCode
	, p.CD_PrimaryAddressPlus4 = d.Plus4
	, p.CD_PrimaryAddressCounty = d.AddressCounty
	, p.CD_PrimaryAddressCountry = d.AddressCountry
	, p.CD_PrimaryAddressCountyFips = d.AddressCountyFips
	, p.CD_PrimaryAddressDeliveryPoint = d.AddressDeliveryPoint
	, p.CD_PrimaryZipLatitude = d.ZipLatitude
	, p.CD_PrimaryZipLongitude = d.ZipLongitude
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and d.Input_Custom3 = 'PrimaryAddress'

	--select * from #CD_DataSet

	update p
	set 	
	p.CD_Address2Type = d.AddressType
	, p.CD_Address2 = d.Address
	, p.CD_Address2_2 = d.Address2
	, p.CD_Address2Suite = d.Suite
	, p.CD_Address2City = d.City
	, p.CD_Address2State = d.State
	, p.CD_Address2ZipCode = d.ZipCode
	, p.CD_Address2Plus4 = d.Plus4
	, p.CD_Address2County = d.AddressCounty
	, p.CD_Address2Country = d.AddressCountry
	, p.CD_Address2CountyFips = d.AddressCountyFips
	, p.CD_Address2DeliveryPoint = d.AddressDeliveryPoint
	, p.CD_Address2ZipLatitude = d.ZipLatitude
	, p.CD_Address2ZipLongitude = d.ZipLongitude
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and d.Input_Custom3 = 'Address2'

	update p
	set 
	p.CD_Address3Type = d.AddressType
	, p.CD_Address3 = d.Address
	, p.CD_Address3_2 = d.Address2
	, p.CD_Address3Suite = d.Suite
	, p.CD_Address3City = d.City
	, p.CD_Address3State = d.State
	, p.CD_Address3ZipCode = d.ZipCode
	, p.CD_Address3Plus4 = d.Plus4
	, p.CD_Address3County = d.AddressCounty
	, p.CD_Address3Country = d.AddressCountry
	, p.CD_Address3CountyFips = d.AddressCountyFips
	, p.CD_Address3DeliveryPoint = d.AddressDeliveryPoint
	, p.CD_Address3ZipLatitude = d.ZipLatitude
	, p.CD_Address3ZipLongitude = d.ZipLongitude
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and d.Input_Custom3 = 'Address3'



	update p
	set p.CD_HomePhone = d.Phone
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId	
	where d.Input_Custom1 = 'TI' and Input_Custom3 = 'HomePhone' and PhoneStatus in ('Valid')

	update p
	set 		
	p.CD_CellPhone = d.Phone
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and Input_Custom3 = 'CellPhone' and PhoneStatus in ('Valid')

	update p
	set 
	p.CD_BusinessPhone = d.Phone
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and Input_Custom3 = 'BusinessPhone' and PhoneStatus in ('Valid')

	update p
	set
	p.CD_Fax = d.Phone
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and Input_Custom3 = 'Fax' and PhoneStatus in ('Valid')

	update p
	set 	
	p.CD_OtherPhone = d.Phone
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and Input_Custom3 = 'OtherPhone' and PhoneStatus in ('Valid')
	

	update p
	set 	
	p.CD_EvEmail = d.EmailAddress
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and Input_Custom3 = 'EvEmail' and EmailStatus like 'Valid%'

	update p
	set 	
	p.CD_PersonalEmail = d.EmailAddress
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where Input_Custom3 = 'PersonalEmail' and EmailStatus like 'Valid%'

	update p
	set 		
	p.CD_BusinessEmail = d.EmailAddress
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and Input_Custom3 = 'BusinessEmail' and EmailStatus like 'Valid%'

	update p
	set 		
	p.CD_OtherEmail = d.EmailAddress
	, p.dblastupdated = getdate()
	, p.ChangeType = 'c'
	from dbo.Patron__c p
	inner join #CD_DataSet d on p.Patron = d.SourceContactId
	where d.Input_Custom1 = 'TI' and Input_Custom3 = 'OtherEmail' and EmailStatus like 'Valid%'


	update dbo.Patron__c
	set ContactId = newid()
	, dblastupdated = getdate()
	, ChangeType = 'c'
	where ContactId is null


	--select distinct Patron into #PatronSet
	--from dbo.Patron__c
	--where dblastupdated >= @ExtractDate

	--select distinct ContactId into #ContactSet
	--from dbo.Patron__c
	--where dblastupdated >= @ExtractDate


	--Get string concatenated list of contact --> patron list
	SELECT
	t1.ContactId
	, ltrim(rtrim(stuff((
		select ', ' + t.Patron
		from dbo.Patron__c t
		where t.ContactId = t1.ContactId
		order by t.Patron
		for xml path('')
	),1,1,''))) as PatronList
	
	INTO #ContactPatronList
	
	FROM dbo.Patron__c t1
	where t1.ContactId is not null
	GROUP BY t1.ContactId


	select p.*
	, ROW_NUMBER() OVER(PARTITION BY p.ContactId ORDER BY isnull(trans.MaxTransDate,'1900-01-01') desc, isnull(p.PacCreateDate,'1900-01-01') desc, p.Patron desc) MergeRank	
	into #PatronContact
	from dbo.Patron__c p
	inner join #CD_DataSet ds on p.Patron = ds.SourceContactId
	left outer join (
		select trans.Patron_ID__c Patron, max(Order_Date__c) MaxTransDate
		from dbo.Transactions__c trans
		group by trans.Patron_ID__c
	) trans on p.Patron = trans.Patron
	where p.ContactId is not null

	select * 
	into #PatronData
	from (
		select p.*
		, isnull(trans.MaxTransDate,'1900-01-01') MaxTransDate
		, ROW_NUMBER() OVER(PARTITION BY p.ContactId ORDER BY isnull(trans.MaxTransDate,'1900-01-01') desc, isnull(p.PacCreateDate,'1900-01-01') desc, p.Patron desc) MergeRank		
		from dbo.Patron__c p
		left outer join (
			select trans.Patron_ID__c Patron, max(Order_Date__c) MaxTransDate
			from dbo.Transactions__c trans
			group by trans.Patron_ID__c
		) trans on p.Patron = trans.Patron
		where p.ContactId is not null
	) a
	where MergeRank = 1


	select p.ContactId
	, isnull(cpl.PatronList, p.Patron) Patron
	, p.PatronStatusCode, p.PatronStatus, p.CustomerTypeCode, p.CustomerType, p.CustomerStatus
	, p.PriorityPtsTix, p.PacCreateDate
	, p.VIP, p.Internet_profile, p.Cust_comments, p.cust_UD1

	into #AccountData
	from #PatronData p
	left outer join #ContactPatronList cpl on p.ContactId = cpl.ContactId	


	merge into dbo.Account as target
	using  #AccountData as source
	on target.ContactId = source.ContactId
	
	when matched and (
		isnull(target.Patron,'') <> isnull(source.Patron,'')
		or isnull(target.PatronStatusCode,'') <> isnull(source.PatronStatusCode,'')
		or isnull(target.PatronStatus,'') <> isnull(source.PatronStatus,'')
		or isnull(target.CustomerTypeCode,'') <> isnull(source.CustomerTypeCode,'')
		or isnull(target.CustomerType,'') <> isnull(source.CustomerType,'')
		or isnull(target.CustomerStatus,'') <> isnull(source.CustomerStatus,'')
		or isnull(target.PriorityPtsTix,'') <> isnull(source.PriorityPtsTix,'')
		or isnull(target.PacCreateDate,'') <> isnull(source.PacCreateDate,'')
		or isnull(target.VIP,'') <> isnull(source.VIP,'')
		or isnull(target.Internet_profile,'') <> isnull(source.Internet_profile,'')
		or isnull(target.Cust_comments,'') <> isnull(source.Cust_comments,'')
		or isnull(target.Cust_UD1,'') <> isnull(source.Cust_UD1,'')
	)

	then 
	
	UPDATE SET 
	target.dbLastUpdated = getdate()
	, target.changetype = 'c'
	, target.Patron = source.Patron
	, target.PatronStatusCode = source.PatronStatusCode
	, target.PatronStatus = source.PatronStatus
	, target.CustomerTypeCode = source.CustomerTypeCode
	, target.CustomerType = source.CustomerType
	, target.CustomerStatus = source.CustomerStatus
	, target.PriorityPtsTix = source.PriorityPtsTix
	, target.PacCreateDate = source.PacCreateDate
	, target.VIP = source.VIP
	, target.Internet_profile = source.Internet_profile
	, target.Cust_comments = source.Cust_comments
	, target.Cust_UD1 = source.Cust_UD1
	

	when not matched by Target then
	
	INSERT (
		ContactId
		, Patron
		, PatronStatusCode
		, PatronStatus
		, CustomerTypeCode
		, CustomerType
		, CustomerStatus
		, PriorityPtsTix
		, PacCreateDate
		, VIP
		, Internet_profile
		, Cust_comments
		, Cust_UD1
		, dbLastUpdated
	)
	VALUES (
		source.ContactId
		, source.Patron
		, source.PatronStatusCode
		, source.PatronStatus
		, source.CustomerTypeCode
		, source.CustomerType
		, source.CustomerStatus
		, source.PriorityPtsTix
		, source.PacCreateDate
		, source.VIP
		, source.Internet_profile
		, source.Cust_comments
		, source.Cust_UD1
		, getdate()
	)
	--when not matched by source then update set [EXPORT_DATETIME] = getdate() , changetype = 'd'
	;


	update a
	set a.FirstName = case when stg.IsBusinessAccount = 1 then null else stg.FirstName end
	, a.LastName = case when stg.IsBusinessAccount = 1 then null else stg.LastName end
	, a.Title = case when stg.IsBusinessAccount = 1 then null else stg.Title end
	, a.FullName = case when stg.IsBusinessAccount = 1 then stg.PatronName else stg.FullName end	
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, Title, FirstName, LastName, FullName, IsBusinessAccount, PatronName
		from ( 
			select pc.ContactId, pc.Title, pc.CD_FirstName FirstName, pc.CD_MiddleName MiddleName, pc.CD_LastName LastName, (pc.CD_FirstName + ' ' + pc.CD_LastName) FullName, case when FullName like '%,%' then 0 else 1 end IsBusinessAccount, FullName PatronName
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.FirstName,'') <> stg.FirstName or isnull(a.LastName,'') <> stg.LastName or isnull(a.FullName,'') <> stg.FullName or isnull(a.Title,'') = stg.Title


	update a
	set a.PrimaryAddressType = stg.PrimaryAddressType
	, a.PrimaryAddressStreet = stg.PrimaryAddressStreet
	, a.PrimaryAddressCity = stg.PrimaryAddressCity
	, a.PrimaryAddressState = stg.PrimaryAddressState
	, a.PrimaryAddressZipCode = stg.PrimaryAddressZipCode
	, a.PrimaryAddressCountry = stg.PrimaryAddressCountry
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, PrimaryAddressType, PrimaryAddressStreet, PrimaryAddressCity, PrimaryAddressState, PrimaryAddressZipCode, PrimaryAddressCountry
		from ( 
			select pc.ContactId, CD_PrimaryAddressType PrimaryAddressType, replace(rtrim(ltrim((CD_PrimaryAddress + ' ' + CD_PrimaryAddress2 + ' ' + CD_PrimaryAddressSuite))), '  ', ' ') PrimaryAddressStreet, CD_PrimaryAddressCity PrimaryAddressCity, CD_PrimaryAddressState PrimaryAddressState, CD_PrimaryAddressZipCode PrimaryAddressZipCode, CD_PrimaryAddressCountry PrimaryAddressCountry
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
		) a 
		where a.MergeRank = 1 
	) stg on a.ContactId = stg.ContactId
	where isnull(a.PrimaryAddressStreet,'') <> stg.PrimaryAddressStreet or isnull(a.PrimaryAddressStreet,'') <> stg.PrimaryAddressCity or isnull(a.PrimaryAddressStreet,'') <> stg.PrimaryAddressState or isnull(a.PrimaryAddressStreet,'') <> stg.PrimaryAddressZipCode or isnull(a.PrimaryAddressStreet,'') <> stg.PrimaryAddressCountry


	update a
	set a.Address2Type = stg.Address2Type
	, a.Address2Street = stg.Address2Street
	, a.Address2City = stg.Address2City
	, a.Address2State = stg.Address2State
	, a.Address2ZipCode = stg.Address2ZipCode
	, a.Address2Country = stg.Address2Country
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, Address2Type, Address2Street, Address2City, Address2State, Address2ZipCode, Address2Country		
		from ( 
			select pc.ContactId, CD_Address2Type Address2Type, replace(rtrim(ltrim((CD_Address2 + ' ' + CD_Address2_2 + ' ' + CD_Address2Suite))), '  ', ' ') Address2Street, CD_Address2City Address2City, CD_Address2State Address2State, CD_Address2ZipCode Address2ZipCode, CD_Address2Country Address2Country
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId	
	where isnull(a.Address2Type,'') = stg.Address2Type or isnull(a.Address2Street,'') <> stg.Address2Street or isnull(a.Address2Street,'') <> stg.Address2City or isnull(a.Address2Street,'') <> stg.Address2State or isnull(a.Address2Street,'') <> stg.Address2ZipCode or isnull(a.Address2Street,'') <> stg.Address2Country


	update a
	set a.Address3Type = stg.Address3Type
	, a.Address3Street = stg.Address3Street
	, a.Address3City = stg.Address3City
	, a.Address3State = stg.Address3State
	, a.Address3ZipCode = stg.Address3ZipCode
	, a.Address3Country = stg.Address3Country
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, Address3Type, Address3Street, Address3City, Address3State, Address3ZipCode, Address3Country		
		from ( 
			select pc.ContactId,  CD_Address3Type Address3Type, replace(rtrim(ltrim((CD_Address3 + ' ' + CD_Address3_2 + ' ' + CD_Address3Suite))), '  ', ' ') Address3Street, CD_Address3City Address3City, CD_Address3State Address3State, CD_Address3ZipCode Address3ZipCode, CD_Address3Country Address3Country
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId	
	where isnull(a.Address3Type,'') = stg.Address3Type or isnull(a.Address3Street,'') <> stg.Address3Street or isnull(a.Address3Street,'') <> stg.Address3City or isnull(a.Address3Street,'') <> stg.Address3State or isnull(a.Address3Street,'') <> stg.Address3ZipCode or isnull(a.Address3Street,'') <> stg.Address3Country


	update a
	set a.HomePhone= stg.HomePhone
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, HomePhone
		from ( 
			select pc.ContactId, pc.CD_HomePhone HomePhone
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_HomePhone,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.HomePhone,'') <> stg.HomePhone 

	update a
	set a.CellPhone= stg.CellPhone
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, CellPhone
		from ( 
			select pc.ContactId, pc.CD_CellPhone CellPhone
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_CellPhone,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.CellPhone,'') <> stg.CellPhone 

	update a
	set a.BusinessPhone= stg.BusinessPhone
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, BusinessPhone
		from ( 
			select pc.ContactId, pc.CD_BusinessPhone BusinessPhone
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_BusinessPhone,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.BusinessPhone,'') <> stg.BusinessPhone 

	update a
	set a.Fax= stg.Fax
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, Fax
		from ( 
			select pc.ContactId, pc.CD_Fax Fax
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_Fax,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.Fax,'') <> stg.Fax 

	update a
	set a.OtherPhone= stg.OtherPhone
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, OtherPhone
		from ( 
			select pc.ContactId, pc.CD_OtherPhone OtherPhone
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_OtherPhone,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.OtherPhone,'') <> stg.OtherPhone 

	update a
	set a.EvEmail= stg.EvEmail
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, EvEmail
		from ( 
			select pc.ContactId, pc.CD_EvEmail EvEmail
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_EvEmail,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.EvEmail,'') <> stg.EvEmail 

	update a
	set a.PersonalEmail= stg.PersonalEmail
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, PersonalEmail
		from ( 
			select pc.ContactId, pc.CD_PersonalEmail PersonalEmail
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_PersonalEmail,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.PersonalEmail,'') <> stg.PersonalEmail 

	update a
	set a.BusinessEmail= stg.BusinessEmail
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, BusinessEmail
		from ( 
			select pc.ContactId, pc.CD_BusinessEmail BusinessEmail
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_BusinessEmail,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.BusinessEmail,'') <> stg.BusinessEmail 

	update a
	set a.OtherEmail= stg.OtherEmail
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, OtherEmail
		from ( 
			select pc.ContactId, pc.CD_OtherEmail OtherEmail
			, ROW_NUMBER() OVER(PARTITION BY pc.ContactId ORDER BY pc.MergeRank) MergeRank	
			from #PatronContact pc
			where isnull(pc.CD_OtherEmail,'') <> ''
		) a 
		where a.MergeRank = 1
	) stg on a.ContactId = stg.ContactId
	where isnull(a.OtherEmail,'') <> stg.OtherEmail 



	select *
	into #MarkCodeOwner
	from (
		select p.ContactId, p.Patron, t.Order_Date__c MaxOrderDate, t.Rep_Code__c MarkCode
		, ROW_NUMBER() OVER(PARTITION BY p.ContactId ORDER BY isnull(t.Order_Date__c,'1900-01-01') desc) MergeRank	
		from dbo.Patron__c p
		inner join dbo.Transactions__c t on p.Patron = t.Patron_ID__c
		inner join dbo.SFDC_User u on t.Rep_Code__c = u.Mark_Code__c
		where isnull(t.Rep_Code__c,'') <> ''
	) a
	where mergeRank = 1

	update a
	set a.OwnerMarkCode = isnull(mco.MarkCode, 'ETL')
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	left outer join #MarkCodeOwner mco on a.ContactId = mco.ContactId
	where a.OwnerMarkCode <> isnull(mco.MarkCode, 'ETL')

	update a 
	set a.IsBusinessAccount = ba.IsBusinessAccount
	, a.FirstName = case when ba.IsBusinessAccount = 1 then null else a.FirstName end
	, a.LastName = case when ba.IsBusinessAccount = 1 then ba.FullName else a.LastName end
	, a.Title = case when ba.IsBusinessAccount = 1 then null else a.Title end
	, a.FullName = case when ba.IsBusinessAccount = 1 then ba.FullName else a.FullName end
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, IsBusinessAccount, FullName
		from (
			select ContactId, IsBusinessAccount, FullName
			, ROW_NUMBER() OVER(PARTITION BY ContactId ORDER BY dbLastUpdated desc) MergeRank	
			from Patron__c	
		) a
		where MergeRank = 1
	) ba on a.ContactId = ba.ContactId
	where isnull(a.IsBusinessAccount,0) <> ba.IsBusinessAccount
	
	--update the new donor flag based on the max in the contact id string 
	update a 
	set a.Donor_ID__c = ba.Donor_ID__c
	, a.Donor_Membership__c = ba.Donor_Membership__c
	, a.changeType = 'c'
	, a.dbLastUpdated = getdate()
	from dbo.Account a
	inner join (
		select ContactId, donor_id__c, Donor_Membership__c
		from (
			select ContactId, donor_id__c, Donor_Membership__c
			, ROW_NUMBER() OVER(PARTITION BY ContactId ORDER BY donor_id__c desc) MergeRank	
			from Patron__c	
		) a
		where MergeRank = 1
	) ba on a.ContactId = ba.ContactId
	where (isnull(a.donor_id__c,'b') <> isnull(ba.donor_id__c, 'a'))  
	or 
	(isnull(a.donor_membership__c, 'a') <> isnull(ba.donor_membership__c,'b'))
	







	update dbo.Account
	set FirstName = null
	, LastName = null
	, Title = null
	, changeType = 'c'
	, dbLastUpdated = getdate()
	where IsBusinessAccount = 1
	and (FirstName is not null or LastName is not null or Title is not null)

	--Set processed records to merged
	update scd
	set scd.IsMerged = 1
	from src.CD_CleanDataResult scd
	inner join #CD_DataSet d on scd.CleanDataResultId = d.CleanDataResultId	

	delete dbo.CD_ProcessQueue
	where SourceContactId in (select distinct SourceContactId from #CD_DataSet)

	
END










GO
