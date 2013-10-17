SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_InsertPRNumber]
@PRId int
as
insert  into tbl_PRNumbers (PRId,PRNum) values (@PRId,@PRId)
select @PRId as PRNUM
GO
