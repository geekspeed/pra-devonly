SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetShipmentInfo]
@ShipToCategory varchar(75)
as
SET NOCOUNT ON
select distinct top 1
ShipToName,ShipToAddrLine1,isnull(ShipToAddrLine2,'') ShipToAddrLine2,ShipToCity,ShipToState,ShipToCountry,
ShipToZipcode
from tbl_Shipping_info
where shipToCategory=@ShipToCategory
GO
