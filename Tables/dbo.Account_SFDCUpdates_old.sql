CREATE TABLE [dbo].[Account_SFDCUpdates_old]
(
[SSB_CRMSYSTEM_ACCT_ID__c] [uniqueidentifier] NULL,
[Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingPostalCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonMobilePhone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonHomePhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonEmail] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTypeId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSID_Winner__c] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USC_ID__c] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimCust_ID__c] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingPostalCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonMailingStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonMailingCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonMailingState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonMailingPostalCode] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonMailingCountry] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonOtherStreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonOtherCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonOtherState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonOtherPostalCode] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonOtherCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesforce_id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USC_Flag__c] [int] NULL,
[USC_Season_Ticket_Years__c] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Status__c] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eVenue_Email__c] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_Status__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_Type__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_Level__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Internet_Profile__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eVenue_Pin__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VIP_Code__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Type__c] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_ID__c] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAG__c] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Comments__c] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_PRIORITY] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attribute] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Note] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_Comments] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[ErrorDescription] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (2100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Business_Email__C] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
