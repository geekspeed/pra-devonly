SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_refreshADtoPRapp]
as
begin
set NOCOUNT ON
BEGIN TRY
begin tran 
delete from tbl_ad_employee

-- 10 minutes approx
set nocount on
declare @sql varchar(max)
   DECLARE @letters2 AS char(36) 
   SET @letters2= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
   DECLARE @letterin2 char(1)
   DECLARE @position2 int
 
DECLARE @letters AS char(36) 
SET @letters= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
DECLARE @letterin char(1)
DECLARE @position int
-- this is the initial variable to incre
--     ment
SET @letterin = 'A'
-- find the letter in your preset string
--     
SET @position = CharIndex(@letterin,@letters,1)
PRINT @position
-- increment to the next position desire
--     d
 
while @position < 36
begin
 
 
 

   
   -- this is the initial variable to incre
   --     ment
   SET @letterin2 = 'A'
   -- find the letter in your preset string
   --     
   SET @position2 = CharIndex(@letterin2,@letters2,1)
--   PRINT @position
   -- increment to the next position desire
   --     d
   
   while @position2 < 36
   begin
   

  select @sql = ' select replace(cn,''CONTRACTOR - '','''') Name,isnull(Department,''NA'') Department,sAmAccountName LoginId,coalesce(telephoneNumber,mobile) Phone,
mail,countryCode as CountryCode,company as Company,physicalDeliveryOfficeName as Office
FROM OPENQUERY (ADSI, ''SELECT  sAMAccountName,department,cn,telephoneNumber,userPrincipalName,mobile,mail,countryCode,company,physicalDeliveryOfficeName
   FROM 
     ''''LDAP://DC=arubanetworks,DC=COM''''
   WHERE 
     objectCategory=''''Person''''  AND objectClass = ''''User''''
     AND samaccountname = ''''' + @letterin + @letterin2 + '*'''''')'
      --where lower(cn) not like '%resource%' and lower(cn) not like '%iad%' and lower(cn) not like '%conf%'  and  lower(cn) not like '%consul%' and lower(cn) not like '%office%'
     
    


insert into tbl_ad_employee exec (@SQL)
 

 

   SET @position2 = @position2 + 1
   -- get the new letter by the new positio
   --     n number
   SET @letterin2 = Substring(@letters2,@position2,1)
   
   end
 

--PRINT @letterin
SET @position = @position + 1
-- get the new letter by the new position number

SET @letterin = Substring(@letters,@position,1)
 
end
update tbl_ad_employee set mail=lower(mail) , loginid=lower(loginid)
commit tran
END TRY
	BEGIN CATCH
	IF @@TRANCOUNT > 0
	ROLLBACK
	-- Raise an error with the details of the exception
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
	@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
End

GO
