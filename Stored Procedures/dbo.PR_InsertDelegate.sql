SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_InsertDelegate]
@DelegateId varchar(30),
@DelegateAction varchar(10),
@StartDate datetime,
@EndDate datetime,
@ForUserId varchar(30)
as
insert into tbl_PurchaseReq_Delegate
(ForUserId,DelegateId,DelegateAction,StartDate,EndDate,Status,CreatedBy,CreatedDate)
values
(@ForUserId,@DelegateId,@DelegateAction,@StartDate,@EndDate,'ACTIVE',@ForUserId,getdate())

select scope_identity() as ItemId
GO
