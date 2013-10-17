CREATE TABLE [dbo].[tbl_PurchaseReq_Attachments]
(
[PRNum] [int] NOT NULL,
[AttachmentId] [int] NOT NULL IDENTITY(1, 1),
[AttachmentSize] [int] NOT NULL,
[AttachmentName] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AttachmentType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AttachmentLocation] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ModifiedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_PurchaseReq_Attachments] ADD CONSTRAINT [PK_tblPurchaseReq_Attachments] PRIMARY KEY CLUSTERED  ([AttachmentId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_purchasereqattachment_prnum] ON [dbo].[tbl_PurchaseReq_Attachments] ([PRNum]) ON [PRIMARY]
GO
