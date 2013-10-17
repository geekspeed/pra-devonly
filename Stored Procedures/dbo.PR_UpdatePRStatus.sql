SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_UpdatePRStatus]
@PRNum int,
@Status varchar(20),
@UserId varchar(30)
as


UPDATE tbl_PurchaseReq
   SET ModifiedDate = getdate()
      ,ModifiedBy = @UserId
      ,Status = @Status
 where PrId= (select distinct top 1 PRId from tbl_PRnumbers where PRnum=@PrNum)

SET NOCOUNT ON
IF(upper(@Status) = 'CANCELLED')
BEGIN 
delete from WorkQueue where WorkTaskID in (select responseTaskId from tbl_approval_chain where approvalPRNumber = @PRNum)
delete from WorkQueuetrigger where WorkTaskId in (select responseTaskId from tbl_approval_chain where approvalPRNumber = @PRNum)
delete from Workstatus where Workflowtaskid  in (select responseTaskId from tbl_approval_chain where approvalPRNumber = @PRNum)
END
GO
