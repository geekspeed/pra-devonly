SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetSupplierInfo_Name]
@SupplierName varchar(75)
as
SET NOCOUNT ON
SELECT DISTINCT TOP 1 [SupplierName]
      ,[SupplierAddrLine1]
      ,[SupplierAddrLine2]
      ,[SupplierCity]
      ,[SupplierState]
      ,[SupplierCountry]
      ,[SupplierZipcode]
      ,[SupplierTaxId]
      ,isnull([SupplierCode],'') SupplierCode
	  ,ContactName
,ContactPhone
,ContactFax
,ContactEmail
  FROM [dbo].vw_SupplierInfo
where UPPER(LTRIM(RTRIM(SupplierName)))=UPPER(LTRIM(RTRIM(@SupplierName)))
GO
