CREATE TABLE [ProdCopy].[Opportunity]
(
[Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDeleted] [bit] NULL,
[AccountId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StageName] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [float] NULL,
[Probability] [float] NULL,
[CloseDate] [date] NULL,
[Type] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextStep] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LeadSource] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsClosed] [bit] NULL,
[IsWon] [bit] NULL,
[ForecastCategory] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForecastCategoryName] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CampaignId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasOpportunityLineItem] [bit] NULL,
[Pricebook2Id] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerId] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NULL,
[CreatedById] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModifiedDate] [datetime] NULL,
[LastModifiedById] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemModstamp] [datetime] NULL,
[LastActivityDate] [date] NULL,
[FiscalQuarter] [int] NULL,
[FiscalYear] [int] NULL,
[Fiscal] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLO__c] [bit] NULL,
[Renewal__c] [bit] NULL,
[Season__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sport__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Short_Description__c] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reason_Lost__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Phone__c] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Email__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Mobile_Phone__c] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Other_Phone__c] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Home_Phone__c] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Patron_ID__c] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full_Opportunity_ID__c] [nvarchar] (1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTypeId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastViewedDate] [datetime] NULL,
[LastReferencedDate] [datetime] NULL,
[Drive_Year__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program_Group__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program_Name__c] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Foundation_Owner__c] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyLoadDate] [datetime] NULL CONSTRAINT [DF__Opportuni__CopyL__2057CCD0] DEFAULT (getdate())
)
GO
ALTER TABLE [ProdCopy].[Opportunity] ADD CONSTRAINT [PK_Opportunity_id] PRIMARY KEY CLUSTERED  ([Id])
GO
CREATE NONCLUSTERED INDEX [ix_opportunity_accountid_createddate_include] ON [ProdCopy].[Opportunity] ([AccountId], [CreatedDate] DESC) INCLUDE ([Id], [LastModifiedDate], [OwnerId], [Reason_Lost__c])
GO
CREATE NONCLUSTERED INDEX [ix_opportunity_isclosed_include] ON [ProdCopy].[Opportunity] ([IsClosed]) INCLUDE ([AccountId], [LastModifiedDate])
GO
CREATE NONCLUSTERED INDEX [ix_opportunity_isclosed_iswon_include] ON [ProdCopy].[Opportunity] ([IsClosed], [IsWon]) INCLUDE ([AccountId], [CreatedDate])
GO
CREATE NONCLUSTERED INDEX [ix_opportunity_ownerid] ON [ProdCopy].[Opportunity] ([OwnerId])
GO
ALTER TABLE [ProdCopy].[Opportunity] ADD CONSTRAINT [FK_Opportunity_User_OwnerId_Id] FOREIGN KEY ([OwnerId]) REFERENCES [ProdCopy].[User] ([Id])
GO
