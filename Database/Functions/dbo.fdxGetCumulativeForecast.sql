SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetCumulativeForecast] ( @FK_dxProduct int , @Date Datetime )
returns float
-- Get Cumulative Forecast align with the Forecast Type
AS
BEGIN

  Return (Select
            (case
               when pr.ForecastType = 0 then  -- Daily
                  coalesce(( Select Sum(CorrectedForecast) from dxMRP where FK_dxProduct = pr.PK_dxProduct and PeriodDate = @Date),0.0)

               when pr.ForecastType = 1 then  -- Weekly
                  coalesce(( Select Sum(CorrectedForecast) from dxMRP
                       where FK_dxProduct = pr.PK_dxProduct
                        and PeriodDate between  DATEADD(wk,DATEDIFF(wk,0,@Date),0) and @Date),0.0)

               when pr.ForecastType = 2 then -- Twice a month ( not available yet )
                  coalesce(( Select Sum(CorrectedForecast) from dxMRP where FK_dxProduct = pr.PK_dxProduct and PeriodDate = @Date),0.0)

               when pr.ForecastType = 3 then -- Monthtly
                  coalesce(( Select Sum(CorrectedForecast) from dxMRP
                       where FK_dxProduct = pr.PK_dxProduct
                        and PeriodDate between  DATEADD(mm,DATEDIFF(mm,0,@Date),0) and @Date),0.0)
              else 0.0 end )
          From dxProduct pr where PK_dxProduct = @FK_dxProduct)

end
GO
