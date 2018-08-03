SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[vwSFDC_Turnkey] AS
		
		select b.ssb_crmsystem_contact_id
				,Turnkey_Discretionary_Income_Index__c 
				,Turnkey_Net_Worth_Gold__c 
				,Turnkey_Standard_Bundle_Date__c 
				,Turnkey_Age_Input_Individual__c 
				,Turnkey_Gender_Input_Individual__c 
				,Turnkey_Marital_Status__c 
				,Turnkey_Presence_of_Children__c 
				,Turnkey_Occupation_Input_Individual__c 
				,Turnkey_PersonicX_Cluster__c 
				,Turnkey_Football_Priority_Score__c 
				,Turnkey_Donor_Capacity_Score__c 
				,Turnkey_Donor_Priority_Score__c 
		FROM usc_sfdc.[dbo].[Account] a WITH(NOLOCK)
		INNER JOIN (SELECT b.SSB_CRMSYSTEM_CONTACT_ID
							, DiscretionaryIncomeIndex AS Turnkey_Discretionary_Income_Index__c 
							, NetWorthGold AS Turnkey_Net_Worth_Gold__c 
							, CAST(TurnkeyStandardBundleDate AS DATE) AS Turnkey_Standard_Bundle_Date__c 
							, AgeInTwoYearIncrements_InputIndividual AS Turnkey_Age_Input_Individual__c 
							, Gender_InputIndividual AS Turnkey_Gender_Input_Individual__c 
							, MaritalStatusinHousehold AS Turnkey_Marital_Status__c 
							, PresenceofChildren AS Turnkey_Presence_of_Children__c 
							, Occupation_InputIndividual AS Turnkey_Occupation_Input_Individual__c 
							, PersonicxCluster AS Turnkey_PersonicX_Cluster__c 
							,models.FootballPriority AS Turnkey_Football_Priority_Score__c 
							,models.DonorCapacity AS Turnkey_Donor_Capacity_Score__c 
							,models.DonorPriority AS Turnkey_Donor_Priority_Score__c 
							,ROW_NUMBER() OVER (PARTITION BY b.SSB_CRMSYSTEM_ACCT_ID ORDER BY turnkey.TurnkeyStandardBundleDate DESC) RN
		FROM USC_SFDC.ods.Turnkey_Acxiom turnkey WITH(NOLOCK)
		JOIN USC_SFDC.ods.Turnkey_Models models WITH(NOLOCK) ON turnkey.TicketingSystemAccountId = models.TicketingSystemAccountID 
		JOIN USC.dbo.vwDimCustomer_ModAcctId b WITH(NOLOCK) ON b.SSID = turnkey.TicketingSystemAccountID AND b.SourceSystem = 'TI USC') b
		ON a.SSB_CRMSYSTEM_ACCT_ID = b.SSB_CRMSYSTEM_CONTACT_ID and b.RN = 1
GO
