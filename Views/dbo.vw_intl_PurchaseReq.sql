SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Object:  View [dbo].[vw_intl_PurchaseReq]    Script Date: 5/28/2013 1:21:33 PM ******/
CREATE VIEW [dbo].[vw_intl_PurchaseReq]
as
SELECT 
PRN.PRNum, 
SUBSTRING(Isnull(PR.Title,''),0,30)+case when LEN(isnull(PR.Title,''))>30 then '...' else '' end AS  Title,
PR.RequestorId, 
PR.RequestorDept,
PR.CreatedDate, 
PR.CreatedBy, 
LV.LookupText AS PRType, 
isnull(LK.LookupText,PR.status)AS Status,
ISNULL(PRC_VALUE.PRValue, 0.00) AS PRValue, 
ISNULL(PRC_VALUE.PRLocalValue, 0.00) AS PRLocalValue, 
SUBSTRING(ISNULL(SUPPLIER.SupplierName, ''),0,20) AS SupplierName, 
ISNULL(SC.ContactName, '') AS ContactName, 
ISNULL(SC.ContactPhone, '') AS ContactPhone, 
ISNULL(SC.ContactEmail, '') AS ContactEmail, 
PR.RequestorDept AS DepartmentName, 
PR.Priority, 
coalesce(PRC_VALUE.DelDate,PR.RequestedDate ) RequestedDate,
PR.Justification,
dbo.GetPONumber (ISNULL(PR.PONumber,''),isnull(PR.Intl_PONumber,''),PR.Entity) as PONumber,
PR.ModifiedBy,
PR.ModifiedDate,
PR.Status as StatusValue,
PR.Buyer as BuyerId,
PR.GLCode as PRTypeValue,
AcctCharged as PrePaidAccountCharged,
DeptCharged as PrePaidDeptCharged
FROM  
dbo.tbl_PurchaseReq AS PR with (nolock)  LEFT OUTER JOIN
dbo.tbl_PRNumbers AS PRN with (nolock)  ON PR.PRId = PRN.PRId 
LEFT OUTER JOIN dbo.tbl_Lookup_Values AS LK with (nolock)  ON PR.Status = LK.LookupValue 
LEFT OUTER JOIN dbo.tbl_Lookup_Values AS LV with (nolock)  ON PR.GLCode = LV.LookupValue 
LEFT OUTER JOIN
 (SELECT PRID, CAST(ISNULL(SUM((100.00 - PartDiscount) * PartQty * PartUnitPrice * LocalToUsd / 100.00), 0) AS decimal(25, 2)) AS PRValue,CAST(ISNULL(SUM((100.00 - PartDiscount) * PartQty * PartUnitPrice / 100.00), 0) AS decimal(25, 2)) AS PRLocalValue, MIN(DeliveryDate) DelDate
  FROM   dbo.tbl_PurchaseReq_Cart AS PRC with (nolock) 
  WHERE (UPPER(Status) = 'ACTIVE')
  GROUP BY PRID) AS PRC_VALUE ON PRC_VALUE.PRID = PR.PRId LEFT OUTER JOIN
  (SELECT DISTINCT PC.PRID, S.SupplierName
   FROM   dbo.tbl_PurchaseReq_Cart AS PC with (nolock)  LEFT OUTER JOIN
   dbo.tbl_Part_Supplier AS PS with (nolock)  ON PC.PartSupplierId = PS.PartSupplierId LEFT OUTER JOIN
   dbo.tbl_SupplierInfo AS S  with (nolock)  ON PS.SupplierId = S.SupplierId) AS SUPPLIER ON PR.PRId = SUPPLIER.PRID LEFT OUTER JOIN
   dbo.tbl_SupplierInfo_Contact AS SC with (nolock)  ON PR.PRId = SC.PRId
WHERE (LV.LookupType = 'PR_TYPE' and LK.LookupType='STATUS')

GO
