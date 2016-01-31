CREATE TABLE [dbo].[dxProductLocation]
(
[PK_dxProductLocation] [int] NOT NULL IDENTITY(1, 1),
[FK_dxWarehouse] [int] NOT NULL CONSTRAINT [DF_dxProductLocation_FK_dxWarehouse] DEFAULT ((1)),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxProductLocation_FK_dxLocation] DEFAULT ((1)),
[FK_dxProduct] [int] NOT NULL CONSTRAINT [DF_dxProductLocation_FK_dxProduct] DEFAULT ((1)),
[InStockQuantity] [float] NOT NULL CONSTRAINT [DF_dxProductLocation_InStockQuantity] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxProductLocation_TotalAmount] DEFAULT ((0.0)),
[AverageAmountPerUnit] AS (case  when abs([InStockQuantity])<(0.0000001) then (0.0) else round([TotalAmount]/[InStockQuantity],(6)) end)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxProductLocation.trUpdateProductWarehouse] ON [dbo].[dxProductLocation]
AFTER UPDATE, INSERT
AS
BEGIN
  SET NOCOUNT ON
  -- Update Product Warehouse
  Insert into dbo.dxProductWarehouse ( FK_dxWarehouse , FK_dxProduct )
    select distinct FK_dxWarehouse , FK_dxProduct from inserted pt
  where ( not exists ( select 1 from dbo.dxProductWarehouse a2
                     where a2.FK_dxWarehouse = pt.FK_dxWarehouse
                       and a2.FK_dxProduct   = pt.FK_dxProduct ))
  Update pl set
    pl.TotalAmount = ( select Round(coalesce( sum(pt.TotalAmount), 0.0 ),2) from dbo.dxProductLocation pt
                        where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                          and pt.FK_dxProduct   = pl.FK_dxProduct) ,
    pl.InStockQuantity = ( select Round(coalesce( sum(InStockQuantity), 0.0 ),6) from dbo.dxProductLocation pt
                        where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                          and pt.FK_dxProduct   = pl.FK_dxProduct)
  From inserted de
  left join dbo.dxProductWarehouse pl on
  (      de.FK_dxWarehouse = pl.FK_dxWarehouse
     and de.FK_dxProduct   = pl.FK_dxProduct )
END
GO
ALTER TABLE [dbo].[dxProductLocation] ADD CONSTRAINT [PK_dxProductLocation] PRIMARY KEY CLUSTERED  ([PK_dxProductLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductLocation_FK_dxLocation] ON [dbo].[dxProductLocation] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductLocation_FK_dxProduct] ON [dbo].[dxProductLocation] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductLocation_FK_dxWarehouse] ON [dbo].[dxProductLocation] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductLocation] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxProductLocation] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxProductLocation] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxProductLocation] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxProductLocation] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxProductLocation] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
