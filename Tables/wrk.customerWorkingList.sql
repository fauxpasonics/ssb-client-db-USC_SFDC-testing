CREATE TABLE [wrk].[customerWorkingList]
(
[DimCustomerID] [int] NOT NULL,
[SSB_CRMSYSTEM_ACCT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsPersonAccount] [int] NOT NULL,
[IsBusinessAccount] [int] NOT NULL,
[MDM_UpdatedDate] [datetime] NULL,
[SFDCProcess_UpdatedDate] [datetime] NOT NULL,
[SSID_Winner] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USC_Losers] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USCCRM_Losers] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimCustID_Losers] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [wrk].[customerWorkingList] ADD CONSTRAINT [PK_customerWorkingList] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_ACCT_ID])
GO
