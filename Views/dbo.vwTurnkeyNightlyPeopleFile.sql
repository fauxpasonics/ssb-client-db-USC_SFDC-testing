SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


CREATE VIEW [dbo].[vwTurnkeyNightlyPeopleFile] 

AS

SELECT 
ts.TicketingSystemAccountID AS TicketingAccountID,
CONVERT(VARCHAR(50), CONCAT(RTRIM(DC.SourceSystem),':',LTRIM(DC.SSID))) AS PersonID,
DC.Firstname AS FirstName,
DC.LastName AS LastName,
DC.[AddressPrimaryStreet] AS Address1,
NULL AS Address2,
DC.[AddressPrimaryCity] AS City,
DC.[AddressPrimaryState] AS [STATE],
DC.[AddressPrimaryZip] AS PostalCode,
DC.[AddressPrimaryCountry] AS Country,
COALESCE(DC.EmailOne, DC.EmailTwo) AS Email,
DC.[PhoneHome] AS HomePhone,
DC.[PhoneCell] AS MobilePhone
FROM dbo.vwDimCustomer_ModAcctId DC
INNER JOIN dbo.TurnkeyQualifiedSubmissions ts
ON dc.SSID = ts.SSID AND ts.SourceSystem = dc.sourcesystem		-- SSID for TI, AccountId for TM
WHERE dc.isbusiness = 0
AND ts.SubmitDate >= CONVERT(date,DATEADD(day,-2,GETDATE()))	--	changed to day-minus-2 by DCH on 2017-04-26
AND ts.ReceiveDate IS NULL
--AND [DC].[CustomerType] = 'Primary'								-- Not necessary for TI



















GO
