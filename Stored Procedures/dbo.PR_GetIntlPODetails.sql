SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetIntlPODetails]
@PRNum int
as
begin
set NoCOUNT ON
select 
isnull(Intl_AddlComments,'') Intl_AddlComments,
isnull(Intl_Buyer,'') Intl_Buyer,
isnull(Intl_DelTerms,'') Intl_DelTerms,
isnull(Intl_FreightTerm,'')Intl_FreightTerm,
isnull(Intl_PaymentTerm,'')Intl_PaymentTerm,
isnull(convert(varchar(10),Intl_PoDate,101),'')Intl_PoDate,
isnull(Intl_PONumber,'')Intl_PONumber,
isnull(Intl_VendorquoteRef,'')Intl_VendorquoteRef
from  tbl_PurchaseReq where PRId= (select PRId from tbl_PRNumbers where PRNum=@PRNum)

end
GO
