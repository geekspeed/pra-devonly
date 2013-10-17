SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Adv_Search_PurchaseReq_NODRAFTS]
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
--ISNULL(PRC_VALUE.PRValue, 0.00) AS PRValue, 
SUBSTRING(ISNULL(SUPPLIER.SupplierName, ''),0,20) AS SupplierName, 
ISNULL(SC.ContactName, '') AS ContactName, 
ISNULL(SC.ContactPhone, '') AS ContactPhone, 
ISNULL(SC.ContactEmail, '') AS ContactEmail, 
PR.RequestorDept AS DepartmentName, 
DT.DeptName as DepartmentNameText,
PR.Priority, 
PR.RequestedDate, 
PR.Justification,
isnull(PR.PONumber,'') as PONumber,
PR.ModifiedBy,
PR.ModifiedDate,
PR.Status as StatusValue,
PR.Buyer as BuyerId,
PA.ApproverName,
EM.EmployeefirstName+' '+EM.EmployeeLastName as CreatedByName,
EM2.EmployeefirstName+' '+EM2.EmployeeLastName as RequestorName,
PR.PODate
FROM  
dbo.tbl_PurchaseReq AS PR 
LEFT OUTER JOIN dbo.vw_Department as DT on PR.RequestorDept = DT.DeptCode 
 inner JOIN dbo.tbl_PRNumbers AS PRN ON PR.PRId = PRN.PRId 
left outer JOIN dbo.tbl_Lookup_Values AS LK ON PR.Status = LK.LookupValue 
LEFT OUTER JOIN dbo.tbl_Lookup_Values AS LV ON PR.GLCode = LV.LookupValue
 --inner JOIN
 --(SELECT PRID, CAST(ISNULL(SUM((100.00 - PartDiscount) * PartQty * PartUnitPrice / 100.00), 0) AS decimal(25, 2)) AS PRValue
 -- FROM   dbo.tbl_PurchaseReq_Cart AS PRC
 -- WHERE (UPPER(Status) = 'ACTIVE')
 -- GROUP BY PRID) AS PRC_VALUE ON PRC_VALUE.PRID = PR.PRId 
  inner JOIN
  (SELECT DISTINCT PC.PRID, S.SupplierName
   FROM   dbo.tbl_PurchaseReq_Cart AS PC LEFT OUTER JOIN
   dbo.tbl_Part_Supplier AS PS ON PC.PartSupplierId = PS.PartSupplierId LEFT OUTER JOIN
   dbo.tbl_SupplierInfo AS S ON PS.SupplierId = S.SupplierId) AS SUPPLIER ON PR.PRId = SUPPLIER.PRID 
   inner JOIN   dbo.tbl_SupplierInfo_Contact AS SC ON PR.PRId = SC.PRId
left outer join 
(select distinct ApprovalPRNumber PRNum,ApproverName,ApproverResponse from tbl_Approval_Chain  where ApproverResponse='PENDING'  
)PA
 on PRN.Prnum = PA.PRNum and UPPER(PR.Status)= PA.ApproverResponse
left outer join vw_employee EM on PR.CreatedBy = EM.EmployeeLoginId
left outer join vw_employee EM2 on PR.RequestorId = EM2.EmployeeLoginId
WHERE (LV.LookupType = 'PR_TYPE' and LK.LookupType='STATUS') and PR.Status<> 'DRAFT'
GO
