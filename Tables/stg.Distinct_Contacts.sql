CREATE TABLE [stg].[Distinct_Contacts]
(
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[USC] [datetime] NULL,
[USC_CRMRecord] [int] NULL,
[USC_CRMActivity] [int] NULL,
[USC_STH] [int] NULL,
[SFDC_Submitted] [int] NULL
)
GO
ALTER TABLE [stg].[Distinct_Contacts] ADD CONSTRAINT [PK_Distinct_Contacts] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_CONTACT_ID])
GO
