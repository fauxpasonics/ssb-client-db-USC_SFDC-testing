SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [MERGEProcess].[sp_ReceiveResults]
  @PK_QueueID VARCHAR(50)
  , @ErrorCode varchar(8000)
  , @ErrorDescription varchar(8000)
AS 
BEGIN
--MergeProcess.sp_ReceiveResults 42952, '',''

INSERT INTO MergeProcess.[RecieveResults]
        ( [PK_QueueID] ,
          [ErrorCode] ,
          [ErrorDescription] ,
          [DateInserted]
        )
VALUES  ( @PK_QueueID , -- PK_QueueID - int
          @ErrorCode , -- ErrorCode - varchar(8000)
          @ErrorDescription , -- ErrorDescription - varchar(8000)
          GETDATE()  -- DateInserted - datetime
        )

UPDATE a
SET [Completed] = 1
FROM [MERGEProcess].[Queue] a
WHERE [PK_QueueID] = @PK_QueueID

--MERGE MERGEProcess.Results TARGET
--USING MergeProcess.Queue SOURCE
--ON Source.PK_QueueID = Target.PK_QueueID AND Source.PK_QueueID = @PK_QueueID
--WHEN MATCHED THEN
--UPDATE SET CreateDateTime = GetDate()
--, ErrorCode = @ErrorCode
--, ErrorDescription = @ErrorDescription
--, MergeDetermination = SOURCE.MergeDetermination
--WHEN NOT MATCHED AND SOURCE.PK_QueueID = @PK_QueueID THEN
--INSERT (Master_SFID
--		, Slave_SFID
--		, ErrorCode
--		, ErrorDescription
--		, ObjectType
--		, MergeDetermination
--		, PK_QueueID
--		)
--VALUES (SOURCE.Master_SFID --Master_SFID
--		, SOURCE.Slave_SFID --Slave_SFID
--		, @ErrorCode --Error
--		, @ErrorDescription --ErrorDescr
--		, SOURCE.ObjectType --ObjectType
--		, SOURCE.MergeDetermination
--		, @PK_QueueID
--		);

--UPDATE a
--SET Completed = 1
--FROM MERGEProcess.Queue a
--WHERE a.PK_QueueID = @PK_QueueID

END

GO
