SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [MERGEProcess].[sp_UpdateSFDC_GUIDs]
as
DECLARE @UID INT, @Key NVARCHAR(MAX), @SFID NVARCHAR(18),  @string NVARCHAR(MAX),  @delimiter CHAR(1) , @Counter int
DECLARE @output TABLE (rowkey NVARCHAR(MAX), SFID NVARCHAR(18), splitdata NVARCHAR(MAX) )
DECLARE @HoldingTbl TABLE (UID INT IDENTITY(1,1), DW_Contact_ID__c nvarchar(MAX), SFID NVARCHAR(18), Patron_ID__c NVARCHAR(MAX), Processed bit)

SET @delimiter = ','

-- Identify all Patrons that are concat (include Comma)
INSERT INTO @HoldingTbl
        ( DW_Contact_ID__c ,
		  sfid ,
          Patron_ID__c ,
          Processed
        )
SELECT DW_ContactID__c, id, Patron_ID__c, 0 Processed
FROM ProdCopy.vw_Account
WHERE 1=1
and CharIndex(',',Patron_ID__c,1) > 0

SET @Counter = 0

WHILE (SELECT COUNT(*) FROM @HoldingTbl WHERE Processed = 0) > 0
BEGIN 

SET @UID = (SELECT TOP 1 UID FROM @HoldingTbl WHERE Processed = 0)
SET @Key = (SELECT DW_Contact_ID__c FROM @HoldingTbl WHERE UID = @UID)
SET @string = (SELECT Patron_ID__c FROM @HoldingTbl WHERE UID = @UID)
SET @SFID = (SELECT SFID FROM @HoldingTbl WHERE UID = @UID)

    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (rowkey, SFID, splitdata)  
        VALUES(@Key, @SFID, SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 

	UPDATE a
	SET Processed = 1
	FROM @HoldingTbl a
	WHERE UID = @UID

	SET @Counter = @Counter + 1
	PRINT @Counter
 
END

TRUNCATE TABLE MERGEProcess.VerticalPatrons 

-- Load all Patrons/GUID into table (change CSV to vertical list)
INSERT INTO MERGEProcess.VerticalPatrons (DW_Contact_ID__c, SFID, Patron, SourceSystem, CleanPatron, Master_Flag)
SELECT rowkey DW_Contact_ID__c, SFID, a.splitdata Patron
, 'TI USC'
, REPLACE(Replace(a.splitdata,'a',''),'e','')
, 0 Master_Flag
FROM @output a
-- SELECT * FROM MERGEProcess.VerticalPatrons

-- Load all Single Patrons completing the vertical list
INSERT INTO MERGEProcess.VerticalPatrons (DW_Contact_ID__c, SFID, Patron, SourceSystem, CleanPatron, Master_Flag)
SELECT DW_ContactID__c, id SFID, Patron_ID__c
, CASE WHEN LEFT(Patron_ID__c,1) ='A' THEN 'TI Texas_Athletics' ELSE 'TI Texas_Erwin' END
, REPLACE(Replace(Patron_ID__c,'a',''),'e','')
, 0 Master_Flag
FROM ProdCopy.vw_Account
WHERE 1=1
and CharIndex(',',Patron_ID__c,1) = 0

-- Identify which GUIDs changed
TRUNCATE TABLE MERGEProcess.SFDC_Account_GUIDUpdate

INSERT INTO MERGEProcess.SFDC_Account_GUIDUpdate
SELECT DISTINCT a.DW_Contact_ID__c Old_DW_Contact_ID__c, z.Id SFAccountID, b.[SSB_CRMSYSTEM_ACCT_ID] New_DW_Contact_ID__c 
--, a.Patron
-- Select *
FROM MERGEProcess.VerticalPatrons a
INNER JOIN USC.dbo.[vwDimCustomer_ModAcctId] b ON b.SSID = CleanPatron AND b.SourceSystem = a.SourceSystem
INNER JOIN ProdCopy.vw_Account z ON a.DW_Contact_ID__c = z.DW_ContactID__c
WHERE a.DW_Contact_ID__c <> b.[SSB_CRMSYSTEM_ACCT_ID]
--WHERE a.Patron IN ('A661312',
--'E50098316')

-- CREATE New Instance of ProdCopy
IF EXISTS(SELECT * FROM sys.tables tbl INNER JOIN sys.schemas s ON s.schema_id = tbl.schema_id WHERE tbl.name = 'ProdCopy_Account' AND s.Name = 'MERGEProcess')
BEGIN
DROP TABLE MERGEProcess.ProdCopy_Account
END

SELECT *, CAST(NULL AS DATE) MERGEProcess_Date
INTO MERGEProcess.ProdCopy_Account
FROM ProdCopy.vw_Account

UPDATE a
SET DW_ContactID__c = b.New_DW_Contact_ID__c
, MERGEProcess_Date = GETDATE()
FROM MERGEProcess.ProdCopy_Account a
INNER JOIN MERGEProcess.SFDC_Account_GUIDUpdate b ON a.DW_ContactID__c = b.Old_DW_Contact_ID__c

--CREATE A VERTICLE WITH UPDATED GUIDs
TRUNCATE TABLE MERGEProcess.VerticalPatrons_Updated

INSERT INTO MERGEProcess.VerticalPatrons_Updated
SELECT DISTINCT ISNULL(b.New_DW_Contact_ID__c, a.DW_Contact_ID__c) DW_Patron_ID__c, a.Patron, GETDATE() LastUpdated, SFID
--SELECT * 
FROM MERGEProcess.VerticalPatrons a
LEFT JOIN MERGEProcess.SFDC_Account_GUIDUpdate b ON a.DW_Contact_ID__c = b.Old_DW_Contact_ID__c

--SELECT * FROM MERGEProcess.SFDC_Account_GUIDUpdate
--WHERE SFAccountID IN (
--SELECT SFAccountID FROM MERGEProcess.SFDC_Account_GUIDUpdate
--GROUP BY SFAccountID
--HAVING COUNT(*) = 1
--)

--SELECT * FROM MergeProcess.SFDC_Account_GUIDUpdate
--WHERE SFAccountID = '0015000000w4epoAAA'

--SELECT * FROM MERGEProcess.VerticalPatrons
--WHERE DW_Contact_ID__c = '130A40C8-2215-4F72-9DC4-9E133CC19721'
GO
