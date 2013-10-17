SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetPONumber]
(
@PONumber varchar(32),
@IntlPONumber varchar(32),
@Entity varchar(32)
)
returns varchar(32)
AS
BEGIN
	--Declare @retPONumber varchar(32)
	--SET @retPONumber = ''
	--SET @retPONumber = @PONumber
	--IF((SELECT COUNT(1) FROM tbl_Lookup_Values WHERE LookupType = 'NON_SAP' AND LookupValue = @Entity) > 0)
	--BEGIN 
	--	SET @retPONumber = @IntlPONumber
	--END

	return @PONumber
	 -- nothing changes
END
GO
