SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[UpSert_FinanceMatrix]
(
@DeptCode varchar(32),
@ApproverID varchar(32),
@Entity varchar(64),
@UserID varchar(64)
)
AS
BEGIN 
UPDATE tbl_finance_matrix SET isActive = 0, lastModifiedDate = GetDate(),lastModifiedBy =@UserID 
WHERE DeptCode = @DeptCode AND isActive = 1 AND EmpEntity = @Entity

INSERT tbl_finance_matrix(DeptCode,PRType,FinLevel,ApproverID,isActive,CreateDate,CreatedBy,EmpEntity) VALUES(@DeptCode,'IndirMat',60,@ApproverID,1,GetDate(),@UserID,@Entity)
INSERT tbl_finance_matrix(DeptCode,PRType,FinLevel,ApproverID,isActive,CreateDate,CreatedBy,EmpEntity) VALUES(@DeptCode,'DirMat',60,@ApproverID,1,GetDate(),@UserID,@Entity)
END
GO
