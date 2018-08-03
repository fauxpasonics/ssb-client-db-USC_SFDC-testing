SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/*****		Revision History

2017-04-21 by DCH	-	Changed to use table dbo.SFDCLoad_Account_Prep instead of view.  Table is populated by sproc etl.Load_SFDCLoad_Account_Prep.
2017-05-3 by AMEITIN - commented out DevelopmentOwner__c until we resolve the source data discrepancies
2017-08-21 by AMEITIN - added back DevelopmentOwner__c
2017-10-10 by AMEITIN altered to use USC_Reporting ProdCopy
*****/



CREATE VIEW [dbo].[vwSFDCLoad_Account_Business_Update]
AS
SELECT  a.[SSB_CRMSYSTEM_ACCT_ID__c]
      ,a.[SSB_CRMSYSTEM_SSID_Winner__c]
      ,a.[SSB_CRMSYSTEM_USC_ID__c] SSB_CRMSYSTEM_Patron_ID__c
      ,a.[SSB_CRMSYSTEM_DimCustomerID__c]
      ,a.[Business_Name] Name
      --,CASE WHEN [Person_RecordTypeId] = b.[RecordTypeId] THEN [Person_RecordTypeId] ELSE [a].[Business_RecordTypeId] END RecordTypeId
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
      ,a.[Phone]
	  ,a.[PersonHomePhone] Business_Home_Phone__c
      ,a.[Business_Email__c]
			,a.BusinessONLY_Email__c
	  ,a.PersonMobilePhone Business_Other_Phone__c
	  ,CAST([salesforce_id] AS NVARCHAR(50)) Id
      ,a.[SSB_CRMSYSTEM_USC_Flag__c]
      ,a.[SSB_CRMSYSTEM_USC_Season_Ticket_Ye__c] SSB_CRMSYSTEM_USC_Season_Ticket_Years__c
      ,a.[Customer_Status__c]
      ,a.[eVenue_Email__c] evenue_Email__c
      ,a.[Donor_Status__c]
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
      ,a.[Donor_Comments__C]
	  ,a.Donor_Membership__c
	  , a.[Football_Full__c]
	  , a.[Football_Rookie__c]
	  , a.[Football_Partial__c]
	  , a.[Men_s_Basketball_Full__c]
	  , a.[Men_s_Basketball_Rookie__c]
	  , a.[Men_s_Basketball_Partial__c]
	  , a.Turnkey_Discretionary_Income_Index__c  --Added 12/1/2016 hjrd
	  , a.Turnkey_Net_Worth_Gold__c   --Added 12/1/2016 hjrd
	  , a.Turnkey_Standard_Bundle_Date__c   --Added 12/1/2016 hjrd
	  , a.Turnkey_Age_Input_Individual__c   --Added 12/1/2016 hjrd
	  , a.Turnkey_Gender_Input_Individual__c   --Added 12/1/2016 hjrd
	  , a.Turnkey_Marital_Status__c   --Added 12/1/2016 hjrd
	  , a.Turnkey_Presence_of_Children__c   --Added 12/1/2016 hjrd
	  , a.Turnkey_Occupation_Input_Individual__c   --Added 12/1/2016 hjrd
	  , a.Turnkey_PersonicX_Cluster__c --Added 12/1/2016 hjrd
	  , a.Turnkey_Football_Priority_Score__c --Added 12/1/2016 hjrd
	  , a.Turnkey_Donor_Capacity_Score__c --Added 12/1/2016 hjrd
	  , a.Turnkey_Donor_Priority_Score__c --Added 12/1/2016 hjrd
	  , a.Development__c --Added 12/1/2016 hjrd

--	FROM dbo.vwSFDCLoad_Account_Prep a
	FROM dbo.SFDCLoad_Account_Prep a (NOLOCK)
	LEFT JOIN USC_Reporting.ProdCopy.[vw_Account] b ON a.[salesforce_id] = b.[Id]
	WHERE 1=1 
	AND (a.IsBusinessAccount = 1 OR SFDC_IsBusiness = 1)
	AND a.salesforce_id <> CAST(a.SSB_CRMSYSTEM_ACCT_ID__c AS VARCHAR(50))











GO
