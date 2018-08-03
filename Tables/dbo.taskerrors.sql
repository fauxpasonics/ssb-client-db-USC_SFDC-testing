CREATE TABLE [dbo].[taskerrors]
(
[WhoId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhatId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[patron] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subject] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[activitydate] [datetime] NULL,
[OwnerId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Accountid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[full_task_ID__c] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
