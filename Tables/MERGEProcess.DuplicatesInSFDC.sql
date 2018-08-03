CREATE TABLE [MERGEProcess].[DuplicatesInSFDC]
(
[DW_Contact_ID__c] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Master_Flag] [int] NOT NULL
)
GO
ALTER TABLE [MERGEProcess].[DuplicatesInSFDC] ADD CONSTRAINT [IX_DuplicatesInSFDC] UNIQUE CLUSTERED  ([DW_Contact_ID__c], [Patron]) WITH (IGNORE_DUP_KEY=ON)
GO
