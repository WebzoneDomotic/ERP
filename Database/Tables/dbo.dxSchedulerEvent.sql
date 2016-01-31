CREATE TABLE [dbo].[dxSchedulerEvent]
(
[PK_dxSchedulerEvent] [int] NOT NULL IDENTITY(1, 1),
[FK_dxWorkOrder] [int] NULL,
[ActualFinish] [int] NULL,
[ActualStart] [int] NULL,
[Caption] [varchar] (2000) COLLATE French_CI_AS NULL,
[EventType] [int] NULL,
[Finish] [datetime] NULL,
[ID] [int] NULL,
[LabelColor] [int] NULL,
[Location] [varchar] (2000) COLLATE French_CI_AS NULL,
[Message] [varchar] (8000) COLLATE French_CI_AS NULL,
[Options] [int] NULL,
[ParentID] [int] NULL,
[RecurrenceIndex] [int] NULL,
[RecurrenceInfo] [text] COLLATE French_CI_AS NULL,
[ReminderDate] [varchar] (100) COLLATE French_CI_AS NULL,
[ReminderMinutesBeforeStart] [varchar] (100) COLLATE French_CI_AS NULL,
[ReminderResourcesData] [text] COLLATE French_CI_AS NULL,
[ResourceID] [text] COLLATE French_CI_AS NULL,
[Start] [datetime] NULL,
[State] [int] NULL,
[TaskCompleteField] [int] NULL,
[TaskIndexField] [int] NULL,
[TaskLinksField] [text] COLLATE French_CI_AS NULL,
[TaskStatusField] [bit] NULL,
[FK_dxClient] [int] NULL,
[FK_dxVendor] [int] NULL,
[FK_dxLinkedRecordDocument] [int] NULL,
[FK_dxWorkOrderPhase] [int] NULL,
[GroupID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxSchedulerEvent] ADD CONSTRAINT [PK_dxSchedulerEvent] PRIMARY KEY CLUSTERED  ([PK_dxSchedulerEvent]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxSchedulerEventTypeDates] ON [dbo].[dxSchedulerEvent] ([EventType], [Start], [Finish]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxSchedulerEventFinish] ON [dbo].[dxSchedulerEvent] ([Finish] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSchedulerEvent_FK_dxClient] ON [dbo].[dxSchedulerEvent] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSchedulerEvent_FK_dxLinkedRecordDocument] ON [dbo].[dxSchedulerEvent] ([FK_dxLinkedRecordDocument]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSchedulerEvent_FK_dxVendor] ON [dbo].[dxSchedulerEvent] ([FK_dxVendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSchedulerEvent_FK_dxWorkOrder] ON [dbo].[dxSchedulerEvent] ([FK_dxWorkOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSchedulerEvent_FK_dxWorkOrderPhase] ON [dbo].[dxSchedulerEvent] ([FK_dxWorkOrderPhase]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxSchedulerEventStart] ON [dbo].[dxSchedulerEvent] ([Start] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxSchedulerEvent] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxSchedulerEvent] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxSchedulerEvent] ADD CONSTRAINT [dxConstraint_FK_dxLinkedRecordDocument_dxSchedulerEvent] FOREIGN KEY ([FK_dxLinkedRecordDocument]) REFERENCES [dbo].[dxLinkedRecordDocument] ([PK_dxLinkedRecordDocument])
GO
ALTER TABLE [dbo].[dxSchedulerEvent] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxSchedulerEvent] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
ALTER TABLE [dbo].[dxSchedulerEvent] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrder_dxSchedulerEvent] FOREIGN KEY ([FK_dxWorkOrder]) REFERENCES [dbo].[dxWorkOrder] ([PK_dxWorkOrder])
GO
ALTER TABLE [dbo].[dxSchedulerEvent] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrderPhase_dxSchedulerEvent] FOREIGN KEY ([FK_dxWorkOrderPhase]) REFERENCES [dbo].[dxWorkOrderPhase] ([PK_dxWorkOrderPhase])
GO
