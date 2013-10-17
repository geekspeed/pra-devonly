SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_DecideByPRId]
@PRId int,
@ApproverId varchar(50),
@Decision varchar(10),
@Comments varchar(4000),
@DelegatedApproverID varchar(50)
as
Begin
set NOCoUNT On
declare @TaskId varchar(250)
Declare @MAX_BU_LEVEL int = 40
set @TaskId = ''
--update tbl_PurchaseReq set Status='PENDINGQ' where PRId=@PRId
BEGIN TRY
BEGIN TRANSACTION

select @TaskId = ResponseTaskID from tbl_Approval_Chain where ApprovalPRNumber=@PRId and ApproverResponse='PENDING' and ApproverEmail in (select @ApproverId+'@arubanetworks.com'  union select lookuptext from tbl_Lookup_Values where LookupType='ALIASES' and LookupValue=@ApproverId)
if(@TaskId <> '')
Begin
	
if(@Decision = 'APPROVED')
Begin

update tbl_Approval_Chain set [ApproverResponse]=@Decision,ApproverResponseDate=getdate(),ApproverResponseComments=@Comments where ResponseTaskId=@TaskId
update tbl_Approval_Chain set [ApproverResponse]=@Decision,ApproverResponseDate=getdate(),ApproverResponseComments='Auto Approval' where ResponseTaskId !=@TaskId and ApprovalPRNumber = @PRId and ApproverEmail = @ApproverId+'@arubanetworks.com' AND ApproverLevel <=@MAX_BU_LEVEL
update tbl_Approval_Chain set [ApproverResponse]='PENDING', ApproverPRSentDAte = getdate() where ApprovalPRNumber=@PRId and approverLevel = (select min(approverlevel) from tbl_Approval_Chain where ApprovalPRNumber=@PRId and [ApproverResponse]='EMAIL_NOT_SENT')
if exists(select 1 from tbl_Approval_Chain where  ApprovalPRNumber=@PRId and [ApproverResponse]='PENDING')
Begin
---Karen : also CC delegates in approval request emails
  DECLARE @CCAdd VARCHAR(1024)
   select ResponseTaskId,ApproverEmail,isnull(COALESCE(@CCAdd + ',', '') + DelegateId+'@arubanetworks.com','') CC ,ApprovalPRNumber,ApproverResponse from tbl_Approval_Chain left outer join tbl_PurchaseReq_Delegate PD on ApproverEmail = PD.ForUserId+'@arubanetworks.com' and  cast(convert(varchar(10),StartDate,101) as datetime)<= cast(convert(varchar(10),getdate(),101) as datetime)
and cast(convert(varchar(10),EndDate,101) as datetime)>=cast(convert(varchar(10),getdate(),101) as datetime)
and Upper(Status)  = 'ACTIVE'
	 where  ApprovalPRNumber=@PRId and [ApproverResponse]='PENDING'
End
else
Begin
 update tbl_PurchaseReq set Status='COMPLETED' where PRId=(select PrID from tbl_PrNumbers where PrNum=@PRId)
 select '' ResponseTaskId,RequestorId+'@arubanetworks.com' ApproverEmail,''as CC,PRId as ApprovalPRNumber,'COMPLETED' ApproverResponse from tbl_PurchaseReq where  PrId=(select PrID from tbl_PrNumbers where PrNum=@PRId) 
End	
End
else IF(@Decision = 'REJECTED')
Begin

update tbl_Approval_Chain set [ApproverResponse]=@Decision,ApproverResponseDate=getdate(),ApproverResponseComments=@Comments where ResponseTaskId=@TaskId
	 update tbl_PurchaseReq set Status='DECLINED' where PRId=(select PrID from tbl_PrNumbers where PrNum=@PRId)
	delete from tbl_Approval_Chain where ApprovalPRNumber=@PRId and ApproverResponse='EMAIL_NOT_SENT'
	 select '' ResponseTaskId,RequestorId+'@arubanetworks.com' ApproverEmail,''as CC,PRId as ApprovalPRNumber,'DECLINED' ApproverResponse from tbl_PurchaseReq where  PrId=(select PrID from tbl_PrNumbers where PrNum=@PRId)
	 
	--select ResponseTaskId,ApproverEmail,ApprovalPRNumber,[ApproverResponse] from tbl_Approval_Chain where  ApprovalPRNumber=@PRId and [ApproverResponse]=@Decision
End
End
update tbl_PurchaseReq set Status='PENDING' where PRId=(select PrID from tbl_PrNumbers where PrNum=@PRId) and Status='PENDINGQ'

IF(@ApproverId <> @DelegatedApproverID)
BEGIN 
	Declare @name varchar(50)
	SET @name = NULL
	SELECT @name = (EmployeeFirstName + ' ' + EmployeeLastName) FROM vw_employee where employeeemail = @DelegatedApproverID+'@arubanetworks.com'
	UPDATE tbl_Approval_Chain SET ApproverName = ISNULL(@name,@DelegatedApproverID),ApproverEmail = @DelegatedApproverID+'@arubanetworks.com', ApproverResponseComments= (ApproverResponseComments+ ' Approved on behalf of ' +@ApproverId) WHERE ResponseTaskID = @TaskId
END

COMMIT 

END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
     ROLLBACK

  -- Raise an error with the details of the exception
  DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
  SELECT @ErrMsg = ERROR_MESSAGE(),
         @ErrSeverity = ERROR_SEVERITY()

  RAISERROR(@ErrMsg, @ErrSeverity, 1)

END CATCH
End
GO
