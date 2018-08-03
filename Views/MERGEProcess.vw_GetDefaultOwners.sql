SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [MERGEProcess].[vw_GetDefaultOwners] AS
SELECT Id, Name 
FROM USC_Reporting.ProdCopy.vw_Users
WHERE Name IN ('ETL User')


GO
