SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetSupplierInfo]
@PRNum int
as
SET NOCOUNT ON
SELECT SI.SupplierId
      ,[SupplierName]
      ,[SupplierAddrLine1]
      ,[SupplierAddrLine2]
      ,[SupplierCity]
      ,[SupplierState]
      ,[SupplierCountry]
      ,[SupplierZipcode]
      ,[SupplierTaxId]
      ,isnull([SupplierCode],'') SupplierCode
      ,[Status]
  FROM tbl_SupplierInfo SI join tbl_SupplierInfo_Contact SC join tbl_PRNumbers PRN
on PRN.PRId = SC.PRId
on SC.SupplierId = SI.SupplierId
where PRN.PRNum=@PRNum
GO
