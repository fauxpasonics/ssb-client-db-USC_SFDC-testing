CREATE TABLE [recoveryset].[Patron__c]
(
[Suffix] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsBusinessAccount] [bit] NULL,
[FullName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Patron] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatronStatusCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatronStatus] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerTypeCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerType] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPtsTix] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PacCreateDate] [datetime] NULL,
[PrimaryAddressType] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressStreet] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressCity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressState] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressZipCode] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddressCountry] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2Type] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2Street] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2State] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2ZipCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2Country] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3Type] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3Street] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3State] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3ZipCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3Country] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CellPhone] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPhone] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneType] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EvEmail] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonalEmail] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessEmail] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherEmailType] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherEmail] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime] NULL,
[ChangeType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [varbinary] (8000) NULL,
[CleanDataLoad] [bit] NULL,
[ContactId] [uniqueidentifier] NULL,
[CD_Prefix] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_MiddleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Suffix] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Salutation] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddress] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddress2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressSuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressCity] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressState] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressZipCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressPlus4] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressCounty] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressCountry] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressCountyFips] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryAddressDeliveryPoint] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryZipLatitude] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PrimaryZipLongitude] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2Type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2_2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2Suite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2City] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2State] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2ZipCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2Plus4] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2County] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2Country] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2CountyFips] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2DeliveryPoint] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2ZipLatitude] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address2ZipLongitude] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3Type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3_2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3Suite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3City] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3State] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3ZipCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3Plus4] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3County] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3Country] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3CountyFips] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3DeliveryPoint] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3ZipLatitude] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Address3ZipLongitude] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_HomePhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_CellPhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_BusinessPhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Fax] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_OtherPhone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_EvEmail] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_PersonalEmail] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_BusinessEmail] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_OtherEmail] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_NameStatus] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesforce_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SFDC_loaddate] [datetime] NULL,
[dbLastUpdated] [datetime] NULL,
[VIP] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Internet_profile] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cust_comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cust_UD1] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pin] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tags] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_ID__c] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Donor_Membership__c] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
