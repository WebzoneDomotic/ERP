SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
CREATE  Function [dbo].[fdxGetStandardMaterialCost] ( @PK_dxProduct int, @Date Datetime )
RETURNS Float
-- Return Standard Material Cost at a specific date
AS
BEGIN
   RETURN

        (SELECT  Coalesce(
            Sum(
                  Coalesce(NetQuantity, 0.0)
                * (1.0+ Coalesce(PctOfWasteQuantity,0.0)/100.0)
                * dbo.fdxGetStandardMaterialCost(ad.FK_dxProduct , @Date )),
         -- Si aucune somme, valeur de historique de la fiche produit
         Coalesce(( select top 1 MaterialCost from dxStandardCostHistory
                       where FK_dxProduct = @PK_dxProduct
                        and EffectiveDate <= @Date order by EffectiveDate desc),0.0)
                  )
         From dxAssemblyDetail ad
         Left outer join dxAssembly ab on ( ab.PK_dxAssembly = ad.FK_dxAssembly )
         where ad.FK_dxAssembly = (Select Top 1 PK_dxAssembly from dxAssembly
                          where FK_dxProduct = @PK_dxProduct
                            and EffectiveDate <= @Date order by EffectiveDate Desc, Version Desc ))
END
GO
