SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ProdCopy].[vw_Transactions] AS 
						---- CREATED BY PROCESS ON Nov 16 2015  7:10AM
						Select * 
						from USC_Reporting.ProdCopy.Transactions__c -- modified by AMeitin 2017-10-10 to pull from USC_reporting database prviously USC_SFDC.ProdCopy.Transactions
						Where 1=1 and IsDeleted = 0
GO
