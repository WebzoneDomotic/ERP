SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetProductSafetyStock] ( @FK_dxProduct int ,@Date Datetime )
returns float
-- Return safety stock for a Product at a specific date
AS
BEGIN
   Return (Select
            (case
               when pr.ForecastType = 0 then  -- Daily
                  pr.SafetyStock
               when pr.ForecastType = 1 then  -- Weekly
                  Coalesce(( select Max(SafetyStock) from  dxProductForecastPerWeek
                                                 where  FK_dxProduct = pr.PK_dxProduct
                                                   and  [Year] = DATEPART( yy, @Date)
                                                   and  [Week] = DatePart( ww, @Date) ), 0.0 )
               when pr.ForecastType = 2 then -- Twice a month ( not available yet )
                  pr.SafetyStock
               when pr.ForecastType = 3 then -- Monthtly
                  Coalesce(( select Max(SafetyStock) from  dxProductForecastPerMonth
                                                 where  FK_dxProduct = pr.PK_dxProduct
                                                   and  [Year] = DATEPART( yy, @Date)
                                                   and  [Month]= DatePart( mm, @Date) ), 0.0 )
              else 0.0 end )
          From dxProduct pr where PK_dxProduct = @FK_dxProduct)
end
GO
