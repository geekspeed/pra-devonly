SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[PR_UpdatePRInfo]  
@RequestorId     varchar(30),  
@RequestorDept     varchar(50),  
@RequestorPhone varchar(50),  
@GLCode           varchar(15),  
@Priority   varchar(15),  
@ModifiedBy   varchar(30),  
@Requesteddate  datetime,  
@Justification     varchar(max),  
@CompanySites varchar(50),  
@ShipName   varchar(75),  
@ShipCompany   varchar(100),  
@ShipAddrLine1 varchar(100),  
@ShipAddrLine2 varchar(100),  
@ShipCity   varchar(50),  
@ShipState   varchar(50),  
@ShipCountry  varchar(50),  
@ShipZipcode  varchar(20),  
@LastApprovedBy varchar(50),  
@PONumber   varchar(25),  
@Status    varchar(20),  
@PODate   datetime,  
@PaymentTerms varchar(400),  
@FreightTerms varchar(50),  
@Taxable varchar(3),  
@AcctCharged varchar(50),  
@ChangeOrder bit,  
@NewVendor varchar(3),  
@ParentPO varchar(25),  
@Buyer varchar(30),  
@DeptCharged varchar(15),  
@Comments varchar(max),  
@Title varchar(max),  
@ShipElectronic varchar(5),  
@PRNum int,
@Entity varchar(32)
as  
UPDATE tbl_PurchaseReq  
   SET RequestorId = @RequestorId  
      ,RequestorDept = @RequestorDept  
      ,RequestorPhone = @RequestorPhone  
      ,GLCode = @GLCode  
      ,Priority = @Priority  
      ,Requesteddate = @Requesteddate  
      ,Justification = @Justification  
   ,CompanySites=@CompanySites  
      ,ShipName = @ShipName  
   ,ShipCompany=@ShipCompany  
      ,ShipAddrLine1 = @ShipAddrLine1  
      ,ShipAddrLine2 = @ShipAddrLine2  
      ,ShipCity = @ShipCity  
      ,ShipState = @ShipState  
      ,ShipCountry = @ShipCountry  
      ,ShipZipcode = @ShipZipcode  
      ,LastApprovedBy = @LastApprovedBy  
      ,PONumber = @PONumber  
      ,ModifiedDate = getdate()  
      ,ModifiedBy = @ModifiedBy  
      ,Status = @Status  
      ,PODate = @PODate  
      ,PaymentTerms = @PaymentTerms  
      ,FreightTerms = @FreightTerms  
      ,Taxable = @Taxable  
      ,AcctCharged = @AcctCharged  
,ChangeOrder=@ChangeOrder  
,NewVendor=@NewVendor  
,ParentPO=@ParentPO  
,Buyer = @Buyer  
,DeptCharged = @DeptCharged  
,Comments=@Comments  
,Title=@Title  
,ShipElectronic=@ShipElectronic
,Entity=@Entity  
 where PrId= (select distinct top 1 PRId from tbl_PRnumbers where PRnum=@PrNum)
GO
