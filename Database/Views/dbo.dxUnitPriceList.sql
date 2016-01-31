SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxUnitPriceList] as 
select
  ve.PK_dxClient,
  pr.PK_dxProduct,
  cl.PK_dxPriceLevel,
  cd.PK_dxPriceLevelDetail,
  cv.PK_dxPriceLevelVolume,
  pr.ID,
  pr.Description,
  pr.StandardPrice,
  Coalesce( ( select top 1 pd.unitAmount from dxClientOrderDetail pd  
                                          left outer join dxClientOrder po on ( po.PK_dxClientOrder = pd.FK_dxClientOrder )     
                                          where po.FK_dxClient = ve.PK_dxClient and pd.FK_dxProduct = pr.PK_dxProduct 
                                          order by po.TransactionDate desc, pd.UnitAmount asc ), 0.0 )  LastSoldUnitAmount ,
  coalesce( cd.UnitAmount, pr.StandardPrice ) LevelUnitAmount, 
  coalesce( cv.LowerBoundQuantity, 0.0)      LowerBoundQuantity,
  coalesce( cv.UnitAmount,  coalesce( cd.UnitAmount, pr.StandardPrice ) ) VolumeUnitAmount,
  coalesce( cd.effectiveDate, GetDate()-3000 ) EffectiveDate
From  dxClient ve ,dxProduct pr
left outer join dxPriceLevelDetail cd on ( pr.PK_dxProduct   = cd.FK_dxProduct )
left outer join dxPriceLevel       cl on ( cl.PK_dxPriceLevel = cd.FK_dxPriceLevel )
left outer join dxPriceLevelVolume cv on ( cd.PK_dxPriceLevelDetail = cv.FK_dxPriceLevelDetail )
where 
 ( cl.PK_dxPriceLevel is null or ve.FK_dxPriceLevel = cl.PK_dxPriceLevel)
GO
