CREATE TABLE [MERGEProcess].[Results]
(
[ObjectType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Master_SFID] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Slave_SFID] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDateTime] [datetime] NULL CONSTRAINT [DF__Results__CreateD__3F115E1A] DEFAULT (getdate()),
[ErrorCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PK_ResultID] [int] NOT NULL IDENTITY(1, 1),
[PK_QueueID] [int] NULL,
[MergeDetermination] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [MERGEProcess].[Results] ADD CONSTRAINT [PK_Results] PRIMARY KEY CLUSTERED  ([PK_ResultID])
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIDX_MergeProcessResults_PKQUEUEID] ON [MERGEProcess].[Results] ([PK_QueueID])
GO
