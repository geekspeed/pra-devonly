CREATE TABLE [dbo].[tbl_Shipping_Info]
(
[ShipToId] [int] NOT NULL IDENTITY(1, 1),
[PREntity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCategory] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToAddrLine1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToAddrLine2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shipToCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToZipcode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomField1] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomField2] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomField3] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomField4] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomField5] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Shipping_Info] ADD CONSTRAINT [PK_tbl_Shipping_Info] PRIMARY KEY CLUSTERED  ([ShipToId]) ON [PRIMARY]
GO
