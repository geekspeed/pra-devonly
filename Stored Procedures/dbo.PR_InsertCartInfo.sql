SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_InsertCartInfo]  
@LineNumber int,  
@PartCode varchar(50),  
@PartDesc varchar(250),  
@SupplierId int,  
@ContactId int,  
@PartQty bigint,  
@PartDiscount float,  
@PartUnitPrice float,  
@Status varchar(10) = 'ACTIVE',  
@AcctCharged varchar(50),  
@DeptCharged varchar(50),  
@LocalToUsd float,  
@CurrType varchar(10),
@DeliveryDate datetime,
@fxFeedDate datetime,
@PRId int  
As  
DECLARE @PartId AS int,@PartSupplierId as int  
--insert Part and get Part Id  
insert into tbl_Part_Info (PartCode,PartDesc) values (@PartCode,@PartDesc)  
select @PartId= scope_identity()   
  
insert into tbl_Part_Supplier (PartId,SupplierId) values(@PartId,@SupplierId)  
select @PartSupplierId= scope_identity()   
  
insert into tbl_PurchaseReq_Cart (PRId,LineNumber,PartSupplierId,PartUnitPrice,PartDiscount,PartQty,Status,ContactId,AcctCharged,DeptCharged,CurrType,LocalToUsd,DeliveryDate,fxFeedDate)  
     values(@PRId,@LineNumber,@PartSupplierId,@PartUnitPrice,@PartDiscount,@PartQty,@Status,@ContactId,@AcctCharged,@DeptCharged,@CurrType,@LocalToUsd,@DeliveryDate,@fxFeedDate)  
select scope_identity() as ItemId
GO
