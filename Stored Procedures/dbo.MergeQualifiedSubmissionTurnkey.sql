SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*****

Helpful note:  Turnkey_Appends = Turnkey_Acxiom.

*****/

CREATE PROCEDURE [dbo].[MergeQualifiedSubmissionTurnkey] 


AS

BEGIN

SET NOCOUNT ON;

SELECT vTF.SSID, vTF.SourceSystem, vTF.TicketingSystemAccountID
INTO #Qualifiedturnkey
FROM dbo.vwTurnKey_Qualified vTF
LEFT OUTER JOIN dbo.TurnkeyQualifiedSubmissions qs
	ON qs.SSID = vTF.SSID
	AND qs.SourceSystem = vTF.SourceSystem
WHERE qs.SSID IS NULL;


MERGE INTO dbo.TurnkeyQualifiedSubmissions AS target
USING #Qualifiedturnkey  AS SOURCE 
	ON SOURCE.SSID = target.SSID
	AND SOURCE.SourceSystem = target.SourceSystem

WHEN NOT MATCHED THEN INSERT 
(
	TC_ID,
	SSID,
	SourceSystem,
	[FileName],
	SubmitDate,
	ReceiveDate,
	LastModifiedDate,
	TicketingSystemAccountID
)
VALUES
(
	0,
	source.SSID,
	source.SourceSystem,
	'0',
	GETDATE(),
	NULL,
	GETDATE(),
	TicketingSystemAccountID
);


-- Checking for return trip people
UPDATE A 
SET A.ReceiveDate = CAST(B.ETL_CreatedDate AS DATE)
FROM dbo.TurnkeyQualifiedSubmissions A
JOIN ods.Turnkey_Acxiom B 
	ON A.TicketingSystemAccountID = B.TicketingSystemAccountID
;


UPDATE A 
SET A.SubmitDate = CAST(B.SubmitDate AS DATE)
FROM dbo.TurnkeyQualifiedSubmissions A
JOIN dbo.vwTurnKey_Qualified B 
	ON A.SSID = B.SSID
	AND A.SourceSystem = B.SourceSystem
;



END



GO
