SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [MERGEProcess].[sp_ReceiveReviewColumnResults_Save]

AS 
--EXEC mergeprocess.[sp_ReceiveReviewColumnResults] @ObjectType = 'Account', -- varchar(50)
--    @PK_QueueID = '-1', -- varchar(50)
--    @ColumnName = 'Description', -- varchar(50)
--    @ColumnIdxID = '37', -- varchar(50)
--    @MasterValue = 'nothing', -- varchar(50)
--    @SlaveValue = 'nothing123', -- varchar(50)
--    @Action = 'CopyToMaster', -- varchar(50)
--    @WhenTo = 'Test', -- varchar(50)
--    @Evaluated = 'True', -- varchar(50)
--    @Result = 'NoError' -- varchar(5000)

MERGE INTO [MERGEProcess].[ReviewColumnResults] TARGET
USING (SELECT a.* FROM [MERGEProcess].[RecieveReviewColumnResults] a 
			INNER JOIN (SELECT [PK_QueueID], MIN([CreatedDate]) MinCreatedDate FROM [MERGEProcess].[RecieveReviewColumnResults] GROUP BY [PK_QueueID]) z
					ON [z].[PK_QueueID] = [a].[PK_QueueID] AND a.[CreatedDate] = z.[MinCreatedDate]) SOURCE 
ON TARGET.[PK_QueueID] = SOURCE.[PK_QueueID] AND [TARGET].[ColumnName] = [SOURCE].[ColumnName]
WHEN MATCHED THEN 
UPDATE SET
TARGET.ObjectType = SOURCE.ObjectType
, TARGET.PK_QueueID = SOURCE.[PK_QueueID]
, TARGET.ColumnName = SOURCE.[ColumnName]
, TARGET.ColumnIdxID = SOURCE.[ColumnIdxID]
, TARGET.MasterValue = SOURCE.[MasterValue]
, TARGET.SlaveValue = SOURCE.[SlaveValue]
, TARGET.ACTION = SOURCE.[Action]
, TARGET.WhenTo = SOURCE.[WhenTo]
, TARGET.Evaluated = SOURCE.[Evaluated]
, TARGET.RESULT = SOURCE.[Result]
, TARGET.LastModifiedTime = SOURCE.[LastModifiedTime]
WHEN NOT MATCHED THEN 
INSERT (
ObjectType, PK_QueueID, ColumnName, ColumnIdxID, MasterValue, SlaveValue, Action, WhenTo, Evaluated, Result, CreatedDate, LastModifiedTime
)
VALUES (
SOURCE.ObjectType, SOURCE.PK_QueueID, SOURCE.ColumnName, SOURCE.ColumnIdxID, SOURCE.MasterValue, SOURCE.SlaveValue, SOURCE.Action, SOURCE.WhenTo, SOURCE.Evaluated, SOURCE.Result, SOURCE.CreatedDate, SOURCE.LastModifiedTime
);
GO
