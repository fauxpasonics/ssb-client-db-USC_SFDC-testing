CREATE TABLE [stg].[SFDC_CurrentPurchaser]
(
[Customer__c] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PRICE] [numeric] (18, 2) NULL,
[QTY] [bigint] NULL,
[SeasonType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoadDate] [datetime] NULL CONSTRAINT [DF_SFDC_CurrentPurchaser_LoadDate] DEFAULT (getdate())
)
GO
