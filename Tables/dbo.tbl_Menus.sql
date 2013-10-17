CREATE TABLE [dbo].[tbl_Menus]
(
[MenuId] [int] NOT NULL IDENTITY(1, 1),
[MenuTitle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NavigationUrl] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModuleId] [int] NOT NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SortOrder] [int] NOT NULL,
[Target] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Menus] ADD CONSTRAINT [PK_tbl_Menus] PRIMARY KEY CLUSTERED  ([MenuId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_moduleId] ON [dbo].[tbl_Menus] ([ModuleId]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Menus] WITH NOCHECK ADD CONSTRAINT [FK_tbl_Menus_tbl_Modules] FOREIGN KEY ([ModuleId]) REFERENCES [dbo].[tbl_Modules] ([ModuleId])
GO
