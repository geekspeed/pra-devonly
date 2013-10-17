SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[PRWS_CheckTaskID]
@TaskId varchar(max)
as
begin
SET NOCOUNT ON
/*
select ApprovalPRNumber PRNUM,PR.StatusValue STATUS ,ApproverResponse RESPONSE ,ApproverLevel APPROVERLEVEL
from tbl_Approval_Chain join vw_PurchaseReq PR 
on ApprovalPrNumber = PR.PRNum 
where responsetaskid=@TaskId*/
--VB 2013-05-28 : Prevent Email approvals for level 60 - only if the entity, dept and acct charged is empty and 110 - always [ V2.1]
declare @approvalPRid int
select @approvalPRid =  tpr.Prid from tbl_Approval_Chain 
join tbl_Prnumbers PN on ApprovalPRNumber=PN.PRNum
join tbl_Purchasereq tpr on PN.Prid=tpr.PRId
where responsetaskid=@TaskId

select ApprovalPRNumber PRNUM,tpr.Status STATUS ,ApproverResponse RESPONSE ,ApproverLevel APPROVERLEVEL,isnull(tpr.Entity,'') ENTITY,isnull(PC1.EmptyDeptCharged,0) EMPTYDEPTCHARGED
,isnull(EmptyAcctCharged,0) EMPTYACCTCHARGED
from tbl_Approval_Chain 
join tbl_Prnumbers PN on ApprovalPRNumber=PN.PRNum
join tbl_Purchasereq tpr on PN.Prid=tpr.PRId
left outer join (select Prid, count(*) EmptyDeptCharged from  tbl_purchasereq_cart    where PRID=@approvalPRid and upper(status)='ACTIVE' and isnull(DeptCharged,'')='' group by prid) PC1  on   pc1.PRID=tpr.PRId
left outer join (select Prid, count(*) EmptyAcctCharged from  tbl_purchasereq_cart    where PRID=@approvalPRid and upper(status)='ACTIVE' and isnull(AcctCharged,'')='' group by prid) PC2  on   pc2.PRID=tpr.PRId
where responsetaskid=@TaskId
end
GO
