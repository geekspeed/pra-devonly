CREATE TABLE [dbo].[tbl_Modules]
(
[ModuleId] [int] NOT NULL IDENTITY(1, 1),
[ModuleTitle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SortOrder] [int] NOT NULL,
[ModuleUrl] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Target] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Modules] ADD CONSTRAINT [PK_tbl_Modules] PRIMARY KEY CLUSTERED  ([ModuleId]) ON [PRIMARY]
GO
