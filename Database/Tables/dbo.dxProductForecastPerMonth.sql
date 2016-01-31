CREATE TABLE [dbo].[dxProductForecastPerMonth]
(
[FK_dxProduct] [int] NOT NULL,
[Year] [int] NOT NULL,
[Month] [int] NOT NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxProductForecastPerMonth_Quantity] DEFAULT ((0.0)),
[MinimumLevelQuantity] [float] NOT NULL CONSTRAINT [DF_dxProductForecastPerMonth_MinimumLevelQuantity] DEFAULT ((0.0)),
[SafetyStock] [float] NOT NULL CONSTRAINT [DF_dxProductForecastPerMonth_SafetyStock] DEFAULT ((0.0))
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductForecastPerMonth_FK_dxProduct] ON [dbo].[dxProductForecastPerMonth] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxProductForecastPerMonth] ON [dbo].[dxProductForecastPerMonth] ([Year], [Month]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductForecastPerMonth] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxProductForecastPerMonth] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
