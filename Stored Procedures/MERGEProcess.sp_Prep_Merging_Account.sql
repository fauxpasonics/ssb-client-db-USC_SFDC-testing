SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

CREATE PROCEDURE [MERGEProcess].[sp_Prep_Merging_Account]
AS

--TRUNCATE TABLE MERGEProcess.DuplicatesInSFDC_Temp
--TRUNCATE TABLE MERGEProcess.DuplicatesInSFDC
--DROP TABLE #tmpRanks_Prep

-- *******ProdCopy GUID Detection

-- Find changed GUIDs
SELECT a.SSB_CRMSYSTEM_ACCT_ID__c Old_Acct_ID, id Old_SFID 
INTO #tmpProdCopy_OldAcct
FROM ProdCopy.vw_Account a
LEFT JOIN dbo.Account b ON a.SSB_CRMSYSTEM_ACCT_ID__c = b.SSB_CRMSYSTEM_ACCT_ID
WHERE b.SSB_CRMSYSTEM_ACCT_ID IS NULL	AND a.isDeleted = 0 AND a.SSB_CRMSYSTEM_ACCT_ID__c  IS NOT NULL;
-- DROP TABLE #tmpProdCopy_OldAcct
-- SELECT * FROM #tmpProdCopy_OldAcct WHERE Old_Acct_ID in ('2f7b092c-fcb2-454d-bed7-5ffec70df6ae', 'a3f56cc9-9436-477c-98de-9ee106d681b2')


SELECT a.SSB_CRMSYSTEM_Acct_ID__c Old_Acct_ID, id Old_SFID 
INTO #tmpNotCurr_Acct
FROM ProdCopy.vw_Account a 
LEFT JOIN dbo.SFDCProcess_DistinctContacts b ON a.SSB_CRMSYSTEM_Acct_ID__c = b.[SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.[SSB_CRMSYSTEM_CONTACT_ID] IS NULL AND a.isDeleted = 0 AND a.SSB_CRMSYSTEM_ACCT_ID__c  IS NOT NULL;
--DROP TABLE #tmpNotCurr_Acct
-- SELECT * FROM #tmpNotCurr_Acct WHERE Old_Acct_ID in ('2f7b092c-fcb2-454d-bed7-5ffec70df6ae', 'a3f56cc9-9436-477c-98de-9ee106d681b2')


/* kw - Changed insert table from #TmpNotCurr_acct to #tmpprodcopy_oldAcct */
INSERT INTO #tmpProdCopy_OldAcct 
SELECT * FROM #tmpNotCurr_Acct a
WHERE a.Old_Acct_ID NOT IN (SELECT Old_Acct_ID FROM #tmpProdCopy_OldAcct)
---SELECT * FROM #TmpProdCopy_oldAcct WHERE Old_Acct_ID in ('2f7b092c-fcb2-454d-bed7-5ffec70df6ae', 'a3f56cc9-9436-477c-98de-9ee106d681b2')

-- Get SSIDs for them
SELECT [SSB_CRMSYSTEM_CONTACT_ID] Old_Acct_ID, SSID, sourcesystem, MAX(a.createddate) CreatedDate 
INTO #tmpHistory_SSID
FROM USC.mdm.SSB_ID_History a
WHERE [SSB_CRMSYSTEM_CONTACT_ID] IN (SELECT Old_Acct_ID FROM #tmpProdCopy_OldAcct)
GROUP BY [SSB_CRMSYSTEM_CONTACT_ID], SSID, sourcesystem
-- Drop Table #tmpHistory_SSID
-- select * from #tmpHistory_SSID where old_acct_id = '2f7b092c-fcb2-454d-bed7-5ffec70df6ae'
---SELECT * FROM psp.mdm.ssb_id_history WHERE ssb_crmsystem_contact_id = '2f7b092c-fcb2-454d-bed7-5ffec70df6ae'
---SELECT * FROM psp.mdm.SSB_ID_History WHERE ssid IN ('A376536D-78B1-E011-B0C5-78E7D186BC48')


---Get records that didn't match the history
SELECT a.*
INTO #tmpHistory_notfound
FROM #tmpProdCopy_OldAcct a
LEFT join USC.mdm.SSB_ID_History b
ON a.old_acct_id =  [SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.ssid IS null
-- Drop Table #tmpHistory_notfound
-- select * from #tmpHistory_notfound where old_acct_id = '2f7b092c-fcb2-454d-bed7-5ffec70df6ae'

-- Get SSIDs for them
INSERT INTO #tmpHistory_SSID
SELECT a.ssb_crmsystem_contact_id Old_Acct_ID, SSID, sourcesystem, MAX(a.createddate) CreatedDate 
FROM USC.mdm.SSB_ID_History a
WHERE a.ssb_crmsystem_contact_id IN (SELECT Old_Acct_ID FROM #tmpProdCopy_OldAcct)
GROUP BY a.ssb_crmsystem_contact_id, SSID, sourcesystem

-- Pair up Old and New Acct IDs
SELECT DISTINCT a.Old_Acct_ID
, b.[SSB_CRMSYSTEM_CONTACT_ID] New_Acct_ID
INTO #tmpOldNew
--DROP TABLE #tmpOldNew
FROM #tmpHistory_SSID a
INNER JOIN USC.dbo.vwDimCustomer_ModAcctId b ON a.SSID = b.SSID AND b.SourceSystem = a.sourcesystem
--WHERE ISNULL(a.ssb_crmsystem_acct_id,a.ssb_crmsystem_contact_id) <> b.SSB_CRMSYSTEM_ACCT_ID
-- DROP TABLE #tmpOldNew
--- select * from #tmpOldNew WHERE Old_Acct_ID in ('2f7b092c-fcb2-454d-bed7-5ffec70df6ae', 'a3f56cc9-9436-477c-98de-9ee106d681b2')

/*  kw - removing
-- Identify any business accounts
SELECT SSB_CRMSYSTEM_ACCT_ID
INTO #tmpBusAccts
FROM dbo.Account
WHERE IsBusinessAccount = 1

DELETE a 
FROM #tmpOldNew a 
LEFT JOIN #tmpBusAccts b ON a.Old_Acct_ID = b.SSB_CRMSYSTEM_ACCT_ID
LEFT JOIN #tmpBusAccts c ON a.New_Acct_ID = c.SSB_CRMSYSTEM_ACCT_ID
WHERE b.SSB_CRMSYSTEM_ACCT_ID IS NOT NULL OR c.SSB_CRMSYSTEM_ACCT_ID IS NOT NULL

*/

-- Load Into Table Prep for Queue
SELECT a.Old_SFID, c.Id New_SFID
INTO #tmpGUIDDetection_Queue
FROM #tmpProdCopy_OldAcct a 
INNER JOIN #tmpOldNew b ON b.Old_Acct_ID = a.Old_Acct_ID
LEFT JOIN ProdCopy.vw_Account c ON b.New_Acct_ID = c.SSB_CRMSYSTEM_Acct_ID__c
WHERE c.Id IS NOT NULL
AND a.Old_SFID <> c.Id
--DROP TABLE #tmpGUIDDetection_Queue

--INSERT INTO MERGEProcess.Queue (ObjectType, Master_SFID, Slave_SFID, MergeDetermination)
--SELECT DISTINCT 'Account' ObjectType, a.New_SFID Master_SFID, a.Old_SFID Slave_SFID, 'ChangedGUID' MergeDetermination
----INTO MERGEProcess.Queue
--FROM #tmpGUIDDetection_Queue a
--LEFT JOIN MERGEProcess.Queue b ON a.New_SFID = b.Master_SFID AND a.Old_SFID = b.Slave_SFID
--WHERE b.PK_QueueID IS null
--AND a.Master_SFID = '0035000002DGioQAAT'

-- Duplicate GUID Detection
SELECT SSB_CRMSYSTEM_Acct_ID__c, COUNT(*) Count
INTO #tmpDupes
FROM ProdCopy.vw_Account
WHERE SSB_CRMSYSTEM_ACCT_ID__c IS NOT NULL AND isdeleted = 0 
GROUP BY SSB_CRMSYSTEM_ACCT_ID__c
HAVING Count(*) > 1
---drop table #tmpDupes

SELECT pvt.SSB_CRMSYSTEM_Acct_ID__c, MAX(ISNULL([1],'')) Master_SFID, MAX(ISNULL([2],'')) Slave_SFID
INTO #tmpDupSFIDs
FROM (
SELECT a.SSB_CRMSYSTEM_Acct_ID__c, id, a.CreatedDate, a.LastModifiedDate, CASE WHEN c.salesforce_ID IS NOT NULL THEN 1 ELSE 0 END Id_Found_dboContact
, RANK() OVER (PARTITION BY a.SSB_CRMSYSTEM_Acct_ID__c ORDER BY CASE WHEN c.salesforce_ID IS NOT NULL THEN 1 ELSE 0 END DESC, CreatedDate ASC, a.LastModifiedDate Desc) RankOrder
FROM ProdCopy.vw_Account a
LEFT JOIN (SELECT DISTINCT salesforce_Id FROM dbo.Account) c ON a.id = c.salesforce_ID
WHERE a.SSB_CRMSYSTEM_ACCT_ID__c IN (SELECT SSB_CRMSYSTEM_ACCT_ID__c FROM #tmpDupes)
) z
PIVOT (MAX(ID) FOR RankOrder IN ([1],[2])) PVT
GROUP BY pvt.SSB_CRMSYSTEM_Acct_ID__c
--DROP TABLE #tmpDupSFIDs


-- MERGE INTO QUEUE ChangedGUID
MERGE MERGEProcess.Queue TARGET
USING (SELECT DISTINCT 'Account' ObjectType, New_SFID Master_SFID, Old_SFID Slave_SFID, 'ChangedGUID' MergeDetermination 
		FROM #tmpGUIDDetection_Queue z
		WHERE z.Old_SFID <> z.New_SFID
		) Source
ON Source.Master_SFID = TARGET.Master_SFID AND Source.Slave_SFID = TARGET.Slave_SFID AND isnull(target.Completed, 0) = 0
--WHEN MATCHED THEN
WHEN NOT MATCHED THEN
INSERT ( ObjectType, Master_SFID, Slave_SFID, MergeDetermination )
VALUES (SOURCE.ObjectType
		, SOURCE.Master_SFID
		, SOURCE.Slave_SFID
		, Source.MergeDetermination
		);

-- MERGE INTO QUEUE DuplicateGUID
MERGE MERGEProcess.Queue TARGET
USING (SELECT DISTINCT 'Account' ObjectType, Master_SFID, Slave_SFID, 'DuplicateGUID' MergeDetermination 
		FROM #tmpDupSFIDs z
		WHERE z.Master_SFID <> z.Slave_SFID
		) Source
ON Source.Master_SFID = TARGET.Master_SFID AND Source.Slave_SFID = TARGET.Slave_SFID AND isnull(completed, 0) = 0
--WHEN MATCHED THEN
WHEN NOT MATCHED THEN
INSERT ( ObjectType, Master_SFID, Slave_SFID, MergeDetermination )
VALUES (SOURCE.ObjectType
		, SOURCE.Master_SFID
		, SOURCE.Slave_SFID
		, Source.MergeDetermination
		);


--******OWNERSHIP CHANGE ARCHIVE
SELECT a.ObjectType, a.Master_SFID, a.Slave_SFID, a.PK_QueueID
, b.SSB_CRMSYSTEM_ACCT_ID__c MstAcctID, c.SSB_CRMSYSTEM_ACCT_ID__c SlvAcctID
, mst.Name MstOwner
, mst.Id MstOwnerId
, slv.Name SlvOwner
, slv.Id SlvOwnerId
, '' Master_Brand, '' Slave_Brand
, CASE WHEN LEN(ISNULL(msth.USC_SeasonTicket_Years,'')) > 0 THEN 1 ELSE 0 END Master_STH
, CASE WHEN LEN(ISNULL(ssth.USC_SeasonTicket_Years,'')) > 0 THEN 1 ELSE 0 END Slave_STH
, CASE WHEN b.OwnerId = c.ownerid then 'None'
		WHEN b.OwnerID IN (SELECT id FROM MERGEProcess.vw_GetDefaultOwners) THEN 'Automated' 
		WHEN c.OwnerID IN (SELECT id FROM MERGEProcess.vw_GetDefaultOwners) THEN 'None' 
		ELSE 'Manual' END Ownership_Type
, a.MergeDetermination
--INTO MERGEProcess.Contact_Ownership
INTO #tmpOwnerChg
--SELECT * 
FROM MERGEProcess.Queue a
LEFT JOIN ProdCopy.vw_Account b ON a.Master_SFID = b.Id
LEFT JOIN ProdCopy.[User] mst ON b.OwnerId = mst.id AND mst.IsActive = 1
LEFT JOIN dbo.[SFDCProcess_DistinctContacts] msth ON b.SSB_CRMSYSTEM_ACCT_ID__c = msth.[SSB_CRMSYSTEM_CONTACT_ID] AND (msth.USC_STH = 1)
LEFT JOIN ProdCopy.vw_Account c ON a.Slave_SFID = c.id
LEFT JOIN ProdCopy.[User] slv ON c.OwnerId = slv.id AND slv.IsActive = 1
LEFT JOIN dbo.[SFDCProcess_DistinctContacts] ssth ON c.SSB_CRMSYSTEM_ACCT_ID__c = ssth.[SSB_CRMSYSTEM_CONTACT_ID] AND (msth.USC_STH = 1)
WHERE a.ObjectType = 'Account'
--SELECT * FROM MERGEProcess.Queue a WHERE 1=1 and a.MergeDetermination = 'Do_NOT_MERGE'
AND ISNULL(a.Completed,0) = 0 
AND b.id <> c.id
---drop table #tmpOwnerChg


MERGE MERGEProcess.Account_MergeDetail AS TARGET
USING #tmpOwnerChg AS SOURCE
ON source.Master_SFID = target.Master_SFID
AND source.Slave_SFID = target.Slave_SFID
WHEN MATCHED THEN
UPDATE SET 
TARGET.ObjectType = SOURCE.ObjectType
, TARGET.Master_SFID = SOURCE.Master_SFID
, TARGET.Slave_SFID = SOURCE.Slave_SFID
, TARGET.PK_QueueID = SOURCE.PK_QueueID
, TARGET.MstAccountID = SOURCE.MstAcctID
, TARGET.SlvAccountID = SOURCE.SlvAcctID
, TARGET.MstOwner = SOURCE.MstOwner
, TARGET.SlvOwner = Source.SlvOwner
, TARGET.Master_Brand = SOURCE.Master_Brand
, TARGET.Slave_Brand = SOURCE.Slave_Brand
, TARGET.Master_STH = SOURCE.Master_STH
, TARGET.Slave_STH = SOURCE.Slave_STH
, TARGET.OwnershipType = SOURCE.Ownership_Type
, TARGET.MergeDetermination = SOURCE.MergeDetermination
, TARGET.LastUpdatedDate = GETDATE() --LastUpdatedDate
WHEN NOT MATCHED THEN
INSERT
        ( ObjectType
        , Master_SFID
        , Slave_SFID
        , PK_QueueID
        , MstAccountID
        , SlvAccountID
        , MstOwner
        , SlvOwner
        , Master_Brand
        , Slave_Brand
        , Master_STH
        , Slave_STH
        , OwnershipType
		, MergeDetermination
		, CreatedDate
		, LastUpdatedDate
        )
VALUES ( SOURCE.ObjectType
        , SOURCE.Master_SFID
        , SOURCE.Slave_SFID
        , SOURCE.PK_QueueID
        , SOURCE.MstAcctID
        , SOURCE.SlvAcctID
        , SOURCE.MstOwner
        , SOURCE.SlvOwner
        , SOURCE.Master_Brand
        , SOURCE.Slave_Brand
        , SOURCE.Master_STH
        , SOURCE.Slave_STH
        , SOURCE.Ownership_Type
		, SOURCE.MergeDetermination
		, GETDATE() --CreatedDate
		, GETDATE() --LastUpdatedDate
);

-- BS Asked to Exclude Business Accounts - 7/27/2015
-- Abbey asked to start including Business Accounts - 8/7/2015
--UPDATE z
--SET [MergeDetermination] = 'DO_NOT_MERGE'
--FROM [MERGEProcess].[Queue] z
--WHERE [Slave_SFID] IN 
--(
--SELECT Id FROM ProdCopy.Account 
--WHERE [SSB_CRMSYSTEM_ACCT_ID__c] IN (
--SELECT DISTINCT [SSB_CRMSYSTEM_ACCT_ID] 
--FROM USC.dbo.[vwDimCustomer_ModAcctId]
--WHERE [SSB_CRMSYSTEM_IsBusinessAccount] = 1
--)
--)


-- STH in QUEUE
--DELETE 
----SELECT * 
--FROM MERGEProcess.Queue
--WHERE RowID IN (
--SELECT RowID FROM MERGEProcess.Account_Ownership a
--WHERE a.Master_STH = 1 OR a.Slave_STH = 1
--)
--AND MergeDetermination <> 'DuplicateGUID'

--SELECT a.*, b.Id OwnerId FROM MERGEProcess.Contact_Ownership a 
--INNER JOIN ProdCopy.[User] b ON a.slvowner = b.Name

--SELECT * FROM mergeprocess.[vw_GetRecordsFromQueue]

GO
