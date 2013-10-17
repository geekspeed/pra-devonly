CREATE TABLE [dbo].[WorkStatus]
(
[WorkflowTrackingID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WorkflowTaskID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ComponentName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ComponentDescription] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EscalationSequenceNumber] [int] NULL,
[FinishPath] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhenWorkStatus] [datetime] NULL
) ON [PRIMARY]
GO
