SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[PR_AdvSearchAccess]    
@UserID varchar(32),  
@RoleId varchar(20)  
AS    
select Count(1) from tbl_menu_user WHERE UserID=@UserID AND RoleId=@RoleId
GO
