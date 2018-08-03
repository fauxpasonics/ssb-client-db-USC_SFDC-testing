SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [dbo].[sp_SFDCProcess_DistinctAccounts_Contacts]
AS
/*
 SELECT COUNT(*) from [dbo].[SFDCProcess_DistinctAccounts]
266797
 SELECT COUNT(*) FROM [dbo].[vwSFDCProcess_DistinctAccounts_CriteriaMet]
267868
*/
-- Create Main Transaction Records Table
SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
 , b.SourceSystem AS Brand
, MAX(a.MaxTransDate) MaxTransDate
--SELECT a.SSID, a.MaxTransDate, a.Team
INTO #tmpTrans
FROM [stg].[SFDC_RecentSeasons_Patrons] a 
INNER JOIN USC.dbo.vwDimCustomer_ModAcctId b ON b.SSID = a.PatronID AND 'TI '+ Team =b.SourceSystem
WHERE b.SSB_CRMSYSTEM_ACCT_ID IS NOT NULL
AND b.SourceSystem NOT LIKE 'Lead%'
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID,b.sourcesystem
-- DROP TABLE #tmpTrans
--SELECT * FROM [#tmpTrans] WHERE [SSB_CRMSYSTEM_CONTACT_ID] = '80154E4F-4983-4BE5-AE30-5E67E4C3E95F'

-- Bring in StdLeads Records
INSERT INTO #tmpTrans
        ( SSB_CRMSYSTEM_ACCT_ID ,
          SSB_CRMSYSTEM_CONTACT_ID ,
          Brand ,
		  MaxTransDate
        )
Select Distinct b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, b.[SourceSystem], --d.[MaxTransDate] 
'1/1/1900' MaxTransDate
FROM dbo.vwDimCustomer_ModAcctId b 
WHERE b.SourceSystem LIKE '%AdobeForm%' 
AND b.SSB_CRMSYSTEM_ACCT_ID IS NOT null
UNION ALL
Select Distinct b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, b.[SourceSystem], MAX(c.TransDate) MaxTransDate
FROM dbo.vwDimCustomer_ModAcctId b 
JOIN USC.dbo.ADV_ContactTransHeader c (NOLOCK) ON b.SourceSystem = 'USC_Advantage' AND b.SSID = c.ContactID 
WHERE c.TransYear > '2014'
AND b.SSB_CRMSYSTEM_ACCT_ID IS NOT null
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID,b.sourcesystem


CREATE INDEX idx_tmpTrans_AccountID ON #tmpTrans ( SSB_CRMSYSTEM_ACCT_ID )
CREATE INDEX idx_tmpTrans_ContactID ON #tmpTrans ( SSB_CRMSYSTEM_CONTACT_ID )

-- Create Activities/Notes Table
/*SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, CASE WHEN Type LIKE '%Athletics%' THEN 'Athletics' ELSE 'Erwin' END Brand, COUNT(*) RecordCount
INTO #tmpActivity
-- SELECT * 
FROM Texas.dbo.vwDimCustomer_ModAcctId b
INNER JOIN dbo.OtherSSIDsToBeLoaded c ON b.SSID = c.SSID
WHERE b.SourceSystem NOT LIKE 'Lead%'
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, CASE WHEN Type LIKE '%Athletics%' THEN 'Athletics' ELSE 'Erwin' END*/
-- Drop Table #tmpActivity


-- Create STH Table
SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
, a.Team Brand
, COUNT(*) Count 
INTO #tmpSTHs
FROM stg.SeasonTicketHolders a
INNER JOIN USC.dbo.vwDimCustomer_ModAcctId b ON b.SSID = a.Customer AND 'TI '+ Team =b.SourceSystem
WHERE b.SSB_CRMSYSTEM_ACCT_ID IS NOT null
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, a.Team
-- DROP TABLE #tmpSTHs

-- Any Records loaded and active in MDM from CRM
SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
, COUNT(*) Count 
INTO #USCSourced
--SELECT DISTINCT [b].[SourceSystem]
FROM USC.dbo.vwDimCustomer_ModAcctId b 
WHERE b.SourceSystem LIKE 'USC SFDC%'
AND b.SSB_CRMSYSTEM_ACCT_ID IS NOT null
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
 --DROP TABLE #USCSourced
 --SELECT * FROM #PSPSourced

/*SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
, COUNT(*) Count 
INTO #Texas_SFDC_SandboxSourced
FROM Texas.dbo.vwDimCustomer_ModAcctId b 
WHERE b.SourceSystem LIKE '%Texas_Athletics%'
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
UNION ALL
SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
, COUNT(*) Count 
FROM Texas.dbo.vwDimCustomer_ModAcctId b 
WHERE b.SourceSystem LIKE '%Texas_Erwin%'
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
 --DROP TABLE #Texas_SFDC_SandboxSourced*/

-- CREATE Branding Table ** ACCOUNT LEVEL w/ Transaction Level
TRUNCATE TABLE stg.Distinct_Accounts

INSERT INTO stg.Distinct_Accounts
SELECT pvt.SSB_CRMSYSTEM_ACCT_ID
, COALESCE([TI USC],[USC_AdobeForm],[USC_Advantage]) USC
, NULL USC_CRMRecord
, NULL USC_CRMActivity
, NULL USC_STH
, NULL SFDC_Submitted
FROM (SELECT SSB_CRMSYSTEM_ACCT_ID, Brand, MAX(MaxTransDate) MaxTransDate 
		FROM #tmpTrans 
		GROUP BY SSB_CRMSYSTEM_ACCT_ID, Brand
		) z
PIVOT (MAX(MaxTransDate) FOR Brand IN ([TI USC],[USC_AdobeForm],[USC_Advantage])) pvt
-- DROP TABLE #tmpBrand

-- Activity Account Level
/*SELECT pvt.*
INTO #tmpActivity_PVT
FROM (SELECT SSB_CRMSYSTEM_ACCT_ID, Brand, COUNT(*) RecordCount FROM #tmpActivity GROUP BY SSB_CRMSYSTEM_ACCT_ID, Brand) z
PIVOT (Sum(RecordCount) FOR Brand IN ([Texas_Athletics],[Texas_Erwin])) pvt*/
-- DROP TABLE #tmpActivity

-- STH Account Level
SELECT pvt.*
INTO #tmpSTH_PVT
FROM (SELECT SSB_CRMSYSTEM_ACCT_ID, Brand, COUNT(*) Count 
		FROM #tmpSTHs 
		GROUP BY SSB_CRMSYSTEM_ACCT_ID, Brand
		) z
PIVOT (Sum(Count) FOR Brand IN ([USC])) pvt
-- DROP TABLE #tmpSTH_PVT

-- INSERT MISSING RECORDS FROM Notes/Activities- Account Level
/*INSERT INTO stg.Distinct_Accounts (SSB_CRMSYSTEM_ACCT_ID, Athletics_CRMActivity, Erwin_CRMActivity) 
SELECT SSB_CRMSYSTEM_ACCT_ID, ISNULL(Athletics,0) Athletics, ISNULL(Erwin,0) Erwin FROM #tmpActivity_PVT
WHERE SSB_CRMSYSTEM_ACCT_ID NOT IN (SELECT SSB_CRMSYSTEM_ACCT_ID FROM stg.Distinct_Accounts)*/

-- INSERT MISSING RECORDS from STHs - Account Level
INSERT INTO stg.Distinct_Accounts (SSB_CRMSYSTEM_ACCT_ID,  USC_CRMActivity) 
SELECT SSB_CRMSYSTEM_ACCT_ID, ISNULL( USC,0) USC FROM #tmpSTH_PVT
WHERE SSB_CRMSYSTEM_ACCT_ID NOT IN (SELECT SSB_CRMSYSTEM_ACCT_ID FROM stg.Distinct_Accounts)

-- SFDC Submitted
INSERT INTO stg.Distinct_Accounts (SSB_CRMSYSTEM_ACCT_ID, [USC_CRMRecord], [USC_CRMActivity]) 
SELECT DISTINCT SSB_CRMSYSTEM_ACCT_ID, 0 CRMRecord, 0 CRMActivity FROM #USCSourced
WHERE SSB_CRMSYSTEM_ACCT_ID NOT IN (SELECT SSB_CRMSYSTEM_ACCT_ID FROM stg.Distinct_Accounts)
-- DROP TABLE #tmpActivity

/*-- INSERT MISSING RECORDS from Texas_SFDC_Sandbox SFDC Submitted Records
INSERT INTO stg.Distinct_Accounts (SSB_CRMSYSTEM_ACCT_ID,  Athletics_CRMActivity, Erwin_CRMActivity) 
SELECT DISTINCT SSB_CRMSYSTEM_ACCT_ID, 0 Athletics, 0 Erwin FROM #Texas_SFDC_SandboxSourced t
WHERE NOT EXISTS (SELECT 1 FROM stg.Distinct_Accounts da where da.SSB_CRMSYSTEM_ACCT_ID = t.SSB_CRMSYSTEM_ACCT_ID)

-- Update CRM Notes/Activity
UPDATE a
SET Athletics_CRMActivity = ISNULL(b.Athletics,0)
, Erwin_CRMActivity = ISNULL(b.Erwin,0)
-- SELECT *
FROM stg.Distinct_Accounts a 
INNER JOIN #tmpActivity_PVT b ON a.SSB_CRMSYSTEM_ACCT_ID = b.SSB_CRMSYSTEM_ACCT_ID*/


-- Update STHs
UPDATE a
SET USC_STH = ISNULL(b.USC,0)
--SELECT *
FROM stg.Distinct_Accounts a 
INNER JOIN #tmpSTH_PVT b ON a.SSB_CRMSYSTEM_ACCT_ID = b.SSB_CRMSYSTEM_ACCT_ID

-- Update SFDC Submitted
UPDATE a
SET SFDC_Submitted = 1
-- SELECT * 
FROM stg.Distinct_Accounts a 
INNER JOIN (SELECT DISTINCT SSB_CRMSYSTEM_ACCT_ID FROM [#USCSourced]) b ON b.SSB_CRMSYSTEM_ACCT_ID = a.SSB_CRMSYSTEM_ACCT_ID


SELECT a.SSB_CRMSYSTEM_ACCT_ID
, CASE WHEN a.USC_STH = 1 THEN 1
		WHEN a.USC IS NOT NULL THEN 1 
		WHEN USC_CRMActivity > 0 THEN 1 
		WHEN USC_CRMRecord > 0 THEN 1 
		ELSE 0 END USC_Flag
, a.USC USC_MaxTransDate
, a.USC_CRMActivity
, a.USC_CRMRecord
, a.USC_STH
, c.USC_SeasonTicket_Years
, a.SFDC_Submitted
 INTO #tmp_Results_Acct
-- Select *
FROM stg.Distinct_Accounts a 
LEFT JOIN dbo.SFDCProcess_Acct_SeasonTicketHolders c ON c.SSB_CRMSYSTEM_ACCT_ID = a.SSB_CRMSYSTEM_ACCT_ID
--WHERE a.SSB_CRMSYSTEM_ACCT_ID = 'BDDD0BE1-37C1-4ABD-B85A-002D24E64171'
-- DROP TABLE #tmp_Results_Acct
-- SELECT * FROM #tmp_Results_Acct WHERE SFDC_Submitted = 1

-- ***********************************************************
-- CREATE Branding Table ** CONTACT LEVEL w/ Transaction Level
TRUNCATE TABLE stg.Distinct_Contacts

INSERT INTO stg.Distinct_Contacts
SELECT  pvt.SSB_CRMSYSTEM_CONTACT_ID, COALESCE([TI USC],[USC_AdobeForm], [USC_Advantage]) USC,NULL USC_CRMRecord, NULL USC_CRMActivity, NULL USC_STH, NULL SFDC_Submitted
FROM (SELECT SSB_CRMSYSTEM_CONTACT_ID, Brand, MAX(MaxTransDate) MaxTransDate FROM #tmpTrans GROUP BY SSB_CRMSYSTEM_CONTACT_ID, Brand) z
PIVOT (MAX(MaxTransDate) FOR Brand IN ([TI USC],[USC_AdobeForm], [USC_Advantage])) pvt
-- DROP TABLE #tmpBrand

-- Activity Contact Level
/*SELECT pvt.*
INTO #tmpActivity_PVT_C
FROM (SELECT SSB_CRMSYSTEM_CONTACT_ID, Brand, COUNT(*) RecordCount FROM #tmpActivity GROUP BY SSB_CRMSYSTEM_CONTACT_ID, Brand) z
PIVOT (Sum(RecordCount) FOR Brand IN ([Erwin],[Athletics])) pvt*/
-- DROP TABLE #tmpActivity

-- STH Contact Level
SELECT pvt.*
INTO #tmpSTH_PVT_C
FROM (SELECT SSB_CRMSYSTEM_CONTACT_ID, Brand, COUNT(*) Count FROM #tmpSTHs GROUP BY SSB_CRMSYSTEM_CONTACT_ID, Brand) z
PIVOT (Sum(Count) FOR Brand IN (USC)) pvt
-- DROP TABLE #tmpActivity

-- INSERT MISSING RECORDS FROM Notes/Activities- Contact Level
/*INSERT INTO stg.Distinct_Contacts (SSB_CRMSYSTEM_CONTACT_ID, Erwin_CRMActivity,Athletics_CRMActivity) 
SELECT SSB_CRMSYSTEM_CONTACT_ID, ISNULL(Erwin,0) Erwin, ISNULL(Athletics,0)Athletics FROM #tmpActivity_PVT_C
WHERE SSB_CRMSYSTEM_CONTACT_ID NOT IN (SELECT SSB_CRMSYSTEM_CONTACT_ID FROM stg.Distinct_Contacts)*/

-- INSERT MISSING RECORDS from STHs - Contact Level
INSERT INTO stg.Distinct_Contacts (SSB_CRMSYSTEM_CONTACT_ID, USC_CRMActivity) 
SELECT SSB_CRMSYSTEM_CONTACT_ID, ISNULL(USC,0) USC FROM #tmpSTH_PVT_C
WHERE SSB_CRMSYSTEM_CONTACT_ID NOT IN (SELECT SSB_CRMSYSTEM_CONTACT_ID FROM stg.Distinct_Contacts)

-- INSERT MISSING RECORDS from Texas_SFDC_Sandbox SFDC Submitted Records
INSERT INTO stg.Distinct_Contacts (SSB_CRMSYSTEM_CONTACT_ID, [USC_CRMRecord], [USC_CRMActivity]) 
SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID, 0 CRMRecord, 0 CRMActivity FROM [#USCSourced]
WHERE SSB_CRMSYSTEM_CONTACT_ID NOT IN (SELECT SSB_CRMSYSTEM_CONTACT_ID FROM stg.Distinct_Contacts)

/*
-- Update CRM Notes/Activity
UPDATE a
SET Athletics_CRMActivity = ISNULL(b.Athletics,0)
, Erwin_CRMActivity = ISNULL(b.Erwin,0)
FROM stg.Distinct_Contacts a 
INNER JOIN #tmpActivity_PVT_C b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID*/

-- Update STHs
UPDATE a
SET USC_STH = ISNULL(b.USC,0)
FROM stg.Distinct_Contacts a 
INNER JOIN #tmpSTH_PVT_C b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID

-- Update SFDC Submitted
UPDATE a
SET SFDC_Submitted = 1
-- SELECT * 
FROM stg.Distinct_Contacts a 
INNER JOIN (SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID FROM [#USCSourced]) b ON b.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID

/*
SELECT pvt.*
INTO #tmpCRMRecords_PVT_C
FROM (SELECT SSB_CRMSYSTEM_CONTACT_ID, Brand, COUNT(*) Count FROM #tmpCRMRecords GROUP BY SSB_CRMSYSTEM_CONTACT_ID, Brand) z
PIVOT (Sum(Count) FOR Brand IN ([Erwin],[Athletics])) pvt

-- Update CRMRecords - Account Level
UPDATE a
SET Athletics_CRMRecord = ISNULL(b.Athletics,0)
, Erwin_CRMRecord = ISNULL(b.Erwin,0)
FROM stg.Distinct_Contacts a
INNER JOIN #tmpCRMRecords_PVT_C b ON a.SSB_CRMSYSTEM_CONTACT_ID = b.SSB_CRMSYSTEM_CONTACT_ID */

SELECT a.SSB_CRMSYSTEM_CONTACT_ID
, CASE WHEN a.USC IS NOT NULL AND a.USC >= ISNULL(a.USC,'1/1/1900') THEN 1 
		WHEN USC_CRMActivity > 0 THEN 1 
		WHEN USC_CRMRecord > 0 THEN 1 
		ELSE 0 END USC_Flag
, a.USC USC_MaxTransDate
, a.USC_CRMActivity
, a.USC_CRMRecord
, a.USC_STH
, c.USC_SeasonTicket_Years
, a.SFDC_Submitted
INTO #tmp_Results_Contact
FROM stg.Distinct_Contacts a 
LEFT JOIN dbo.SFDCProcess_Contact_SeasonTicketHolders c ON c.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID
-- WHERE SSB_CRMSYSTEM_ACCT_ID = '6052863A-C6F3-4A84-8237-4644C29BB1B5'-- WHERE SSB_CRMSYSTEM_ACCT_ID = '6052863A-C6F3-4A84-8237-4644C29BB1B5'
-- DROP TABLE #tmp_Results_Contact
-- SELECT * FROM #tmp_Results_Contact

TRUNCATE TABLE dbo.SFDCProcess_DistinctAccounts

INSERT INTO dbo.SFDCProcess_DistinctAccounts (SSB_CRMSYSTEM_ACCT_ID, USC_Flag, USC_MaxTransDate,
USC_CRMActivity,USC_CRMRecord,USC_STH, USC_SeasonTicket_Years,
 Brand,SFDCLoadCriteriaMet,SFDC_Submitted)
SELECT SSB_CRMSYSTEM_ACCT_ID, USC_Flag, USC_MaxTransDate,
USC_CRMActivity,USC_CRMRecord,USC_STH, USC_SeasonTicket_Years,
 'USC' AS Brand,NULL,SFDC_Submitted
FROM #tmp_Results_Acct

TRUNCATE TABLE dbo.SFDCProcess_DistinctContacts

INSERT INTO dbo.SFDCProcess_DistinctContacts (SSB_CRMSYSTEM_CONTACT_ID, USC_Flag, USC_MaxTransDate,
USC_CRMActivity,USC_CRMRecord,USC_STH, USC_SeasonTicket_Years,Brand,SFDCLoadCriteriaMet,SFDC_Submitted)
SELECT SSB_CRMSYSTEM_CONTACT_ID, USC_Flag, USC_MaxTransDate,
USC_CRMActivity,USC_CRMRecord,USC_STH, USC_SeasonTicket_Years,
 'USC' AS Brand,NULL,SFDC_Submitted
FROM #tmp_Results_Contact

UPDATE a 
SET [SFDCLoadCriteriaMet] = 1
FROM dbo.SFDCProcess_DistinctAccounts a
WHERE ( USC_MaxTransDate IS NOT NULL)
OR ISNULL(USC_STH,0) > 0
OR ISNULL([a].[SFDC_Submitted],0) = 1

UPDATE a 
SET [SFDCLoadCriteriaMet] = 1
FROM dbo.SFDCProcess_DistinctContacts a
WHERE (USC_MaxTransDate IS NOT NULL)
OR ISNULL(USC_STH,0) > 0
OR ISNULL([a].[SFDC_Submitted],0) = 1

--DROP TABLE #tmpActivity_PVT
DROP TABLE #tmpSTH_PVT
--DROP TABLE #tmpCRMRecords_PVT

--DROP TABLE #tmpActivity_PVT_C
DROP TABLE #tmpSTH_PVT_C
--DROP TABLE #tmpCRMRecords_PVT_C

DROP TABLE #tmpTrans
--DROP TABLE #tmpActivity
DROP TABLE #tmpSTHs
--DROP TABLE #Texas_SFDC_SandboxSourced
--DROP TABLE #tmpCRMRecords

--DROP TABLE #tmpBrand_Acct
--DROP TABLE #tmpBrand_Contact
DROP TABLE #tmp_Results_Acct
DROP TABLE #tmp_Results_Contact


--SELECT * FROM [dbo].[SFDCProcess_DistinctAccounts]
--WHERE [SFDC_Submitted] = 1

--SELECT * FROM [dbo].[SFDCProcess_DistinctContacts]
--WHERE [SFDC_Submitted] = 1



GO
