SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[vwSFDCMaint_SFCreated_GUIDUpdate_Account]
AS
SELECT DISTINCT b.[SourceSystem], b.SSID Id, b.[SSB_CRMSYSTEM_CONTACT_ID] SSB_CRMSYSTEM_ACCT_ID__c
FROM USC.dbo.vwDimCustomer_ModAcctId b 
INNER JOIN USC_Reporting.ProdCopy.Account c ON b.SSID = c.Id AND b.SourceSystem = 'USC SFDC Account'
WHERE [b].[IsDeleted] = 0



GO
