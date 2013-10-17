SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GetFxRates]
AS
select fxRate_id,fxDate, from_symbol, to_name, to_symbol, fRate,cRate, Created_Date  from [fxRate_feeds] WHERE active = 1
GO
