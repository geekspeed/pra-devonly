CREATE TABLE [dbo].[tbl_User_Dept]
(
[UserId] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DeptId] [int] NOT NULL,
[IsActive] [bit] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedDate] [datetime] NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
