SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_UpdateSupplierInfo]
@SupplierName varchar(75)
 ,@SupplierAddrLine1 varchar(100)
           ,@SupplierAddrLine2 varchar(100)
           ,@SupplierCity varchar(50)
           ,@SupplierState varchar(50)
           ,@SupplierCountry varchar(50)
           ,@SupplierZipcode varchar(20)
           ,@SupplierTaxId varchar(20)
           ,@SupplierCode varchar(50)
,@Status varchar(10)
,@PRNum int
as
UPDATE [dbo].[tbl_SupplierInfo]
   SET [SupplierName] = @SupplierName
      ,[SupplierAddrLine1] = @SupplierAddrLine1
      ,[SupplierAddrLine2] = @SupplierAddrLine2
      ,[SupplierCity] = @SupplierCity
      ,[SupplierState] = @SupplierState
      ,[SupplierCountry] = @SupplierCountry
      ,[SupplierZipcode] = @SupplierZipcode
      ,[SupplierTaxId] = @SupplierTaxId
      ,[SupplierCode] = @SupplierCode
      ,[Status] = @Status
 WHERE 
SupplierId=(select SC.SupplierId from tbl_SupplierInfo_Contact SC join tbl_PRNumbers PRN
on PRN.PRId = SC.PRId
where PRN.PRNum=@PRNum)
GO
