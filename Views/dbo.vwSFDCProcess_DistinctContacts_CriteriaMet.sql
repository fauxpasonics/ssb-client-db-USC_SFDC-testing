SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwSFDCProcess_DistinctContacts_CriteriaMet]
AS
SELECT * FROM dbo.SFDCProcess_DistinctContacts
WHERE [SFDCLoadCriteriaMet] = 1
GO
