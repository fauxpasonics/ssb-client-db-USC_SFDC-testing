CREATE TABLE [stg].[Distinct_Accounts]
(
[SSB_CRMSYSTEM_ACCT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USC] [datetime] NULL,
[USC_CRMRecord] [int] NULL,
[USC_CRMActivity] [int] NULL,
[USC_STH] [int] NULL,
[SFDC_Submitted] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_stgDistAccounts_ACCTGUID] ON [stg].[Distinct_Accounts] ([SSB_CRMSYSTEM_ACCT_ID])
GO
