CREATE TABLE [dbo].[tbl_purchasereq_cart]
(
[ItemID] [int] NOT NULL IDENTITY(1, 1),
[PRID] [int] NOT NULL,
[LineNumber] [int] NOT NULL,
[PartSupplierId] [int] NOT NULL,
[PartUnitPrice] [float] NOT NULL,
[PartDiscount] [float] NOT NULL,
[PartQty] [int] NOT NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [int] NOT NULL,
[AcctCharged] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeptCharged] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LocalToUsd] [float] NOT NULL,
[fxFeedDate] [datetime] NULL,
[DeliveryDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_purchasereq_cart] ADD CONSTRAINT [PK_tbl_purchasereq_cart] PRIMARY KEY CLUSTERED  ([ItemID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tbl_purchasereqcart_PrId_ItemId] ON [dbo].[tbl_purchasereq_cart] ([ItemID], [PRID]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tblpurchaseregcart_supplierid] ON [dbo].[tbl_purchasereq_cart] ([PartSupplierId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tblpurchaseregcart_prid] ON [dbo].[tbl_purchasereq_cart] ([PRID]) INCLUDE ([DeptCharged]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_purchasereq_cart] WITH NOCHECK ADD CONSTRAINT [FK_tbl_purchasereq_cart_tbl_Purchasereq] FOREIGN KEY ([PRID]) REFERENCES [dbo].[tbl_Purchasereq] ([PRId])
GO
