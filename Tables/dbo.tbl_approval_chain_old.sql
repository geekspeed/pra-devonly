CREATE TABLE [dbo].[tbl_approval_chain_old]
(
[ApprovalPRNumber] [int] NOT NULL,
[ApproverName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApproverLevel] [int] NOT NULL,
[ApproverDepartment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApproverResponseDate] [datetime] NULL,
[ApproverResponse] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApproverEmail] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApproverPRSentDAte] [datetime] NULL,
[ApproverResponseComments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseTaskId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [dbo].[trig_insert_approval_chain]
   ON  [dbo].[tbl_approval_chain_old] 
   AFTER insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @oldValue varchar(25)
declare @PrNum int,@email varchar(50),@trig varchar(25),@rowCnt int
set @trig = 'false'
set @oldValue='UNKNOWN'
select @email=approveremail,@PrNum=approvalprnumber from inserted

--print @email
--print @PrNum

if @email='dl-purchasereq@arubanetworks.com' 
Begin
	select @rowCnt = Count(*) from tbl_approval_chain where approvalprnumber=@PrNum
	if @rowcnt = 1 --for mdf kinda requests
	Begin
		select @trig = Prnum from vw_intl_purchasereq where Prnum=@PrNum and 
		requestordept in (110,210,220,230,240,310,320,400,405,410,420,425,430,435,440,445,450,460,500,510,520,525,530,540,550,551,553,555,560,565,570,575,580,585,591,592,593,600, 608, 690, 691,692,693,695,770) and PRvalue>= 50000 and PRtype='Non-Inventory'
		if @trig <> 'false'
		Begin
			update tbl_approval_chain set approverresponse='INPROCESS' where approvalprnumber=@PrNum and approveremail='dl-purchasereq@arubanetworks.com'
			insert into tbl_approval_chain
			select top 1 approvalprnumber,'Hitesh Sheth',109 as approverlevel,approverdepartment,getdate() approverresponsedate,'PENDING' Approverresponse,'hsheth@arubanetworks.com' approveremail,getdate() approverprsentdate,approverresponsecomments,replace(replace(convert(varchar(36),getdate()),' ',''),':','') responsetaskid from tbl_approval_chain where approvalprnumber=@PrNum and approveremail='dl-purchasereq@arubanetworks.com'
			--print 'triggered'
		End
		
	End
End


END

GO
DISABLE TRIGGER [dbo].[trig_insert_approval_chain] ON [dbo].[tbl_approval_chain_old]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [dbo].[trig_replacements] on [tbl_approval_chain_old]
for insert
as
declare @OldApproverEmail varchar(50),@ResponseTaskId varchar(100)
declare @NewApproverName varchar(50),@NewApproverEmail varchar(50)

select @OldApproverEmail=ApproverEmail,@ResponseTaskId=ResponseTaskId from Inserted
if(@OldApproverEmail='mlu@arubanetworks.com')
Begin
Update tbl_approval_chain set ApproverEmail='afanse@arubanetworks.com', ApproverName='Ashish Fanse'
where ResponseTaskId=@ResponseTaskId
End
GO
DISABLE TRIGGER [dbo].[trig_replacements] ON [dbo].[tbl_approval_chain_old]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [dbo].[trig_Update_approval_chain]
   ON  [dbo].[tbl_approval_chain_old] 
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @oldValue varchar(25)
declare @PrNum int,@email varchar(50),@trig varchar(25)
set @trig = 'false'
set @oldValue='UNKNOWN'
select @oldValue = Approverresponse,@email=approveremail,@PrNum=approvalprnumber from deleted
--print  @oldValue
--print @email
--print @PrNum

if @email='dl-purchasereq@arubanetworks.com' and @oldValue=''
Begin
	select @trig = Prnum from vw_intl_purchasereq where Prnum=@PrNum and 
	requestordept in (110,210,220,230,240,310,320,400,405,410,420,425,430,435,440,445,450,460,500,510,520,525,530,540,550,551,553,555,560,565,570,575,580,585,591,592,593,
	600, 608, 690, 691,692,693,695,770) and PRvalue>= 50000 and  PRtype='Non-Inventory'
	if @trig <> 'false'
		Begin
			update tbl_approval_chain set approverresponse='INPROCESS' where approvalprnumber=@PrNum and approveremail='dl-purchasereq@arubanetworks.com'
			insert into tbl_approval_chain
			select top 1 approvalprnumber,'Hitesh Sheth',109 as approverlevel,approverdepartment,getdate() approverresponsedate,'PENDING' Approverresponse,'hsheth@arubanetworks.com' approveremail,getdate() approverprsentdate,approverresponsecomments,replace(replace(convert(varchar(36),getdate()),' ',''),':','') responsetaskid from tbl_approval_chain where approvalprnumber=@PrNum and approveremail='dl-purchasereq@arubanetworks.com'
			--print 'triggered'
		End
		

End


END

GO
DISABLE TRIGGER [dbo].[trig_Update_approval_chain] ON [dbo].[tbl_approval_chain_old]
GO
