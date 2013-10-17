SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetDelegatedActivityInfo]
(
@UserID varchar(32)
)
AS

select *from dbo.tbl_PurchaseReq_DelegateActivity WHERE ForUserID = @UserID order by ForUserId,ActivityDateTime,Notes desc
GO
