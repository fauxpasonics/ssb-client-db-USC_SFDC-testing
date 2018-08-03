CREATE TABLE [dbo].[Account_old]
(
[ContactId] [uniqueidentifier] NULL,
[IsBusinessAccount] [bit] NULL CONSTRAINT [DF_Account_IsBusiness] DEFAULT ((0)),
[FullName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatronStatusCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatronStatus] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerTypeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerType] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPtsTix] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PacCreateDate] [datetime] NULL,
[PrimaryAddressType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressStreet] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressCity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressState] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressZipCode] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressCountry] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2Type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2Street] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2City] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2State] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2ZipCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2Country] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3Type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3Street] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3City] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3State] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3ZipCode] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3Country] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CellPhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EvEmail] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonalEmail] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessEmail] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherEmailType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherEmail] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VIP] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Internet_profile] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cust_comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cust_UD1] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerMarkCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime] NULL,
[changeType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesforce_ID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SFDC_loadDate] [datetime] NULL,
[dbLastUpdated] [datetime] NULL,
[dw_contactid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_ID__c] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_Membership__c] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [idxcontact] ON [dbo].[Account_old] ([ContactId])
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141209-213049] ON [dbo].[Account_old] ([ContactId])
GO
