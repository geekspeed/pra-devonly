SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetEmployee]
as

select  'EMPLOYEE' LookupType ,Name as TXT, lower(LoginId) as VAL  from vw_Ad_employee join vw_Employee on lower(loginId)=LOWER(employeeloginid)
order by Name ASC
GO
