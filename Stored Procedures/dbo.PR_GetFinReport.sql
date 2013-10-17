SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetFinReport]
@FinUserEmail varchar(50),
@StartDate varchar(10),
@EndDate varchar(10)
as
Begin
SET NOCOUNT ON

select 
P.Prnum,
P.RequestorId, 
P.RequestorDept,
P.[Status],
P.Title,
convert(varchar(10),P.RequestedDate,101) ServiceDeliveryDate,
P.PRValue,
convert(varchar(10),P.CreatedDate,101) PRCreatedDate,
P.PONumber,
P.SupplierName,
convert(varchar(10),C.ApproverResponseDate,101) ApproverResponseDate,
C.ApproverResponse,
L.LineNumber,
L.PartCode,
L.PartDesc,
L.UnitPrice,
L.PartQty,
L.ExtPrice,
L.AcctCharged,
L.DeptCharged,
P.PrePaidAccountCharged,
P.PrePaidDeptCharged
 from .
tbl_approval_chain  C
join vw_intl_PurchaseReq P on C.ApprovalPRNumber=P.PRNum 
join vw_pr_line l on l.PRnum = P.Prnum
where C.ApproverEmail=@FinUserEmail and C.ApproverResponse in ('APPROVED','PENDING')
and (C.ApproverPRSentDAte>=@StartDate+ ' 00:00:00.000' and C.ApproverPRSentDAte<=@EndDate+ ' 23:59:59.000' or C.ApproverResponseDate>=@StartDate+' 00:00:00.000' and C.ApproverResponseDate<=@EndDate+' 23:59:59.000') order by C.ApprovalPRNumber,L.LineNumber
End
GO
