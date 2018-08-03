CREATE TABLE [dbo].[PT_Name__c_Errors]
(
[zid__c] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Type__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_datetime__C] [datetime] NULL,
[SFDC_LoadDate] [datetime] NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
