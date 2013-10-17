CREATE TABLE [dbo].[tbl_Purchasereq]
(
[PRId] [int] NOT NULL IDENTITY(1, 1),
[RequestorId] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestorDept] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestorPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GLCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Priority] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL,
[CreatedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestedDate] [datetime] NULL,
[Justification] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCompany] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddrLine1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipAddrLine2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipCountry] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipZipcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PONumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedDate] [datetime] NULL,
[ModifiedBy] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PODate] [datetime] NULL,
[PaymentTerms] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FreightTerms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Taxable] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctCharged] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeOrder] [bit] NULL,
[ParentPO] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewVendor] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanySites] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Buyer] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeptCharged] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHIPELECTRONIC] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Intl_PONumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Intl_PaymentTerm] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Intl_FreightTerm] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Intl_VendorquoteRef] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Intl_PoDate] [datetime] NULL,
[Intl_Buyer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Intl_DelTerms] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Intl_AddlComments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Entity] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[trig_PR_updatePurchaseReq]
ON [dbo].[tbl_Purchasereq]
FOR UPDATE
AS
SET NOCOUNT ON
DECLARE @OldValue varchar(100)
DECLARE @NewValue varchar(100)
DECLARE @ModifiedBy VARCHAR(30)
DECLARE @FieldName VARCHAR(100)
DECLARE @PRId int
SELECT @PRId = (SELECT PRId FROM Inserted)
SELECT @ModifiedBy = (SELECT ModifiedBy FROM Inserted)
IF UPDATE(Status) 
BEGIN
SET @FieldName = 'Status'
SELECT @OldValue = (SELECT Status FROM Deleted)
SELECT @NewValue = (SELECT Status FROM Inserted)
if(@OldValue <> @NewValue )
Insert into tbl_PurchaseReq_Audit(PRID,FieldName,Oldvalue,NewValue,ModifiedBY,ModifiedDate,TblAction)
values
(@PRId,@FieldName,@OldValue,@NewValue,@ModifiedBy,getdate(),'U')

IF UPDATE(ModifiedBy) 
BEGIN
SET @FieldName = 'ModifiedBy'
SELECT @OldValue = (SELECT ModifiedBy FROM Deleted)
SELECT @NewValue = (SELECT ModifiedBy FROM Inserted)
if(@OldValue <> @NewValue )
Insert into tbl_PurchaseReq_Audit(PRID,FieldName,Oldvalue,NewValue,ModifiedBY,ModifiedDate,TblAction)
values
(@PRId,@FieldName,@OldValue,@NewValue,@ModifiedBy,getdate(),'U')
END

END
GO
ALTER TABLE [dbo].[tbl_Purchasereq] ADD CONSTRAINT [PK_tblPR1_PRId] PRIMARY KEY CLUSTERED  ([PRId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_purchasereq_requestorid] ON [dbo].[tbl_Purchasereq] ([RequestorId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PRStatus] ON [dbo].[tbl_Purchasereq] ([Status]) INCLUDE ([PRId]) ON [PRIMARY]
GO
