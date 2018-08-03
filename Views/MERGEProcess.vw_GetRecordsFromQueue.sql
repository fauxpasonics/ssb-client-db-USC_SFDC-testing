SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [MERGEProcess].[vw_GetRecordsFromQueue]
AS
	
--SELECT CAST('Account' AS VARCHAR(50)) ObjectType, CAST('001G000001clLmAIAU' AS VARCHAR(50)) Master_SFID, CAST('001G000001aEvBJIA0' AS NVARCHAR(50)) Slave_SFID, CAST('ChangedGUID' AS VARCHAR(50)) MergeDetermination, -6 PK_QueueID, 1 Rank
--UNION ALL
--SELECT CAST('Account' AS VARCHAR(50)) ObjectType, CAST('001G000001pSycxIAC' AS VARCHAR(50)) Master_SFID, CAST('001G000001pT8TWIA0' AS NVARCHAR(50)) Slave_SFID, CAST('ChangedGUID' AS VARCHAR(50)) MergeDetermination, -2 PK_QueueID, 1 Rank
--UNION ALL
--SELECT CAST('Account' AS VARCHAR(50)) ObjectType, CAST('001G000001VoI5PIAV' AS VARCHAR(50)) Master_SFID, CAST('001G000001FSokyIAD' AS NVARCHAR(50)) Slave_SFID, CAST('ChangedGUID' AS VARCHAR(50)) MergeDetermination, -3 PK_QueueID, 1 Rank
--UNION ALL
--SELECT CAST('Account' AS VARCHAR(50)) ObjectType, CAST('001G000001aFme8IAC' AS VARCHAR(50)) Master_SFID, CAST('001G000001FT0wYIAT' AS NVARCHAR(50)) Slave_SFID, CAST('ChangedGUID' AS VARCHAR(50)) MergeDetermination, -4 PK_QueueID, 1 Rank
--UNION ALL
--SELECT CAST('Account' AS VARCHAR(50)) ObjectType, CAST('001G000001FSTGmIAP' AS VARCHAR(50)) Master_SFID, CAST('001G000001aE1dQIAS' AS NVARCHAR(50)) Slave_SFID, CAST('ChangedGUID' AS VARCHAR(50)) MergeDetermination, -5 PK_QueueID, 1 Rank


SELECT      TOP 100 PERCENT CAST(a.ObjectType AS VARCHAR(50)) ObjectType, a.Master_SFID, a.Slave_SFID, CAST(a.MergeDetermination AS VARCHAR(50)) MergeDetermination, a.PK_QueueID
, RANK() OVER (ORDER BY CASE WHEN MergeDetermination = 'LeadConvert' THEN 2 WHEN MergeDetermination = 'DO_NOT_MERGE' THEN 1 ELSE 100 END, ObjectType ASC) Rank
FROM            MERGEProcess.Queue AS a 
WHERE        (1 = 1) 
AND (ISNULL(a.Completed, 0) = 0) 
AND (a.Master_SFID IS NOT NULL) AND (a.Slave_SFID IS NOT NULL) 
AND a.MergeDetermination <> 'DO_NOT_MERGE'


GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 237
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "co"
            Begin Extent = 
               Top = 6
               Left = 275
               Bottom = 136
               Right = 474
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'MERGEProcess', 'VIEW', N'vw_GetRecordsFromQueue', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'MERGEProcess', 'VIEW', N'vw_GetRecordsFromQueue', NULL, NULL
GO
