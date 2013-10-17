SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetLookupValues]  
@UserId varchar(30)  
as  
/*  
Declare @UserRole as varchar(20)  
set @UserRole='user'   
  
select @UserRole=RoleId from tbl_User_Roles where UserId=@UserId  
  
--select @UserId  
  
if (@UserRole='fin')  
begin  
select EmployeeFirstName+' '+EmployeeLastName as TXT, EmployeeLoginId as VAL  from vw_employee order by txt  
end  
else  
begin  
select EmployeeFirstName+' '+EmployeeLastName as TXT, @UserId as VAL  from vw_employee where EmployeeLoginId=@UserId  
--union  
--select M.UserNAme TXT,M.userid VAL from vw_employee M join vw_employee U  
--on U.manager = M.UserNAme where u.UserId='vivek'  
union  
select distinct isnull(v.EmployeeFirstName+' '+v.EmployeeLastName,t.foruserId) as TXT,foruserID as VAL   
from tbl_PurchaseReq_Delegate t left outer join vw_employee v  
on v.EmployeeLoginId=t.foruserid  
where getdate()>=startdate   
  and getdate()<=enddate   
  and status='ACTIVE'  
  and DelegateId = @UserId order by TXT  
end  
*/  
--Employee Info  
select Name as TXT, lower(LoginId) as VAL  from vw_Ad_employee join vw_Employee on lower(loginId)=LOWER(employeeloginid) order by txt  
  
--LookupValues  
select LookupId,LookupType, LookupText TXT, LookupValue VAL, isnull(ParentLookupId,0) ParentLookupId,SortOrder  
from tbl_Lookup_Values  
where Status='ACTIVE'  
union   
select LookupId,LookupType, LookupText TXT, LookupValue VAL, isnull(ParentLookupId,0) ParentLookupId,SortOrder   
from vw_PaymentTerms  
union  
select LookupId,LookupType, LookupText TXT, LookupValue VAL, isnull(ParentLookupId,0) ParentLookupId,SortOrder   
from vw_FOB  
order by LookupType,SortOrder asc  
--ReqDept  
select 'DEPT' LookupType, DeptCode+' - ' + DeptName TXT,DeptCode VAL  
from vw_Department  
order by DeptName
GO
