CREATE TABLE [recon].[final]
(
[WhoId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhatId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActivityDate] [datetime] NULL,
[Status] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Priority] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
