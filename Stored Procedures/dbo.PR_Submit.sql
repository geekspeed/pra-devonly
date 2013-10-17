SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_Submit]
@PRId int
as
Begin
SET NoCOUNT ON
	BEGIN TRY
		BEGIN TRANSACTION
		---ACTUAL CODE
		declare @requestorId varchar(50),@requestorDept varchar(50),@PRType varchar(75), @PRValue decimal,@tempPRType varchar(75)
		declare @FIN_LEVEL int, @FIN_VP_LEVEL int,@CFO_LEVEL int,@PUR_LEVEL int,@CEO_LEVEL int,@MAX_BU_LEVEL int,@DIR_LEVEL int,@MANAGER_LEVEL int,@BOD_LEVEL int
		declare @VP_FOUND int, @DIR_FOUND int,@FIN_MANAGER_LEVEL int
		declare @VPGUY varchar(25)
		declare @EMPGUY varchar(25)
		declare @SCM varchar(25)
		Declare @tempDeptID varchar(50)
		Declare @empEntity nvarchar(100) --VB 2013-05-20

		--pre-defined levels
		set @MANAGER_LEVEL = 20
		set @DIR_LEVEL		= 30
		set @MAX_BU_LEVEL	= 40 --mostly VP
		set @FIN_LEVEL		= 60
		set @FIN_VP_LEVEL	= 70
		set @CFO_LEVEL		= 80
		set @CEO_LEVEL		= 90
		set @BOD_LEVEL		= 105
		set @PUR_LEVEL		= 110

		set @DIR_FOUND=0
		set @VP_FOUND=0
		
		set @empEntity='UNKNOWN' --VB 2013-05-20




		--check if PR is Submitted
		if not exists(select 1 from tbl_Approval_Chain where ApprovalPRNumber=@PRId)
		Begin
		-- get PR requestor ,Requestor dept, PRValue, PR Type
		select @requestorId = a.RequestorId , @requestorDept=RequestorDept,@PRType=PRTypeValue ,@PRValue = PRValue from vw_intl_PurchaseReq a where a.PrNum=@PRId

		--set EmployeeEntity VB 2013-05-20
		Select @empEntity=EmployeeEntity from vw_Employee where EmployeeLoginId=@requestorId

		--Set Dept to retrieve Approval Matrix
		Select @tempDeptID = DeptCode from tbl_Approval_Level where DeptCode = @requestorDept and PRType =  @PRType
		IF (@tempDeptID is null )
		BEGIN 
		PRINT 'Department code is not exist in tbl_Approval_Level'
		SET @tempDeptID = '-100'
		END 
		--
		
		print @requestorId
		print @requestorDept
		print @PRType
		print @PRValue
		print @tempDeptID
	--start insert into approval chain
		
		--PUR Level Check
		if exists (select 1 from tbl_Approval_Level where PRType=@PRType and DeptCode=@tempDeptID  and MinAmount<=@PRValue and MaxAmount>=@PRValue and Level=@PUR_LEVEL and isActive=1)
		Begin	
		INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
		select @PRId,LookupText,Approverlevel,@requestordept,null,'EMAIL_NOT_SENT',LookupValue,null,null,NEWID()from tbl_workflow_lookup where lookuptype='Purchasing' and isActive=1
		End	

		--BOD level check
		if exists (select 1 from tbl_Approval_Level where PRType=@PRType and DeptCode=@tempDeptID  and MinAmount<=@PRValue and MaxAmount>=@PRValue and Level=@BOD_LEVEL and isActive=1)
		Begin	
		INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
		select @PRId,LookupText,Approverlevel,@requestordept,null,'EMAIL_NOT_SENT',LookupValue,null,null,NEWID()from tbl_workflow_lookup where lookuptype='BOD' and isActive=1
		End	
		
		--CEO Level Check
		if exists (select 1 from tbl_Approval_Level where PRType=@PRType and DeptCode=@tempDeptID  and MinAmount<=@PRValue and MaxAmount>=@PRValue and Level=@CEO_LEVEL and isActive=1)
		Begin	
		INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
		select @PRId,LookupText,Approverlevel,@requestordept,null,'EMAIL_NOT_SENT',LookupValue,null,null,NEWID()from tbl_workflow_lookup where lookuptype='CEO' and isActive=1
		End	

		--CFO Level Check
		if exists (select 1 from tbl_Approval_Level where PRType=@PRType and DeptCode=@tempDeptID  and MinAmount<=@PRValue and MaxAmount>=@PRValue and Level=@CFO_LEVEL and isActive=1)
		Begin	
		INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
		select @PRId,LookupText,Approverlevel,@requestordept,null,'EMAIL_NOT_SENT',LookupValue,null,null,NEWID()from tbl_workflow_lookup where lookuptype='CFO' and isActive=1
		End	
		
		--VP Finance Level Check
		if exists (select 1 from tbl_Approval_Level where PRType=@PRType and DeptCode=@tempDeptID  and MinAmount<=@PRValue and MaxAmount>=@PRValue and Level=@FIN_VP_LEVEL and isActive=1)
		Begin	
		INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
		select @PRId,LookupText,Approverlevel,@requestordept,null,'EMAIL_NOT_SENT',LookupValue,null,null,NEWID()from tbl_workflow_lookup where lookuptype='VPFIN' and isActive=1
		End	
		
		
		--Fin hierarchy
		--Finance approver by Employee Entity VB 2013-05-20
		if not exists(select 1 from tbl_finance_matrix where EmpEntity=@empEntity and DeptCode=@requestorDept and PRType=@PRType and isActive=1 and FinLevel=@FIN_LEVEL)
		Begin
		Set @empEntity='ARUN' -- reset Entity to default value as there MUST always be one entry for ARUN
		End
		--Finance approver by Employee Entity VB 2013-05-20

		INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId]) 
		select @PRId,EmployeeFirstName+' '+EmployeeLastName,L.Level,@requestordept,null,'EMAIL_NOT_SENT',M.ApproverId+'@arubanetworks.com',null,null,NEWID()
		from tbl_Approval_Level L
		join tbl_finance_matrix M on L.PRType = M.PRType and L.Level = M.FinLevel and M.isActive=1 and M.EmpEntity=@empEntity --VB 2013-05-20
		join vw_Employee on M.ApproverId = EmployeeLoginId
		where L.PRType=@PRType and  L.DeptCode=@tempDeptID and L.MinAmount<=@PRValue and L.MaxAmount>=@PRValue and   M.DeptCode = @requestordept  and      L.isActive=1 order by L.Level Desc

		--BU Level check
		if exists (select 1 from tbl_Approval_Level where PRType=@PRType  and DeptCode=@tempDeptID and MinAmount<=@PRValue and MaxAmount>=@PRValue and Level=@MAX_BU_LEVEL and isActive=1)
		Begin

			select  @VPGUY= dbo.func_GetSupervisor(@requestorId,@MAX_BU_LEVEL)
			if( @VPGUY  is not null)
			Begin
				INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
				select @PRId,EmployeeFirstName+ ' '+EmployeeLastName,@MAX_BU_LEVEL,EmployeeDeptId,null,'EMAIL_NOT_SENT',EmployeeEmail,null,null,NEWID() from vw_Employee where Employeeloginid = @VPGUY

				set @VP_FOUND=1 	

			End	
			print 'VP_FOUND: '+Convert(varchar(10),@VP_FOUND	)
		--if the above does not find a VP the below will add the DIR
			if(@VP_FOUND = 0) --if vp not found use DIR to approve
			Begin
				select  @VPGUY= dbo.func_GetSupervisor(@requestorId,@DIR_LEVEL)
				if( @VPGUY  is not null)
				Begin
					INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
					select @PRId,EmployeeFirstName+ ' '+EmployeeLastName,@MAX_BU_LEVEL,EmployeeDeptId,null,'EMAIL_NOT_SENT',EmployeeEmail,null,null,NEWID() from vw_Employee where Employeeloginid = @VPGUY

					set @DIR_FOUND=1 	

				End	
			End
			print '@DIR_FOUND: '+Convert(varchar(10),@DIR_FOUND	)

		End
		
		--Director
		if exists (select 1 from tbl_Approval_Level where PRType=@PRType  and DeptCode=@tempDeptID and MinAmount<=@PRValue and MaxAmount>=@PRValue and Level=@DIR_LEVEL and isActive=1)
		Begin
			set @DIR_FOUND=0
			set @VP_FOUND=0
			set @VPGUY = null
			select  @VPGUY= dbo.func_GetSupervisor(@requestorId,@DIR_LEVEL)
			if( @VPGUY  is not null)
			Begin
				INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
				select @PRId,EmployeeFirstName+ ' '+EmployeeLastName,@DIR_LEVEL,EmployeeDeptId,null,'EMAIL_NOT_SENT',EmployeeEmail,null,null,NEWID() from vw_Employee where Employeeloginid = @VPGUY

				set @DIR_FOUND=1 	

			End	
			print 'DIR_FOUND: '+Convert(varchar(10),@DIR_FOUND	)
			--if the above does not find a VP the below will add the DIR
			if(@DIR_FOUND = 0) --if vp not found use DIR to approve
			Begin
				select  @VPGUY= dbo.func_GetSupervisor(@requestorId,@MAX_BU_LEVEL)
				if( @VPGUY  is not null)
				Begin
					INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
					select @PRId,EmployeeFirstName+ ' '+EmployeeLastName,@DIR_LEVEL,EmployeeDeptId,null,'EMAIL_NOT_SENT',EmployeeEmail,null,null,NEWID() from vw_Employee where Employeeloginid = @VPGUY

					set @VP_FOUND=1 	

				End	
			End
			print '@VP_FOUND: '+Convert(varchar(10),@VP_FOUND)	 
		End
		--Manager Approval : level 20
		if exists (select 1 from tbl_Approval_Level where PRType=@PRType and  DeptCode=@tempDeptID and MinAmount<=@PRValue and MaxAmount>=@PRValue and Level=@MANAGER_LEVEL and isActive=1)
		Begin
		-- use reporting manager
			INSERT INTO [tbl_Approval_Chain]([ApprovalPRNumber],[ApproverName],[ApproverLevel],[ApproverDepartment] ,[ApproverResponseDate] ,[ApproverResponse],[ApproverEmail],[ApproverPRSentDAte],[ApproverResponseComments],[ResponseTaskId])
			select @PRId,EmployeeFirstName+ ' '+EmployeeLastName,@MANAGER_LEVEL,EmployeeDeptId,null,'EMAIL_NOT_SENT',EmployeeEmail,null,null,NEWID() from vw_Employee where Employeeloginid = (select employeemanagerid from vw_employee where employeeloginid=@requestorId)
		End

		update tbl_Approval_Chain set [ApproverResponse]='PENDING',ApproverPRSentDAte=GETDATE() where ApprovalPRNumber=@PRId
		and approverLevel = (select min(approverlevel) from tbl_Approval_Chain where ApprovalPRNumber=@PRId and [ApproverResponse]='EMAIL_NOT_SENT')
		
		
		--include Delegates also in approval requests
		--select ResponseTaskId,ApproverEmail,ApprovalPRNumber from tbl_Approval_Chain where  ApprovalPRNumber=@PRId and [ApproverResponse]='PENDING'
		DECLARE @ccAdd VARCHAR(1024)
		select ResponseTaskId,ApproverEmail,isnull(COALESCE(@ccAdd + ',', '') + DelegateId+'@arubanetworks.com','') CC ,ApprovalPRNumber,ApproverResponse from tbl_Approval_Chain left outer join tbl_PurchaseReq_Delegate PD on ApproverEmail = PD.ForUserId+'@arubanetworks.com' and  cast(convert(varchar(10),StartDate,101) as datetime)<= cast(convert(varchar(10),getdate(),101) as datetime)
		and cast(convert(varchar(10),EndDate,101) as datetime)>=cast(convert(varchar(10),getdate(),101) as datetime)
		and Upper(Status)  = 'ACTIVE'
		where  ApprovalPRNumber=@PRid and [ApproverResponse]='PENDING'
		
		End --if not exists
		else
		Begin
		--signal Web service to do nothing
		select 'IGNOREREQUEST' as ResponseTaskId,'IGNOREREQUEST' as ApproverEmail,0 as ApprovalPRNumber
		END
		--END CODE
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
