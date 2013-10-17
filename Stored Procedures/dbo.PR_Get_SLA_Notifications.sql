SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_Get_SLA_Notifications]
AS
BEGIN
	SELECT  AC.ResponseTaskId,PR.PRNum,PR.Title, PR.PRValue, E.Name as RequestorName,AC.ApproverEmail, AC.ApproverName, datediff(day,approverPRSentdate,getdate()) OverDue  from tbl_approval_chain AC 
	INNER JOIN approver_SLA_Notify AN ON AC.ApproverLevel = AN.ApproverLevel
	INNER JOIN vw_intl_purchaseReq PR ON AC.ApprovalPRNumber = PR.PRNum
	INNER JOIN vw_AD_Employee E ON E.loginid = PR.RequestorId
	WHERE ApproverResponse='PENDING' AND PR.StatusValue = 'PENDING'  AND datediff(day,approverPRSentdate,getdate()) > AN.SLA_Notify AND datediff(day,approverPRSentdate,getdate()) < SLA_Notify_Ignore 
	AND AC.ApproverPRReminderDate < GETDATE()
	ORDER BY ApproverEmail, approverPRsentdate  
END
GO
