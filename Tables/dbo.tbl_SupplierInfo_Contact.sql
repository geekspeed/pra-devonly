CREATE TABLE [dbo].[tbl_SupplierInfo_Contact]
(
[SupplierId] [int] NULL,
[ContactName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactEmail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactFax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [int] NOT NULL IDENTITY(1, 1),
[PRId] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_suppliercontactinfo_prid] ON [dbo].[tbl_SupplierInfo_Contact] ([PRId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_suppliercontactinfo_SupplierIDcontactid] ON [dbo].[tbl_SupplierInfo_Contact] ([SupplierId], [ContactId]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [SupplierID_Prid] ON [dbo].[tbl_SupplierInfo_Contact] ([SupplierId], [ContactId], [PRId] DESC) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_SupplierInfo_Contact] WITH NOCHECK ADD CONSTRAINT [FK_tbl_SupplierInfo_Contact_tbl_Purchasereq] FOREIGN KEY ([PRId]) REFERENCES [dbo].[tbl_Purchasereq] ([PRId])
GO
ALTER TABLE [dbo].[tbl_SupplierInfo_Contact] WITH NOCHECK ADD CONSTRAINT [FK_tbl_SupplierInfo_Contact_tbl_SupplierInfo] FOREIGN KEY ([SupplierId]) REFERENCES [dbo].[tbl_SupplierInfo] ([SupplierId])
GO
