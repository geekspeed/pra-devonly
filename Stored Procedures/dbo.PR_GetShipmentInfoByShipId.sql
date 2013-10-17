SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_GetShipmentInfoByShipId]  
@ShipId int  
as  
SET NOCOUNT ON  
select distinct top 1 isnull([ShipToCategory],'') ShipToCategory
      ,isnull([ShipToName],'') ShipToName
      ,isnull([ShipToAddrLine1],'') ShipToAddrLine1
      ,isnull([ShipToAddrLine2],'') ShipToAddrLine2
      ,isnull([ShipToCity],'') ShipToCity
      ,isnull([ShipToState],'') ShipToState
      ,isnull([shipToCountry],'') shipToCountry
      ,isnull([ShipToZipcode],'') ShipToZipcode
      ,isnull([CustomField1],'') CustomField1
      ,isnull([CustomField2],'') CustomField2
      ,isnull([CustomField3],'') CustomField3
      ,isnull([CustomField4],'') CustomField4
      ,isnull([CustomField5],'') CustomField5
 from dbo.tbl_Shipping_info 
where shipToId=@ShipId
GO
