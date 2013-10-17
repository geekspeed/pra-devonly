CREATE TABLE [dbo].[tbl_Purchasereq_fin]
(
[PRId] [int] NOT NULL IDENTITY(1, 1),
[RequestorId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestorDept] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestorPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Priority] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestedDate] [datetime] NULL,
[Justification] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCompany] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddrLine1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddrLine2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipZipcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PONumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedDate] [datetime] NULL,
[ModifiedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PODate] [datetime] NULL,
[PaymentTerms] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FreightTerms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Taxable] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctCharged] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeOrder] [bit] NULL,
[ParentPO] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewVendor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanySites] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Buyer] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeptCharged] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHIPELECTRONIC] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Purchasereq_fin] ADD CONSTRAINT [PK_tblPurchaseReq3_PRId] PRIMARY KEY CLUSTERED  ([PRId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BSearch] ON [dbo].[tbl_Purchasereq_fin] ([PRId], [RequestorId], [RequestorDept], [PONumber]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [DeptId] ON [dbo].[tbl_Purchasereq_fin] ([RequestorDept], [PRId]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
