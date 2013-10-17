SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_UpdateContactInfo]
@SupplierId int,
@PRNum int,
@ContactName Varchar(50), 
@ContactPhone Varchar(50),
@ContactEmail Varchar(50),
@ContactFax Varchar(50)
as
update tbl_SupplierInfo_Contact
set
SupplierId = @SupplierId,
ContactName =@ContactName,
ContactPhone =@ContactPhone,
ContactEmail =@ContactEmail,
ContactFax =@ContactFax
where 
PRId=(select distinct top 1 PRId from tbl_PRNumbers where PRNum=@PrNum)
GO
