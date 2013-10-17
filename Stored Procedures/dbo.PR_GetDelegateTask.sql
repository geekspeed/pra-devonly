SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetDelegateTask]
as
SET NOCOUNT ON
select LookupId,LookupType,LookupText TXT, LookupValue VAL,isnull(ParentLookupId,0) ParentLookupID
from tbl_Lookup_values
where LookupType='DELEGATE_ACTION'
and Status='ACTIVE'
order by SortOrder asc
GO
