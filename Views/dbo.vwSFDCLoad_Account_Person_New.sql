SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/*****		Revision History

2017-04-21 by DCH	-	Changed to use table dbo.SFDCLoad_Account_Prep instead of view.  Table is populated by sproc etl.Load_SFDCLoad_Account_Prep.
2017-05-3 by AMEITIN - commented out DevelopmentOwner__c until we resolve the source data discrepancies
2017-08-21 by AMEITIN - added back DevelopmentOwner__c 
2017-10-10 by AMEITIN - added criteria to prevent creating records we won't match to in the where clause
2017-10-11 by AMEITIN - added Business_Name__c

*****/

CREATE VIEW [dbo].[vwSFDCLoad_Account_Person_New]
AS
SELECT a.[SSB_CRMSYSTEM_ACCT_ID__c]
    ,a.[SSB_CRMSYSTEM_SSID_Winner__c]
    ,[SSB_CRMSYSTEM_USC_ID__c]SSB_CRMSYSTEM_Patron_ID__c
    ,a.[SSB_CRMSYSTEM_DimCustomerID__c]
    ,a.[PersonTitle]
    ,LEFT(a.[FirstName],100) FirstName
    ,LEFT(a.[LastName],100) LastName
    ,a.[Person_RecordTypeId] RecordTypeId
    ,a.[BillingStreet]
    ,a.[BillingCity]
    ,a.[BillingState]
    ,a.[BillingPostalCode]
    ,a.[BillingCountry]
    ,a.[ShippingStreet]
    ,a.[ShippingCity]
    ,a.[ShippingState]
    ,a.[ShippingPostalCode]
    ,a.[ShippingCountry]
    ,a.[PersonMailingStreet]
    ,a.[PersonMailingCity]
    ,a.[PersonMailingState]
    ,a.[PersonMailingPostalCode]
    ,a.[PersonMailingCountry]
    ,a.[PersonOtherStreet]
    ,a.[PersonOtherCity]
    ,a.[PersonOtherState]
    ,a.[PersonOtherPostalCode]
    ,a.[PersonOtherCountry]
    ,a.[Phone]
    ,a.[PersonMobilePhone]
    ,a.[PersonHomePhone] 
    ,LEFT(a.[PersonEmail],255) PersonEmail
	,a.Secondary_Email__pc
    ,a.[SSB_CRMSYSTEM_USC_Flag__c]
    ,a.[SSB_CRMSYSTEM_USC_Season_Ticket_Ye__c]SSB_CRMSYSTEM_USC_Season_Ticket_Years__c
    ,a.[Customer_Status__c]
    ,a.[eVenue_Email__c] evenue_Email__c
    ,a.[Donor_Status__c] Patron_Status__c
    ,a.[Donor_Type__c]
    ,a.[Donor_Level__c]
    ,a.[Internet_Profile__c]
    ,a.[eVenue_Pin__c]
    ,a.[VIP_Code__c]
    ,a.[Customer_Type__c]
    ,a.[Donor_ID__c]
    ,a.[TAG__c]
    ,a.[Customer_Comments__c]
    ,a.[C_PRIORITY__C]
    ,a.[Attribute__C]
    ,a.[Note__C]
    ,a.[Donor_Comments__C] Donor_Comments__c
	,a.Donor_Membership__c
	,a.[Football_Full__c]
	,a.[Football_Rookie__c]
	,a.[Football_Partial__c]
	,a.[Men_s_Basketball_Full__c]
	,a.[Men_s_Basketball_Rookie__c]
	,a.[Men_s_Basketball_Partial__c]
	,a.Turnkey_Discretionary_Income_Index__c  --Added 12/1/2016 hjrd
	,a.Turnkey_Net_Worth_Gold__c   --Added 12/1/2016 hjrd
	,a.Turnkey_Standard_Bundle_Date__c   --Added 12/1/2016 hjrd
	,a.Turnkey_Age_Input_Individual__c   --Added 12/1/2016 hjrd
	,a.Turnkey_Gender_Input_Individual__c   --Added 12/1/2016 hjrd
	,a.Turnkey_Marital_Status__c   --Added 12/1/2016 hjrd
	,a.Turnkey_Presence_of_Children__c   --Added 12/1/2016 hjrd
	,a.Turnkey_Occupation_Input_Individual__c   --Added 12/1/2016 hjrd
	,a.Turnkey_PersonicX_Cluster__c --Added 12/1/2016 hjrd
	,a.Turnkey_Football_Priority_Score__c --Added 12/1/2016 hjrd
	,a.Turnkey_Donor_Capacity_Score__c --Added 12/1/2016 hjrd
	,a.Turnkey_Donor_Priority_Score__c --Added 12/1/2016 hjrd
	,a.Development__c --Added 12/1/2016 hjrd
	, CASE WHEN a.Business_Name IS NULL THEN NULL 
		   ELSE a.Business_Name END AS Business_Name__c

--	FROM dbo.vwSFDCLoad_Account_Prep a
FROM dbo.SFDCLoad_Account_Prep a (NOLOCK)
WHERE 1=1 
AND a.IsBusinessAccount = 0
AND LEN(a.salesforce_id) > 18
AND a.salesforce_id NOT IN (SELECT salesforce_id ---added by AMEITIN 2017-10-10 to prevent creating records we won't match to
							FROM dbo.SFDCLoad_Account_Prep (NOLOCK) 
							WHERE IsBusinessAccount = 0
							AND LEN(salesforce_id) > 18
							AND (BillingStreet = ' '  OR BillingStreet IS NULL) 
							AND (PersonMailingStreet = ' ' OR PersonMailingStreet IS NULL)
							AND (PersonEmail = ' ' OR PersonEmail IS NULL)
							) 




GO
