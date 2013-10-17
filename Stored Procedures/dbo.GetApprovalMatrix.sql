SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetApprovalMatrix]
AS
select DeptCode, PRType, ApproverID, CreateDate, CreatedBy from [tbl_finance_matrix] where isActive = 1
GO
