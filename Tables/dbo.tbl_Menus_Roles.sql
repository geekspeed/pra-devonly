CREATE TABLE [dbo].[tbl_Menus_Roles]
(
[MenuRoleId] [int] NOT NULL IDENTITY(1, 1),
[MenuId] [int] NOT NULL,
[RoleId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Menus_Roles] ADD CONSTRAINT [PK_tbl_Menus_User_Roles] PRIMARY KEY CLUSTERED  ([MenuRoleId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_MenuRole] ON [dbo].[tbl_Menus_Roles] ([RoleId]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Menus_Roles] WITH NOCHECK ADD CONSTRAINT [FK_tbl_Menus_User_Roles_tbl_Menus] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[tbl_Menus] ([MenuId])
GO
ALTER TABLE [dbo].[tbl_Menus_Roles] WITH NOCHECK ADD CONSTRAINT [FK_tbl_Menus_User_Roles_tbl_User_Roles] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[tbl_Roles] ([RoleId])
GO
