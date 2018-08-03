CREATE TABLE [dbo].[Season__c_Errors]
(
[ZID__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Activity__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status__c] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dbLastUpdated] [datetime] NULL,
[Export_datetime__c] [datetime] NULL,
[SFDC_LoadDate] [datetime] NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
