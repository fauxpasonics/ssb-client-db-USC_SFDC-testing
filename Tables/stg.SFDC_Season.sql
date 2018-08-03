CREATE TABLE [stg].[SFDC_Season]
(
[ZID__c] [varchar] (47) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_Datetime__c] [datetime] NULL,
[Season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Activity__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status__c] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF__SFDC_Seas__CopyL__3A81B327] DEFAULT (getdate())
)
GO
