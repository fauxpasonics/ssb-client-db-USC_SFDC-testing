SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*****		Revision History		*****************************************

2017-04-21 by DCH	-	Created to materialize the view into a table rather than using the view in an SSIS package.
						The subordinate views will use dbo.SFDCLoad_Account_Prep as the driving table.

2017-10-10 by AMeitin - Altered to use USC_Reporting ProdCopy
*****/


CREATE PROCEDURE [etl].[Load_SFDCLoad_Account_Prep]
AS


TRUNCATE TABLE dbo.SFDCLoad_Account_Prep;


INSERT dbo.SFDCLoad_Account_Prep
SELECT a.SSB_CRMSYSTEM_ACCT_ID SSB_CRMSYSTEM_ACCT_ID__c
, a.SSID_Winner SSB_CRMSYSTEM_SSID_Winner__c
, a.USC_Losers SSB_CRMSYSTEM_USC_ID__c
, a.DimCustID_Losers SSB_CRMSYSTEM_DimCustomerID__c
, a.Title PersonTitle
, a.FirstName, a.LastName
, CAST(CASE WHEN FullName LIKE '%,%' THEN NULL ELSE FullName END AS NVARCHAR(50)) AS Business_Name
--, COALESCE(FullName,a.FirstName + ' ' + a.Lastname) Business_Name
, PersonRT.id Person_RecordTypeId
, BusinessRT.Id Business_RecordTypeId
, CASE WHEN [rectypealt].[RecordTypeId] = [BusinessRT].id THEN 1 ELSE 0 END SFDC_IsBusiness
, a.BillingStreet, a.BillingCity, a.BillingState, a.BillingPostalCode, a.BillingCountry
, a.ShippingStreet, a.ShippingCity, a.ShippingState, a.ShippingPostalCode, a.ShippingCountry
, a.PersonMailingStreet, a.PersonMailingCity, a.PersonMailingState, a.PersonMailingPostalCode, a.PersonMailingCountry
, a.PersonOtherStreet, a.PersonOtherCity, a.PersonOtherState, a.PersonOtherPostalCode, a.PersonOtherCountry
, a.Phone
, a.PersonMobilePhone PersonMobilePhone
, a.PersonHomePhone PersonHomePhone
, a.Email PersonEmail
, a.Email Business_Email__c -- Changed 12/1/2016 hjrd
--, a.Email BusinessOnly_Email__c --Changed 12/1/2016 hjrd
, a.SecondaryEmail Secondary_Email__pc
, NULL AS BusinessOnly_Email__c --Changed 12/1/2016 hjrd
, a.salesforce_id
, a.IsBusinessAccount
, a.USC_Flag SSB_CRMSYSTEM_USC_Flag__c
, a.USC_SeasonTicket_Years SSB_CRMSYSTEM_USC_Season_Ticket_Ye__c
, Customer_Status Customer_Status__c
, eVenue_Email eVenue_Email__c
, Donor_Status Donor_Status__c
, Donor_Type Donor_Type__c
, Donor_Level Donor_Level__c
, Internet_Profile Internet_Profile__c
, eVenue_Pin eVenue_Pin__c
, VIP_Code VIP_Code__c
, Customer_Type Customer_Type__c
, Donor_ID Donor_ID__c
, TAG TAG__c
, LEFT(Customer_Comments,255) Customer_Comments__c
,[C_PRIORITY] C_PRIORITY__C
,[Attribute] Attribute__C
,[Note] Note__C
,[Donor_Comments] Donor_Comments__C
,dm.[Memberships] Donor_Membership__c
,[BusiPerson_ChgFlag]
, ISNULL(cp.[Football_Full__c],0) [Football_Full__c]
, ISNULL(cp.[Football_Rookie__c],0) [Football_Rookie__c]
, ISNULL(cp.[Football_Partial__c],0) [Football_Partial__c]
, ISNULL(cp.[Men_s_Basketball_Full__c],0) [Men_s_Basketball_Full__c]
, ISNULL(cp.[Men_s_Basketball_Rookie__c],0) [Men_s_Basketball_Rookie__c]
, ISNULL(cp.[Men_s_Basketball_Partial__c],0) [Men_s_Basketball_Partial__c]
,CAST(tk.Turnkey_Discretionary_Income_Index__c AS INT) Turnkey_Discretionary_Income_Index__c  --Added 12/1/2016 hjrd
,tk.Turnkey_Net_Worth_Gold__c   --Added 12/1/2016 hjrd
,tk.Turnkey_Standard_Bundle_Date__c   --Added 12/1/2016 hjrd
,tk.Turnkey_Age_Input_Individual__c Turnkey_Age_Input_Individual__c  --Added 12/1/2016 hjrd
,tk.Turnkey_Gender_Input_Individual__c   --Added 12/1/2016 hjrd
,tk.Turnkey_Marital_Status__c   --Added 12/1/2016 hjrd
,tk.Turnkey_Presence_of_Children__c   --Added 12/1/2016 hjrd
,tk.Turnkey_Occupation_Input_Individual__c   --Added 12/1/2016 hjrd
,tk.Turnkey_PersonicX_Cluster__c --Added 12/1/2016 hjrd
,CAST(tk.Turnkey_Football_Priority_Score__c AS INT) Turnkey_Football_Priority_Score__c --Added 12/1/2016 hjrd
,CAST(tk.Turnkey_Donor_Capacity_Score__c AS INT) Turnkey_Donor_Capacity_Score__c --Added 12/1/2016 hjrd
,CAST(tk.Turnkey_Donor_Priority_Score__c AS INT) Turnkey_Donor_Priority_Score__c --Added 12/1/2016 hjrd
,Dev.id development__c--Added 12/1/2016 hjrd

FROM dbo.Account a (NOLOCK)
JOIN USC_Reporting.ProdCopy.RecordType PersonRT (NOLOCK)
	ON PersonRT.DeveloperName = 'PersonAccount'
JOIN USC_Reporting.ProdCopy.RecordType BusinessRT (NOLOCK)
	ON BusinessRT.DeveloperName = 'Business_Account'
LEFT JOIN dbo.Ref_Membership_Lookup dm (NOLOCK)
	ON a.MembershipLevel = dm.UD4
LEFT JOIN dbo.vwSFDCLoad_CurrentPurchaser cp 
	ON a.SSB_CRMSYSTEM_ACCT_ID = cp.SSB_CRMSYSTEM_ACCT_ID
LEFT JOIN USC_Reporting.ProdCopy.vw_Account rectypealt 
	ON a.salesforce_ID = rectypealt.Id
	AND LEN(a.salesforce_ID) = 18
LEFT JOIN dbo.vwSFDC_Development Dev
	ON a.SSB_CRMSYSTEM_ACCT_ID = dev.SSB_CRMSYSTEM_CONTACT_ID  --Added 12/1/2016 hjrd
LEFT JOIN dbo.vwSFDC_Turnkey tk
	ON a.SSB_CRMSYSTEM_ACCT_ID = tk.SSB_CRMSYSTEM_CONTACT_ID  --Added 12/1/2016 hjrd
WHERE a.SFDCProcess_UpdatedDate > DATEADD(DAY,-2,GETDATE())				--		added on 2017-04-20 by DCH









GO
