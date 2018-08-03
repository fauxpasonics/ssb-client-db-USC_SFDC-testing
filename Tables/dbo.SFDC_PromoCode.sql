CREATE TABLE [dbo].[SFDC_PromoCode]
(
[ZID__c] [varchar] (47) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_Datetime__c] [datetime] NULL,
[Promo__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF__SFDC_Prom__CopyL__32E0915F] DEFAULT (getdate())
)
GO
