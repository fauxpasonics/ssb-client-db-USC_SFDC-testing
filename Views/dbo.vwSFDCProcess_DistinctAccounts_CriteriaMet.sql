SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwSFDCProcess_DistinctAccounts_CriteriaMet]
AS
SELECT * FROM dbo.SFDCProcess_DistinctAccounts
WHERE [SFDCLoadCriteriaMet] = 1
GO
