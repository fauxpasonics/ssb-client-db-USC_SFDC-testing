CREATE TABLE [stg].[Item_C]
(
[Season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZID__c] [varchar] (47) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_Datetime__c] [datetime] NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF__Item_C__CopyLoad__1CF15040] DEFAULT (getdate())
)
GO
