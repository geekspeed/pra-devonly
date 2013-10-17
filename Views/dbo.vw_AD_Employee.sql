SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[vw_AD_Employee]
as
select isnull(Name,EmployeeFirstName+' '+employeeLastName) name,EmployeeDeptId Department,lower(Loginid) as loginId,Phone,EmployeeEmail Mail, case  when (EmployeeEntity='ARIN') then  'India' else null end as Country ,Office
from vw_Employee left outer join tbl_AD_EMPLOYEE with (nolock) on EmployeeLoginId=LoginId where mail is not null
--select EmployeeFirstName+' '+EmployeeLastName Name,EmployeeDeptId Department,lower(EmployeeLoginId) as loginId,EmployeePhone Phone,EmployeeEmail Mail, case  when (EmployeeEntity='ARIN') then  'India' else null end as Country ,'' Office
--from vw_Employee with (nolock)-- where mail is not null


GO
