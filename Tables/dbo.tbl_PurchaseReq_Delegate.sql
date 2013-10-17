CREATE TABLE [dbo].[tbl_PurchaseReq_Delegate]
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
[ItemId] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trig_PR_DelegateActivity]
ON [dbo].[tbl_PurchaseReq_Delegate]
FOR INSERT, UPDATE
AS
BEGIN
IF EXISTS(SELECT * FROM DELETED)
	BEGIN
		Insert into tbl_PurchaseReq_DelegateActivity
		SELECT *, getdate(),'Before Update' FROM Deleted
		IF EXISTS(SELECT * FROM inserted)
		BEGIN
			Insert into tbl_PurchaseReq_DelegateActivity
			SELECT *, getdate(),'After Update' FROM inserted
		END
	END
ELSE
	BEGIN
		Insert into tbl_PurchaseReq_DelegateActivity
		SELECT *, getdate(),'Insert' FROM inserted
	END
END
GO
ALTER TABLE [dbo].[tbl_PurchaseReq_Delegate] ADD CONSTRAINT [PK_tblPurchaseReq_Delegate] PRIMARY KEY CLUSTERED  ([ItemId]) ON [PRIMARY]
GO
