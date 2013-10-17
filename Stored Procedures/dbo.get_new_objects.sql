
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--not changing anything  - vivek 2013-10-17

CREATE proc [dbo].[get_new_objects]
	@begin_date datetime,
	@end_date datetime
AS
begin
	select name,type,modify_date from PRA.sys.objects 
	where modify_date between @begin_date and @end_date
	and (type = 'U' or type = 'P' or type='V' )
end



GO

GRANT EXECUTE ON  [dbo].[get_new_objects] TO [ARUBANETWORKS\preddy]
GO
