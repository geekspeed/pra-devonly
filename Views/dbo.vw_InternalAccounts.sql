SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_InternalAccounts]  
as  
/* PRE-SAP */  
--selecet only accounts where company id='00' mlu's request  
/*  
select Department,Account_desc as AcctName, Account from [EXPANDABLE].[ESIDB].[dbo].glfca where Account_Status='A'and company_id='00'  
*/  
/*POST-SAP*/  
select AcctDesc as AcctName, AcctCode as Account  
from [employeedb-devonly].[dbo].[tbl_Accounts_SAP]  with (nolock)

GO
