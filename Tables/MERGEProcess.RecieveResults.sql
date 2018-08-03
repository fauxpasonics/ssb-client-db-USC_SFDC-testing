CREATE TABLE [MERGEProcess].[RecieveResults]
(
[RRID] [int] NOT NULL IDENTITY(1, 1),
[PK_QueueID] [int] NULL,
[ErrorCode] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateInserted] [datetime] NULL CONSTRAINT [DF__RecieveRe__DateI__3805392F] DEFAULT (getdate())
)
GO
ALTER TABLE [MERGEProcess].[RecieveResults] ADD CONSTRAINT [PK__RecieveR__E3054D13039AA072] PRIMARY KEY CLUSTERED  ([RRID])
GO
