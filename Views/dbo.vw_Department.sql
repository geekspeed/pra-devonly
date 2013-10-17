SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE View [dbo].[vw_Department]  
(DeptCode,DeptName)as  
--select ID DeptCode,[Name] DeptName  
--from [FFANG-DT].[HRISDB].[dbo].[lkpDepartment]  
--where lower(ID)<>'other'  
  
/* Pre -SAP*/  
/*  
select DeptCode DeptCode, DeptDesc DeptName  
from [sql01].[employeedb].[dbo].[vw_Dept_Values]   
where lower(DeptCode)<>'other'  
*/  
/* Post - SAP */  
select DeptCode DeptCode, DeptDesc DeptName  
from [employeedb-devonly].[dbo].[tbl_Dept_values]   with (nolock)

GO
