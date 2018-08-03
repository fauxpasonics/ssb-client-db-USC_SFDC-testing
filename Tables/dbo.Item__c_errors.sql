CREATE TABLE [dbo].[Item__c_errors]
(
[changeType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zid__c] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_datetime__c] [datetime] NULL,
[Item__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadDate] [datetime] NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
