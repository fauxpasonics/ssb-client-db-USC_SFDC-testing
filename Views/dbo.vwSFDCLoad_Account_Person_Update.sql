SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/*****		Revision History

2017-04-21 by DCH	-	Changed to use table dbo.SFDCLoad_Account_Prep instead of view.  Table is populated by sproc etl.Load_SFDCLoad_Account_Prep.
2017-05-3 by AMEITIN - commented out DevelopmentOwner__c until we resolve the source data discrepancies
2017-08-21 by AMEITIN - added back DevelopmentOwner__c
2017-10-10 by AMEITIN added Busines_Name__c
*****/


CREATE VIEW [dbo].[vwSFDCLoad_Account_Person_Update]
AS
SELECT a.[SSB_CRMSYSTEM_ACCT_ID__c]																  
      ,a.[SSB_CRMSYSTEM_SSID_Winner__c]															  --, b.SSB_CRMSYSTEM_SSID_Winner__c
      ,a.[SSB_CRMSYSTEM_USC_ID__c] SSB_CRMSYSTEM_Patron_ID__c									  --, b.SSB_CRMSYSTEM_Patron_ID__c
      ,a.[SSB_CRMSYSTEM_DimCustomerID__c]														  --, b.[SSB_CRMSYSTEM_DimCustomerID__c]
      ,a.[PersonTitle]																			  --, b.[PersonTitle]
      ,a.[FirstName]																			  --, b.[FirstName]
      ,LEFT(a.[LastName],1000)  LastName														  --, b.LastName
      ,a.[BillingStreet]																		  --, b.[BillingStreet]
      ,a.[BillingCity]																			  --, b.[BillingCity]
      ,a.[BillingState]																			  --, b.[BillingState]
      ,a.[BillingPostalCode]																	  --, b.[BillingPostalCode]
      ,a.[BillingCountry]																		  --, b.[BillingCountry]
      ,a.[ShippingStreet]																		  --, b.[ShippingStreet]
      ,a.[ShippingCity]																			  --, b.[ShippingCity]
      ,a.[ShippingState]																		  --, b.[ShippingState]
      ,a.[ShippingPostalCode]																	  --, b.[ShippingPostalCode]
      ,a.[ShippingCountry]																		  --, b.[ShippingCountry]
      ,a.[PersonMailingStreet]																	  --, b.[PersonMailingStreet]
      ,a.[PersonMailingCity]																	  --, b.[PersonMailingCity]
      ,a.[PersonMailingState]																	  --, b.[PersonMailingState]
      ,a.[PersonMailingPostalCode]																  --, b.[PersonMailingPostalCode]
      ,a.[PersonMailingCountry]																	  --, b.[PersonMailingCountry]
      ,a.[PersonOtherStreet]																	  --, b.[PersonOtherStreet]
      ,a.[PersonOtherCity]																		  --, b.[PersonOtherCity]
      ,a.[PersonOtherState]																		  --, b.[PersonOtherState]
      ,a.[PersonOtherPostalCode]																  --, b.[PersonOtherPostalCode]
      ,a.[PersonOtherCountry]																	  --, b.[PersonOtherCountry]
      ,a.[Phone]																				  --, b.[Phone]
      ,a.[PersonMobilePhone]																	  --, b.[PersonMobilePhone]
      ,a.[PersonHomePhone]																		  --, b.[PersonHomePhone]
      ,LEFT(a.[PersonEmail],255) PersonEmail													  --, b.PersonEmail
	  ,a.Secondary_Email__pc																	  --, b.Secondary_Email__pc
      ,CAST([salesforce_id] AS NVARCHAR(50)) Id													  --
      ,a.[SSB_CRMSYSTEM_USC_Flag__c]															  --, b.[SSB_CRMSYSTEM_USC_Flag__c]
      ,a.[SSB_CRMSYSTEM_USC_Season_Ticket_Ye__c] SSB_CRMSYSTEM_USC_Season_Ticket_Years__c		  --, b.SSB_CRMSYSTEM_USC_Season_Ticket_Years__c
      ,a.[Customer_Status__c]																	  --, b.[Customer_Status__c]
      ,a.[eVenue_Email__c] evenue_Email__c														  --, b.evenue_Email__c
      ,a.[Donor_Status__c]																		  ----, b.[Donor_Status__c]
      ,a.[Donor_Type__c]																		  ----, b.[Donor_Type__c]
      ,a.[Donor_Level__c]																		  ----, b.[Donor_Membership__c]
      ,a.[Internet_Profile__c]																	  --, b.[Internet_Profile__c]
      ,a.[eVenue_Pin__c]																		  ----, b.[eVenue_Pin__c]
      ,a.[VIP_Code__c]																			  ----, b.[VIP_Code__c]
      ,a.[Customer_Type__c]																		  --, b.[Customer_Type__c]
      ,a.[Donor_ID__c]																			  --, b.[Donor_ID__c]
      ,a.[TAG__c]																				  ----, b.[TAG__c]
      ,a.[Customer_Comments__c]																	  --, b.[Customer_Comments__c]
      ,a.[C_PRIORITY__C]																		  ----, b.[C_PRIORITY__C]
      ,a.[Attribute__C]																			  ----, b.[Attribute__C]
      ,a.[Note__C]																				  ----, b.[Note__C]
      ,a.[Donor_Comments__C]																	  ----, b.[Donor_Comments__C]
	  , a.Donor_Membership__c																	  --, b.Donor_Membership__c
	  , a.[Football_Full__c]																	  --, b.[Football_Full__c]
	  , a.[Football_Rookie__c]																	  --, b.[Football_Rookie__c]
	  , a.[Football_Partial__c]																	  --, b.[Football_Partial__c]
	  , a.[Men_s_Basketball_Full__c]															  --, b.[Men_s_Basketball_Full__c]
	  , a.[Men_s_Basketball_Rookie__c]															  --, b.[Men_s_Basketball_Rookie__c]
	  , a.[Men_s_Basketball_Partial__c]															  --, b.[Men_s_Basketball_Partial__c]
	  --Added 12/1/2016 by HJRD																	  --
	  ,a.Turnkey_Discretionary_Income_Index__c 													  --, b.Turnkey_Discretionary_Income_Index__c
	  ,a.Turnkey_Net_Worth_Gold__c   															  --, b.Turnkey_Net_Worth_Gold__c
	  ,a.Turnkey_Standard_Bundle_Date__c   														  --, b.Turnkey_Standard_Bundle_Date__c
	  ,a.Turnkey_Age_Input_Individual__c   														  --, b.Turnkey_Age_Input_Individual__c
	  ,a.Turnkey_Gender_Input_Individual__c   													  --, b.Turnkey_Gender_Input_Individual__c
	  ,a.Turnkey_Marital_Status__c   															  --, b.Turnkey_Marital_Status__c
	  ,a.Turnkey_Presence_of_Children__c   														  --, b.Turnkey_Presence_of_Children__c
	  ,a.Turnkey_Occupation_Input_Individual__c 												  --, b.Turnkey_Occupation_Input_Individual__c
	  ,a.Turnkey_PersonicX_Cluster__c 															  --, b.Turnkey_PersonicX_Cluster__c
	  ,a.Turnkey_Football_Priority_Score__c 													  --, b.Turnkey_Football_Priority_Score__c
	  ,a.Turnkey_Donor_Capacity_Score__c														  --, b.Turnkey_Donor_Capacity_Score__c
	  ,a.Turnkey_Donor_Priority_Score__c														  --, b.Turnkey_Donor_Priority_Score__c
	  ,a.Development__c 																		  --, b.Development__c
	  , CASE WHEN a.Business_Name IS NULL THEN NULL												  --, b.Business_Name__c
			 ELSE a.Business_Name END AS Business_Name__c
--	FROM dbo.vwSFDCLoad_Account_Prep a
FROM dbo.SFDCLoad_Account_Prep a (NOLOCK)
LEFT JOIN USC_Reporting.ProdCopy.vw_Account b
	ON a.salesforce_id = b.Id
WHERE 1=1 
AND (a.IsBusinessAccount = 0 AND SFDC_IsBusiness = 0)
AND a.salesforce_id <> CAST(a.SSB_CRMSYSTEM_ACCT_ID__c AS VARCHAR(50))
AND (1=2
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[SSB_CRMSYSTEM_SSID_Winner__c] AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.SSB_CRMSYSTEM_SSID_Winner__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[SSB_CRMSYSTEM_USC_ID__c] AS VARCHAR(150)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.SSB_CRMSYSTEM_Patron_ID__c AS VARCHAR(150)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[SSB_CRMSYSTEM_DimCustomerID__c] AS VARCHAR(5000)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[SSB_CRMSYSTEM_DimCustomerID__c] AS VARCHAR(5000)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonTitle] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonTitle] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[FirstName] AS VARCHAR(40)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[FirstName] AS VARCHAR(40)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.LastName AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.LastName AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[BillingStreet] AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[BillingStreet] AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[BillingCity] AS VARCHAR(40)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[BillingCity] AS VARCHAR(40)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[BillingState] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[BillingState] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[BillingPostalCode] AS VARCHAR(20)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[BillingPostalCode] AS VARCHAR(20)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[BillingCountry] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[BillingCountry] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[ShippingStreet] AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[ShippingStreet] AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[ShippingCity] AS VARCHAR(40)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[ShippingCity] AS VARCHAR(40)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[ShippingState] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[ShippingState] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[ShippingPostalCode] AS VARCHAR(20)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[ShippingPostalCode] AS VARCHAR(20)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[ShippingCountry] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[ShippingCountry] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonMailingStreet] AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonMailingStreet] AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonMailingCity] AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonMailingCity] AS VARCHAR(40)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonMailingState] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonMailingState] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonMailingPostalCode] AS VARCHAR(20)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonMailingPostalCode] AS VARCHAR(20)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonMailingCountry] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonMailingCountry] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonOtherStreet] AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonOtherStreet] AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonOtherCity] AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonOtherCity] AS VARCHAR(40)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonOtherState] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonOtherState] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonOtherPostalCode] AS VARCHAR(20)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonOtherPostalCode] AS VARCHAR(20)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonOtherCountry] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonOtherCountry] AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Phone] AS VARCHAR(40)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Phone] AS VARCHAR(40)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonMobilePhone] AS VARCHAR(40)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonMobilePhone] AS VARCHAR(40)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[PersonHomePhone] AS VARCHAR(40)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[PersonHomePhone] AS VARCHAR(40)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.PersonEmail AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.PersonEmail AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Secondary_Email__pc AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Secondary_Email__pc AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[SSB_CRMSYSTEM_USC_Flag__c] AS BIT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[SSB_CRMSYSTEM_USC_Flag__c] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[SSB_CRMSYSTEM_USC_Season_Ticket_Ye__c] AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.SSB_CRMSYSTEM_USC_Season_Ticket_Years__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Customer_Status__c] AS VARCHAR(128)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Customer_Status__c] AS VARCHAR(128)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[eVenue_Email__c] AS VARCHAR(80)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.evenue_Email__c AS VARCHAR(80)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Internet_Profile__c] AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Internet_Profile__c] AS VARCHAR(100)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Customer_Type__c] AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Customer_Type__c] AS VARCHAR(100)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Donor_ID__c] AS VARCHAR(50)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Donor_ID__c] AS VARCHAR(50)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Customer_Comments__c] AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Customer_Comments__c] AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Donor_Membership__c AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Donor_Membership__c AS VARCHAR(255)))),''))
    OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Football_Full__c] AS BIT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Football_Full__c] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Football_Rookie__c] AS BIT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Football_Rookie__c] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Football_Partial__c] AS BIT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Football_Partial__c] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Men_s_Basketball_Full__c] AS BIT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Men_s_Basketball_Full__c] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Men_s_Basketball_Rookie__c] AS BIT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Men_s_Basketball_Rookie__c] AS BIT))),''))
    OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.[Men_s_Basketball_Partial__c] AS BIT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[Men_s_Basketball_Partial__c] AS BIT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Discretionary_Income_Index__c AS INT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Discretionary_Income_Index__c AS INT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Net_Worth_Gold__c AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Net_Worth_Gold__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Standard_Bundle_Date__c AS DATE))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Standard_Bundle_Date__c AS DATE))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Age_Input_Individual__c AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Age_Input_Individual__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Gender_Input_Individual__c AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Gender_Input_Individual__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Marital_Status__c AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Marital_Status__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Presence_of_Children__c AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Presence_of_Children__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Occupation_Input_Individual__c AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Occupation_Input_Individual__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_PersonicX_Cluster__c AS VARCHAR(255)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_PersonicX_Cluster__c AS VARCHAR(255)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Football_Priority_Score__c AS INT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Football_Priority_Score__c AS INT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Donor_Capacity_Score__c AS INT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Donor_Capacity_Score__c AS INT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Turnkey_Donor_Priority_Score__c AS INT))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Turnkey_Donor_Priority_Score__c AS INT))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Development__c AS VARCHAR(18)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Development__c AS VARCHAR(18)))),''))	
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.donor_level__c AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Donor_Membership__c AS VARCHAR(100)))),''))	
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(a.Business_Name AS VARCHAR(1000)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.Business_Name__c AS VARCHAR(100)))),''))	

)




GO
