SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- =============================================
-- Author:		<Abbey Meitin>
-- Create date: <10/1/2016>
-- Description:	<Turnkey Automated Nightly Process - Business File>
-- =============================================


CREATE VIEW [dbo].[vwTurnkeyNightlyBusinessFile] 

AS

SELECT  
ts.TicketingSystemAccountID AS TicketingAccountID, --should always be ticketing system ID, blank if record does not exist in ticketing
CONVERT(VARCHAR(50), CONCAT(RTRIM(DC.SourceSystem),':',LTRIM(DC.SSID))) AS PersonID, --SourceSystem:SSID updated 10/13/16 ameitin
DC.Firstname AS FirstName,
DC.LastName AS LastName,
COALESCE(DC.EmailOne, DC.EmailTwo) AS WorkEmailAddress,
COALESCE(FullName,DC.FirstName + ' ' + DC.Lastname) Business_Name,
DC.[AddressPrimaryStreet] AS BusinessAddress1,
DC.[AddressPrimaryCity] AS BusinessCity,
DC.[AddressPrimaryState] AS BusinessState,
DC.[AddressPrimaryZip] AS BusinessPostalCode,
DC.[AddressPrimaryCountry] AS BusinessCountry,
DC.[PhoneBusiness] AS Phone
FROM [dbo].[vwDimCustomer_ModAcctId] DC
INNER JOIN dbo.TurnkeyQualifiedSubmissions ts
ON dc.SSID = ts.SSID AND ts.SourceSystem = dc.SourceSystem		-- SSID for TI, AccountId for TM
WHERE dc.isbusiness = 1
AND ts.SubmitDate >= CONVERT(date,DATEADD(day,-2,GETDATE()))	--	changed to day-minus-2 by DCH on 2017-04-26
AND ts.ReceiveDate IS NULL										--changed by Ameitin to account for empty files
--AND [DC].[CustomerType] = 'Primary'								-- Not necessary for TI















GO
