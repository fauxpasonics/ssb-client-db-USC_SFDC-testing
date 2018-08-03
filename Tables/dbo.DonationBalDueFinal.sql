CREATE TABLE [dbo].[DonationBalDueFinal]
(
[adnumber] [int] NULL,
[ADNumber_withZeros] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaciolanID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [uniqueidentifier] NULL,
[salesforce_ID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transyear] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[programname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CashPledges] [numeric] (18, 2) NULL,
[CashReceipts] [numeric] (18, 2) NULL,
[credits] [numeric] (18, 2) NULL,
[bal] [numeric] (19, 2) NULL
)
GO
