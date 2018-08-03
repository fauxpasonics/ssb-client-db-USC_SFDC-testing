CREATE TABLE [stg].[SeasonTicketHolders]
(
[Team] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEASONYR] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF__SeasonTic__CopyL__4F7CD00D] DEFAULT (getdate())
)
GO
