CREATE TABLE [stg].[SFDC_RecentSeasons_Patrons]
(
[PatronID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaxTransDate] [datetime] NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF__SFDC_Rece__CopyL__4D94879B] DEFAULT (getdate())
)
GO
