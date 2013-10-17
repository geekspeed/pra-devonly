SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetUserInfo]
@UserId varchar(30)
as
set NOCOUNT ON
--select EmployeeFirstName+' '+EmployeeLastName RequestorName,isnull(EmployeeDeptID,'') RequestorDept, 
-- Added phone number 08-MArch-2010 Vivek
select EmployeeFirstName+' '+EmployeeLastName RequestorName,isnull(EmployeeDeptID,'') RequestorDept, 
isnull(AD.Phone ,isnull(EmployeePhone,'')) RequestorPhone,isnull(RoleId,'user') as UserRole ,isnull(t1.LookupType,'') as UserType
,isnull(t2.LookupValue,'') as AllowInv,AD.Name  as ADName
from vw_employee 
left outer join dbo.vw_ad_employee AD on vw_employee.EmployeeloginId = AD.LoginId
left outer join tbl_User_Roles on vw_employee.EmployeeLoginId = tbl_User_Roles.UserId
left outer join tbl_lookup_values t1 on vw_employee.EmployeeLoginId=t1.LookupValue and t1.lookupType<>'ALLOW_INV_OPS'
left outer join tbl_lookup_values t2 on vw_employee.EmployeeLoginId=t2.LookupValue and t2.lookupType='ALLOW_INV_OPS'
where vw_employee.EmployeeLoginId=@UserId --and tbl_lookup_values.Status='ACTIVE'

select Ad.Name Name,AD.LoginId LoginId from vw_AD_Employee Ad where Ad.loginId=@UserId
Union all
select  AD.Name Name, Ad.LoginId from vw_AD_Employee AD join tbl_PurchaseReq_Delegate on AD.LoginId = ForUserId
where DelegateId =@UserId and StartDate + ' 00:00:01' <=GETDATE() and EndDate + ' 23:59:59'>=GETDATE() AND Status = 'ACTIVE'
GO
