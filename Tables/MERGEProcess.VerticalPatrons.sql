CREATE TABLE [MERGEProcess].[VerticalPatrons]
(
[DW_Contact_ID__c] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Master_Flag] [int] NOT NULL,
[SourceSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CleanPatron] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SFID] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
