CREATE TABLE [dbo].[tbl_User_Roles]
(
[UserId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RoleId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_LoginId_RoleID] ON [dbo].[tbl_User_Roles] ([UserId]) INCLUDE ([RoleId]) ON [PRIMARY]
GO
