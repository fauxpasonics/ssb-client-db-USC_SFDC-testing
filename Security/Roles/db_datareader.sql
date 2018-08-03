EXEC sp_addrolemember N'db_datareader', N'SSBCLOUD\BI Developers'
GO
EXEC sp_addrolemember N'db_datareader', N'SSBCLOUD\CI - DB Read Only'
GO
EXEC sp_addrolemember N'db_datareader', N'svcQA'
GO
EXEC sp_addrolemember N'db_datareader', N'svcssbrp'
GO
