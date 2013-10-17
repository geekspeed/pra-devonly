SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[PR_ClosePR]
(
@UserID varchar(32),
@PRNum int
)
AS
UPDATE tbl_purchasereq SET status='COMPLETED' , modifiedby=@UserID 
WHERE PRID IN (SELECT PRID FROM tbl_PRNUMBERS WHERE PRNUM = @PRNum) AND status='PENDING' AND
(select COUNT(1) from tbl_approval_chain where approvalprnumber = @PRNum AND ApproverLevel = 110 and ApproverResponse='APPROVED' ) = 1
GO
