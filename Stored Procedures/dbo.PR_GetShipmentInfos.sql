SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetShipmentInfos]  
AS  
select *  
from tbl_Shipping_info
GO
