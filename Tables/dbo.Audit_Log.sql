CREATE TABLE [dbo].[Audit_Log]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[Activity] [varchar] (92) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL
) ON [PRIMARY]
GO
