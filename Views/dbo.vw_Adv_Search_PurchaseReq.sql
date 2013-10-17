SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Adv_Search_PurchaseReq]
as
SELECT 
PRN.PRNum, 
SUBSTRING(Isnull(PR.Title,''),0,30)+case when LEN(isnull(PR.Title,''))>30 then '...' else '' end AS  Title,
PR.RequestorId, 
PR.RequestorDept,
PR.CreatedDate, 
PR.CreatedBy, 
isnull(EM3.Name,PR.CreatedBy) CreatedByName,
LV.LookupText AS PRType, 
isnull(LK.LookupText,PR.status)AS Status,
ISNULL(PRC_VALUE.PRValue, 0.00) AS PRValue, 
RTRIM(LTRIM(SUPPLIER.SupplierName)) AS SupplierName, 
PR.RequestorDept AS DepartmentName, 
isnull(DT.DeptName,PR.RequestorDept) as DepartmentNameText,
PR.Priority, 
coalesce(PRC_VALUE.DelDate,PR.RequestedDate ) RequestedDate,
PR.Justification,
isnull(PR.PONumber,'') as PONumber,
PR.ModifiedBy,
PR.ModifiedDate,
PR.Status as StatusValue,
PR.Buyer as BuyerId,
PA.ApproverName,
isnull(EM2.Name,Pr.RequestorId) as RequestorName,
PR.PODate,
PR.AcctCharged,
PR.DeptCharged
FROM  
dbo.tbl_PurchaseReq AS PR LEFT OUTER JOIN
dbo.vw_Department as DT on PR.RequestorDept = DT.DeptCode LEFT OUTER JOIN
dbo.tbl_PRNumbers AS PRN ON PR.PRId = PRN.PRId LEFT OUTER JOIN
dbo.tbl_Lookup_Values AS LK ON PR.Status = LK.LookupValue LEFT OUTER JOIN
dbo.tbl_Lookup_Values AS LV ON PR.GLCode = LV.LookupValue LEFT OUTER JOIN
 (SELECT PRID,CAST(ISNULL(SUM((100.00 - PartDiscount) * PartQty * PartUnitPrice * LocalToUsd / 100.00), 0) AS decimal(25, 2)) AS PRValue, MIN(DeliveryDate) DelDate
  FROM   dbo.tbl_PurchaseReq_Cart AS PRC
  WHERE (UPPER(Status) = 'ACTIVE')
  GROUP BY PRID) AS PRC_VALUE ON PRC_VALUE.PRID = PR.PRId LEFT OUTER JOIN
  (SELECT DISTINCT PC.PRID, S.SupplierName
   FROM   dbo.tbl_PurchaseReq_Cart AS PC LEFT OUTER JOIN
   dbo.tbl_Part_Supplier AS PS ON PC.PartSupplierId = PS.PartSupplierId LEFT OUTER JOIN
   dbo.tbl_SupplierInfo AS S ON PS.SupplierId = S.SupplierId) AS SUPPLIER ON PR.PRId = SUPPLIER.PRID 
left outer join 
(select distinct ApprovalPRNumber PRNum,ApproverName,ApproverResponse from tbl_Approval_Chain  where ApproverResponse='PENDING'  
)PA
 on PRN.Prnum = PA.PRNum and UPPER(PR.Status)= PA.ApproverResponse
left outer join vw_ad_employee EM2 on PR.RequestorId = EM2.loginId
left outer join vw_ad_employee EM3 on PR.CreatedBy = EM3.loginId
WHERE (LV.LookupType = 'PR_TYPE' and LK.LookupType='STATUS')
GO
