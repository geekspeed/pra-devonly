CREATE TABLE [dbo].[tbl_SAP_Vendor]
(
[VENDORID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VENDORNAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STREET] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COUNTRY] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PINCODE] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAXCODE] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POBOX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FAX] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATE] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_VENDOR_NAME] ON [dbo].[tbl_SAP_Vendor] ([VENDORNAME]) ON [PRIMARY]
GO
