CREATE TABLE [MERGEProcess].[queue_temp030917]
(
[PK_QueueID] [int] NOT NULL IDENTITY(1, 1),
[ObjectType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Master_SFID] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Slave_SFID] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MergeDetermination] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Completed] [int] NULL
)
GO
