SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetMenuItems]
@RoleTitle varchar(15)
as
set NOCOUNT on
select distinct MO.ModuleId,MO.ModuleTitle,rtrim(ltrim(isnull(MO.ModuleUrl,''))) ModuleUrl,MO.SortOrder ,isnull(MO.Target,'_self') Target
from 
	 tbl_Modules MO 
join tbl_Module_roles MU on MU.ModuleId=MO.ModuleId 
join tbl_Roles u  on u.roleid=mu.roleid
where 
	ltrim(rtrim(u.roletitle))=@RoleTitle 
and mo.status='ACTIVE' 
order by mo.SortOrder asc
--select distinct MO.ModuleId,MO.ModuleTitle,MO.ModuleUrl,MO.SortOrder 
--from 
--	 tbl_Modules MO 
--join  tbl_Menus M  on M.moduleId = MO.moduleid
--join tbl_menus_User_roles MU on m.menuId=mu.menuId 
--join tbl_User_roles u  on u.roleid=mu.roleid
--where 
--	ltrim(rtrim(u.roletitle))=@RoleTitle 
--and mo.status='ACTIVE' 
--order by mo.SortOrder asc

select  m.MenuTitle,m.NavigationUrl,m.ModuleId,m.SortOrder ,isnull(m.Target,'_self') Target 
from 
	 tbl_Menus M 
join tbl_menus_roles MU on m.menuId=mu.menuId 
join tbl_Roles u  on u.roleid=mu.roleid
where 
	ltrim(rtrim(u.roletitle))=@RoleTitle
and m.status='ACTIVE'
order by m.Sortorder asc
GO
