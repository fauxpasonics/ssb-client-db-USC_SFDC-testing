CREATE TABLE [dbo].[SFDCProcess_DistinctContacts]
(
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[USC_Flag] [int] NOT NULL,
[USC_MaxTransDate] [datetime] NULL,
[USC_CRMActivity] [int] NULL,
[USC_CRMRecord] [int] NULL,
[USC_STH] [int] NULL,
[USC_SeasonTicket_Years] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Brand] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SFDCLoadCriteriaMet] [bit] NULL CONSTRAINT [DF_SFDCProcess_DistinctContacts_SFDCLoadCriteriaMet] DEFAULT ((0)),
[SFDC_Submitted] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[SFDCProcess_DistinctContacts] ADD CONSTRAINT [PK_SFDCProcess_DistinctContacts] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_CONTACT_ID])
GO
