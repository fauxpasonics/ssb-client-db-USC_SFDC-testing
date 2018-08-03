CREATE TABLE [dbo].[SFDC_USC_Opens]
(
[ID] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Link Id] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Link type] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatronId] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Activity type] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Due date] [datetime] NULL,
[Close date] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Incoming or outgoing] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Owner] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Supervisor] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Create date] [datetime] NULL,
[Last updated] [datetime] NULL
)
GO
