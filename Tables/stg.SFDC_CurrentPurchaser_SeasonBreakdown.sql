CREATE TABLE [stg].[SFDC_CurrentPurchaser_SeasonBreakdown]
(
[Customer__c] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrSeason] [int] NOT NULL,
[I_PRICE] [numeric] (18, 2) NULL,
[QTY] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FB_F8] [int] NOT NULL,
[FB_FSN] [int] NOT NULL,
[MBB_BM] [int] NOT NULL,
[FB_MINI] [int] NOT NULL,
[MBB_MINI] [int] NOT NULL
)
GO
