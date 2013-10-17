SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetApprovalPRList]
@UserName varchar(100),
@PageSize int,
@PRType varchar(50),
@GetPage int
as
SET NOCOUNT ON
Declare @NoOfPages int, @TotalRows int,@startRow int,@EndRow int
Declare @thisSql varchar(max),@CountSql varchar(max),@SelectSql varchar(max),@PagerSql varchar(max),@userRole varchar(50),@UserId varchar(50),@Bod varchar(50),@Statuses varchar(max)
--addded: begin: this code to allow 'Purchasing' and 'Board of Directors' to be able to view pending PRs in their name viz: Purchasing
--set @UserId=''
--select @UserId = EmployeeloginId from vw_employee where EmployeeFirstName+' '+EmployeelastName=@UserName
set @UserRole='user'
--select @UserRole=RoleId from tbl_User_Roles where UserId=@UserId
select @UserRole=RoleId from tbl_User_Roles where UserId=@UserName
IF @UserRole='pur' and @UserName <> 'mgodsil'
BEGIN
--set @UserName='Purchasing'
set @UserName='dl-purchasereq'
END
set @UserName = @UserName+'@arubanetworks.com'
set @UserName = ''''+@UserName+''''
set @Bod=''
/*
select @Bod=LookupType from tbl_Lookup_Values where LookupText=@UserName
IF @Bod='BOD' 
BEGIN
--set @UserName='Board of Directors'
set @UserName='''Board of Directors'' OR AC.ApproverName=''Lory Lytle'''
END
*/
--print @UserName
--addded: ends

--set Status values
IF @PRType = 'PENDING'
	BEGIN
		set @Statuses = '''PENDING'''
	END
ELSE IF @PRType = 'COMPLETED'
	BEGIN
		set @Statuses = '''COMPLETED'',''CANCELLED'',''DECLINED'''
	END
ELSE
	BEGIN
		set @Statuses = '''PENDING'''
	END

set @CountSql = 'select count(*) from 
( select PR.PRNum,RequestorId,PRType,SupplierName,Status,PRValue,CreatedBy,CreatedDate  from 
vw_intl_PurchaseReq PR join ( 
select distinct AC.ApprovalPRNumber PRNum,AC.ApproverName from tbl_Approval_Chain   AC
left outer join 
( select ApprovalPRNumber PRNum,min(ApproverLevel) MinAppLevel  
from tbl_Approval_Chain  where (ApproverResponse=''PENDING'') group by approvalPRNumber
) MAL on AC.ApprovalPRNumber=MAL.PRNum  
	where AC.ApproverEmail='+@UserName+' and AC.ApproverLevel = MAL.MinApplevel
and UPPER(AC.ApproverResponse)=''PENDING'' ) PA 
ON PA.PRNum = PR.PRNum where PR.StatusValue  in ('+@Statuses+') ) x'


set @SelectSql = 'Select PRNum,isnull(AD.Name,RequestorId) RequestorId,Title,PRType,SupplierName,Status,PRValue,CreatedBy,CreatedDate ,Show,LastApprovalDate,RequestorDept,RequestedDate
from (
select 
ROW_NUMBER() OVER(ORDER BY APRCHAIN.LastApprovalDate desc,PR.PRNum DESC) AS rownum, PR.PRNum,PR.Title,RequestorId,PRType,SupplierName,Status,PRValue,CreatedBy,convert(varchar(10),CreatedDate,101) CreatedDate,isnull(PRA.Show,''false'') Show,APRCHAIN.LastApprovalDate LastApprovalDate,PR.RequestorDept,isnull(PR.RequestedDate,'''') RequestedDate   from 
vw_intl_PurchaseReq PR join (
	select distinct AC.ApprovalPRNumber PRNum,AC.ApproverName from 
	tbl_Approval_Chain   AC
	left outer join (
	select ApprovalPRNumber PRNum,min(ApproverLevel) MinAppLevel  from tbl_Approval_Chain  
where (ApproverResponse=''PENDING'' ) 
group by approvalPRNumber) MAL
	on AC.ApprovalPRNumber=MAL.PRNum  
	where AC.ApproverEmail='+@UserName+' and AC.ApproverLevel = MAL.MinApplevel and UPPER(AC.ApproverResponse)=''PENDING'') PA 
on PR.PRNum= PA.PRNum 
left outer join
(select PrNum, case Count(*) when 0 then ''false'' else ''true'' end as Show  from tbl_PurchaseReq_Attachments group by PRnum) PRA 
on PR.PrNum=PRA.PrNum
left outer join 
(select  approvalprnumber, max(approverresponsedate)  LastApprovalDate from tbl_Approval_Chain  where approverresponse in (''APPROVED'') group by approvalprnumber ) APRCHAIN
on PR.PrNum=APRCHAIN.ApprovalPRNumber 
where PR.StatusValue in ('+@Statuses+')'



CREATE TABLE #Data (var int)
set @thisSql = @CountSql
print @thisSql
INSERT #Data exec (@thisSql)
SELECT @TotalRows = var from #Data
DROP TABLE #Data
--print 'Total Rows = '+cast(@TotalRows as varchar(10))	
--check for "view all" condition
-- i.e. @GetPage = -1
IF @GetPage = -1
Begin
set @PageSize = @TotalRows
set @GetPage = 1
End

set @NoOfPages = @TotalRows/@PageSize
IF @TotalRows%@PageSize>0
Begin
set @NoOfPages = @NoOfPages+1
End

If @NoOfPages < @GetPage
Begin
set @GetPage=1
End

set @startRow = (@PageSize*(@GetPage-1))+1
set @EndRow = (@PageSize*@GetPage)
set @PagerSql =') x left outer join vw_AD_Employee AD on RequestorId=AD.loginId  where x.rownum>= '+cast(@startRow as varchar(10))+' and x.rownum <= '+cast(@EndRow as varchar(10))

--print @PagerSql

set @thisSql = @SelectSql+@PagerSql

print @thisSql

exec (@thisSql)

select @GetPage  PageNumber,
	   @NoOfPages  TotalPages,
       @TotalRows TotalRecords
GO
