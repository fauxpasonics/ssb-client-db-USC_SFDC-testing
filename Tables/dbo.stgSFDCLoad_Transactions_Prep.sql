CREATE TABLE [dbo].[stgSFDCLoad_Transactions_Prep]
(
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORDER_LINE_ID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ORDER_SEQUENCE] [bigint] NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BASIS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_DISP] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PRICE] [numeric] (18, 2) NULL,
[ORDER_DATE] [datetime] NULL,
[I_OQTY] [bigint] NULL,
[ORDER_TOTAL] [numeric] (38, 2) NULL,
[I_PAY] [numeric] (18, 2) NULL,
[MINPMTDATE] [datetime] NULL,
[ORIG_SALECODE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROMO] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_MARK] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INREFSOURCE] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INREFDATA] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEAT_BLOCK] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ODET_EXPORT_DATETIME] [datetime] NULL,
[ITEM_EXPORT_DATETIME] [datetime] NULL,
[maxchangedate] [datetime] NULL,
[CopyLoadDate] [datetime] NULL,
[SourceSystem] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentHash] [varbinary] (max) NULL
)
GO
ALTER TABLE [dbo].[stgSFDCLoad_Transactions_Prep] ADD CONSTRAINT [PK_stgSFDCLoad_Transactions_Prep] PRIMARY KEY CLUSTERED  ([ORDER_LINE_ID])
GO
