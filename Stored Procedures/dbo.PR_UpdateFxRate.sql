SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[PR_UpdateFxRate]
(@ToSymbol varchar(4),
 @LocalToUSDRate float
)as
begin
set nocount on
if(ltrim(rtrim(isnull(@ToSymbol,''))) = '' or isnull(@LocalToUSDRate,0.0)<=0.0 )
Begin
print 'bad inputs'
return
End
if(upper(ltrim(rtrim(isnull(@ToSymbol,''))))='USD')
Begin
set @LocalToUSDRate =1.0
End
begin try
begin tran
update fxRate_feeds set active=0 where to_symbol=upper(@ToSymbol) and active=1
insert into  fxRate_feeds(fxdate,from_name,from_symbol,to_name,to_symbol,frate,crate,type,active,text,created_date)
values(getdate(),'United States','USD',upper(@ToSymbol),upper(@ToSymbol),1/@LocalToUSDRate,@LocalToUSDRate,'Manual',1,'',getdate())
Commit
end try
BEGIN CATCH
	IF @@TRANCOUNT > 0
	ROLLBACK
	-- Raise an error with the details of the exception
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
	@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
end



GO
