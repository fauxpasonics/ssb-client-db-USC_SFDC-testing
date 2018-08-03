SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [MERGEProcess].[sp_ReceiveResults_Save]
AS 
BEGIN
--MergeProcess.sp_ReceiveResults 42952, '',''
SELECT * FROM [MERGEProcess].[RecieveResults]
MERGE MERGEProcess.Results TARGET
USING (SELECT a.[PK_QueueID], a.[Master_SFID], a.[Slave_SFID], b.[ErrorCode], b.[ErrorDescription], a.[ObjectType], a.[MergeDetermination] FROM MergeProcess.Queue a 
			INNER JOIN MergeProcess.[RecieveResults] b ON [b].[PK_QueueID] = [a].[PK_QueueID]) SOURCE
ON Source.PK_QueueID = Target.PK_QueueID
WHEN MATCHED THEN
UPDATE SET CreateDateTime = GetDate()
, ErrorCode = SOURCE.[ErrorCode]
, ErrorDescription = SOURCE.ErrorDescription
, MergeDetermination = SOURCE.MergeDetermination
WHEN NOT MATCHED THEN
INSERT (Master_SFID
		, Slave_SFID
		, ErrorCode
		, ErrorDescription
		, ObjectType
		, MergeDetermination
		, PK_QueueID
		)
VALUES (SOURCE.Master_SFID --Master_SFID
		, SOURCE.Slave_SFID --Slave_SFID
		, SOURCE.[ErrorCode] --Error
		, SOURCE.ErrorDescription --ErrorDescr
		, SOURCE.ObjectType --ObjectType
		, SOURCE.MergeDetermination
		, SOURCE.PK_QueueID
		);

UPDATE a
SET Completed = 1
FROM MERGEProcess.Queue a
INNER JOIN MergeProcess.[RecieveResults] b ON [b].[PK_QueueID] = [a].[PK_QueueID]

END

GO
