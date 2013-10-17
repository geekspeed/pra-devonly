CREATE TABLE [dbo].[tbl_PurchaseReq_Audit]
(
[PRId] [int] NOT NULL,
[ModifiedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
[FieldName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TblAction] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewValue] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_PRAudit] ON [dbo].[tbl_PurchaseReq_Audit] ([PRId] DESC, [ModifiedDate] DESC) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
