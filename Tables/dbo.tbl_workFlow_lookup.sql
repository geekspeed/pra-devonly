CREATE TABLE [dbo].[tbl_workFlow_lookup]
(
[wflookupid] [int] NOT NULL IDENTITY(1, 1),
[LookupType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LookupValue] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lookupText] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[approverlevel] [int] NULL,
[isActive] [bit] NULL,
[createDate] [datetime] NULL,
[lastModifiedDate] [datetime] NULL,
[createdBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
