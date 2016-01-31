CREATE TABLE [dbo].[inv]
(
[PK] [bigint] NOT NULL IDENTITY(1, 1),
[cu] [float] NULL CONSTRAINT [DF_inv_cu] DEFAULT ((0)),
[qty] [float] NULL CONSTRAINT [DF_inv_qty] DEFAULT ((0)),
[Cost] AS ([cu]*[qty]),
[TotalCost] [float] NULL CONSTRAINT [DF_inv_TotalCost] DEFAULT ((0)),
[TotalQty] [float] NULL CONSTRAINT [DF_inv_TotalQty] DEFAULT ((0)),
[AvgCost] [float] NULL CONSTRAINT [DF_inv_AvgCost] DEFAULT ((0))
) ON [PRIMARY]
GO
