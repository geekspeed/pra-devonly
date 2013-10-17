CREATE TABLE [dbo].[tbl_Payment_Terms]
(
[LookupId] [numeric] (8, 0) NOT NULL,
[LookupType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LookupText] [char] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LookupValue] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentLookupId] [int] NOT NULL,
[SortOrder] [int] NOT NULL
) ON [PRIMARY]
GO
