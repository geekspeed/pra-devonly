IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'IAD_PRA')
CREATE LOGIN [IAD_PRA] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [IAD_PRA] FOR LOGIN [IAD_PRA]
GO
