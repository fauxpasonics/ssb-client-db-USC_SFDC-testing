SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dbo].[vwSFDC_Development] AS 

SELECT adv.StaffAssigned AS Development__c
				, suser.Id
				, dc.ssb_crmsystem_contact_id 
		
		FROM  [USC].[dbo].[ADV_Contact] adv WITH (NOLOCK)
				INNER JOIN [USC].[dbo].[ADV_Reps] reps WITH (NOLOCK) ON adv.staffassigned = reps.repid
				--INNER JOIN usc.dbo.vwDimCustomer_ModAcctId dc on CAST(adv.PatronID AS nvarchar(100)) = dc.SSID and dc.SourceSystem = 'TI USC' and [SSB_CRMSYSTEM_PRIMARY_FLAG] = '1'
				LEFT JOIN USC_Reporting.[prodcopy].[vw_Users] suser ON adv.StaffAssigned = suser.Name 
				INNER JOIN usc.dbo.vwDimCustomer_ModAcctId dc on CAST(adv.ContactId AS nvarchar(100)) = dc.SSID and dc.SourceSystem = 'USC_Advantage' 
				INNER JOIN ( SELECT dc2.SSB_CRMSYSTEM_CONTACT_ID
											,trans.ContactId
											, MAX(TransDate) TransDate
											, SSCreatedDate
											, ROW_NUMBER() OVER(PARTITION BY SSB_CRMSYSTEM_CONTACT_ID ORDER BY MAX(TransDate) DESC, SSCreatedDate) xRank
                                    FROM usc.dbo.vwDimCustomer_ModAcctId dc2 (NOLOCK) 
									LEFT JOIN USC.dbo.ADV_ContactTransHeader trans (NOLOCK) ON dc2.SourceSystem = 'USC_Advantage' AND dc2.SSID = CAST(trans.ContactId AS nvarchar(100))
									WHERE SourceSystem = 'USC_Advantage'
									--AND trans.ContactId IN ( '324368')
									GROUP BY dc2.SSB_CRMSYSTEM_CONTACT_ID, trans.ContactId, SSCreatedDate
                                   ) acct ON adv.ContactId = acct.ContactId AND acct.xRank = 1
		
		WHERE adv.StaffAssigned IS NOT NULL
		--AND adv.ContactId =  '324368'

		      

GO
