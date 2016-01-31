CREATE TABLE [dbo].[dxWorkOrderResource]
(
[PK_dxWorkOrderResource] [int] NOT NULL IDENTITY(1, 1),
[FK_dxResource] [int] NOT NULL,
[Hours] [float] NOT NULL CONSTRAINT [DF_dxWorkOrderResource_Hours] DEFAULT ((0.0)),
[FK_dxWorkOrderPhase] [int] NOT NULL,
[FK_dxPhaseDetail] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxWorkOrderResource] ADD CONSTRAINT [PK_dxWorkOrderResource] PRIMARY KEY CLUSTERED  ([PK_dxWorkOrderResource]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrderResource_FK_dxPhaseDetail] ON [dbo].[dxWorkOrderResource] ([FK_dxPhaseDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrderResource_FK_dxResource] ON [dbo].[dxWorkOrderResource] ([FK_dxResource]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrderResource_FK_dxWorkOrderPhase] ON [dbo].[dxWorkOrderResource] ([FK_dxWorkOrderPhase]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxWorkOrderResource] ADD CONSTRAINT [dxConstraint_FK_dxPhaseDetail_dxWorkOrderResource] FOREIGN KEY ([FK_dxPhaseDetail]) REFERENCES [dbo].[dxPhaseDetail] ([PK_dxPhaseDetail])
GO
ALTER TABLE [dbo].[dxWorkOrderResource] ADD CONSTRAINT [dxConstraint_FK_dxResource_dxWorkOrderResource] FOREIGN KEY ([FK_dxResource]) REFERENCES [dbo].[dxResource] ([PK_dxResource])
GO
ALTER TABLE [dbo].[dxWorkOrderResource] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrderPhase_dxWorkOrderResource] FOREIGN KEY ([FK_dxWorkOrderPhase]) REFERENCES [dbo].[dxWorkOrderPhase] ([PK_dxWorkOrderPhase])
GO
