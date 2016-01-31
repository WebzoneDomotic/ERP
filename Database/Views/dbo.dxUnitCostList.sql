SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ---------------------------------------- Create All View ---------------------------------------------

create view [dbo].[dxUnitCostList] as 
select
  ve.PK_dxVendor,
  pr.PK_dxProduct,
  cl.PK_dxCostLevel,
  cd.PK_dxCostLevelDetail,
  cv.PK_dxCostLevelVolume,
  pr.ID,
  pr.Description,
  0.0 as StandardCost,
  Coalesce( ( select top 1 pd.unitAmount from dxPurchaseOrderDetail pd  
                                          left outer join dxPurchaseOrder po on ( po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )     
                                          where po.FK_dxVendor = ve.PK_dxVendor and pd.FK_dxProduct = pr.PK_dxProduct 
                                          order by po.TransactionDate desc, pd.UnitAmount asc ), 0.0 )  LastPurchaseUnitAmount ,
  coalesce( cd.UnitAmount, 0.0 ) LevelUnitAmount,
  coalesce( cv.LowerBoundQuantity, 0.0)      LowerBoundQuantity,
  coalesce( cv.UnitAmount,  coalesce( cd.UnitAmount, 0.0 ) ) VolumeUnitAmount,
  coalesce( cd.effectiveDate, GetDate()-3000 ) EffectiveDate
From  dxvendor ve ,dxProduct pr
left outer join dxCostLevelDetail cd on ( pr.PK_dxProduct   = cd.FK_dxProduct )
left outer join dxCostLevel       cl on ( cl.PK_dxCostLevel = cd.FK_dxCostLevel )
left outer join dxCostLevelVolume cv on ( cd.PK_dxCostLevelDetail = cv.FK_dxCostLevelDetail )
where 
 ( cl.PK_dxCostLevel is null or ve.FK_dxCostLevel = cl.PK_dxCostLevel)
GO
