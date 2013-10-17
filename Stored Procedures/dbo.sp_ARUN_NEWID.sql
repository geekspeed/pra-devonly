SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_ARUN_NEWID]
(
@keytype varchar(25),
@result varchar(50) OUT
) 
as
BEGIN
declare @tempres varchar(50)
declare @nextval int,@initlen int
declare @seed int,@incr int, @curval int,@pad char(1),@keylen int,@prefix varchar(25),@count int,@flag int
set @flag=1


select @count=count(*) from dbo.ARUN_WEBKEYS where TYPE=@keytype
print 'Count='+convert(varchar,@count)
if (@count=1)
Begin
   set transaction isolation level repeatable read
	begin tran
	select @prefix=PREFIX,@seed=SEED,@curval=isnull(CURVAL,0),@pad=isnull(PADDING,'N'),@incr=INCREMENT,@keylen=KEYLENGTH from dbo.ARUN_WEBKEYS with (UPDLOCK) where TYPE=@keytype

	--check if first entry
	Print @seed
	print @curval
    if(@seed>=@curval)
		begin
			set @nextval = @seed
			print 'same as seed'	
		end
	else
		begin
			set @nextval = @curval
			print 'not same as seed'
			print'nextval='	+convert(varchar,@nextval)
		end
    set @tempres = convert(varchar,@nextval)
	print @tempres
	set @initlen = len(@prefix)+len(@tempres)
--check for padding
	if(@pad = 'Y')
		begin
			while(@initlen<@keylen)
			begin
				set @tempres= '0'+@tempres
				set @initlen = len(@prefix)+len(@tempres)
			end		
		end
	
    set @result = @prefix+@tempres
	print @result

--check for keylength
  if(len(@result) > @keylen)
	begin
     set @result = null
	end
print @result

if(@result is not null)
	begin
		update dbo.ARUN_WEBKEYS set CURVAL=CURVAL+INCREMENT where TYPE=@keytype
		if(@@ERROR <>0)
		begin
			set @flag=0
		end
	end
else
	Begin
	set @flag=0
	end

print 'flag='+convert(varchar,@flag)
 if(@flag>0)
	Begin
		commit tran
	End
 else
	Begin
		set @result = null
		rollback tran
	End
	
end
else
	begin
		set @result = null
	end

print 'result='+@result

return @result
End
GO
