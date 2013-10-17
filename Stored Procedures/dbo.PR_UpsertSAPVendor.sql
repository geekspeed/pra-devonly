SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_UpsertSAPVendor]
(
		@SupplierName [varchar](100)
      ,@SupplierAddrLine1 [varchar](255)
      ,@SupplierPOBox [varchar](25)
      ,@SupplierCity [varchar](50)
      ,@SupplierState [varchar](25)
      ,@SupplierCountry [varchar](25)
      ,@SupplierZipCode [varchar](25)
      ,@SupplierTaxId [varchar](25)
      ,@SupplierCode [varchar](25)
      ,@ContactName [varchar](255)
      ,@ContactPhone [varchar](50)
      ,@ContactFax [varchar](35)
   ,@ContactEmail [varchar](255))
   as
   begin
   set nocount on
   if exists(select 1 from tbl_sap_Vendor where VENDORID=@SupplierCode)
   begin
   UPDATE tbl_sap_Vendor
   SET VENDORNAME = @SupplierName
      ,STREET = @SupplierAddrLine1
      ,POBOX = @SupplierPOBox
      ,CITY = @SupplierCity
      ,[STATE] = @SupplierState
      ,COUNTRY = @SupplierCountry
      ,PINCODE = @SupplierZipcode
      ,TAXCODE = @SupplierTaxId
      ,NAME=@ContactName
      ,PHONE=@ContactPhone
      ,FAX=@ContactFax
   ,Email=@ContactEmail
      where VENDORID = @SupplierCode
   end
   else
   begin
   INSERT INTO [tbl_SAP_Vendor]
           (VENDORNAME
           ,STREET
           ,POBOX
           ,CITY
           ,[STATE]
           ,COUNTRY
           ,PINCODE
           ,TAXCODE
           ,VENDORID
           ,NAME
           ,PHONE
           ,FAX
           ,Email)
     VALUES
           (
@SupplierName,
           @SupplierAddrLine1, 
           @SupplierPOBox, 
           @SupplierCity, 
           @SupplierState, 
           @SupplierCountry,
           @SupplierZipCode,
           @SupplierTaxId, 
           @SupplierCode, 
           @ContactName, 
           @ContactPhone,
           @ContactFax, 
           @ContactEmail)


   end
   
   
   End
GO
