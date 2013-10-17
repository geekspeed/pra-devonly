SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetPRAttachment]
@PRNum int
as
SELECT [AttachmentId]
      ,convert(Numeric(18,2),convert(Numeric(18,2),AttachmentSize)/1024) as AttachmentSize
      ,[AttachmentName]
      ,[AttachmentType]
      ,[AttachmentLocation]
      ,[CreatedBy]
      ,convert(varchar(10),CreatedDate,101) CreatedDate
FROM [dbo].[tbl_PurchaseReq_Attachments]
where
PRNum = @PRNum
and Status <> 'INACTIVE'
GO
