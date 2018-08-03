SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spSFDCLoad_SaveResults_Acct] AS
UPDATE a
SET salesforce_id = CASE WHEN b.[salesforce_id] IS NULL THEN a.salesforce_Id ELSE b.[salesforce_id] END,
SFDC_LoadDate = GETDATE()
,LastSFDCLoad_Error = b.ErrorDescription
,LastSFDCLoad_AttemptDate = GETDATE()
--SELECT b.*
FROM dbo.account a
INNER JOIN dbo.Account_SFDCUpdates b ON a.SSB_CRMSYSTEM_ACCT_ID = b.SSB_CRMSYSTEM_ACCT_ID__c

GO
