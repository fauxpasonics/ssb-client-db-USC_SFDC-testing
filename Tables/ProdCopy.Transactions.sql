CREATE TABLE [ProdCopy].[Transactions]
(
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OwnerId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NULL,
[CreatedDate] [datetime] NULL,
[CreatedById] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModifiedDate] [datetime] NULL,
[LastModifiedById] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemModstamp] [datetime] NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron_ID__c] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Export_Datetime__c] [datetime] NULL,
[Account__c] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount_Paid__c] [float] NULL,
[Basis__c] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Disposition_Code__c] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Code__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item_Price__c] [float] NULL,
[Item_Title__c] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location_Preference__c] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order_Date__c] [date] NULL,
[Order_Line_ID__c] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order_Quantity__c] [float] NULL,
[Order_Total__c] [float] NULL,
[Orig_Salecode__c] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Orig_Salecode_Name__c] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Level__c] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Type__c] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Promo_Code__c] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Promo_Code_Name__c] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mark_Code__c] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season_Code__c] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season_Name__c] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat_Block__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sequence__c] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ticket_Class__c] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item_Code__c] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rep_Code__c] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_SPECIAL__c] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service_Specialist__c] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF_ProdCopy_Transactions] DEFAULT (getdate())
)
GO
ALTER TABLE [ProdCopy].[Transactions] ADD CONSTRAINT [PK_ProdCopy_Transactions] PRIMARY KEY CLUSTERED  ([Id])
GO
