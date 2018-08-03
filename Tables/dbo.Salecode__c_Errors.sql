CREATE TABLE [dbo].[Salecode__c_Errors]
(
[changeType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZID__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salecode__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_datetime__c] [datetime] NULL,
[SFDC_LoadDate] [datetime] NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
