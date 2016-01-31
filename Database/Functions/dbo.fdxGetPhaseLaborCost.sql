SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
CREATE Function [dbo].[fdxGetPhaseLaborCost] (
  @PK_dxProduct int ,
  @PhaseNumber int ,
  @Date Datetime,
  @DeclareQuantity Float )

RETURNS Float
BEGIN
   RETURN (
    Select
          Coalesce(
          Round( Sum( dbo.fdxFracToHour(InternalSetupTime) * dbo.fdxGetResourceRate(pd.FK_dxResource, @Date) * Ceiling(  @DeclareQuantity /BatchSize )),2)
        + Round( Sum( dbo.fdxFracToHour(ExternalSetupTime) * dbo.fdxGetResourceRate(pd.FK_dxResource, @Date) * Ceiling(  @DeclareQuantity /BatchSize )),2)
        + Round( Sum( dbo.fdxFracToHour(BatchOperationTime)* dbo.fdxGetResourceRate(pd.FK_dxResource, @Date) / pd.BatchSize * @DeclareQuantity ),2)
          ,0.0)
    From dxPhaseDetail pd
    join dxPhase   ph on (pd.FK_dxPhase = ph.PK_dxPhase )
    join dxRouting rt on (ph.FK_dxRouting = rt.PK_dxRouting)
    where rt.PK_dxRouting = ( Select top 1 FK_dxRouting from dxAssembly aa
                               where FK_dxProduct = @PK_dxProduct
                                 and EffectiveDate <= @Date order by EffectiveDate Desc , Version Desc)
      and ph.PhaseNumber  <= @PhaseNumber )
 END
GO
