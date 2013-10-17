SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PR_UpdateIntlPODetails]
@PRNum int,
@PaymentTerms varchar(25),
@UserId varchar(30),
@FreightTerms varchar(25),
@Buyer varchar(25),
@VendorQuoteNum varchar(25),
@PODate datetime,
@DeliveryTerms varchar(max),
@AddlComments varchar(max)
as
begin
declare @result varchar(25)
Begin Try
	Begin tran
	exec dbo.sp_ARUN_NEWID 'INTLPONUM', @result OUT
	print 'from SP='+@result
	if @result is not null
	Begin
	update tbl_PurchaseReq set 
	Intl_AddlComments= @AddlComments,
	Intl_Buyer=@Buyer,
	Intl_DelTerms=@DeliveryTerms,
	Intl_FreightTerm= @FreightTerms,
	Intl_PaymentTerm=@PaymentTerms,
	Intl_PoDate=@PODate,
	Intl_PONumber=@result,
	Intl_VendorquoteRef=@VendorQuoteNum,
	ModifiedBy=@UserId,
	ModifiedDate=GETDATE()
	where PRId= (select PRId from tbl_PRNumbers where PRNum=@PRNum)
	commit 
	select @result
	end
	else
	Begin
	rollback
	select ''
	end
	
End try
Begin Catch
if @@TRANCOUNT >0
rollback
select ''
end catch

end
GO
