SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 15 avril 2012
-- Description:	Mise à jour des sommaires sur les différents niveaux d'inventaire
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxUpdateProductLot]
as
Begin
  SET NOCOUNT ON

  -- Update Lot
  Insert into dbo.dxProductLot ( FK_dxWarehouse , FK_dxProduct, FK_dxLocation, Lot )
         select distinct FK_dxWarehouse , FK_dxProduct, FK_dxLocation , Lot from dbo.dxProductTransaction a1
   where ( not exists ( select 1 from dbo.dxProductLot a2
                         where a2.FK_dxWarehouse = a1.FK_dxWarehouse
                           and a2.FK_dxProduct   = a1.FK_dxProduct
                           and a2.FK_dxLocation  = a1.FK_dxLocation
                            and a2.Lot           = a1.Lot ))
  Update pl set
    pl.TotalAmount = ( select Round(coalesce( sum(pt.Amount), 0.0 ),2) from dbo.dxProductTransaction pt
                     where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                       and pt.FK_dxProduct   = pl.FK_dxProduct
                       and pt.FK_dxLocation  = pl.FK_dxLocation
                       and pt.Lot            = pl.Lot  ),
    pl.InStockQuantity = ( select Round(coalesce( sum(Quantity), 0.0 ),6) from dbo.dxProductTransaction pt
                     where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                       and pt.FK_dxProduct   = pl.FK_dxProduct
                       and pt.FK_dxLocation  = pl.FK_dxLocation
                       and pt.Lot            = pl.Lot  )
  From dbo.dxProductLot pl

  -- Update Product Lot
  Insert into dbo.dxProductLocation ( FK_dxWarehouse , FK_dxProduct, FK_dxLocation )
       select distinct FK_dxWarehouse , FK_dxProduct, FK_dxLocation from dbo.dxProductLot a1
  where ( not exists ( select 1 from dxProductLocation a2
                              where a2.FK_dxWarehouse = a1.FK_dxWarehouse
                                and a2.FK_dxProduct   = a1.FK_dxProduct
                                and a2.FK_dxLocation  = a1.FK_dxLocation ))
  Update dbo.dxProductLocation set
  TotalAmount =  ( select  Round(coalesce( sum(TotalAmount), 0.0 ),2) from dbo.dxProductLot
                    where FK_dxWarehouse = dxProductLocation.FK_dxWarehouse
                      and FK_dxProduct   = dxProductLocation.FK_dxProduct
                      and FK_dxLocation  = dxProductLocation.FK_dxLocation  ),
  InStockQuantity =  ( select Round( coalesce( sum(InStockQuantity ), 0.0 ),6) from dbo.dxProductLot
                    where FK_dxWarehouse = dxProductLocation.FK_dxWarehouse
                      and FK_dxProduct   = dxProductLocation.FK_dxProduct
                      and FK_dxLocation  = dxProductLocation.FK_dxLocation  )

  -- Update Product Warehouse
  Insert into dbo.dxProductWarehouse ( FK_dxWarehouse , FK_dxProduct )
       select distinct FK_dxWarehouse , FK_dxProduct from dbo.dxProductLocation a1
  where( not exists ( select 1 from dxProductWarehouse a2
                              where a2.FK_dxWarehouse = a1.FK_dxWarehouse
                                and a2.FK_dxProduct   = a1.FK_dxProduct ))
  Update dbo.dxProductWarehouse set
    TotalAmount = ( select Round(coalesce( sum(TotalAmount), 0.0 ),2) from dbo.dxProductLocation
                      where FK_dxWarehouse = dxProductWarehouse.FK_dxWarehouse
                        and FK_dxProduct   = dxProductWarehouse.FK_dxProduct   ),
    InStockQuantity = ( select Round(coalesce( sum(InStockQuantity ), 0.0 ),6) from dbo.dxProductLocation
                      where FK_dxWarehouse = dxProductWarehouse.FK_dxWarehouse
                        and FK_dxProduct   = dxProductWarehouse.FK_dxProduct )
  -- Update Warehouse
  Update dbo.dxWarehouse set TotalAmount =
  ( select Round(coalesce( sum(TotalAmount), 0.0 ),2) from dbo.dxProductWarehouse where FK_dxWarehouse = dxWarehouse.PK_dxWarehouse )

end
GO
