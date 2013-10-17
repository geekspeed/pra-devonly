SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetClosedPRList]
@UserID varchar(30),
@PageSize int,
@GetPage int
as
SET NOCOUNT ON
Declare @UserRole as varchar(20)
Declare @NoOfPages int, @TotalRows int,@startRow int,@EndRow int
Declare @thisSql varchar(max),@CountSql varchar(max),@SelectSql varchar(max),@PagerSql varchar(500),@SearchCriteria varchar(max)
--set Roles
set @UserRole='user'
select @UserRole=RoleId from tbl_User_Roles where UserId=@UserId
if(UPPER(@UserID)='MGODSIL' OR UPPER(@UserID)='JASONL' ) -- HD 64851
Begin
set @USerRole='pur'
End

IF UPPER(@UserRole)='USER' OR UPPER(@UserRole)='COO'
	BEGIN
		set @SearchCriteria = ' where (PR.requestorID='''+@UserID+''' or PR.createdBY='''+@UserID+''') and PR.StatusValue in (''COMPLETED'',''DECLINED'',''CANCELLED'') ' 
	END
ELSE IF UPPER(@UserRole)='FIN'
	BEGIN
--for pur role I am removeing ,''DECLINED'',''CANCELLED''
		set @SearchCriteria = ' where (PR.requestorId is not null) and PR.StatusValue in (''COMPLETED'') ' 
	END
ELSE IF UPPER(@UserRole)='PUR'
	BEGIN
--for pur role I am removeing ,''DECLINED'',''CANCELLED''
		 set @SearchCriteria = 'where ((PR.requestorID='''+@UserId+''' or PR.createdBY='''+@UserId+''' ) 
and PR.StatusValue in (''COMPLETED'') ) OR ( (PR.BuyerId='''+@UserId+''' or PR.BuyerId is null) and PR.StatusValue in (''COMPLETED'') )' 
	END
ELSE IF UPPER(@UserRole)='INDIA-FIN-READ'
	BEGIN
--search only completed PRs for India Employees
		 set @SearchCriteria = ' where (AD.Country=''India'' and  PR.StatusValue in (''COMPLETED'') )'
	END
ELSE
	BEGIN
	set @SearchCriteria = 'where PR.StatusValue in (''COMPLETED'',''DECLINED'',''CANCELLED'')' 
	END

set @CountSql = 'select count(*) from vw_intl_PurchaseReq PR join vw_ad_employee AD on PR.RequestorId = AD.LoginId '

set @SelectSql = 'Select PRNum,isnull(AD.Name,RequestorId) RequestorId,Title,PRType,SupplierName,PONumber,Status,ApproverName,PRValue,CreatedBy,CreatedDate ,Show
from (select ROW_NUMBER() OVER(ORDER BY PR.PRNum DESC) AS rownum
,PR.PRNum,PR.RequestorId,PR.Title,PR.PRType,PR.SupplierName,PR.PONumber,PR.Status,isnull(PA.ApproverName,'''') ApproverName,PR.PRValue,convert(varchar(10),PR.CreatedDate,101) CreatedDate,PR.CreatedBy,isnull(PRA.Show,''false'') Show
 from vw_intl_PurchaseReq PR join vw_ad_employee AD on PR.RequestorId = AD.LoginId left outer join 
(select distinct ApprovalPRNumber PRNum,ApproverName from tbl_Approval_Chain  where ApproverResponse=''PENDING''  )PA
 on PR.Prnum = PA.PRNum
left outer join
(select PrNum, case Count(*) when 0 then ''false'' else ''true'' end as Show  from tbl_PurchaseReq_Attachments group by PRnum) PRA 
on PR.PrNum=PRA.PrNum
 '

--set @SearchCriteria = 'lower(SupplierName) like '''+@SearchCriteria+'%'''
--print @SearchCriteria
--set @PageSize=20
--print 'page Size = '+cast(@PageSize as varchar(10))
--print 'GetPage  = '+cast(@GetPage as varchar(10))

CREATE TABLE #Data (var int)
set @thisSql = @CountSql+@SearchCriteria
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
set @PagerSql =') x   left outer join vw_AD_Employee AD on RequestorId=AD.loginId where x.rownum>= '+cast(@startRow as varchar(10))+' and x.rownum <= '+cast(@EndRow as varchar(10)) 
--print @PagerSql


set @thisSql = @SelectSql+@SearchCriteria+@PagerSql

print @thisSql

exec (@thisSql)

select @GetPage  PageNumber,
	   @NoOfPages  TotalPages,
       @TotalRows TotalRecords
GO
