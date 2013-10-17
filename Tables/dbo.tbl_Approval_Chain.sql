CREATE TABLE [dbo].[tbl_Approval_Chain]
(
[ApprovalPRNumber] [int] NOT NULL,
[ApproverName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApproverLevel] [int] NOT NULL,
[ApproverDepartment] [int] NOT NULL,
[ApproverResponseDate] [datetime] NULL,
[ApproverResponse] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApproverEmail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApproverPRSentDAte] [datetime] NULL,
[ApproverResponseComments] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseTaskId] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApproverPRReminderDate] [datetime] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_tbl_Approval_Chain_9_1374627940__K1_K6_2] ON [dbo].[tbl_Approval_Chain] ([ApprovalPRNumber], [ApproverResponse]) INCLUDE ([ApproverName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tblapprovalchain_approvalprnumber] ON [dbo].[tbl_Approval_Chain] ([ApprovalPRNumber], [ApproverResponse]) INCLUDE ([ApproverName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_ApproverResponse] ON [dbo].[tbl_Approval_Chain] ([ApproverResponse], [ApprovalPRNumber]) ON [PRIMARY]
GO
