SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[Load_ods_Turnkey_Models]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     05/26/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.Turnkey_Models),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

/*Extract Options, default values set if the option is not specified*/	
DECLARE @DisableInsert nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableInsert'),'false')
DECLARE @DisableUpdate nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableUpdate'),'false')
DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')


BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId


SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
,  ETL_FileName, PersonID, FootballPriority, FootballPriorityDate, DonorCapacity, DonorCapacityDate, DonorPriority, DonorPriorityDate, TicketingSystemAccountID, AbilitecID
INTO #SrcData
FROM stg.Turnkey_Models
;


EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AbilitecID),'DBNULL_TEXT') + ISNULL(RTRIM(DonorCapacity),'DBNULL_TEXT') + ISNULL(RTRIM(DonorCapacityDate),'DBNULL_TEXT') + ISNULL(RTRIM(DonorPriority),'DBNULL_TEXT') + ISNULL(RTRIM(DonorPriorityDate),'DBNULL_TEXT') + ISNULL(RTRIM(FootballPriority),'DBNULL_TEXT') + ISNULL(RTRIM(FootballPriorityDate),'DBNULL_TEXT') + ISNULL(RTRIM(PersonID),'DBNULL_TEXT') + ISNULL(RTRIM(TicketingSystemAccountID),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (AbilitecID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Turnkey_Models AS myTarget
USING #SrcData AS mySource
ON myTarget.AbilitecID = mySource.AbilitecID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	 , myTarget.[ETL_FileName] = mySource.[ETL_FileName]
     , myTarget.[PersonID] = mySource.[PersonID]
     , myTarget.[FootballPriority] = mySource.[FootballPriority]
     , myTarget.[FootballPriorityDate] = mySource.[FootballPriorityDate]
     , myTarget.[DonorCapacity] = mySource.[DonorCapacity]
     , myTarget.[DonorCapacityDate] = mySource.[DonorCapacityDate]
     , myTarget.[DonorPriority] = mySource.[DonorPriority]
     , myTarget.[DonorPriorityDate] = mySource.[DonorPriorityDate]
     , myTarget.[TicketingSystemAccountID] = mySource.[TicketingSystemAccountID]

     
WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_FileName]
     ,[PersonID]
     ,[FootballPriority]
     ,[FootballPriorityDate]
     ,[DonorCapacity]
     ,[DonorCapacityDate]
     ,[DonorPriority]
     ,[DonorPriorityDate]
     ,[TicketingSystemAccountID]
	 ,[AbilitecID]
     )
VALUES
     (@RunTime	--ETL_CreatedDate
     ,@RunTime	--ETL_UpdateddDate
     ,0			--ETL_IsDeleted
     ,NULL		--ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.[ETL_FileName]
     ,mySource.[PersonID]
     ,mySource.[FootballPriority]
     ,mySource.[FootballPriorityDate]
     ,mySource.[DonorCapacity]
     ,mySource.[DonorCapacityDate]
     ,mySource.[DonorPriority]
     ,mySource.[DonorPriorityDate]
     ,mySource.[TicketingSystemAccountID]
	 ,mySource.[AbilitecID]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Turnkey_Models WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Turnkey_Models WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Insert Row Count', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Update Row Count', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END




GO
