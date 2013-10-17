SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetDeptPRs]
@UserID varchar(30),
@DeptNo int,
@PageSize int,
@PRType varchar(50),
@GetPage int
as
SET NOCOUNT ON
Declare @NoOfPages int, @TotalRows int,@startRow int,@EndRow int
Declare @thisSql varchar(max),@CountSql varchar(max),@SelectSql varchar(max),@PagerSql varchar(500),@SearchCriteria varchar(max),@Statuses varchar(max)
Declare @UserDeptId int
Declare @UserDeptList varchar(400)
set @UserDeptId = 0
IF @DeptNo = -1
	BEGIN
		SELECT @UserDeptList = COALESCE(@UserDeptList+',' ,'') + convert(varchar(10),EmployeedeptId)
  from (
select EmployeedeptId from vw_Employee where employeeLoginid=@UserID
		union
select DeptId from tbl_User_Dept where UserId=@UserID and IsActive=1)x
	END
ELSE
	BEGIN
		Set @UserDeptId = @DeptNo
	END
	--set @UserDeptList = cast(@UserDeptId as varchar(50))
	--IF @UserID = 'kmorris'
	--Begin
	--	Set @UserDeptList = '600,608'
	--End
	--IF @UserID ='cliu' OR @UserId='xiali'
	--BEGIN
	--	set @UserDeptList = '110,215,225,315,415,425,528,648,710,720,740,750'
	--END

	

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

set @searchCriteria = 'select  PRNum, RequestorId,Title, PRType, SupplierName, PONumber, Status, PRValue,convert(varchar(10), CreatedDate,101) CreatedDate, CreatedBy from vw_intl_PurchaseReq where RequestorDept  in (' + @UserDeptList +') and StatusValue IN ('+@Statuses+')' 

set @CountSql = 'select count(*) from ('+@SearchCriteria+') PR '

set @SelectSql = 'Select PRNum,isnull(AD.Name,RequestorId) RequestorId,Title,PRType,SupplierName,PONumber,Status,ApproverName,PRValue,CreatedBy,CreatedDate ,Show
from (select ROW_NUMBER() OVER(ORDER BY PR.PRNum DESC) AS rownum
,PR.PRNum,PR.RequestorId,PR.Title,PR.PRType,PR.SupplierName,PR.PONumber,PR.Status,isnull(PA.ApproverName,'''') ApproverName,PR.PRValue,convert(varchar(10),PR.CreatedDate,101) CreatedDate,PR.CreatedBy,isnull(PRA.Show,''false'') Show
 from ('+@SearchCriteria +') PR left outer join 
(select distinct ApprovalPRNumber PRNum,ApproverName from tbl_Approval_Chain  where ApproverResponse=''PENDING''  )PA
 on PR.Prnum = PA.PRNum
left outer join
(select PrNum, case Count(*) when 0 then ''false'' else ''true'' end as Show  from tbl_PurchaseReq_Attachments group by PRnum) PRA 
on PR.PrNum=PRA.PrNum
 '



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
set @PagerSql =') x  left outer join vw_AD_Employee AD on RequestorId=AD.loginId where x.rownum>= '+cast(@startRow as varchar(10))+' and x.rownum <= '+cast(@EndRow as varchar(10))

--print @PagerSql

--set @thisSql = @SelectSql+@SearchCriteria+@PagerSql
set @thisSql = @SelectSql+@PagerSql

print @thisSql

exec (@thisSql)

select @GetPage  PageNumber,
	   @NoOfPages  TotalPages,
       @TotalRows TotalRecords
GO
