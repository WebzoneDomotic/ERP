CREATE TABLE [dbo].[dxMRP]
(
[FK_dxProduct] [int] NOT NULL,
[LeadTime] [float] NOT NULL CONSTRAINT [DF_dxMRP_LeadTime] DEFAULT ((0.0)),
[Period] [int] NOT NULL CONSTRAINT [DF_dxMRP_Period] DEFAULT ((0)),
[PeriodDate] [datetime] NOT NULL,
[ForecastRequirements] [float] NOT NULL CONSTRAINT [DF_dxMRP_ForecastQuantity] DEFAULT ((0.0)),
[GrossRequirements] [float] NOT NULL CONSTRAINT [DF_dxMRP_GrossRequirements] DEFAULT ((0.0)),
[ScheduledReceipts] [float] NOT NULL CONSTRAINT [DF_dxMRP_ScheduledReceipts] DEFAULT ((0.0)),
[ProjectedOnHand] [float] NOT NULL CONSTRAINT [DF_dxMRP_ProjectedOnHand] DEFAULT ((0.0)),
[NetRequirements] [float] NOT NULL CONSTRAINT [DF_dxMRP_NetRequirements] DEFAULT ((0.0)),
[PlannedOrderReceipts] [float] NOT NULL CONSTRAINT [DF_dxMRP_PlannedOrderReceipts] DEFAULT ((0.0)),
[PlannedOrderReleases] [float] NOT NULL CONSTRAINT [DF_dxMRP_PlannedOrderReleases] DEFAULT ((0.0)),
[FK_dxVendor] [int] NULL,
[FK_dxPurchaseOrder] [int] NULL,
[FK_dxWorkOrder] [int] NULL,
[BOPeriod] [int] NULL,
[PK_dxMRP] [int] NOT NULL IDENTITY(1, 1),
[Selected] [bit] NOT NULL CONSTRAINT [DF_dxMRP_Selected] DEFAULT ((0)),
[ProposedQuantity] [float] NOT NULL CONSTRAINT [DF_dxMRP_ProposedQuantity] DEFAULT ((0.0)),
[Note] [varchar] (8000) COLLATE French_CI_AS NULL,
[SafetyStock] [float] NOT NULL CONSTRAINT [DF_dxMRP_SafetyStock] DEFAULT ((0.0)),
[CumulativeExpedition] [float] NOT NULL CONSTRAINT [DF_dxMRP_CumulativeExpedition] DEFAULT ((0.0)),
[PlannedExpedition] [float] NOT NULL CONSTRAINT [DF_dxMRP_PlannedExpedition] DEFAULT ((0.0)),
[CorrectedForecast] [float] NOT NULL CONSTRAINT [DF_dxMRP_CorrectedForecast] DEFAULT ((0.0)),
[CumulativeCorrectedForecast] [float] NOT NULL CONSTRAINT [DF_dxMRP_CumulativeCorrectedForecast] DEFAULT ((0.0)),
[ProductForecast] [float] NOT NULL CONSTRAINT [DF_dxMRP_ProductForecast] DEFAULT ((0.0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxMRP] ADD CONSTRAINT [PK_dxMRP] PRIMARY KEY CLUSTERED  ([PK_dxMRP]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxMRP_FK_dxProduct] ON [dbo].[dxMRP] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxMRP_FK_dxPurchaseOrder] ON [dbo].[dxMRP] ([FK_dxPurchaseOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxMRP_FK_dxVendor] ON [dbo].[dxMRP] ([FK_dxVendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxMRP_FK_dxWorkOrder] ON [dbo].[dxMRP] ([FK_dxWorkOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxMRPPeriod] ON [dbo].[dxMRP] ([Period]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxMRPPeriodDate] ON [dbo].[dxMRP] ([PeriodDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxMRP] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxMRP] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxMRP] ADD CONSTRAINT [dxConstraint_FK_dxPurchaseOrder_dxMRP] FOREIGN KEY ([FK_dxPurchaseOrder]) REFERENCES [dbo].[dxPurchaseOrder] ([PK_dxPurchaseOrder])
GO
ALTER TABLE [dbo].[dxMRP] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxMRP] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
ALTER TABLE [dbo].[dxMRP] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrder_dxMRP] FOREIGN KEY ([FK_dxWorkOrder]) REFERENCES [dbo].[dxWorkOrder] ([PK_dxWorkOrder])
GO
