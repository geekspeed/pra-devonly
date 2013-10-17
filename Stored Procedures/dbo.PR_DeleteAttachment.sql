SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_DeleteAttachment]
@AttachmentId int,
@UserId varchar(30)
as
update tbl_PurchaseReq_Attachments
set
Status='INACTIVE',
ModifiedBy = @UserId,
ModifiedDate = getdate()
where
AttachmentId = @AttachmentId
GO
