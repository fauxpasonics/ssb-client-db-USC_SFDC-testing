CREATE TABLE [dbo].[Item__c]
(
[Season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_Datetime__c] [datetime2] NULL,
[changeType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesforce_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZID__c] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SFDC_loadDate] [datetime] NULL,
[dbLastUpdated] [datetime] NULL
)
GO
