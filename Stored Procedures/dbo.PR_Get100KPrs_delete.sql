SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_Get100KPrs_delete]
as
Begin
set NOCOUNT on
/*
select Prnum,p.title Title,deptname+' ['+vp.requestordept+']' DeptName,PRValue,vp.requestorid,vp.suppliername,fin.approveremail FinanceApproverEmail,vp.justification ,bus.approveremail BusinessOwner
from vw_intl_purchasereq vp 
join tbl_approval_chain pur on PRNum = pur.approvalprnumber and pur.ApproverResponse='PENDING' and pur.approverlevel=110
join tbl_approval_chain fin on PRNum = fin.approvalprnumber and fin.ApproverResponse='APPROVED' and fin.approverlevel=60
join tbl_approval_chain bus on PRNum = bus.approvalprnumber and bus.ApproverResponse='APPROVED' and bus.approverlevel=(select max(approverlevel) from tbl_approval_chain where approvalprnumber=PRNum and approverlevel <60 group by approvalprnumber )
join tbl_purchasereq p on prnum=prid
join vw_department on vp.requestordept = deptcode
where vp.status='PENDING' and PRvalue>= 50000   and prnum not in (select prid from tbl_notified_pr)
and vp.requestordept in (110,210,220,230,240,310,320,400,405,410,420,425,430,435,440,445,450,460,500,510,520,525,530,540,550,551,553,555,560,565,570,575,580,585,591,592,593,
600, 608, 690, 691,692,693,695,770)
)
*/

select Prnum,p.title Title,deptname+' ['+vp.requestordept+']' DeptName,PRValue,vp.requestorid,vp.suppliername,fin.approveremail FinanceApproverEmail,vp.justification ,bus.approveremail BusinessOwner
from vw_intl_purchasereq vp 
join tbl_approval_chain coo on PRNum = coo.approvalprnumber and coo.ApproverResponse='PENDING' and coo.approverlevel=109
join tbl_approval_chain fin on PRNum = fin.approvalprnumber and fin.ApproverResponse='APPROVED' and fin.approverlevel=60
join tbl_approval_chain bus on PRNum = bus.approvalprnumber and bus.ApproverResponse='APPROVED' and bus.approverlevel=(select max(approverlevel) from tbl_approval_chain where approvalprnumber=PRNum and approverlevel <60 group by approvalprnumber )
join tbl_purchasereq p on prnum=prid
join vw_department on vp.requestordept = deptcode
where vp.status='PENDING' and prnum not in (select prid from tbl_notified_pr)


End
GO
