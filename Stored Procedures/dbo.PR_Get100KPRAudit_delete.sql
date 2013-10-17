SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[PR_Get100KPRAudit_delete]
@PRNum int
AS
SET NOCOUNT ON
select * from (
select 'Created' Action,convert(varchar(10),CreatedDate,101) Date,isnull(EmployeeFirstName+' '+EmployeeLastName,CreatedBy)+' ('+CreatedBy+'@arubanetworks.com)' as UserName,'' Approverlevel from vw_PurchaseReq
left outer join vw_employee on CreatedBy=EmployeeLoginId where PRNum=@PRNum
union
select isnull(LookupText,ApproverResponse) Action,convert(varchar(10),ApproverResponseDate,101) Date,ApproverName +' ('+approveremail+')' as UserName,ApproverLevel from tbl_Approval_Chain 
left outer join tbl_lookup_values 
on lookupvalue=approverResponse where ApprovalPRNumber=@PRNum and ApproverResponse is not null and ApproverResponse not in ('PENDING','')and  LookupType='Status'
)M order by approverlevel,date
GO
