SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [MERGEProcess].[sp_Prep_Merging]
AS

--TRUNCATE TABLE MERGEProcess.DuplicatesInSFDC_Temp
--TRUNCATE TABLE MERGEProcess.DuplicatesInSFDC

SELECT DISTINCT b.DW_Contact_ID__c, b.SFID, b.Patron, RANK() OVER (PARTITION BY b.Patron ORDER BY a.CreatedDate ASC, a.LastModifiedDate ASC, b.SFID ASC) PatronRank 
INTO #tmpRanks
--SELECT DISTINCT id, a.Patron_ID__c, b.Patron, b.SFID, a.createddate, a.lastmodifieddate
-- Select *
FROM ProdCopy.Account a
INNER JOIN MERGEProcess.VerticalPatrons_Updated b ON a.id = b.SFID
WHERE 1=1 
--AND a.id = '0015000000w2vwxAAA'
--AND b.Patron = 'A101914'
--AND a.id <> b.SFID
AND b.Patron IN 
(
SELECT Patron FROM MERGEProcess.VerticalPatrons GROUP BY Patron HAVING COUNT(DISTINCT SFID) > 1
)
-- DROP TABLE #tmpRanks
SELECT * FROM [#tmpRanks]
SELECT SFid Id, Patron, PatronRank Master_Flag, DW_Contact_ID__c
INTO #tmpMaster
FROM #tmpRanks
WHERE PatronRank = 1
-- DROP TABLE #tmpMaster

SELECT SFID id, Patron, PatronRank Master_Flag, DW_Contact_ID__c
INTO #tmpSlave
FROM #tmpRanks
WHERE PatronRank > 1
-- DROP TABLE #tmpSlave

SELECT DISTINCT CAST(z.Id AS VARCHAR(18)) Master_SFID
, z.Patron
, a.Id Slave_SFID
INTO #tmpMaster_Output
FROM #tmpMaster z 
, #tmpSlave a --ON a.DW_Contact_ID__c = z.DW_Contact_ID__c
--WHERE z.patron = 'A105768'
--WHERE a.DW_Contact_ID__c = '000C8722-F30F-4AA5-A1A7-27244AEB68CB'
--WHERE z.SFAccountID	IS NOT NULL	
ORDER BY z.Patron
-- DROP TABLE #tmpMaster_Output

--TRUNCATE TABLE MERGEProcess.Queue

INSERT INTO MERGEProcess.Queue ([ObjectType], [Master_SFID], [Slave_SFID], [MergeDetermination])
SELECT DISTINCT 'Account', a.Master_SFID, a.Slave_SFID, 'DuplicateGUID'
--, CAST(NULL AS VARCHAR(50)) ErrorCode, CAST(NULL AS VARCHAR(8000)) AS ErrorDescription
FROM #tmpMaster_Output a
Where a.Master_SFID <> a.Slave_SFID
--AND a.slave_SFID = '0015000000zPModAAG'
-- SELECT * FROM MERGEProcess.Queue

--SELECT a.*, b.DW_Contact_ID__c MstContactID, c.DW_Contact_ID__c SlvContactID, mst.Name MstOwner, slv.Name SlvOwner 
--FROM MERGEProcess.Queue a
--LEFT JOIN ProdCopy.Account b ON a.Master_SFID = b.Id
--LEFT JOIN ProdCopy.[User] mst ON b.OwnerId = mst.id
--LEFT JOIN ProdCopy.Account c ON a.Slave_SFID = c.id
--LEFT JOIN ProdCopy.[User] slv ON c.OwnerId = slv.id
--WHERE b.Ownerid <> c.OwnerId
----AND b.OwnerID NOT IN (SELECT id FROM ProdCopy.[User] WHERE FirstName IN ('Siaolan','ETL','braden','thomas'))
--AND c.OwnerID NOT IN (SELECT id FROM ProdCopy.[User] WHERE FirstName IN ('ETL'))
--ORDER BY RowID

DROP TABLE #tmpMaster
DROP TABLE #tmpSlave
DROP TABLE #tmpMaster_Output

GO
