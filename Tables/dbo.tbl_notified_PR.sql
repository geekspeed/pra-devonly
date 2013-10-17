CREATE TABLE [dbo].[tbl_notified_PR]
(
[PrId] [int] NOT NULL,
[NotifyDateTime] [datetime] NULL CONSTRAINT [DF__tbl_notif__Notif__0EF836A4] DEFAULT (getdate()),
[replyEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_PRId] ON [dbo].[tbl_notified_PR] ([PrId]) ON [PRIMARY]
GO
