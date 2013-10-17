CREATE TABLE [dbo].[tbl_COO_approval]
(
[DepartmentCode] [int] NOT NULL,
[isActive] [bit] NULL,
[createDate] [datetime] NULL,
[lastModifiedDate] [datetime] NULL,
[createdBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
