SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetSuppliers]
@SupplierPrefix varchar(50)
as
SET NOCOUNT ON
select distinct TOP 50 SupplierName as TXT from [dbo].[vw_SupplierInfo] 
where LOWER(SupplierName) like LOWER(@SupplierPrefix)+'%'
GO
