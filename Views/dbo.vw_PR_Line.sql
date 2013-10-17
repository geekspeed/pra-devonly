SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_PR_Line]
as
select 
PR.Prnum,
C.LineNumber,
P.PartCode,
P.PartDesc,
C.PartUnitPrice UnitPrice,
C.CurrType Currency,
C.PartQty,
cast(C.pArtUNitPrice*c.PArtQty*C.LocalToUsd as Decimal(25,2))  ExtPrice,
isnull(C.AcctCharged,'') AcctCharged,
isnull(C.DeptCharged,'') DeptCharged
from
tbl_PRNumbers PR
join tbl_PurchaseReq H on PR.PRnum=h.Prid
join tbl_purchasereq_cart C on C.Prid = H.Prid  and C.Status='ACTIVE'
join tbl_part_supplier S on C.partsupplierID = S.PArtsupplierid
join tbl_part_info P on S.partid = P.partid

GO
