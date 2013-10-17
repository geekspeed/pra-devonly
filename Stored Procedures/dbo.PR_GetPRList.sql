SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetPRList]
@UserID varchar(30),
@UserRole varchar(30),
@PageSize int,
@GetPage int
as
SET NOCOUNT ON
Declare @NoOfPages int, @TotalRows int,@startRow int,@EndRow int
Declare @thisSql varchar(max),@CountSql varchar(max),@SelectSql varchar(max),@PagerSql varchar(500),@SearchCriteria varchar(max)




IF UPPER(@UserRole)='USER' OR UPPER(@UserRole)='COO'
	BEGIN
		set @SearchCriteria = ' select  PRNum, RequestorId,Title, PRType,RequestorDept, SupplierName, PONumber, Status, PRValue,convert(varchar(10), CreatedDate,101) CreatedDate, CreatedBy,isnull(RequestedDate,'''') RequestedDate
 from vw_intl_PurchaseReq where ( requestorId='''+@UserId+'''or createdby='''+@UserId+''' ) and StatusValue NOT IN (''COMPLETED'',''DECLINED'',''CANCELLED'')' 
	END
ELSE IF UPPER(@UserRole) = 'INDIA-FIN-READ'
	BEGIN
		set @SearchCriteria = ' select  PRNum, RequestorId,Title, PRType,RequestorDept, SupplierName, PONumber, Status, PRValue,convert(varchar(10), CreatedDate,101) CreatedDate, CreatedBy,isnull(RequestedDate,'''') RequestedDate
 from vw_intl_PurchaseReq join vw_ad_employee on Requestorid = loginId and Country=''India'' where   StatusValue  IN (''PENDING'')' 
	END
ELSE
	BEGIN
		set @SearchCriteria = 'select PRNum,RequestorId,Title,PRType,RequestorDept, SupplierName, PONumber, Status, PRValue,convert(varchar(10), CreatedDate,101) CreatedDate, CreatedBy,isnull(RequestedDate,'''') RequestedDate
 from vw_intl_PurchaseReq where  StatusValue =''PENDING''  OR ( (requestorId='''+@UserId+'''or createdby='''+@UserId+''' ) and StatusValue = ''DRAFT'') ' 
	END

--set @CountSql = 'select count(*) from vw_intl_PurchaseReq PR '
set @CountSql = 'select count(*) from ('+@SearchCriteria+') PR '

set @SelectSql = 'Select PRNum,isnull(AD.Name,RequestorId) RequestorId,Title,PRType,RequestorDept,SupplierName,PONumber,Status,ApproverName,PRValue,CreatedBy,CreatedDate ,Show,RequestedDate
from (select ROW_NUMBER() OVER(ORDER BY PR.PRNum DESC) AS rownum
,PR.PRNum,PR.RequestorId,PR.Title,PR.PRType,PR.RequestorDept,PR.SupplierName,PR.PONumber,PR.Status,
case when PR.Status<>''PENDING'' then isnull(PA.ApproverName,'''') else isnull(PA.ApproverName,''Queued'') end ApproverName,PR.PRValue,convert(varchar(10),PR.CreatedDate,101) CreatedDate,PR.CreatedBy,isnull(PRA.Show,''false'') Show , PR.RequestedDate 
 from ('+@SearchCriteria +') PR left outer join 
(select distinct ApprovalPRNumber PRNum,isnull(Name,ApproverName)ApproverName,ApproverEmail from tbl_Approval_Chain  left outer join vw_ad_employee
on ApproverEmail = mail  where ApproverResponse=''PENDING''  )PA
 on PR.Prnum = PA.PRNum
left outer join
(select PrNum, case Count(*) when 0 then ''false'' else ''true'' end as Show  from tbl_PurchaseReq_Attachments where status <>''INACTIVE'' group by PRnum) PRA 
on PR.PrNum=PRA.PrNum
 '

--set @SearchCriteria = 'lower(SupplierName) like '''+@SearchCriteria+'%'''
--print @SearchCriteria
--set @PageSize=20
--print 'page Size = '+cast(@PageSize as varchar(10))
--print 'GetPage  = '+cast(@GetPage as varchar(10))

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
set @PagerSql =')x left outer join vw_AD_Employee AD on RequestorId=AD.loginId  where x.rownum>= '+cast(@startRow as varchar(10))+' and x.rownum <= '+cast(@EndRow as varchar(10))

--print @PagerSql

--set @thisSql = @SelectSql+@SearchCriteria+@PagerSql
set @thisSql = @SelectSql+@PagerSql

print @thisSql

exec (@thisSql)

select @GetPage  PageNumber,
	   @NoOfPages  TotalPages,
       @TotalRows TotalRecords
GO
