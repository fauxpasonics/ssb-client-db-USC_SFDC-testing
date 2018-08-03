SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SFDCProcess_SeasonTicketHolders]
AS
TRUNCATE TABLE dbo.SFDCProcess_Acct_SeasonTicketHolders
TRUNCATE TABLE dbo.SFDCProcess_Contact_SeasonTicketHolders

--INSERT INTO dbo.SFDCProcess_SeasonTicketHolders
--SELECT DISTINCT a.SSB_CRMSYSTEM_ACCT_ID, a.SeasonList Devils_SeasonTicket_Years, CAST(NULL AS VARCHAR(1000)) Sixers_SeasonTicket_Years, a.LoadDateTime 
--FROM stg.SeasonTicketHolders a 
--WHERE Team = 'Devils'
--Drop Table #tmpA
-- Prep Sixers Season Data
SELECT DISTINCT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, Team,a.Customer AS SSID, CAST(a.[SEASONYR] AS INT) Season, CAST(a.[SEASONYR] AS INT) + 1 Season1, a.[CopyLoadDate]
INTO #tmpA
FROM stg.SeasonTicketHolders a
INNER JOIN USC.dbo.vwDimCustomer_ModAcctId b ON b.SSID = a.Customer

--****SET UP ACCOUNT LEVEL SEASON TICKET HOLDERS
SELECT SSB_CRMSYSTEM_ACCT_ID
			, STUFF((SELECT  ',' + LTRIM(STR(Season)) + '-' + LTRIM(STR(Season1))
				FROM (SELECT DISTINCT SSB_CRMSYSTEM_ACCT_ID, Team, Season, Season1 FROM #tmpA
						WHERE Team = 'USC') USC
				WHERE  t2.SSB_CRMSYSTEM_ACCT_ID =USC.SSB_CRMSYSTEM_ACCT_ID
				ORDER BY USC.SSB_CRMSYSTEM_ACCT_ID, USC.Season Desc
				FOR XML PATH('')), 1, 1, '') AS USCSeasonList	
		        , STUFF((SELECT  ',' + SSID
				FROM (SELECT DISTINCT SSB_CRMSYSTEM_ACCT_ID, TEAM, SSID FROM #tmpA) SSIDs
				WHERE  t2.SSB_CRMSYSTEM_ACCT_ID = SSIDs.SSB_CRMSYSTEM_ACCT_ID
				ORDER BY SSIDs.SSB_CRMSYSTEM_ACCT_ID, SSIDs.Team Desc
				FOR XML PATH('')), 1, 1, '') AS SSIDList
, MAX(CopyLoadDate) LoadDateTime
, COUNT(DISTINCT Team) Dist_Team
, COUNT(DISTINCT t2.SSB_CRMSYSTEM_CONTACT_ID) Dist_Contact
, COUNT(DISTINCT t2.SSID) Dist_SSID
INTO #tmpAcct
FROM #tmpA t2
WHERE t2.SSB_CRMSYSTEM_ACCT_ID IS NOT NULL
GROUP BY SSB_CRMSYSTEM_ACCT_ID

INSERT INTO dbo.SFDCProcess_Acct_SeasonTicketHolders
        ( SSB_CRMSYSTEM_ACCT_ID ,
          USC_SeasonTicket_Years ,
          --Sixers_SeasonTicket_Years ,
          SSIDs_List ,
          Distinct_Teams ,
          Distinct_ContactIDs ,
		  Distinct_SSIDs
        )
SELECT SSB_CRMSYSTEM_ACCT_ID,  USCSeasonList, SSIDList, Dist_Team, Dist_Contact, Dist_SSID FROM #tmpAcct

--****SET UP CONTACT LEVEL SEASON TICKET HOLDERS
SELECT SSB_CRMSYSTEM_CONTACT_ID
			, STUFF((SELECT  ',' + LTRIM(STR(Season)) + '-' + LTRIM(STR(Season1))
				FROM (SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID, Team, Season, Season1 FROM #tmpA
						WHERE Team = 'USC') USC
				WHERE  t2.SSB_CRMSYSTEM_CONTACT_ID = USC.SSB_CRMSYSTEM_CONTACT_ID
				ORDER BY USC.SSB_CRMSYSTEM_CONTACT_ID, USC.Season DESC
				FOR XML PATH('')), 1, 1, '') AS USCSeasonList	
			    , STUFF((SELECT  ',' + SSID
				FROM (SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID, TEAM, SSID FROM #tmpA) SSIDs
				WHERE  t2.SSB_CRMSYSTEM_CONTACT_ID = SSIDs.SSB_CRMSYSTEM_CONTACT_ID
				ORDER BY SSIDs.SSB_CRMSYSTEM_CONTACT_ID, SSIDs.Team DESC
				FOR XML PATH('')), 1, 1, '') AS SSIDList
, MAX(CopyLoadDate) LoadDateTime
, COUNT(DISTINCT Team) Dist_Team
, COUNT(DISTINCT SSID) Dist_SSID
INTO #tmpContact
FROM #tmpA t2
WHERE t2.SSB_CRMSYSTEM_CONTACT_ID IS NOT NULL
GROUP BY SSB_CRMSYSTEM_CONTACT_ID

INSERT INTO dbo.SFDCProcess_Contact_SeasonTicketHolders
        ( SSB_CRMSYSTEM_CONTACT_ID ,
          USC_SeasonTicket_Years ,
          --Sixers_SeasonTicket_Years ,
          SSIDs_List ,
          Distinct_Teams ,
		  Distinct_SSIDs
        )
SELECT SSB_CRMSYSTEM_CONTACT_ID, USCSeasonList, SSIDList, Dist_Team, Dist_SSID FROM #tmpContact

DROP TABLE #TmpA
DROP TABLE #TmpAcct
DROP TABLE #tmpContact




GO
