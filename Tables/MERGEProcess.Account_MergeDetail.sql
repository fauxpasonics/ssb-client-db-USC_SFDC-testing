CREATE TABLE [MERGEProcess].[Account_MergeDetail]
(
[ObjectType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Master_SFID] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Slave_SFID] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PK_QueueID] [int] NULL,
[MstAccountID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SlvAccountID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MstOwner] [nvarchar] (121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SlvOwner] [nvarchar] (121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Master_Brand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Slave_Brand] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Master_STH] [int] NOT NULL,
[Slave_STH] [int] NOT NULL,
[OwnershipType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MergeDetermination] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[LastUpdatedDate] [datetime] NULL
)
GO
