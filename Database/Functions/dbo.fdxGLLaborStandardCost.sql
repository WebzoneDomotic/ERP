SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-10-05
-- Description:	la valeur au standard passée au GL pour une transaction d'inventaire
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGLLaborStandardCost] (
        @KindOfDocument int
      , @PhaseLaborStandardCostVariance float
      , @LaborStandardCost float
      , @Quantity float
      , @TransactionDate Datetime
       )
returns Float
as
begin
   Return ( Case
              when @KindOfDocument = 15 then @PhaseLaborStandardCostVariance
              when @KindOfDocument = 18 then case when @Quantity < 0.0 then @PhaseLaborStandardCostVariance else @LaborStandardCost end
              when @KindOfDocument = 17 then case when @Quantity < 0.0 then @PhaseLaborStandardCostVariance else @LaborStandardCost end
            else @LaborStandardCost  end )
   
end
GO
