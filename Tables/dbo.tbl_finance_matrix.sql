CREATE TABLE [dbo].[tbl_finance_matrix]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DeptCode] [int] NOT NULL,
[PRType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinLevel] [int] NOT NULL,
[ApproverId] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[isActive] [bit] NULL,
[createDate] [datetime] NULL,
[lastModifiedDate] [datetime] NULL,
[createdBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpEntity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__tbl_finan__EmpEn__60924D76] DEFAULT ('ARUN')
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_UNIQ_entity_prtype_dept_approver_level_active] ON [dbo].[tbl_finance_matrix] ([DeptCode], [PRType], [FinLevel], [ApproverId], [isActive], [EmpEntity]) ON [PRIMARY]
GO
