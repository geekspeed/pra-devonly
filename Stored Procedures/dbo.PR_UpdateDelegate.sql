SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_UpdateDelegate]
@DelegateId varchar(30),
@DelegateAction varchar(10),
@StartDate datetime,
@EndDate datetime,
@ForUserId varchar(30),
@ItemId int,
@Status varchar(10)
as
update tbl_PurchaseReq_Delegate
set
DelegateId=@DelegateId,
DelegateAction=@DelegateAction,
StartDate = @StartDate,
EndDate = @EndDate,
Status = @Status,
ModifiedDate = getdate(),
ModifiedBy = @ForUserId
where
ItemId=@ItemId
GO
