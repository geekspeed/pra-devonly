SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetEmailInfo]
@PRId int
as
Begin
select
PRN.PRNum, 
PR.Title,
PR.RequestorId,
isnull(LV.LookupText,Pr.GLCode) PRType,
isnull(AD.Name,PR.RequestorId) RequestorName,
ISNULL(DEPT.DeptName,PR.RequestorDept) DeptName,
ISNULL(DEPT.DEPTCODE,PR.RequestorDept) DeptCode,
PR.Priority,
PRC_VALUE.PRLocalValue,
PRC_VALUE.PRValue,
PRC_VALUE.CurrType LocalCurr,
ISNULL(SUPPLIER.SupplierName, '') SupplierName,
convert(varchar(10),PR.RequestedDate,111) RequestedDate, PR.Justification,
isnull(LV.LookupValue,Pr.GLCode) PRTypeValue
from
dbo.tbl_PurchaseReq AS PR LEFT OUTER JOIN
dbo.vw_ad_employee AD  on PR.RequestorId=AD.loginId left outer join
dbo.vw_Department DEPT  on PR.Requestordept =DEPT.DeptCOde left outer join
dbo.tbl_PRNumbers AS PRN ON PR.PRId = PRN.PRId LEFT OUTER JOIN
dbo.tbl_Lookup_Values AS LK ON PR.Status = LK.LookupValue LEFT OUTER JOIN
dbo.tbl_Lookup_Values AS LV ON PR.GLCode = LV.LookupValue LEFT OUTER JOIN
 (SELECT PRID,CurrType, CAST(ISNULL(SUM((100.00 - PartDiscount) * PartQty * PartUnitPrice * LocalToUsd / 100.00), 0) AS decimal(25, 2)) AS PRValue,CAST(ISNULL(SUM((100.00 - PartDiscount) * PartQty * PartUnitPrice / 100.00), 0) AS decimal(25, 2)) AS PRLocalValue
  FROM   dbo.tbl_PurchaseReq_Cart AS PRC
  WHERE (UPPER(Status) = 'ACTIVE')
  GROUP BY PRID,CurrType) AS PRC_VALUE ON PRC_VALUE.PRID = PR.PRId LEFT OUTER JOIN
  (SELECT DISTINCT PC.PRID, S.SupplierName
   FROM   dbo.tbl_PurchaseReq_Cart AS PC LEFT OUTER JOIN
   dbo.tbl_Part_Supplier AS PS ON PC.PartSupplierId = PS.PartSupplierId LEFT OUTER JOIN
   dbo.tbl_SupplierInfo AS S ON PS.SupplierId = S.SupplierId) AS SUPPLIER ON PR.PRId = SUPPLIER.PRID LEFT OUTER JOIN
   dbo.tbl_SupplierInfo_Contact AS SC ON PR.PRId = SC.PRId
WHERE (LV.LookupType = 'PR_TYPE' and LK.LookupType='STATUS') and PRN.PRId=@PRId

End
GO
