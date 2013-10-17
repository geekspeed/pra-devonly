SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_UpdateCartInfo]  
@ItemId int,  
@PartSupplierId int,  
@PartCode varchar(50),  
@PartDesc varchar(250),  
@SupplierId int,  
@ContactId int,  
@PartQty bigint,  
@PartDiscount float,  
@PartUnitPrice float,  
@PRNum int,  
@AcctCharged varchar(50),  
@DeptCharged varchar(50),  
@LocalToUsd float,  
@CurrType varchar(10),  
@Status varchar(10),
@DeliveryDate datetime,
@fxFeedDate datetime  
As  
--Part Supplier  
IF(@Status = 'ACTIVE')  
BEGIN  
Update tbl_Part_Supplier  
set   
SupplierId=@SupplierId  
where PartSupplierId=@PartSupplierId  
  
--Part Info  
update tbl_Part_Info  
set  
PartCode = @PartCode,  
PartDesc = @PartDesc  
where PartId=(select distinct TOP 1 PartId from tbl_Part_Supplier where PartSupplierId=@PartSupplierId)  
  
update tbl_PurchaseReq_Cart  
set   
PartQty=@PartQty,  
PartDiscount = @PartDiscount,  
PartUnitPrice=@PartUnitPrice,  
ContactId  = @ContactId,  
AcctCharged = @AcctCharged,  
DeptCharged=@DeptCharged,  
LocalToUsd = @LocalToUsd,  
CurrType=@CurrType,  
Status = @Status,
DeliveryDate = @DeliveryDate,
fxFeedDate = @fxFeedDate
where  
ItemId=@ItemId  
and PRId=(select distinct top 1 PRId from tbl_PRnumbers where PRNum=@PRNum)  
  
END  
else  
BEGIN  
update tbl_PurchaseReq_Cart  
set   
Status = @Status  
where  
ItemId=@ItemId  
and PRId=(select distinct top 1 PRId from tbl_PRnumbers where PRNum=@PRNum)  
  
END
GO
