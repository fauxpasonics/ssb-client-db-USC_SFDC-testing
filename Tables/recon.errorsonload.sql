CREATE TABLE [recon].[errorsonload]
(
[Status] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhoId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhatId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActivityDate] [datetime] NULL,
[Type] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
