SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetPRCart]  
@PRNum int  
AS  
SET NOCOUNT ON  
  
select   
PN.PRNum,  
PRC.PRId,  
PRC.ItemId,  
PRC.LineNumber,  
PRC.PartSupplierId,  
PS.SupplierId as SupplierId,  
PINFO.PartCode,  
PINFO.PartDesc,  
PRC.ContactId,  
PRC.PartUnitPrice,  
PRC.PartDiscount,  
PRC.PartQty,  
isnull(PRC.AcctCharged,'') AcctCharged,  
isnull(PRC.AcctCharged,'') AcctChargedTxt,  
isnull(PRC.DeptCharged,'') DeptCharged,  
isnull(PRC.DeptCharged,'') DeptChargedTxt,  
isnull(PRC.CurrType,'') CurrType,  
PRC.LocalToUsd,  
(PRC.PartQty * PRC.PartUnitPrice) PartEstPriceLC,  
(100.00-PRC.PartDiscount)*PRC.PartQty*PRC.LocalToUsd*PRC.PartUnitPrice/100.00 as PartEstPrice,  
(100.00-PRC.PartDiscount)*PRC.PartQty*PRC.PartUnitPrice/100.00 as PartEstLocalPrice,  
 isnull(PRC.Status,'ACTIVE') as Status,
 DeliveryDate,fxFeedDate  
from tbl_PurchaseReq_Cart PRC join tbl_Prnumbers PN on PRC.PrId=PN.PrId   
join tbl_Part_Supplier PS on PRC.PartSupplierId = PS.PartSupplierId  
join tbl_Part_Info PINFO on PS.PartId = PINFO.PartId  
where PN.PrNum=@PRNum  
and isnull(PRC.Status,'')<>'DELETE'  
order by PRC.LineNumber asc
GO
