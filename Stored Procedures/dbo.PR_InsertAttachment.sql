SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_InsertAttachment]
@PRNum int,
@AttachmentName varchar(150),
@AttachmentLocation varchar(250),
@AttachmentSize int,
@AttachmentType varchar(100),
@UserId varchar(30)
as
insert into tbl_PurchaseReq_Attachments
(PRNum,AttachmentName,AttachmentLocation,AttachmentType,AttachmentSize,CreatedBy,CreatedDate,Status)
values
(@PRNum,@AttachmentName,@AttachmentLocation,@AttachmentType,@AttachmentSize,@UserId,getdate(),'ACTIVE')

select scope_identity() as AttachmentId
GO
