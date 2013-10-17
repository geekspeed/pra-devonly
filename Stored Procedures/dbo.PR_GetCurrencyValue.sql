SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_GetCurrencyValue]   
@CurrencySymbol varchar(16)   
AS  
BEGIN  
SELECT top 1 crate,created_date  FROM fxrate_feeds WHERE to_symbol =@CurrencySymbol order by created_date desc
END
GO
