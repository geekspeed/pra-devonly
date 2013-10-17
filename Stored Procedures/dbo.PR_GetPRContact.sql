SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetPRContact]
@PRNum int
AS
SET NOCOUNT ON

Select 
SC.SupplierId,
SC.ContactId,
SC.ContactName,
SC.ContactPhone,
SC.ContactEmail,
SC.ContactFax 
from tbl_SupplierInfo_Contact SC join tbl_PRNumbers PN
on PN.PrId = SC.PRId
where PN.PRNum=@PRNum
GO
