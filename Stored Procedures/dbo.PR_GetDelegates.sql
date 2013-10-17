SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetDelegates]
@ForUserId as varchar(30)
as
SET NOCOUNT ON
SELECT ItemId,
ForUserId
	  ,PD.DelegateId
      ,isnull(case EM.EmployeeFirstName
		when null
		Then PD.DelegateId
		else EM.EmployeeFirstName+' '+EM.EmployeeLastName end,PD.DelegateID) as DelegateName
      ,LK.Lookupvalue DelegateActionText
      ,PD.DelegateAction
      ,convert(varchar(10),PD.StartDate,101) as StartDate
      ,convert(varchar(10),PD.EndDate,101) as EndDate,
    PD.Status
  FROM tbl_PurchaseReq_Delegate PD
left outer join tbl_lookup_values LK on PD.DelegateAction = LK.LookupValue 
left outer join vw_employee EM on PD.DelegateID = EM.EmployeeLoginId
  where PD.ForUserId=@ForUserId
--and cast(convert(varchar(10),PD.StartDate,101) as datetime)<= cast(convert(varchar(10),getdate(),101) as datetime)
and cast(convert(varchar(10),PD.EndDate,101) as datetime)>=cast(convert(varchar(10),getdate(),101) as datetime)
and Upper(PD.Status)  = 'ACTIVE'
and Upper(LK.Status) ='ACTIVE'
GO
