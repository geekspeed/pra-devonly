SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[PR_GetUserCountriesCount]  
@UserID varchar(32)  
AS  
select Count(1) from tbl_user_country WHERE isActive = 1 AND UserID=@UserID
GO
