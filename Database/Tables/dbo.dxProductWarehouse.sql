CREATE TABLE [dbo].[dxProductWarehouse]
(
[PK_dxProductWarehouse] [int] NOT NULL IDENTITY(1, 1),
[FK_dxWarehouse] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[InStockQuantity] [float] NOT NULL CONSTRAINT [DF_dxProductInventory_InStockQuantity] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxProductInventory_TotalCost] DEFAULT ((0.0)),
[AverageAmountPerUnit] AS (case  when abs([InStockQuantity])<(0.0000001) then (0.0) else round([TotalAmount]/[InStockQuantity],(6)) end)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxProductWarehouse.trUpdateWarehouse] ON [dbo].[dxProductWarehouse]
AFTER UPDATE, INSERT
AS
BEGIN
  SET NOCOUNT ON
  -- Update Warehouse
  Update pl set
    pl.TotalAmount = ( select Round(coalesce( sum(pt.TotalAmount), 0.0 ),2) from dbo.dxProductWarehouse pt
                        where pt.FK_dxWarehouse = pl.PK_dxWarehouse)
  From inserted de
  left join dbo.dxWarehouse pl on  ( de.FK_dxWarehouse = pl.PK_dxWarehouse )

END
GO
ALTER TABLE [dbo].[dxProductWarehouse] ADD CONSTRAINT [PK_dxProductInventory] PRIMARY KEY CLUSTERED  ([PK_dxProductWarehouse]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductWarehouse_FK_dxProduct] ON [dbo].[dxProductWarehouse] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductWarehouse_FK_dxWarehouse] ON [dbo].[dxProductWarehouse] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductWarehouse] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxProductWarehouse] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxProductWarehouse] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxProductWarehouse] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
