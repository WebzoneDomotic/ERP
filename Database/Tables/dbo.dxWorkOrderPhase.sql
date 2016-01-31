CREATE TABLE [dbo].[dxWorkOrderPhase]
(
[PK_dxWorkOrderPhase] [int] NOT NULL IDENTITY(1, 1),
[FK_dxWorkOrder] [int] NOT NULL,
[FK_dxRouting] [int] NOT NULL,
[FK_dxPhase] [int] NOT NULL,
[PhaseNumber] [int] NOT NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[StartDate] [datetime] NOT NULL,
[FinishDate] [datetime] NOT NULL,
[Duration] [float] NOT NULL CONSTRAINT [DF_dxWorkOrderPhase_Duration] DEFAULT ((0.0)),
[IsWorkOrder] [bit] NOT NULL CONSTRAINT [DF_dxWorkOrderPhase_IsWorkOrder] DEFAULT ((0)),
[FK_dxWorkOrderPhase__WorkOrder] [int] NULL,
[LateFinishDate] [datetime] NULL,
[Locked] [bit] NOT NULL CONSTRAINT [DF_dxWorkOrderPhase_Locked] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxWorkOrderPhase.trWorkOrderPhaseDelete] ON [dbo].[dxWorkOrderPhase]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  --Delete the SchedulerEvent
  Delete from dxSchedulerEvent     where FK_dxWorkOrderPhase in (SELECT PK_dxWorkOrderPhase From dxWorkOrderPhase where FK_dxWorkOrderPhase__WorkOrder in (SELECT PK_dxWorkOrderPhase FROM deleted)) ;
  Delete from dxSchedulerEvent     where FK_dxWorkOrderPhase in (SELECT PK_dxWorkOrderPhase FROM deleted) ;
  Delete from dxWorkOrderResource  where FK_dxWorkOrderPhase in (SELECT PK_dxWorkOrderPhase FROM deleted) ;
  -- Delete the children if it is the case
  Delete from dxWorkOrderPhase     where FK_dxWorkOrderPhase__WorkOrder in (SELECT PK_dxWorkOrderPhase FROM deleted) ;
  Delete from dxWorkOrderPhase     where PK_dxWorkOrderPhase in (SELECT PK_dxWorkOrderPhase FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxWorkOrderPhase.trWorkOrderPhaseEvent] ON [dbo].[dxWorkOrderPhase]
FOR INSERT, UPDATE
AS

  --Insert the SchedulerEvent only if does not exists
  INSERT INTO dxSchedulerEvent (
         FK_dxWorkOrderPhase
        ,ID
        ,ParentID
        ,Caption
        ,Location
        ,Start
        ,Finish
         )
    Select  PK_dxWorkOrderPhase
           ,PK_dxWorkOrderPhase
           ,FK_dxWorkOrderPhase__WorkOrder
           ,''
           ,Convert(Varchar(50), AskedQuantity)
           ,DateAdd(hh, 8,WorkOrderDate)
           ,DateAdd(hh,12,WorkOrderDate)
          from inserted wp
      Left outer join dxWorkOrder wo on ( wo.PK_dxWorkOrder = wp.FK_dxWorkOrder)
      Left outer join dxProduct   pr on ( pr.PK_dxProduct = wo.FK_dxProduct)
      where ( not exists ( Select 1 from dxSchedulerEvent where FK_dxWorkOrderPhase = wp.PK_dxWorkOrderPhase  ) )


    if update ( FK_dxWorkOrderPhase__WorkOrder ) or update( StartDate) or update ( FinishDate )
      Update se
         set se.Caption  = wp.Description
           , se.Start    = wp.StartDate
           , se.Finish   = wp.FinishDate
           , se.ParentID = wp.FK_dxWorkOrderPhase__WorkOrder
           , se.GroupID  = wp.FK_dxWorkOrderPhase__WorkOrder
      From inserted  wp
      left join dxSchedulerEvent se on ( wp.PK_dxWorkOrderPhase = se.FK_dxWorkOrderPhase)
GO
ALTER TABLE [dbo].[dxWorkOrderPhase] ADD CONSTRAINT [PK_dxWorkOrderPhase] PRIMARY KEY CLUSTERED  ([PK_dxWorkOrderPhase]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrderPhase_FK_dxPhase] ON [dbo].[dxWorkOrderPhase] ([FK_dxPhase]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrderPhase_FK_dxRouting] ON [dbo].[dxWorkOrderPhase] ([FK_dxRouting]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrderPhase_FK_dxWorkOrder] ON [dbo].[dxWorkOrderPhase] ([FK_dxWorkOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrderPhase_FK_dxWorkOrderPhase__WorkOrder] ON [dbo].[dxWorkOrderPhase] ([FK_dxWorkOrderPhase__WorkOrder]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxWorkOrderPhase] ADD CONSTRAINT [dxConstraint_FK_dxPhase_dxWorkOrderPhase] FOREIGN KEY ([FK_dxPhase]) REFERENCES [dbo].[dxPhase] ([PK_dxPhase])
GO
ALTER TABLE [dbo].[dxWorkOrderPhase] ADD CONSTRAINT [dxConstraint_FK_dxRouting_dxWorkOrderPhase] FOREIGN KEY ([FK_dxRouting]) REFERENCES [dbo].[dxRouting] ([PK_dxRouting])
GO
ALTER TABLE [dbo].[dxWorkOrderPhase] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrder_dxWorkOrderPhase] FOREIGN KEY ([FK_dxWorkOrder]) REFERENCES [dbo].[dxWorkOrder] ([PK_dxWorkOrder])
GO
ALTER TABLE [dbo].[dxWorkOrderPhase] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrderPhase__WorkOrder_dxWorkOrderPhase] FOREIGN KEY ([FK_dxWorkOrderPhase__WorkOrder]) REFERENCES [dbo].[dxWorkOrderPhase] ([PK_dxWorkOrderPhase])
GO
