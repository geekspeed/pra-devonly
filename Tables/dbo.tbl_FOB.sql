CREATE TABLE [dbo].[tbl_FOB]
(
[LookupId] [numeric] (8, 0) NOT NULL,
[LookupType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LookupText] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LookupValue] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentLookupId] [int] NOT NULL,
[SortOrder] [int] NOT NULL
) ON [PRIMARY]
GO
