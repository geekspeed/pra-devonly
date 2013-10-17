CREATE TABLE [dbo].[tbl_Module_Roles]
(
[ModuleRoleId] [int] NOT NULL IDENTITY(1, 1),
[ModuleId] [int] NOT NULL,
[RoleId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Module_Roles] ADD CONSTRAINT [PK_tbl_Module_User_Roles] PRIMARY KEY CLUSTERED  ([ModuleRoleId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_MduelRole] ON [dbo].[tbl_Module_Roles] ([RoleId]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Module_Roles] WITH NOCHECK ADD CONSTRAINT [FK_tbl_Module_User_Roles_tbl_Modules] FOREIGN KEY ([ModuleId]) REFERENCES [dbo].[tbl_Modules] ([ModuleId])
GO
ALTER TABLE [dbo].[tbl_Module_Roles] WITH NOCHECK ADD CONSTRAINT [FK_tbl_Module_User_Roles_tbl_User_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[tbl_Roles] ([RoleId])
GO
