SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[UpSert_FxRates]
(
@FxDate DateTime,
@ToSymbol varchar(32),
@ToName varchar(128),
@fRate float,
@cRate float,
@UserID varchar(64)
)
AS
BEGIN
UPDATE fxRate_feeds SET text = 'Updated by ' + @UserID, active = 0 WHERE to_symbol = @ToSymbol AND active = 1

INSERT fxRate_feeds(fxdate,from_name,from_symbol,to_name,to_symbol,frate,crate,text,type,active,created_date)
VALUES(@FxDate,'United States','USD',@ToName,@ToSymbol,@fRate,@cRate, 'Created by ' + @UserID, 'Though PRAdmin',1,getdate())
END
GO
