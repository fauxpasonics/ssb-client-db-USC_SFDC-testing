SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW  [MERGEProcess].[vw_ColumnsToReview]
AS
--SaveAsNote
--CopyToMaster
--OwnerChange
SELECT 'Account' ObjectType, CAST('Description' AS VARCHAR(500)) ColumnName, 'SaveAsNote' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts
UNION ALL
SELECT 'Account' ObjectType, 'OwnerId' ColumnName, 'OwnerChange' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts
UNION ALL
SELECT 'Account' ObjectType, 'Development__c' ColumnName, 'OwnerChange' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts
UNION ALL
SELECT 'Account' ObjectType, 'Service__c' ColumnName, 'OwnerChange' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts
UNION ALL
SELECT 'Account' ObjectType, 'Donor_Membership__c' ColumnName, 'CopyToMaster' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts
UNION ALL
SELECT 'Account' ObjectType, 'Opposing_Team_Fan__c' ColumnName, 'CopyToMaster' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts
UNION ALL
SELECT 'Account' ObjectType, 'Opposing_Team__c' ColumnName, 'CopyToMaster' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts
UNION ALL 
SELECT 'Account' ObjectType, 'Group_Association__c' ColumnName, 'CopyToMaster' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts
UNION 
SELECT 'Account' ObjectType, 'Development__c' ColumnName, 'OwnerChange' Action, 'ConflictOnly' WhenTo, 1 ReportConflicts







GO
