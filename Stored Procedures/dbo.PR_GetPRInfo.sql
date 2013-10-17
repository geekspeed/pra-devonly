SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[PR_GetPRInfo]    
@PRNum int    
AS    
SET NOCOUNT ON    
select     
PN.PrNum,    
PR.PRId,    
PR.Title,    
PR.RequestorId,    
PR.RequestorDept,    
PR.RequestorPhone,    
PR.GLCode,    
PR.Priority,    
PR.CreatedBy,    
convert(char(10),PR.createddate,101)as CreatedDate,    
convert(char(10),PR.Requesteddate,101)as RequestedDate,    
PR.Justification,    
PR.CompanySites,    
PR.ShipName,    
PR.ShipCompany,    
PR.ShipAddrLine1,    
PR.ShipAddrLine2,    
PR.ShipCity,    
PR.ShipState,    
PR.ShipCountry,    
PR.ShipZipcode,    
PR.LastApprovedby,    
PR.PONumber,     
convert(char(10),PR.PODate,101) as PODate,    
PR.PaymentTerms,    
PR.FreightTerms,    
PR.Taxable,    
PR.AcctCharged,    
PR.Status,    
LK.LookupText StatusValue,    
PR.ModifiedBy,    
isnull(PR.ModifiedDate,PR.CreatedDate) as ModifiedDate,    -- this is the version number of the PR
CASE WHEN PR.ChangeOrder=1 THEN 'TRUE' else 'FALSE' END as ChangeOrder ,    
PR.NewVendor,    
PR.ParentPO,    
PR.Comments,    
PR.Buyer,    
PR.DeptCharged,    
PR.ShipElectronic,    
SC.ContactId,    
SC.SupplierId,    
SC.ContactName,    
SC.ContactPhone,    
SC.ContactEmail,    
SC.ContactFax,  
PR.Entity,
PRA.AttachmentCount  
 from     
tbl_Prnumbers PN     
join tbl_PurchaseReq PR on PN.PrId=PR.PrId     
left outer join tbl_Supplierinfo_Contact SC on PR.PrId = SC.PrId     
left outer join tbl_Lookup_values LK on PR.Status = LK.LookupValue   
left outer join  
(select PrNum, Count(*) as AttachmentCount  from tbl_PurchaseReq_Attachments where status <>'INACTIVE' group by PRnum) PRA   
on PN.PrNum=PRA.PrNum  
     where PN.PrNum=@PrNum and LK.LookupType='STATUS'    
    
   
--SELECT TOP 1 'cRate - 1 USD = ' + (cast(fx.frate as varchar(20)) + ' '+CurrType)  Action,fxFeedDate Date ,'Fx Rate as' UserName,'' Approverlevel 
--FROM tbl_purchasereq_cart SC    
--INNER JOIN tbl_PRNUmbers PN ON SC.PrId=PN.PrId     
--INNER JOIN fxRate_feeds fx ON fx.to_symbol = sc.CurrType    
--WHERE PN.PRNUM =@PrNum  
SELECT TOP 1 'cRate - 1 USD = ' + (cast((1/sc.LocalToUsd) as varchar(20)) + ' '+sc.CurrType)  Action,fxFeedDate Date ,'Fx Rate as' UserName,'' Approverlevel 
FROM tbl_purchasereq_cart SC    
INNER JOIN tbl_PRNUmbers PN ON SC.PrId=PN.PrId     
WHERE PN.PRNUM =@PrNum  
UNION  
select 'Created' Action,CreatedDate Date,isnull(EmployeeFirstName+' '+EmployeeLastName,CreatedBy) as UserName,'' Approverlevel from vw_PurchaseReq     
left outer join vw_employee on CreatedBy=EmployeeLoginId where PRNum=@PRNum    
union    
select 'Modified' Action,ModifiedDate Date,isnull(EmployeeFirstName+' '+EmployeeLastName,ModifiedBy)as  UserName,'' Approverlevel from vw_PurchaseReq     
left outer join vw_employee on ModifiedBy=EmployeeLoginId where PRNum=@PRNum and Modifiedby is not null     
union    
select isnull(LookupText,ApproverResponse) Action,ApproverResponseDate Date,ApproverName as UserName,ApproverLevel from tbl_Approval_Chain     
left outer join tbl_lookup_values     
on lookupvalue=approverResponse where ApprovalPRNumber=@PRNum and ApproverResponse is not null and ApproverResponse not in ('PENDING','')and  LookupType='Status'    
order by Date,ApproverLevel
GO
