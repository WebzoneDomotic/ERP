SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxUnitCostProduct] as 
select
  ve.PK_dxVendor, 
  pr.PK_dxProduct,
  null PK_dxCostLevel,
  null PK_dxCostLevelDetail,
  null PK_dxCostLevelVolume,
  pr.ID,
  pr.Description,
  0.0 as StandardCost,
  Coalesce( ( select top 1 pd.unitAmount from dxPurchaseOrderDetail pd  
                                          left outer join dxPurchaseOrder po on ( po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )     
                                          where po.FK_dxVendor = ve.PK_dxVendor and pd.FK_dxProduct = pr.PK_dxProduct 
                                          order by po.TransactionDate desc, pd.UnitAmount asc ), 0.0 )  LastPurchaseUnitAmount ,
  0.0  LevelUnitAmount,
  0.0  LowerBoundQuantity,
  0.0  VolumeUnitAmount,
   GetDate()-3000  EffectiveDate
From   dxVendor ve, dxProduct pr
GO
