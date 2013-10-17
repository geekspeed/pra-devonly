SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [dbo].[IsPRModified]
@PRNum varchar(32),
@UserId varchar(32),
@ModifiedDate varchar(32)
AS
Declare @boolCanUpdatePR bit
set @boolCanUpdatePR=0 -- set as PR cannot be updated
Begin try
if (@ModifiedDate is null)
begin 
	set @ModifiedDate=''
end 
if exists( select 1 from tbl_purchasereq where prid = (select top 1 PRID from tbl_Prnumbers WHERE PRNum = @PRNum ) AND convert(varchar, isnull(modifieddate,createdDate),121)=@ModifiedDate)
Begin
set @boolCanUpdatePR=1
end
select @boolCanUpdatePR
end try
Begin catch
-- Raise an error with the details of the exception
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
	@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
end catch
GO
