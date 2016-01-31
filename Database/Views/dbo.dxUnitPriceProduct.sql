SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxUnitPriceProduct] as 
select
  ve.PK_dxClient, 
  pr.PK_dxProduct,
  null PK_dxPriceLevel,
  null PK_dxPriceLevelDetail,
  null PK_dxPriceLevelVolume,
  pr.ID,
  pr.Description,
  pr.StandardPrice,
  Coalesce( ( select top 1 pd.unitAmount from dxClientOrderDetail pd  
                                          left outer join dxClientOrder po on ( po.PK_dxClientOrder = pd.FK_dxClientOrder )     
                                          where po.FK_dxClient = ve.PK_dxClient and pd.FK_dxProduct = pr.PK_dxProduct 
                                          order by po.TransactionDate desc, pd.UnitAmount asc ), 0.0 )  LastSoldUnitAmount ,
  pr.StandardPrice LevelUnitAmount, 
  0.0              LowerBoundQuantity,
  pr.StandardPrice VolumeUnitAmount,
   GetDate()-3000  EffectiveDate
From   dxClient ve, dxProduct pr
GO
