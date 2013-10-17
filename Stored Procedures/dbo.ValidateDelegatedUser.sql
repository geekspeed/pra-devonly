SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[ValidateDelegatedUser]
@TaskId VARCHAR(250),
@DelegatedApproverID VARCHAR(50),
@outResult bit out
AS
BEGIN
SET @outResult = 1
DECLARE @ApproverId VARCHAR(50)

SELECT @ApproverId = ApproverEmail FROM tbl_Approval_Chain WHERE ResponsetaskId=@TaskId  

IF(@ApproverId != (@DelegatedApproverID+'@arubanetworks.com'))
BEGIN
	IF ((select count(1) from dbo.tbl_PurchaseReq_Delegate WHERE getdate() between startdate and enddate and delegateid = @DelegatedApproverID and status='ACTIVE' and (ForUserID+'@arubanetworks.com') = @ApproverId) < 1 )
	BEGIN 
		print '2'
		SET @outResult = 0
	END
END
END
GO
