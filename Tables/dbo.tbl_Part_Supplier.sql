CREATE TABLE [dbo].[tbl_Part_Supplier]
(
[PartSupplierId] [int] NOT NULL IDENTITY(1, 1),
[PartId] [int] NOT NULL,
[SupplierId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Part_Supplier] ADD CONSTRAINT [PK_tblPart_Supplier] PRIMARY KEY CLUSTERED  ([PartSupplierId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_partsupplier_supplierid] ON [dbo].[tbl_Part_Supplier] ([SupplierId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Part_Supplier] WITH NOCHECK ADD CONSTRAINT [FK_tblPart_Supplier_tblPart_Info] FOREIGN KEY ([PartId]) REFERENCES [dbo].[tbl_Part_Info] ([PartId])
GO
ALTER TABLE [dbo].[tbl_Part_Supplier] WITH NOCHECK ADD CONSTRAINT [FK_tblPart_Supplier_tblSupplierInfo] FOREIGN KEY ([SupplierId]) REFERENCES [dbo].[tbl_SupplierInfo] ([SupplierId])
GO
