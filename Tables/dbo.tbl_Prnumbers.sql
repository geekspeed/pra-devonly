CREATE TABLE [dbo].[tbl_Prnumbers]
(
[PRId] [int] NOT NULL,
[PRNum] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Prnumbers] ADD CONSTRAINT [PK_tbl_Prnumbers] PRIMARY KEY CLUSTERED  ([PRNum]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_tblprnumbers_prid] ON [dbo].[tbl_Prnumbers] ([PRId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Prnumbers] WITH NOCHECK ADD CONSTRAINT [FK_tbl_Prnumbers_tbl_Purchasereq] FOREIGN KEY ([PRId]) REFERENCES [dbo].[tbl_Purchasereq] ([PRId])
GO
