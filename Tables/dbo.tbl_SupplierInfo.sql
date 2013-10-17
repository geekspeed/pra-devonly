CREATE TABLE [dbo].[tbl_SupplierInfo]
(
[SupplierId] [int] NOT NULL IDENTITY(1, 1),
[SupplierName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierAddrLine1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierAddrLine2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierZipcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierTaxId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Suppvar] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_SupplierInfo] ADD CONSTRAINT [PK_tblSupplierInfo] PRIMARY KEY CLUSTERED  ([SupplierId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_SuppName] ON [dbo].[tbl_SupplierInfo] ([SupplierName]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
