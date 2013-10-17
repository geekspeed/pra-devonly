SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetAcctDept]    
as    

select 'DEPT' as LookupType, DeptCode+' - ' + SUBSTRING (DeptName, 1, 10) as TXT, DeptCode as VAL from vw_department order by TXT    
  --accounts    
select 'ACCT' as LookupType,Account+' - ' + SUBSTRING (AcctName, 1, 10) TXT, Account as VAL  from vw_internalaccounts    
-- fxRate Symbols  
SELECT distinct to_symbol as TXT,'FXRATES' as LookupType, crate as VAL FROM fxrate_feeds where to_symbol = 'USD'
UNION ALL
--SELECT distinct to_symbol as TXT,'FXRATES' as LookupType, crate as VAL FROM fxrate_feeds where convert(varchar(11),created_date) >= (select convert(varchar(11),Max(created_date))  from fxrate_feeds) and to_symbol != 'USD'
SELECT distinct to_symbol as TXT,'FXRATES' as LookupType, crate as VAL FROM fxrate_feeds where active=1 and to_symbol != 'USD' -- to get only the active ones

GO
