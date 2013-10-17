SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Get_User_Preferences_Details]        
@userid varchar(32),        
@prnum int        
AS        
SELECT recipients FROM tbl_user_preferences   
WHERE Active = 1 and userid = @userid   
and charindex(recipients,(SELECT SUBSTRING(  
(SELECT ',' + ApproverEmail FROM tbl_Approval_Chain   
WHERE ApprovalPRNumber = @prnum and ApproverEmail NOT like @userid+'@arubanetworks.com'  
FOR XML PATH('')),2,200000) AS CSV))= 0
GO
