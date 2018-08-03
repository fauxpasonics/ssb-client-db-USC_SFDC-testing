SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [MERGEProcess].[sp_ReceiveReviewColumnResults]
@ObjectType VARCHAR(50)
,@PK_QueueID VARCHAR(50)
,@ColumnName VARCHAR(50)
,@ColumnIdxID VARCHAR(50)
,@MasterValue VARCHAR(50)
,@SlaveValue VARCHAR(50)
,@Action VARCHAR(50)
,@WhenTo VARCHAR(50)
,@Evaluated VARCHAR(50)
,@Result VARCHAR(5000)

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


--DECLARE @Results TABLE 
--(
--ObjectType VARCHAR(50)
--,PK_QueueID VARCHAR(50)
--,ColumnName VARCHAR(50)
--,ColumnIdxID VARCHAR(50)
--,MasterValue VARCHAR(50)
--,SlaveValue VARCHAR(50)
--,Action VARCHAR(50)
--,WhenTo VARCHAR(50)
--,Evaluated VARCHAR(50)
--,Result VARCHAR(5000)
--,CreatedDate DATETIME DEFAULT GETDATE()
--,LastModifiedTime DATETIME DEFAULT GETDATE()
--)

INSERT INTO MergeProcess.[RecieveReviewColumnResults]
        ( [ObjectType] ,
          [PK_QueueID] ,
          [ColumnName] ,
          [ColumnIdxID] ,
          [MasterValue] ,
          [SlaveValue] ,
          [Action] ,
          [WhenTo] ,
          [Evaluated] ,
          [Result] ,
          [CreatedDate] ,
          [LastModifiedTime]
        )
VALUES  ( @ObjectType 
          ,@PK_QueueID 
          ,@ColumnName 
          ,@ColumnIdxID
          ,@MasterValue
          ,@SlaveValue 
          ,@Action 
          ,@WhenTo 
          ,@Evaluated 
          ,@Result 
          ,GETDATE() 
          ,GETDATE() 
        )

--MERGE INTO [MERGEProcess].[ReviewColumnResults] TARGET
--USING @Results SOURCE 
--ON TARGET.[PK_QueueID] = SOURCE.[PK_QueueID] AND [TARGET].[ColumnName] = [SOURCE].[ColumnName]
--WHEN MATCHED THEN 
--UPDATE SET
--TARGET.ObjectType = SOURCE.ObjectType
--, TARGET.PK_QueueID = SOURCE.[PK_QueueID]
--, TARGET.ColumnName = SOURCE.[ColumnName]
--, TARGET.ColumnIdxID = SOURCE.[ColumnIdxID]
--, TARGET.MasterValue = SOURCE.[MasterValue]
--, TARGET.SlaveValue = SOURCE.[SlaveValue]
--, TARGET.ACTION = SOURCE.[Action]
--, TARGET.WhenTo = SOURCE.[WhenTo]
--, TARGET.Evaluated = SOURCE.[Evaluated]
--, TARGET.RESULT = SOURCE.[Result]
--, TARGET.LastModifiedTime = SOURCE.[LastModifiedTime]
--WHEN NOT MATCHED THEN 
--INSERT (
--ObjectType, PK_QueueID, ColumnName, ColumnIdxID, MasterValue, SlaveValue, Action, WhenTo, Evaluated, Result, CreatedDate, LastModifiedTime
--)
--VALUES (
--SOURCE.ObjectType, SOURCE.PK_QueueID, SOURCE.ColumnName, SOURCE.ColumnIdxID, SOURCE.MasterValue, SOURCE.SlaveValue, SOURCE.Action, SOURCE.WhenTo, SOURCE.Evaluated, SOURCE.Result, SOURCE.CreatedDate, SOURCE.LastModifiedTime
--);
GO
