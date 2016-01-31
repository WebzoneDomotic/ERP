SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-10-05
-- Description:	la valeur au standard passée au GL pour une transaction d'inventaire
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGLMaterialStandardCost] (
        @KindOfDocument int
      , @PhaseMaterialStandardCostVariance float
      , @MaterialStandardCost float
      , @Quantity float
      , @TransactionDate Datetime
       )
returns Float
as
begin
   Return ( Case
              when @KindOfDocument = 15 then @PhaseMaterialStandardCostVariance
              when @KindOfDocument = 16 then 
                       -- Case when @TransactionDate < '2012-10-12' then -- Date de la nouvelle version
                          case when abs(@Quantity) < 0.000001 then @PhaseMaterialStandardCostVariance else @MaterialStandardCost end
                       --  else
                       --   case when @Quantity < 0.0 then @PhaseMaterialStandardCostVariance else @MaterialStandardCost end
                       -- end
              when @KindOfDocument = 17 then 
                          case when @Quantity < 0.0 then @PhaseMaterialStandardCostVariance else @MaterialStandardCost end
            else @MaterialStandardCost  end )
   
end
GO
