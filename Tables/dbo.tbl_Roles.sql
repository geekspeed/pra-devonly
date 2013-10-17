CREATE TABLE [dbo].[tbl_Roles]
(
[RoleId] [int] NOT NULL IDENTITY(1, 1),
[RoleTitle] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Roles] ADD CONSTRAINT [PK_tbl_User_Roles] PRIMARY KEY CLUSTERED  ([RoleId]) ON [PRIMARY]
GO
