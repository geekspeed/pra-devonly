SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetApprovalHistory]
@UserId varchar(40),
@PageSize int,
@PRType varchar(50),
@GetPage int
as
SET NOCOUNT ON
Declare @NoOfPages int, @TotalRows int,@startRow int,@EndRow int
Declare @thisSql varchar(max),@CountSql varchar(max),@SelectSql varchar(max),@PagerSql varchar(max),@UserRole varchar(50),@UserEmail varchar(100),@Statuses varchar(max)--,@Bod varchar(50)
Declare @addBuyerCriteria varchar(max)
set @addBuyerCriteria = ''
--addded: begin: this code to allow 'Purchasing' and 'Board of Directors' to be able to view pending PRs in their name viz: Purchasing

set @UserEmail = @UserId+'@arubanetworks.com'
set @UserRole='user'
select @UserRole=RoleId from tbl_User_Roles where UserId=@UserId
IF @UserRole='pur' 
BEGIN
set @UserEmail='dl-PurchaseReq@arubanetworks.com'
set @addBuyerCriteria = 'and (BuyerId = '''+@UserId+''' OR BuyerId is NULL)'
END

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

/*
set @Bod=''
select @Bod=LookupType from tbl_Lookup_Values where LookupValue=@UserId
IF @Bod='BOD' 
BEGIN
set @UserEmail='Board of Directors'
END
*/
--print @UserName
--addded: ends

set @CountSql = 'select count(*) from 
( select 
PR.PRNum,RequestorId,PRType,SupplierName,Status as [Current Status],PRValue,CreatedBy,convert(varchar(10),CreatedDate,101) CreatedDate,BuyerID,
AC.ApproverResponse as [Your Response],convert(varchar(10),MAD.ApproverResponseDate,101) ApproverResponseDate
from 
vw_intl_PurchaseReq PR join 
tbl_Approval_Chain  AC on AC.ApprovalPRNumber=PR.PRNum   join
(select ApprovalPRNumber,max(ApproverResponseDate)ApproverResponseDate from tbl_approval_Chain where approverEmail= '''+ @UserEmail +''' group by ApprovalPRNumber,ApproverEmail)MAD  on MAD.ApprovalPRNumber = AC.ApprovalPRNumber
where 
AC.approverEmail='''+@UserEmail+''''+@addBuyerCriteria + 'and LEN(ltrim(rtrim(AC.ApproverResponse)))>0 and AC.ApproverResponse not in (''PENDING'')  and StatusValue IN ('+@Statuses+') ) x'

set @SelectSql = 'Select distinct PRNum,RequestorId,Title,PRType,SupplierName,CurrentStatus,PRValue,CreatedBy,CreatedDate ,YourResponse,ApproverResponseDate,Show,ApproverName,ModifiedDate
from (
select 
ROW_NUMBER() OVER(ORDER BY PR.ModifiedDate DESC) AS rownum, 
PR.PRNum,RequestorId,PR.Title,PRType,SupplierName,PR.Status as [CurrentStatus],PRValue,PR.CreatedBy,convert(varchar(10),PR.CreatedDate,101) CreatedDate,BuyerID,
isnull(LV.LookupText,AC.ApproverResponse) as [YourResponse],convert(varchar(10),MAD.ApproverResponseDate,101) ApproverResponseDate,
isnull(PRA.Show,''false'') Show,AppName.ApproverName, MAD.ApproverResponseDate as ResponseDate, CONVERT(varchar(10), PR.ModifiedDate,102) ModifiedDate  from 
vw_intl_PurchaseReq PR join tbl_Approval_Chain  AC on AC.ApprovalPRNumber=PR.PRNum   join
(select ApprovalPRNumber,max(ApproverResponseDate)ApproverResponseDate from tbl_approval_Chain where approverEmail= '''+ @UserEmail +''' group by ApprovalPRNumber,ApproverEmail)MAD  on MAD.ApprovalPRNumber = AC.ApprovalPRNumber
left outer join
(select PrNum, case Count(*) when 0 then ''false'' else ''true'' end as Show  from tbl_PurchaseReq_Attachments group by PRnum) PRA 
on PR.PrNum=PRA.PrNum left outer join tbl_lookup_values LV on LV.LookupValue=AC.ApproverResponse 
left outer join
(	select ApprovalPRNumber,ApproverName from tbl_approval_Chain where ApproverResponse = ''PENDING'' 

 )	AppName  on AppName.ApprovalPRNumber = AC.ApprovalPRNumber
	 where
AC.approverEmail='''+@UserEmail+''''+@addBuyerCriteria + 'and LEN(ltrim(rtrim(AC.ApproverResponse)))>0 and AC.ApproverResponse not in (''PENDING'')  and LV.LookupType=''Status''  and StatusValue IN ('+@Statuses+') '



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
set @PagerSql =') x where x.rownum>= '+cast(@startRow as varchar(10))+' and x.rownum <= '+cast(@EndRow as varchar(10))

--print @PagerSql

set @thisSql = @SelectSql+@PagerSql

print @thisSql

exec (@thisSql)

select @GetPage  PageNumber,
	   @NoOfPages  TotalPages,
       @TotalRows TotalRecords
GO
