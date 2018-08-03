CREATE TABLE [dbo].[CD_ProcessQueue]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[SourceSystem] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceContactId] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContactField] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_dbo.CD_ProcessQueue_InsertedDate] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[CD_ProcessQueue] ADD CONSTRAINT [PK_dbo.CD_ProcessQueue] PRIMARY KEY CLUSTERED  ([Id])
GO
