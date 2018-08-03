SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SourceLoadPostProcessing]
(
	@AuditSourceExtractId int,
	@RecordCountSource int,
	@RecordCountDataFlow int
)

as 
BEGIN

	DECLARE @DestinationTable varchar(200), @RecordCountSql nvarchar(max), @RecordCount int

	SELECT @DestinationTable = DestinationTable	
	FROM SSIS_Config.dbo.AuditSourceExtract
	WHERE AuditSourceExtractId = @AuditSourceExtractId


	SET @RecordCountSql = 'select @cnt=count(*) FROM ' + cast(@DestinationTable as nvarchar(200))
	print @RecordCountSql

	EXECUTE sp_executesql @RecordCountSql, N'@cnt int OUTPUT', @cnt=@RecordCount OUTPUT
		
	UPDATE SSIS_Config.dbo.AuditSourceExtract			
	SET ExecEndDate = getdate()
		, RecordCountSource = @RecordCountSource
		, RecordCountDataFlow = @RecordCountDataFlow
		, RecordCountDestination = @RecordCount
	WHERE AuditSourceExtractId = @AuditSourceExtractId


END







GO
