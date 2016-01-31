SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
CREATE  Function [dbo].[fdxGetStandardLaborCost] ( @PK_dxProduct int, @Date Datetime, @DeclareQuantity Float )
RETURNS Float
-- Return Standard Labor Cost at a specific date
AS
BEGIN
   RETURN
       -- On ramasse toute les items du premier niveau du BOM
       -- avec le coût de MOD de chaque item basé sur une qté déclarée
       (SELECT
           Coalesce(
                    Sum( dbo.fdxGetStandardLaborCost(ad.FK_dxProduct , @Date, @DeclareQuantity * Coalesce(NetQuantity, 0.0) * (1.0+ Coalesce(PctOfWasteQuantity,0.0)/100.0)))
                   , 0.0 )
       From dxAssemblyDetail ad
       Left outer join dxAssembly ab on ( ab.PK_dxAssembly = ad.FK_dxAssembly )
       where ad.FK_dxAssembly = (Select Top 1 PK_dxAssembly from dxAssembly
                        where FK_dxProduct = @PK_dxProduct
                          and EffectiveDate <= @Date order by EffectiveDate Desc, Version Desc ))
       +
       -- Plus la MOD pour assembler tout le niveau
       Coalesce((  Select

                Round( Sum( dbo.fdxFracToHour(InternalSetupTime) * dbo.fdxGetResourceRate(pd.FK_dxResource, @Date) * Ceiling(  @DeclareQuantity / pd.BatchSize )),2)
              + Round( Sum( dbo.fdxFracToHour(ExternalSetupTime) * dbo.fdxGetResourceRate(pd.FK_dxResource, @Date) * Ceiling(  @DeclareQuantity / pd.BatchSize )),2)
              + Round( Sum( dbo.fdxFracToHour(BatchOperationTime)* dbo.fdxGetResourceRate(pd.FK_dxResource, @Date) / pd.BatchSize * @DeclareQuantity ),2)

          From dxPhaseDetail pd
          join dxPhase   ph on (pd.FK_dxPhase = ph.PK_dxPhase )
          join dxRouting rt on (ph.FK_dxRouting = rt.PK_dxRouting)
          where rt.PK_dxRouting = ( Select top 1 FK_dxRouting from dxAssembly aa
                                     where FK_dxProduct = @PK_dxProduct
                                       and EffectiveDate <= @Date order by EffectiveDate Desc , Version Desc)
                 )  ,
                  -- Si aucune somme pour ce niveau , valeur de historique de la fiche produit
                  @DeclareQuantity * Coalesce(( select top 1 LaborCost from dxStandardCostHistory
                       where FK_dxProduct = @PK_dxProduct
                        and EffectiveDate <= @Date order by EffectiveDate desc),0.0) )
END
GO
