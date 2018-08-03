SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[SourceLoadPreProcessing]
(
	@BatchId int,
	@BatchFullLoad bit,
	@Source varchar(200),
	@IntegrationName varchar(200),	
	@IncrementalExtractDate datetime
)

as 
BEGIN

	DECLARE @SourceTable varchar(200), @DestinationTable varchar(200), @Active bit, @TruncSql varchar(max), @SourceFullLoad bit, @AuditSourceExtractId int = 0, @IsDateExtractable bit, @FullLoadSql varchar(max), @DateExtractSql varchar(max), @ExtractSql varchar(2000), @AuditCountSql varchar(2000), @ExtractColumns varchar(max),@mergeProc varchar(500)

	SELECT @SourceTable = SourceTable 
		, @DestinationTable = DestinationTable
		, @Active = Active
		, @SourceFullLoad = case when @BatchFullLoad = 1 then 1 else FullLoad end
		, @FullLoadSql = FullLoadSql
		, @DateExtractSql = DateExtractSql
		, @IsDateExtractable = IsDateExtractable
		, @ExtractColumns = ExtractColumns
		,@mergeProc = mergeproc
	FROM SSIS_Config.dbo.SourceExtractControl
	WHERE Source = @Source
		and IntegrationName = @IntegrationName

	

	if (@Active = 1)
	begin

		INSERT INTO SSIS_Config.dbo.AuditSourceExtract (BatchId, Source, IntegrationName, SourceTable, DestinationTable, IncrementalExtractDate, ExecStartDate, FullLoad)
		values (@BatchId, @Source, @IntegrationName, @SourceTable, @DestinationTable, @IncrementalExtractDate, getdate(), @SourceFullLoad)

		set @AuditSourceExtractId = @@identity

		print 'Truncating Table: ' + @SourceTable

		set @TruncSql = 'TRUNCATE TABLE ' + @SourceTable

		EXEC (@TruncSql)

	end

	set @ExtractSql = replace(@FullLoadSql, '{columns}', @ExtractColumns)
	set @AuditCountSql = replace(@FullLoadSql, '{columns}', 'count(*) RecordCount')

	if (@IsDateExtractable = 1 and @BatchFullLoad = 0)
	begin
		set @ExtractSql = replace(replace(@DateExtractSql, '{columns}', @ExtractColumns), '{IncrementalExtractDate}', @IncrementalExtractDate)
		set @AuditCountSql = replace(replace(@DateExtractSql, '{columns}', 'count(*) RecordCount'), '{IncrementalExtractDate}', @IncrementalExtractDate)
	end

	SELECT @Active Active, @AuditSourceExtractId AuditSourceExtractId, @ExtractSql ExtractSql, @AuditCountSql AuditCountSql, @mergeProc mergeProc


END









GO
