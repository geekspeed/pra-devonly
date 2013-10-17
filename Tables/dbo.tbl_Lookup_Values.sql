CREATE TABLE [dbo].[tbl_Lookup_Values]
(
[LookupId] [int] NOT NULL IDENTITY(1, 1),
[LookupType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LookupText] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LookupValue] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentLookupId] [int] NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LookupDesc] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortOrder] [int] NULL,
[CreatedDate] [datetime] NULL,
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Lookup_Values] ADD CONSTRAINT [PK_tblLookup_Values] PRIMARY KEY CLUSTERED  ([LookupId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_LookupType] ON [dbo].[tbl_Lookup_Values] ([LookupType]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
