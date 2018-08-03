SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ProdCopy].[vw_Account] AS 
						---- CREATED BY PROCESS ON Nov 16 2015  6:15AM
						Select * 
						from USC_Reporting.ProdCopy.Account --modified by AMeitin 2017-10-10 to pull from USC_Reporting database
						Where 1=1 and IsDeleted = 0
GO
