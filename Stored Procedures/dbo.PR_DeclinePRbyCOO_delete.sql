SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_DeclinePRbyCOO_delete]
@PRNum int
as
Begin

update tbl_purchasereq set status='DECLINED' where prid= (select distinct top 1 PRId from tbl_PRnumbers where PRnum=@PrNum)
update tbl_approval_chain set Approverresponse='DECLINED', approverresponsedate=getdate()
where approvalprnumber=@PRNum and approverlevel=109

update tbl_approval_chain set approverresponse='',approverresponsecomments='COO Decline' , responsetaskid='' where approvalprnumber=@PRNum and approveremail='dl-purchasereq@arubanetworks.com'

End
GO
