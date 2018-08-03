CREATE TABLE [MERGEProcess].[RecieveResults_temp030917]
(
[RRID] [int] NOT NULL IDENTITY(1, 1),
[PK_QueueID] [int] NULL,
[ErrorCode] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateInserted] [datetime] NULL
)
GO
