CREATE TABLE [dbo].[PT_Name_C]
(
[ZID__c] [varchar] (47) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Type__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_Datetime__c] [datetime] NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF__PT_Name_C__CopyL__2E1BDC42] DEFAULT (getdate())
)
GO
