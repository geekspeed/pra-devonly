SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[PR_GetPrintPRInfo]
@PRNum int
AS
SET NOCOUNT ON
select 
PN.PrNum,
isnull(VE1.EmployeeFirstName+' '+VE1.EmployeeLastName,PR.RequestorId) RequestorID,
isnull(PR.Title,'') Title,
isnull(VD.DeptName+' ['+PR.RequestorDept+']',PR.RequestorDept) RequestorDept,
PR.RequestorPhone,
isnull(GL.lookupText,PR.GLCode) GLCode,
isnull(PRY.LookupText,PR.Priority) Priority,
PR.CreatedBy,
convert(char(10),PR.createddate,101)as CreatedDate,
isnull(convert(char(10),PR.Requesteddate,101),'')as RequestedDate,
isnull(PR.Justification,'') Justification,
isnull(PR.ShipName,'')ShipName,
isnull(PR.ShipCompany,'') Shipcompany,
isnull(PR.ShipAddrLine1,'') ShipAddrLine1,
isnull(PR.ShipAddrLine2,'') ShipAddrLine2,
isnull(PR.ShipCity,'')ShipCity,
isnull(PR.ShipState,'') ShipState,
isnull(CTY.LookupText,PR.ShipCountry) ShipCountry,
isnull(PR.ShipZipcode,'')ShipZipCode,
isnull(PR.PONumber,'') PONumber, 
isnull(convert(char(10),PR.PODate,101),'') as PODate,
isnull(PT.LookupText,PR.PaymentTerms) PaymentTerms,
isnull(PR.Taxable,'')Taxable,
isnull(PR.AcctCharged,'') AcctCharged,
LK.LookupText Status,
PR.Status StatusCode,
isnull(PR.ModifiedBy,'') ModifiedBy,
isnull(convert(char(10),PR.ModifiedDate,101),'') as ModifiedDate,
CASE WHEN PR.ChangeOrder=1 THEN PR.ParentPO else '' END as ParentPO ,
isnull(PR.Comments,'') Comments,
isnull(PR.DeptCharged,'')DeptCharged,
case when PR.Shipelectronic='YES' then 'Yes' when  PR.Shipelectronic='NO' then 'No' else 'Unknown' End Shipelectronic,
isnull(SC.ContactName,'') ContactName,
isnull(SC.ContactPhone,'')ContactPhone,
isnull(SC.ContactEmail,'')ContactEmail,
isnull(SC.ContactFax,'')ContactFax,
isnull(FT.LookupText,'') FreightTerms,
isnull(BR.EmployeeFirstName+' '+BR.EmployeeLastName,isnull(PR.Buyer,'')) Buyer,
case when PR.TAXABLE='YES' THEN 'Yes' when PR.TAXABLE='NO' then 'No' else '' end Taxable,
SI.SupplierName,
isnull(SI.SupplierCode,'') SupplierCode,
isnull(SI.SupplierAddrLine1,'') SupplierAddrLine1,
isnull(SI.SupplierAddrLine2,'') SupplierAddrLine2,
isnull(SI.SupplierCity,'')SupplierCity,
isnull(SI.SupplierState,'')SupplierState,
SI.SupplierCountry,
isnull(SI.SupplierZipcode,'')SupplierZipCode,
isnull(SI.SupplierTaxId,'') SupplierTaxId, PR.Entity
 from 
tbl_Prnumbers PN 
join tbl_PurchaseReq PR on PN.PrId=PR.PrId 
left outer join tbl_Supplierinfo_Contact SC on PR.PrId = SC.PrId 
left outer join tbl_Supplierinfo SI on SC.SupplierID = SI.SupplierID 
left outer join vw_Employee VE1 on PR.RequestorID = VE1.EmployeeLoginId 
left outer join vw_Department VD on PR.RequestorDept = VD.DeptCode
left outer join vw_PaymentTerms PT on PR.PaymentTerms = PT.Lookupvalue
left outer join tbl_Lookup_values LK on PR.Status = LK.LookupValue
left outer join tbl_Lookup_values GL on  PR.GlCode = GL.LookupValue
left outer join tbl_Lookup_values PRY on PR.Priority = PRY.Lookupvalue
left outer join tbl_Lookup_values CTY on PR.ShipCountry = CTY.Lookupvalue
left outer join vw_FOB FT on PR.FreightTerms = FT.LookupValue
left outer join vw_employee BR on PR.Buyer = BR.EmployeeLoginID
where 
PN.PRNum = @PRNum
and LK.LookupType='STATUS' 
and GL.LookupType='PR_TYPE' 
and PRY.LookupType='PRIORITY'
and (CTY.LookupType='COUNTRY' OR PR.ShipCountry is NULL)



select 'Created' Action,CreatedDate Date,isnull(EmployeeFirstName+' '+EmployeeLastName,CreatedBy) as UserName,'' Approverlevel from vw_PurchaseReq 
left outer join vw_employee on CreatedBy=EmployeeLoginId where PRNum=@PRNum
union
select 'Modified' Action,ModifiedDate Date,isnull(EmployeeFirstName+' '+EmployeeLastName,ModifiedBy)as  UserName,'' Approverlevel from vw_PurchaseReq 
left outer join vw_employee on ModifiedBy=EmployeeLoginId where PRNum=@PRNum and Modifiedby is not null 
union
select isnull(LookupText,ApproverResponse) Action,ApproverResponseDate Date,ApproverName as UserName,ApproverLevel from tbl_Approval_Chain 
left outer join tbl_lookup_values 
on lookupvalue=approverResponse where ApprovalPRNumber=@PRNum and ApproverResponse is not null and ApproverResponse not in ('PENDING','')and  LookupType='Status'
union
--select 'Cancelled' Action,ModifiedDate Date,isnull(EmployeeFirstName+' '+EmployeeLastName,ModifiedBy)as  UserName,'' Approverlevel from tbl_PurchaseReq_Audit
--left outer join vw_employee on ModifiedBy=EmployeeLoginId where PrId = (select PRId from tbl_PRNumbers where PRNum = @PRNum) and FieldName='Status' and NewValue='CANCELLED'
--order by Date,ApproverLevel
select 'Cancelled' Action,ModifiedDate Date,isnull(EmployeeFirstName+' '+EmployeeLastName,ModifiedBy)as  UserName,'' Approverlevel from vw_PurchaseReq
left outer join vw_employee on ModifiedBy=EmployeeLoginId where PRNum = @PRNum and StatusValue='CANCELLED'
GO
