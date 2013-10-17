SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_InsertContactInfo]
@SupplierId int,
@PRId int,
@ContactName Varchar(50), 
@ContactPhone Varchar(50),
@ContactEmail Varchar(50),
@ContactFax Varchar(50)
as
insert into tbl_SupplierInfo_Contact
(SupplierId,ContactName, ContactPhone,ContactEmail,ContactFax,PRId)
values
(@SupplierId,@ContactName, @ContactPhone,@ContactEmail,@ContactFax,@PRId)

select SCOPE_IDENTITY() as ContactId
GO
