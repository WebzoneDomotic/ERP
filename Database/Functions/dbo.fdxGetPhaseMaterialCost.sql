SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
CREATE Function [dbo].[fdxGetPhaseMaterialCost] (
  @PK_dxProduct int ,
  @PhaseNumber int ,
  @Date Datetime,
  @DeclareQuantity Float )

RETURNS Float
BEGIN
   RETURN (
           SELECT Sum( @DeclareQuantity *
                   Coalesce(NetQuantity, 0.0)
                * (1.0+ Coalesce(PctOfWasteQuantity,0.0)/100.0)
                * dbo.fdxGetStandardMaterialCost(ad.FK_dxProduct , @Date ))
           From dxAssemblyDetail ad
           Left outer join dxAssembly ab on ( ab.PK_dxAssembly = ad.FK_dxAssembly )
           where ad.FK_dxAssembly = (Select Top 1 PK_dxAssembly from dxAssembly
                            where FK_dxProduct = @PK_dxProduct
                              and EffectiveDate <= @Date order by EffectiveDate Desc, Version Desc )
            and ad.PhaseNumber <= @PhaseNumber  )
END
GO
