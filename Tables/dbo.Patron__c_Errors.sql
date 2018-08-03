CREATE TABLE [dbo].[Patron__c_Errors]
(
[zid__c] [varchar] (121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron_ID__c] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DW_ContactId__c] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_datetime__c] [datetime] NULL,
[dbLastUpdated] [datetime] NULL,
[SFDC_LoadDate] [datetime] NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
