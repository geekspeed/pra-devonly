SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_CheckPRWflowEntry]
@PRType varchar(50), 
@RequestorDept varchar(50), 
@PRValue float
as
Begin
set nocount On
		Declare @tempDeptID varchar(50)
		
		--Set Dept to retrieve Approval Matrix
		Select @tempDeptID = DeptCode from tbl_Approval_Level where DeptCode = @RequestorDept and PRType=@PRType and isactive=1
		IF (@tempDeptID is null )
		BEGIN 
			PRINT 'Department code is not exist in tbl_Approval_Level'
			SET @tempDeptID = '-100'
		END 
	   select count(*) as ApprovalCount from tbl_Approval_Level where DeptCode=@tempDeptID and PRType=@PRType and minamount<=@PRValue and isactive=1
       
End

--(@PRId int)
--as
--Begin
--set nocount On
--		Declare @tempDeptID varchar(50),@PRType varchar(50), @RequestorDept varchar(50), @PRValue float
--		if exists(select 1 from vw_intl_purchasereq where PRNum=@PRId)
--		Begin
--			select @RequestorDept=RequestorDept,@PRType=PRTypevalue,@PRValue=PRValue from vw_intl_purchasereq where PRNum=@PRId
--			--Set Dept to retrieve Approval Matrix
--			Select @tempDeptID = DeptCode from tbl_Approval_Level where DeptCode = @RequestorDept and PRType=@PRType and isactive=1
--			IF (@tempDeptID is null )
--			BEGIN 
--				PRINT 'Department code is not exist in tbl_Approval_Level'
--				SET @tempDeptID = '-100'
--			END 
--		   select count(*) as ApprovalCount from tbl_Approval_Level where DeptCode=@tempDeptID and PRType=@PRType and minamount<=@PRValue and isactive=1
--       end
--       else
--       Begin
--       select -1 as ApprovalCount
--       End
--End
GO
