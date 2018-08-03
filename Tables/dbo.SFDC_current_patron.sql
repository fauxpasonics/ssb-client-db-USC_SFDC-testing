CREATE TABLE [dbo].[SFDC_current_patron]
(
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron_ID__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account__c] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DW_contactID__c] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_Datetime__c] [datetime] NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF__SFDC_curr__CopyL__0F975522] DEFAULT (getdate())
)
GO
CREATE NONCLUSTERED INDEX [idxpatronId] ON [dbo].[SFDC_current_patron] ([Patron_ID__c])
GO
