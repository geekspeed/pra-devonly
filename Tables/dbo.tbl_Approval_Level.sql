CREATE TABLE [dbo].[tbl_Approval_Level]
(
[PRType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Level] [int] NOT NULL,
[DeptCode] [int] NOT NULL,
[MinAmount] [float] NOT NULL,
[MaxAmount] [float] NOT NULL,
[isActive] [bit] NULL,
[createDate] [datetime] NULL,
[lastModifiedDate] [datetime] NULL,
[createdBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Approval_Level_IDX1] ON [dbo].[tbl_Approval_Level] ([PRType], [Level], [DeptCode]) ON [PRIMARY]
GO
