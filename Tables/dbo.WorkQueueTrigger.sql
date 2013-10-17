CREATE TABLE [dbo].[WorkQueueTrigger]
(
[WorkQueueTriggerID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WorkTaskID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processed] [bit] NULL,
[Sequence] [int] NULL,
[TriggerTime] [datetime] NULL,
[TriggerType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
