CREATE TABLE [dbo].[tbl_Finance_Approver]
(
[DepartmentCode] [int] NULL,
[DepartmentName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinancePRType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IMApproverName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IMApproverEmail] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DMApproverName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DMApproverEmail] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IDX_Fin_Approver] ON [dbo].[tbl_Finance_Approver] ([DepartmentCode]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
