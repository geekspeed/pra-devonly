CREATE TABLE [dbo].[tbl_PurchaseReq_DelegateActivity]
(
[ForUserId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DelegateId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DelegateAction] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ModifiedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedDate] [datetime] NULL,
[ItemId] [int] NOT NULL,
[ActivityDateTime] [datetime] NOT NULL,
[Notes] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
