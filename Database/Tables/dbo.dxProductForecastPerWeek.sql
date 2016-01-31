CREATE TABLE [dbo].[dxProductForecastPerWeek]
(
[FK_dxProduct] [int] NOT NULL,
[Year] [int] NOT NULL,
[Week] [int] NOT NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxProductForecastPerWeek_Quantity] DEFAULT ((0.0)),
[MinimumLevelQuantity] [float] NOT NULL CONSTRAINT [DF_dxProductForecastPerWeek_MinimumLevelQuantity] DEFAULT ((0.0)),
[SafetyStock] [float] NOT NULL CONSTRAINT [DF_dxProductForecastPerWeek_SafetyStock] DEFAULT ((0.0))
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductForecastPerWeek_FK_dxProduct] ON [dbo].[dxProductForecastPerWeek] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxProductForecastPerWeek] ON [dbo].[dxProductForecastPerWeek] ([Year], [Week]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductForecastPerWeek] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxProductForecastPerWeek] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
