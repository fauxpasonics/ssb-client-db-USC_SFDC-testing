CREATE TABLE [MERGEProcess].[ReviewColumnResults]
(
[ObjectType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PK_QueueID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnIdxID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SlaveValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhenTo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Evaluated] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__ReviewCol__Creat__420DC656] DEFAULT (getdate()),
[LastModifiedTime] [datetime] NULL CONSTRAINT [DF__ReviewCol__LastM__4301EA8F] DEFAULT (getdate())
)
GO
