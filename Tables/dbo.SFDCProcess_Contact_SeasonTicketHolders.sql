CREATE TABLE [dbo].[SFDCProcess_Contact_SeasonTicketHolders]
(
[SSB_CRMSYSTEM_CONTACT_ID] [uniqueidentifier] NOT NULL,
[USC_SeasonTicket_Years] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSIDs_List] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Distinct_Teams] [int] NULL,
[Distinct_SSIDs] [int] NULL,
[LoadDateTime] [datetime] NULL CONSTRAINT [DF_SFDCProcess_Contact_SeasonTicketHolders_LoadDateTime] DEFAULT (getdate())
)
GO
