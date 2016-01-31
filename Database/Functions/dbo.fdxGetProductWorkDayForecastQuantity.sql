SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetProductWorkDayForecastQuantity] ( @FK_dxProduct int ,@Date Datetime )
returns float
-- Return forecast quantity far a Product at a specific date and convert it for a working day
AS
BEGIN

  Return (Select
            (case
               when pr.ForecastType = 0 then  -- Daily
                  pr.DailyForecast * 7.0 / 5.0
               when pr.ForecastType = 1 then  -- Weekly
                  Coalesce(( select Max(Quantity) from  dxProductForecastPerWeek
                                                 where  FK_dxProduct = pr.PK_dxProduct
                                                   and  [Year] = DATEPART( yy, @Date)
                                                   and  [Week] = DatePart( ww, @Date) ), 0.0 ) / 5.0
               when pr.ForecastType = 2 then -- Twice a month ( not available yet )
                  pr.DailyForecast  * 7.0 / 5.0
               when pr.ForecastType = 3 then -- Monthtly
                  Coalesce(( select Max(Quantity) from  dxProductForecastPerMonth
                                                 where  FK_dxProduct = pr.PK_dxProduct
                                                   and  [Year] = DATEPART( yy, @Date)
                                                   and  [Month]= DatePart( mm, @Date) ), 0.0 ) / dbo.fdxGetWorkDaysInMonth ( @Date )
              else 0.0 end )
          From dxProduct pr where PK_dxProduct = @FK_dxProduct)

end
GO
