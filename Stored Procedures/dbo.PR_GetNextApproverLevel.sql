SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetNextApproverLevel] 
@PRNum int as SET NOCOUNT ON   
Select distinct TOP 1 ApproverLevel from tbl_Approval_Chain 
where ApprovalPRNumber=@PRNum and ApproverLevel 
= ( Select Min(ApproverLevel) from tbl_Approval_Chain  where ApprovalPRNumber=@PRNum and UPPER(ApproverResponse)='PENDING' group by ApprovalPRNumber )and UPPER(ApproverResponse) = 'PENDING'
GO
