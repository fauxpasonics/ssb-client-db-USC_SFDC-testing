CREATE TABLE [dbo].[Promo_Code__c_Errors]
(
[changeType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZID__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Promo__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesforce_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[loadDate] [datetime] NULL,
[Export_datetime__c] [datetime] NULL,
[SFDC_LoadDate] [datetime] NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
