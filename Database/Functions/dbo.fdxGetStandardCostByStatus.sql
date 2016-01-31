SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
CREATE  Function [dbo].[fdxGetStandardCostByStatus] ( @PK_dxProduct int, @Status int, @PhaseNumber int, @Date Datetime )
RETURNS Float
-- Return Standard Cost at a specific date by Status
AS
BEGIN
   RETURN Coalesce(Case
             When Coalesce(@PhaseNumber,0) <= 0 then
                Case
                   when @Status = 0 then
                   --   Coalesce(( select top 1 MaterialCost from dxStandardCostHistory
                   --               where FK_dxProduct = @PK_dxProduct
                   --                 and EffectiveDate <= @Date
                   --                 order by EffectiveDate desc),0.0)
                   dbo.fdxGetStandardMaterialCost (  @PK_dxProduct , @Date )
                   when @Status = 1 then
                   --   Coalesce(( select top 1 LaborCost from dxStandardCostHistory
                   --               where FK_dxProduct = @PK_dxProduct
                   --                 and EffectiveDate <= @Date
                   --                 order by EffectiveDate desc),0.0)
                   dbo.fdxGetStandardLaborCost            (  @PK_dxProduct , @Date, 100000.0 ) / 100000.0
                   when @Status = 2 then
                   --   Coalesce(( select top 1 OverheadFixedCost from dxStandardCostHistory
                   --               where FK_dxProduct = @PK_dxProduct
                   --                 and EffectiveDate <= @Date
                   --                 order by EffectiveDate desc),0.0)
                   dbo.fdxGetStandardOverheadFixedCost    (  @PK_dxProduct , @Date, 100000.0 ) / 100000.0
                   when @Status = 3 then
                   --   Coalesce(( select top 1 OverheadVariableCost from dxStandardCostHistory
                   --              where FK_dxProduct = @PK_dxProduct
                   --                 and EffectiveDate <= @Date
                   --                 order by EffectiveDate desc),0.0)
                   dbo.fdxGetStandardOverheadVariableCost (  @PK_dxProduct , @Date, 100000.0 ) / 100000.0
                end
             else
                Case
                   when @Status = 0 then dbo.fdxGetPhaseMaterialCost        (  @PK_dxProduct , @PhaseNumber , @Date, 100000.0 ) / 100000.0
                   when @Status = 1 then dbo.fdxGetPhaseLaborCost           (  @PK_dxProduct , @PhaseNumber , @Date, 100000.0 ) / 100000.0
                   when @Status = 2 then dbo.fdxGetPhaseOverheadFixedCost   (  @PK_dxProduct , @PhaseNumber , @Date, 100000.0 ) / 100000.0
                   when @Status = 3 then dbo.fdxGetPhaseOverheadVariableCost(  @PK_dxProduct , @PhaseNumber , @Date, 100000.0 ) / 100000.0
                end
             end , 0.0)
END
GO
