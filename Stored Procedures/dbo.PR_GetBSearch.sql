SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetBSearch]
@UserID varchar(30),
@SearchCriteria varchar(max),
@PageSize int,
@GetPage int
as
SET NOCOUNT ON
Declare @NoOfPages int, @TotalRows int,@startRow int,@EndRow int,@UserRole varchar(10),@UserDept varchar(10),@contructSearchSql varchar(max)
Declare @thisSql varchar(max),@CountSql varchar(max),@SelectSql varchar(max),@PagerSql varchar(max),@SearchSql varchar(max),@RoleSql varchar(max)
Set @UserRole = 'USER';
Select @UserRole = upper(RoleId) from tbl_User_Roles with(nolock) where UserId=@UserId
set @UserDept = null
set @RoleSql= ''
set @contructSearchSql = ''
IF @UserRole = 'USER'
BEGIN
Select @UserDept = EmployeeDeptId from vw_employee with(nolock) where EmployeeLoginId=@UserId
SET @RoleSql = '(RequestorDept = '''+@UserDept+''') AND'

END

if(@UserRole = 'PUR')
Begin
set @UserID = 'dl-purchasereq'
End

if(@UserRole = 'PRADMIN')
Begin
set @UserID = ''
End

SET @contructSearchSql = ''
--VB 2013-06-11 prevent names or searches with single quote affecting the query
set @SearchCriteria = REPLace(@SearchCriteria,'''','''''')

 ---- Requestor Name
 --SET @contructSearchSql = @contructSearchSql + ' PRNum IN ('
 --SET @contructSearchSql =  @contructSearchSql + ' select PRNum from tbl_Purchasereq PR join tbl_PRnumbers on tbl_PRnumbers.PRId = PR.PRID INNER JOIN vw_Employee Emp ON PR.RequestorID = Emp.EmployeeLoginID  where(Emp.EmployeeFirstName like ''%'+   @SearchCriteria + '%'' OR Emp.EmployeeLastName like ''%'+   @SearchCriteria + '%'')'
 --SET @contructSearchSql = @contructSearchSql + ' ) '  
 
 ---- Requestor Departmnet
 --SET @contructSearchSql = @contructSearchSql + 'OR PRNum IN ('
 --SET @contructSearchSql =  @contructSearchSql + ' select PRNum from tbl_Purchasereq PR join tbl_PRnumbers on tbl_PRnumbers.PRId = PR.PRID INNER JOIN vw_Department Dept ON Dept.DeptCode = PR.RequestorDept  where ( Dept.DeptCode  LIKE ''%'+   @SearchCriteria + '%'' OR dept.DeptName LIKE ''%'+   @SearchCriteria + '%'')'
 --SET @contructSearchSql = @contructSearchSql + ' ) '  
 
 -- Justification
 SET @contructSearchSql = @contructSearchSql + ' PRNum IN ('
 SET @contructSearchSql =  @contructSearchSql + ' select PRNum from tbl_Purchasereq PR with(nolock) INNER JOIN tbl_PRnumbers with(nolock) on tbl_PRnumbers.PRId = PR.PRID  where PR.Justification LIKE ''%'+   @SearchCriteria + '%'''
 SET @contructSearchSql = @contructSearchSql + ' ) ' 
 
 -- SupplierName
 SET @contructSearchSql = @contructSearchSql + 'OR PRNum IN ('
 SET @contructSearchSql =  @contructSearchSql + ' select DISTINCT PRNum from tbl_SupplierInfo with(nolock) join tbl_Part_Supplier with(nolock) on tbl_SupplierInfo.SupplierId=tbl_Part_Supplier.SupplierId  join tbl_purchasereq_cart PC with (nolock) on PC.PartSupplierId = tbl_Part_Supplier.PartSupplierId   join tbl_Purchasereq PR ON PR.PRId =  PC.PRID join tbl_PRnumbers on tbl_PRnumbers.PRId = PR.PRID WHERE tbl_SupplierInfo.SupplierName LIKE ''%'+   @SearchCriteria + '%'''
 SET @contructSearchSql = @contructSearchSql + ' ) '  
 
 ---- Ship To Name
 --SET @contructSearchSql = @contructSearchSql + 'OR PRNum IN ('
 --SET @contructSearchSql =  @contructSearchSql + ' select PRNum from tbl_Purchasereq join tbl_PRnumbers on tbl_PRnumbers.PRId = tbl_Purchasereq.PRID  where ShipName LIKE ''%'+   @SearchCriteria + '%'''
 --SET @contructSearchSql = @contructSearchSql + ' ) '  
 
 -- Comments
 SET @contructSearchSql = @contructSearchSql + 'OR PRNum IN ('
 SET @contructSearchSql =  @contructSearchSql + ' select PRNum from tbl_Purchasereq with(nolock) join tbl_PRnumbers with(nolock) on tbl_PRnumbers.PRId = tbl_Purchasereq.PRID  where Comments LIKE ''%'+   @SearchCriteria + '%'''
 SET @contructSearchSql = @contructSearchSql + ' ) '  
 
 -- Part Description
 SET @contructSearchSql = @contructSearchSql + 'OR PRNum IN ('
 SET @contructSearchSql =  @contructSearchSql + ' select Distinct PRNum from dbo.tbl_Purchasereq PR with(nolock)
		INNER JOIN tbl_purchasereq_cart pc with (nolock) on PR.PRId = pc.PRID
		INNER JOIN tbl_Part_Info PI with (nolock) on PC.ItemID = PI.PartId
		INNER JOIN tbl_PRnumbers with (nolock) on tbl_PRnumbers.PRId = PR.PRID
		WHERE PI.PartDesc LIKE ''%'+   @SearchCriteria + '%'')'
 SET @contructSearchSql = @contructSearchSql + '  '  
 
 -- bug : include PRs that are in Approval chain for approvers ; eg: kevin to have visibility of  IT's PRs
PRINT @contructSearchSql

SET @SearchSql = ' select  PRNum, RequestorId,Title, PRType, SupplierName, PONumber, Status, PRValue,convert(varchar(10), CreatedDate,101) CreatedDate, CreatedBy,ApproverName
 from vw_search_PurchaseReq with(nolock) where '+ @RoleSql +' (
 ShipName like (''%'+@SearchCriteria+'%'')
OR ContactName like (''%'+@SearchCriteria+'%'')
OR PRNum like (''%'+@SearchCriteria+'%'')
OR Title like (''%'+@SearchCriteria+'%'')
OR intl_PONumber like (''%'+@SearchCriteria+'%'')
OR PONumber like (''%'+@SearchCriteria+'%'') OR ' + @contructSearchSql +
 ') and StatusValue NOT IN (''DRAFT'')' 
 
 SET @SearchSql = @SearchSql + ' union select  PRNum, RequestorId,Title, PRType, SupplierName, PONumber, Status, PRValue,convert(varchar(10), CreatedDate,101) CreatedDate, CreatedBy,ApproverName
  from vw_search_PurchaseReq with(nolock) where PRNum  in (  select approvalPRnumber from tbl_approval_chain with(nolock) where approvalPRNumber IN
									( select PRNum from tbl_Purchasereq with(nolock) join tbl_PRnumbers with (nolock) on tbl_PRnumbers.PRId = tbl_Purchasereq.PRID WHERE convert(varchar(32),PRNum) = '''+@SearchCriteria+''' OR ' + @contructSearchSql +' )and ApproverResponse not in ('''',''EMAIL_NOT_SENT'') and ApproverEmail like ''%'+@Userid+'%@arubanetworks.com'''+')'

print @SearchSql


set @CountSql = 'select count(*) from ('+@SearchSql+') PR '

set @SelectSql = 'Select PRNum, isnull(AD.Name,RequestorId) RequestorId,Title,PRType,SupplierName,PONumber,Status,ApproverName,PRValue,CreatedBy,CreatedDate ,Show
from (select ROW_NUMBER() OVER(ORDER BY PR.PRNum DESC) AS rownum
,PR.PRNum,PR.RequestorId,PR.Title,PR.PRType,PR.SupplierName,PR.PONumber,PR.Status,isnull(PR.ApproverName,'''') ApproverName,PR.PRValue,convert(varchar(10),PR.CreatedDate,101) CreatedDate,PR.CreatedBy,isnull(PRA.Show,''false'') Show
 from ('+@SearchSql +') PR left outer join
(select PrNum, case Count(*) when 0 then ''false'' else ''true'' end as Show  from tbl_PurchaseReq_Attachments with (nolock) group by PRnum) PRA 
on PR.PrNum=PRA.PrNum
 '

PRINT @SelectSql

CREATE TABLE #Data (var int)
--set @thisSql = @CountSql+@SearchCriteria
set @thisSql = @CountSql
--print @thisSql
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

--print @thisSql

exec (@thisSql)

select @GetPage  PageNumber,
	   @NoOfPages  TotalPages,
       @TotalRows TotalRecords
GO
