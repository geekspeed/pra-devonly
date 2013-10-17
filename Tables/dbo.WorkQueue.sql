CREATE TABLE [dbo].[WorkQueue]
(
[WorkTaskID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WorkflowTrackingID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModelID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ComponentID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Context] [image] NULL,
[ComponentName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
