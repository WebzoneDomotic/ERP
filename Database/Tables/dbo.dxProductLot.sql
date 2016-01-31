CREATE TABLE [dbo].[dxProductLot]
(
[PK_dxProductLot] [int] NOT NULL IDENTITY(1, 1),
[FK_dxWarehouse] [int] NOT NULL CONSTRAINT [DF_dxProductLot_FK_dxWarehouse] DEFAULT ((1)),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxProductLot_FK_dxLocation] DEFAULT ((1)),
[FK_dxProduct] [int] NOT NULL CONSTRAINT [DF_dxProductLot_FK_dxProduct] DEFAULT ((1)),
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxProductLot_Lot] DEFAULT ('0'),
[InStockQuantity] [float] NOT NULL CONSTRAINT [DF_dxProductLot_InStockQuantity] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxProductLot_TotalAmount] DEFAULT ((0.0)),
[AverageAmountPerUnit] AS (case  when abs([InStockQuantity])<(0.0000001) then (0.0) else round([TotalAmount]/[InStockQuantity],(6)) end)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxProductLot.trUpdateProductLocation] ON [dbo].[dxProductLot]
For UPDATE
AS
BEGIN
  SET NOCOUNT ON
  -- Update Product Location
  Insert into dbo.dxProductLocation ( FK_dxWarehouse , FK_dxProduct, FK_dxLocation )
    select distinct FK_dxWarehouse , FK_dxProduct, FK_dxLocation from inserted pt
  where ( not exists ( select 1 from dbo.dxProductLocation a2
                     where a2.FK_dxWarehouse = pt.FK_dxWarehouse
                       and a2.FK_dxProduct   = pt.FK_dxProduct
                       and a2.FK_dxLocation  = pt.FK_dxLocation ))

  Update pl set
    pl.TotalAmount = ( select Round(coalesce( sum(pt.TotalAmount), 0.0 ),2) from dbo.dxProductLot pt
                        where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                          and pt.FK_dxProduct   = pl.FK_dxProduct
                          and pt.FK_dxLocation  = pl.FK_dxLocation ) ,
    pl.InStockQuantity = ( select Round(coalesce( sum(InStockQuantity), 0.0 ),6) from dbo.dxProductLot pt
                        where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                          and pt.FK_dxProduct   = pl.FK_dxProduct
                          and pt.FK_dxLocation  = pl.FK_dxLocation )
  From inserted de
  left join dbo.dxProductLocation pl on
  (      de.FK_dxWarehouse = pl.FK_dxWarehouse
     and de.FK_dxProduct   = pl.FK_dxProduct
     and de.FK_dxLocation  = pl.FK_dxLocation )
END
GO
ALTER TABLE [dbo].[dxProductLot] ADD CONSTRAINT [CK_dxProductLot_InStockQuantity] CHECK (([InStockQuantity]>=(0.0)))
GO
ALTER TABLE [dbo].[dxProductLot] ADD CONSTRAINT [PK_dxProductLot] PRIMARY KEY CLUSTERED  ([PK_dxProductLot]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductLot_FK_dxLocation] ON [dbo].[dxProductLot] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductLot_FK_dxProduct] ON [dbo].[dxProductLot] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductLot_FK_dxWarehouse] ON [dbo].[dxProductLot] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductLot] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxProductLot] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxProductLot] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxProductLot] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxProductLot] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxProductLot] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
