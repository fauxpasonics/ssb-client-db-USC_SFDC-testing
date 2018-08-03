CREATE TABLE [dbo].[SSISLogging]
(
[EventID] [int] NOT NULL IDENTITY(1, 1),
[EventType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PackageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaskName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventCode] [int] NULL,
[EventDescription] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackageDuration] [int] NULL,
[ContainerDuration] [int] NULL,
[LogDate] [datetime] NULL
)
GO
