SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[PR_insNotifyPR]
(@Prid int,
@replyemail varchar(50),
@toEmail varchar(50)
)
as
insert into tbl_notified_pr (Prid,replyemail,toemail)values(@Prid,@replyemail,@toemail)
GO
