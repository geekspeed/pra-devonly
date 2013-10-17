SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Insert_fx_rate_details]  
@fxdate datetime,  
@from_name nvarchar(64),  
@from_symbol nvarchar(64),  
@to_name nvarchar(64),  
@to_symbol nvarchar(64),  
@frate float,  
@crate float,  
@text nvarchar(256),  
@type nvarchar(64)  
AS  
INSERT fxrate_feeds(fxdate,from_name,from_symbol,to_name,to_symbol,frate,crate,text,type,active, created_date)  
values(@fxdate,@from_name,@from_symbol,@to_name,@to_symbol,@frate,@crate,@text,@type,1,getdate())
GO
