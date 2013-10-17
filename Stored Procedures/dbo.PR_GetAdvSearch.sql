SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetAdvSearch]
@UserID varchar(30),
@SearchCriteria varchar(max),
@PageSize int,
@GetPage int,
@Order varchar(250) = 'PR.PRNum DESC'
AS
SET NOCOUNT ON
Declare @NoOfPages int, @TotalRows int,@startRow int,@EndRow int,@UserRole varchar(128),@UserDept varchar(4000),@contructSearchSql varchar(max)
Declare @thisSql varchar(max),@CountSql varchar(max),@SelectSql varchar(max),@PagerSql varchar(max),@SearchSql varchar(max),@RoleSql varchar(max),@IndiaFinSql varchar(max)
Set @UserRole = 'USER';
Select @UserRole = upper(RoleId) from tbl_User_Roles where UserId=@UserId
set @UserDept = null
set @RoleSql= ''
set @contructSearchSql = ''
SET @IndiaFinSql = ''

if(@UserRole = 'PUR')
Begin
set @UserID = 'dl-purchasereq'
End

if(@UserRole = 'PRADMIN')
Begin
set @UserID = ''
End



SELECT @UserDept = COALESCE(@UserDept+',' ,'') + convert(varchar(10),EmployeedeptId)
  from (
select EmployeedeptId from vw_Employee with(nolock) where employeeLoginid=@UserID
		union
select DeptId from tbl_User_Dept with(nolock) where UserId=@UserId and IsActive=1)x

SET @RoleSql = ' 1=1 '

if( @UserDept <> '' )
BEGIN 
	SET @RoleSql = @RoleSql +  ' AND (RequestorDept IN ( '+@UserDept+'))' --'set departments
END 

IF UPPER(@UserRole)='USER'
	BEGIN
	SET @RoleSql = @RoleSql
	END
ELSE IF UPPER(@UserRole) = 'INDIA-FIN-READ'
BEGIN
	SET @IndiaFinSql = ' INNER JOIN vw_ad_employee ON RequestorID = loginId and Country=''India'''
	SET @RoleSql =' 1=1 '
END
ELSE -- to account for FIN and PUR users - Vivek 2012-12-07
BEGIN
	SET @RoleSql =' 1=1 '
END


SET @contructSearchSql = 'select PRNum from tbl_PRNumbers with(nolock) where 1=1 '

PRINT ' @IndiaFinSql - ' + @IndiaFinSql 
PRINT ' @@UserRole - ' + @UserRole 


 IF (charindex('PRNumbers', @SearchCriteria) > 0 AND charindex('#7', @SearchCriteria) > 0)
  BEGIN
   SET @contructSearchSql = @contructSearchSql + 'AND PRNum IN (' -- change AND to OR
	SET @contructSearchSql = @contructSearchSql + ' SELECT PRNum from tbl_PRNumbers with(nolock) where '+ SUBSTRING(@SearchCriteria,charindex('PRNumbers', @SearchCriteria)+10,charindex('#7', @SearchCriteria) - charindex('PRNumbers', @SearchCriteria) - 11) 
	SET @contructSearchSql = @contructSearchSql + ' ) '
	--SET @contructSearchSql= @contructSearchSql + ' UNION'	
	
 END

 IF (charindex('PrTable', @SearchCriteria) > 0 AND charindex('#2', @SearchCriteria) > 0)
  BEGIN
   SET @contructSearchSql = @contructSearchSql + 'AND PRNum IN ('
	SET @contructSearchSql =  @contructSearchSql + ' select PRNum from tbl_Purchasereq with(nolock)  join tbl_PRnumbers with(nolock) on tbl_PRnumbers.PRId = tbl_purchasereq.PRID where '+ SUBSTRING(@SearchCriteria,charindex('PrTable', @SearchCriteria)+8,charindex('#2', @SearchCriteria) - charindex('PrTable', @SearchCriteria) - 9) 
	SET @contructSearchSql = @contructSearchSql + ' ) '
	--SET @contructSearchSql= @contructSearchSql + ' UNION'	
 END 
 
  IF (charindex('PrTable1', @SearchCriteria) > 0 AND charindex('#8', @SearchCriteria) > 0)  
  BEGIN  
   SET @contructSearchSql = @contructSearchSql + 'AND PRNum IN ('   -- changed from OR to AND vivek 2012-12-07
 SET @contructSearchSql =  @contructSearchSql + ' select PRNum from tbl_Purchasereq_cart with(nolock)  join tbl_PRnumbers with(nolock) on tbl_PRnumbers.PRId = tbl_Purchasereq_cart.PRID where '+ SUBSTRING(@SearchCriteria,charindex('PrTable1', @SearchCriteria)+9,charindex('#8', @SearchCriteria) - charindex('PrTable1', @SearchCriteria) - 9)   
 SET @contructSearchSql = @contructSearchSql + ' ) '  
 --SET @contructSearchSql= @contructSearchSql + ' UNION'   
 END   

 IF (charindex('EmpTable', @SearchCriteria) > 0 AND charindex('#1', @SearchCriteria) > 0)
 BEGIN
    SET @contructSearchSql = @contructSearchSql + 'AND PRNum IN ('
	SET @contructSearchSql = @contructSearchSql +' SELECT PRNum from tbl_Purchasereq PR with(nolock) join tbl_PRnumbers with(nolock) on tbl_PRnumbers.PRId = PR.PRID INNER JOIN vw_AD_Employee E ON PR.RequestorId = E.loginId where  E.Name LIKE '+ SUBSTRING(@SearchCriteria,charindex('EmpTable', @SearchCriteria)+9,charindex('#1', @SearchCriteria) - charindex('EmpTable', @SearchCriteria) - 10)
	SET @contructSearchSql = @contructSearchSql + ' ) '
	--SET @contructSearchSql= @contructSearchSql + ' UNION'		
 END

 IF (charindex('DepartmentTable', @SearchCriteria) > 0 AND charindex('#3', @SearchCriteria) > 0)
 BEGIN
  SET @contructSearchSql = @contructSearchSql + 'AND PRNum IN ('
	SET @contructSearchSql = @contructSearchSql + ' select PRNum from tbl_Purchasereq PR with(nolock) join tbl_PRnumbers with(nolock) on tbl_PRnumbers.PRId = PR.PRID INNER JOIN dbo.vw_Department as DT on PR.RequestorDept = DT.DeptCode WHERE DT.DeptName LIKE '+ SUBSTRING(@SearchCriteria,charindex('DepartmentTable', @SearchCriteria)+16,charindex('#3', @SearchCriteria) - charindex('DepartmentTable', @SearchCriteria) - 17)
		SET @contructSearchSql = @contructSearchSql + ' ) '
	--SET @contructSearchSql= @contructSearchSql + ' UNION'	
 END 
 
 IF (charindex('SupplierTable', @SearchCriteria) > 0 AND charindex('#4', @SearchCriteria) > 0)
 BEGIN
  SET @contructSearchSql = @contructSearchSql + 'AND PRNum IN ('
	SET @contructSearchSql = @contructSearchSql + ' select PRNum from tbl_Purchasereq with(nolock) join tbl_PRnumbers with(nolock) on tbl_PRnumbers.PRId = tbl_purchasereq.PRID where tbl_purchasereq.PRID IN '+
	'( 
		SELECT DISTINCT PC.PRID
		FROM   dbo.tbl_PurchaseReq_Cart AS PC with(nolock) LEFT OUTER JOIN
		dbo.tbl_Part_Supplier AS PS with(nolock) ON PC.PartSupplierId = PS.PartSupplierId LEFT OUTER JOIN
		dbo.tbl_SupplierInfo AS S with(nolock) ON PS.SupplierId = S.SupplierId WHERE S.SupplierName LIKE '+SUBSTRING(@SearchCriteria,charindex('SupplierTable', @SearchCriteria)+14,charindex('#4', @SearchCriteria) - charindex('SupplierTable', @SearchCriteria) - 15)+')'
	SET @contructSearchSql = @contructSearchSql + ' ) '
	--SET @contructSearchSql= @contructSearchSql + ' UNION'	
 END 
 
  IF (charindex('PrTypeTable', @SearchCriteria) > 0 AND charindex('#5', @SearchCriteria) > 0)
 BEGIN
 SET @contructSearchSql = @contructSearchSql + 'AND PRNum IN ('
	SET @contructSearchSql = @contructSearchSql + ' SELECT PRNum  FROM tbl_purchasereq PR with(nolock) LEFT OUTER JOIN tbl_Lookup_Values AS LK with(nolock) ON PR.GLCode = LK.LookupValue join tbl_PRnumbers with(nolock) on tbl_PRnumbers.PRId = PR.PRID WHERE LK.LookupText IN '+SUBSTRING(@SearchCriteria,charindex('PrTypeTable', @SearchCriteria)+12,charindex('#5', @SearchCriteria) - charindex('PrTypeTable', @SearchCriteria) - 13)
	SET @contructSearchSql = @contructSearchSql + ' ) '
	--SET @contructSearchSql= @contructSearchSql + ' UNION'	
 END 
 
  IF (charindex('ApprovalTable', @SearchCriteria) > 0 AND charindex('#6', @SearchCriteria) > 0)
 BEGIN
 SET @contructSearchSql = @contructSearchSql + 'AND PRNum IN ('
	SET @contructSearchSql = @contructSearchSql + '  SELECT approvalPRNumber from tbl_Approval_Chain PC with(nolock) WHERE PC.ApproverResponse <>'''' AND PC.ApproverResponse <> ''EMAIL_NOT_SENT'' AND PC.ApproverResponse = ''PENDING''  AND PC.ApproverName LIKE '+SUBSTRING(@SearchCriteria,charindex('ApprovalTable', @SearchCriteria)+14,charindex('#6', @SearchCriteria) - charindex('ApprovalTable', @SearchCriteria) - 15)
	SET @contructSearchSql = @contructSearchSql + ' ) '
	--SET @contructSearchSql= @contructSearchSql + ' UNION'	
 END 
 


 

IF (CHARINDEX('NOINU',REVERSE(@contructSearchSql)) > 0 )
BEGIN
SET @contructSearchSql  =LEFT(@contructSearchSql,LEN(@contructSearchSql)- CHARINDEX('NOINU',REVERSE(@contructSearchSql))- 4) --CHARINDEX(' NOINU ',' ' + REPLACE(REPLACE(REVERSE(@contructSearchSql),',',' '),'.',' ') + ' ')
END
 
PRINT '@ContructSearchSql - ' + @contructSearchSql

SET @SearchSql = ' select  PRNum, RequestorName,Title, PRType, SupplierName, PONumber, Status, PRValue,convert(varchar(10), CreatedDate,101) CreatedDate, CreatedBy,ApproverName,isnull(convert(varchar(10), PODate,101),'''') PODate ,DepartmentNameText DeptName,isnull(convert(varchar(10), RequestedDate,101),'''') RequestedDate,isnull(BuyerId,'''') BuyerId, AcctCharged, DeptCharged
 from vw_Adv_Search_PurchaseReq '+ @IndiaFinSql  +'  where '+ @RoleSql +' AND PRNum IN (
'+@contructSearchSql+') ' 

-- bug : include PRs that are in Approval chain for approvers ; eg: kevin to have visibility of  IT's PRs
SET @SearchSql = @SearchSql + ' union select  PRNum, RequestorName,Title, PRType, SupplierName, PONumber, Status, PRValue,convert(varchar(10), CreatedDate,101) CreatedDate, CreatedBy,ApproverName,isnull(convert(varchar(10), PODate,101),'''') PODate ,DepartmentNameText DeptName,isnull(convert(varchar(10), RequestedDate,101),'''') RequestedDate,isnull(BuyerId,'''') BuyerId, AcctCharged, DeptCharged from vw_Adv_Search_PurchaseReq where PRNum  in(  select approvalPRnumber from tbl_approval_chain where approvalPRNumber IN
									('+@ContructSearchSql+' )and ApproverResponse not in ('''',''EMAIL_NOT_SENT'') and ApproverEmail like ''%'+@Userid+'%@arubanetworks.com'''+')'

print '@SearchSql - ' + @SearchSql

SET @CountSql = 'select count(*) from ('+@SearchSql+') PR '

--PRINT '@CountSql - ' + @CountSql

set @SelectSql = 'Select PRNum,RequestorName RequestorId,DeptName,Title,PRType,PRValue,Status,ApproverName,SupplierName,RequestedDate,CreatedDate,PODate,PONumber,BuyerId,Show, AcctCharged, DeptCharged
from (select ROW_NUMBER() OVER(ORDER BY '+@Order+') AS rownum
,PR.PRNum,PR.RequestorName,PR.Title,PR.PRType,PR.SupplierName,PR.PONumber,PR.Status,isnull(PR.ApproverName,'''') ApproverName,PR.PRValue,convert(varchar(10),PR.CreatedDate,101) CreatedDate,PR.CreatedBy,PR.PODate,PR.DeptName,PR.RequestedDate,PR.BuyerId,isnull(PRA.Show,''false'') Show, AcctCharged, DeptCharged
 from ('+@SearchSql +') PR left outer join
(select PrNum, case Count(*) when 0 then ''false'' else ''true'' end as Show  from tbl_PurchaseReq_Attachments group by PRnum) PRA 
on PR.PrNum=PRA.PrNum
 '

print '@SelectSql - '  + @SelectSql
CREATE TABLE #Data (var int)
--set @thisSql = @CountSql+@SearchCriteria
set @thisSql = @CountSql
--print @thisSql
INSERT #Data exec (@thisSql)
SELECT @TotalRows = var from #Data
DROP TABLE #Data

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
set @PagerSql =') x where x.rownum>= '+cast(@startRow as varchar(10))+' and x.rownum <= '+cast(@EndRow as varchar(10))

print @PagerSql

set @thisSql = @SelectSql+@PagerSql

print @thisSql

exec (@thisSql)

select @GetPage  PageNumber,
	   @NoOfPages  TotalPages,
       @TotalRows TotalRecords

GO
