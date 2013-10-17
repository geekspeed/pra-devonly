SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[func_GetEstaff] (@userid varchar(50))
returns varchar(50)
as
Begin
	declare @SUPERVISOR_FOUND int
	declare @SUPERVISOR varchar(50)
	declare @EMPGUY varchar(50)
	declare @CEO varchar(50)
	set @SUPERVISOR_FOUND=0
	set @EMPGUY=@userid
	set @SUPERVISOR = @userid
	select @CEO = replace(lower(isnull(LookupValue,'')),'@arubanetworks.com','') from tbl_workFlow_lookup where LookupType='CEO' and isActive=1
	while @SUPERVISOR_FOUND=0  AND @SUPERVISOR <> @CEO
	Begin
		--print @SUPERVISOR_FOUND
		select @SUPERVISOR =  EmployeeManagerId from vw_Employee where EmployeeLoginId=@EMPGUY 
		--print @SUPERVISOR
		if exists(select 1 from vw_Employee where EmployeeLoginId=@SUPERVISOR and EmployeeManagerId=@CEO) AND (@SUPERVISOR <> @EMPGUY) 
		Begin
			set @SUPERVISOR_FOUND=1	
		End
		else
		Begin
			set @EMPGUY=@SUPERVISOR
		End
	End
	if(@SUPERVISOR_FOUND =0)
	Begin
		set @SUPERVISOR= null
	End
	return @SUPERVISOR
End
GO
