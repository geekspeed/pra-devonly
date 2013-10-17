SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[PR_ApprovePRbyCOO]
@PRNum int
as
Begin
update tbl_approval_chain set Approverresponse='APPROVED', approverresponsedate=getdate()
where approvalprnumber=@PRNum and approverlevel=109

update tbl_approval_chain set approverresponse='PENDING' where approvalprnumber=@PRNum and approveremail='dl-purchasereq@arubanetworks.com'
End
GO
