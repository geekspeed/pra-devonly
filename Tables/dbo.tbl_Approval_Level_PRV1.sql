CREATE TABLE [dbo].[tbl_Approval_Level_PRV1]
(
[PRType] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Level] [int] NOT NULL,
[MinAmount] [money] NOT NULL,
[MaxAmount] [money] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
