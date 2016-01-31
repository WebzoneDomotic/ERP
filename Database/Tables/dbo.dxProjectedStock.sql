CREATE TABLE [dbo].[dxProjectedStock]
(
[PK_dxProjectedStock] [int] NOT NULL IDENTITY(1, 1),
[Document] [varchar] (50) COLLATE French_CI_AS NULL,
[FK_dxProduct] [int] NULL,
[PeriodDate] [datetime] NULL,
[Level] [int] NOT NULL CONSTRAINT [DF_dxProjectedStock_Level] DEFAULT ((0)),
[GrossRequirements] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_GrossRequirements] DEFAULT ((0)),
[CumulativeGrossRequirements] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_CumulativeGrossRequirements] DEFAULT ((0)),
[ScheduledReceipts] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_ScheduledReceipts] DEFAULT ((0)),
[PlannedExpedition] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_PlannedExpedition] DEFAULT ((0)),
[Stock] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_Stock] DEFAULT ((0)),
[ProjectedStock] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_ProjectedStock] DEFAULT ((0)),
[RecNo] [int] NOT NULL CONSTRAINT [DF_dxProjectedStock_RecNo] DEFAULT ((-1)),
[Forecast] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_Forecast] DEFAULT ((0.0)),
[CumulativeForecast] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_CumulativeForecast] DEFAULT ((0.0)),
[ProjectedStockNoForecast] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_ProjectedStockNoForecast] DEFAULT ((0.0)),
[ProjectedStockWithAllPO] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_ProjectedStockWithAllPO] DEFAULT ((0.0)),
[ProposedQuantity] [float] NOT NULL CONSTRAINT [DF_dxProjectedStock_ProposedQuantity] DEFAULT ((0.0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProjectedStock] ADD CONSTRAINT [PK_dxProjectedStock] PRIMARY KEY CLUSTERED  ([PK_dxProjectedStock]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProjectedStock_FK_dxProduct] ON [dbo].[dxProjectedStock] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxProjectedStockLevel] ON [dbo].[dxProjectedStock] ([FK_dxProduct], [Level]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxProjectedStockPeriod] ON [dbo].[dxProjectedStock] ([FK_dxProduct], [PeriodDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProjectedStock] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxProjectedStock] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
