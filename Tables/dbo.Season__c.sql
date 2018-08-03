CREATE TABLE [dbo].[Season__c]
(
[ZID__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Activity__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status__c] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_Datetime__c] [datetime] NULL,
[changeType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesforce_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SFDC_loadDate] [datetime] NULL,
[dbLastUpdated] [datetime] NULL
)
GO
