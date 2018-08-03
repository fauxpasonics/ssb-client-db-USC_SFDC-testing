SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [MERGEProcess].[sp_ViewCurrentStatus] as
SELECT COUNT(*) TotalPending from MergeProcess.QUEUE Where Completed is NULL
SELECT ObjectType, MergeDetermination, COUNT(*) Pending, RANK() OVER (ORDER BY CASE WHEN MergeDetermination = 'LeadConvert' THEN 2 WHEN MergeDetermination = 'DO_NOT_MERGE' THEN 1 ELSE 100 END, ObjectType ASC) RANK from MergeProcess.Queue Where Completed is NULL GROUP BY ObjectType, MergeDetermination ORDER BY Rank
SELECT CAST(CreateDateTime AS Date) iDate, ObjectType, MergeDetermination, SUM(CASE WHEN errorcode = '' THEN 1 ELSE 0 END) NoError, SUM(CASE WHEN errorcode <> '' THEN 1 ELSE 0 END) ERROR FROM MergeProcess.Results WHERE CreateDateTime >= CAST(GETDATE()-3 AS Date) GROUP BY CAST(CreateDateTime AS Date), ObjectType, MergeDetermination ORDER BY iDate
GO
