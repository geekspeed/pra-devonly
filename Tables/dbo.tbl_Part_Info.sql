CREATE TABLE [dbo].[tbl_Part_Info]
(
[PartId] [int] NOT NULL IDENTITY(1, 1),
[PartDesc] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PartCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Part_Info] ADD CONSTRAINT [PK_tblPart_Info] PRIMARY KEY CLUSTERED  ([PartId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_PArtIDCode] ON [dbo].[tbl_Part_Info] ([PartId], [PartCode]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
