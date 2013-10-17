SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_InsertSupplierInfo]
@SupplierName varchar(75)
 ,@SupplierAddrLine1 varchar(100)
           ,@SupplierAddrLine2 varchar(100)
           ,@SupplierCity varchar(50)
           ,@SupplierState varchar(50)
           ,@SupplierCountry varchar(50)
           ,@SupplierZipcode varchar(20)
           ,@SupplierTaxId varchar(20)
           ,@SupplierCode varchar(50)
as

INSERT INTO [dbo].[tbl_SupplierInfo]
           ([SupplierName]
           ,[SupplierAddrLine1]
           ,[SupplierAddrLine2]
           ,[SupplierCity]
           ,[SupplierState]
           ,[SupplierCountry]
           ,[SupplierZipcode]
           ,[SupplierTaxId]
           ,[SupplierCode]
			,Status        )
     VALUES
           (@SupplierName
           ,@SupplierAddrLine1
           ,@SupplierAddrLine2
           ,@SupplierCity
           ,@SupplierState
           ,@SupplierCountry
           ,@SupplierZipcode
           ,@SupplierTaxId
           ,@SupplierCode
,'ACTIVE')
   
select scope_IDENTITY() as SupplierId
GO
