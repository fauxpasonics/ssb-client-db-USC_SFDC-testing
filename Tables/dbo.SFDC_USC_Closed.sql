CREATE TABLE [dbo].[SFDC_USC_Closed]
(
[ID] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Link Id] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Link type] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatronId] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Activity type] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Due date] [datetime] NULL,
[Close date] [datetime] NULL,
[Incoming or outgoing] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Owner] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Createdate] [datetime] NULL,
[Lastupdated] [datetime] NULL
)
GO
