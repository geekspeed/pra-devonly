SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetIntlPRForm]
@PRNum int
as
begin
set NoCOUNT ON
SELECT 
	@PRnum PRId
	,isnull(convert(varchar(10),PR.Intl_PoDate,101),'') Intl_PoDate
	,isnull(PR.Intl_VendorquoteRef,'') Intl_VendorquoteRef
	,isnull(PT.LookupText,'') Intl_PaymentTerm
	,isnull(FT.LookupText,'') Intl_FreightTerm
	,isnull(PR.Intl_DelTerms,'')  Intl_DelTerms
	,isnull(AD.Name,PR.RequestorId) RequestorName
	,isnull(PR.ShipCompany,'') ShipCompany
	,isnull(PR.ShipName,'')ShipName
	,isnull(PR.ShipAddrLine1,'')ShipAddrLine1
	,isnull(PR.ShipAddrLine2,'') ShipAddrLine2
	,isnull(PR.ShipCity,'') ShipCity
	,isnull(PR.ShipState,'') ShipState
	,LC.LookupText ShipCountry
	,isnull(PR.ShipZipcode,'') ShipZipcode
	,isnull(PR.Intl_PONumber,'') Intl_PONumber
	,isnull(PR.Intl_AddlComments,'') Intl_AddlComments
FROM tbl_PurchaseReq PR with (nolock)
  left outer join vw_ad_employee AD with (nolock) on PR.RequestorId =  AD.LoginId
  left join tbl_lookup_values LC with (nolock) on PR.ShipCountry =  lc.Lookupvalue and LC.LookupType='COUNTRY'
  left join tbl_lookup_values PT with (nolock) on PR.Intl_PaymentTerm =  PT.Lookupvalue and PT.lookupType='INTL_PAYMENT_TERMS'
  left join tbl_lookup_values FT with (nolock) on PR.Intl_FreightTerm =  FT.Lookupvalue and FT.LookupType='INTL_FREIGHT_TERMS'
  where PRId = (select PRId from tbl_PrNumbers  where PRNum=@PRnum)

  exec [PR_GetSupplierInfo] @PRNum
  
  exec [PR_GetPRContact] @PRNum
  
  exec [PR_GetPRCart] @PRNum
  
  end
GO
