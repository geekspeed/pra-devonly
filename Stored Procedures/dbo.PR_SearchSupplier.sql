SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_SearchSupplier]
@SearchCriteria varchar(4000),
@GetPage int,
@PageSize int
as
SET NOCOUNT ON
Declare @NoOfPages int, @TotalRows int,@startRow int,@EndRow int
Declare @thisSql varchar(8000),@CountSql varchar(500),@SelectSql varchar(3000),@PagerSql varchar(500)

set @CountSql = 'select count(*) from vw_SupplierInfo where '

set @SelectSql = 'select SupplierName,SupplierAddrLine1,SupplierAddrLine2,SupplierCity
,SupplierState,SupplierCountry,SupplierZipCode,SupplierTaxId,ContactName,ContactPhone,ContactFax,ContactEmail,SupplierCode from (
select 
ROW_NUMBER() OVER(ORDER BY SupplierName ASC) AS rownum
,SupplierName,SupplierAddrLine1,SupplierAddrLine2,SupplierCity
,SupplierState,SupplierCountry,SupplierZipCode,SupplierTaxId,ContactName,ContactPhone,ContactFax,ContactEmail,isnull(SupplierCode,'''') SupplierCode
 from vw_SupplierInfo
where '

--set @SearchCriteria = 'lower(SupplierName) like '''+@SearchCriteria+'%'''
--print @SearchCriteria
--set @PageSize=20
--print 'page Size = '+cast(@PageSize as varchar(10))
--print 'GetPage  = '+cast(@GetPage as varchar(10))

CREATE TABLE #Data (var int)
set @thisSql = @CountSql+@SearchCriteria
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
--print 'No Of Page = '+cast(@NoOfPages as varchar(10))
set @startRow = (@PageSize*(@GetPage-1))+1
set @EndRow = (@PageSize*@GetPage)
set @PagerSql =') x where x.rownum>= '+cast(@startRow as varchar(10))+' and x.rownum <= '+cast(@EndRow as varchar(10))
set @thisSql = @SelectSql+@SearchCriteria+@PagerSql

exec (@thisSql)

select @GetPage  PageNumber,
	   @NoOfPages  TotalPages,
       @TotalRows TotalRecords
GO
