CREATE TABLE [dbo].[Archived_Account]
(
[SSB_CRMSYSTEM_ACCT_ID] [uniqueidentifier] NOT NULL,
[salesforce_id] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New_Acct_Id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Deleted] [int] NULL,
[Processed] [int] NULL,
[SFDC_CreatedDate] [datetime] NULL,
[Updated_DateTime] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[Archived_Account] ADD CONSTRAINT [PK_Archived_Account] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_ACCT_ID], [New_Acct_Id])
GO
