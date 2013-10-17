SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetRemitEmailAddress]
@PREntity varchar(64)
AS
SELECT Email FROM tbl_Shipping_Info WHERE AddressType = 'Remit_Address' AND PREntity = @PREntity
GO
