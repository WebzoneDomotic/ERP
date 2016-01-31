SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create  Function [dbo].[fdxGetProductCost] ( @PK_dxProduct int, @Date Datetime )
RETURNS Float
-- Return de cost for a product at a specific date
AS
BEGIN
   RETURN Coalesce(( select top 1 StandardCost from dxStandardCostHistory
                        where FK_dxProduct = @PK_dxProduct
                          and EffectiveDate <= @Date order by EffectiveDate desc),0.0)
END
GO
