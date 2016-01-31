SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetProductCorrectedForecastQuantity] ( @FK_dxProduct int ,@Date Datetime )
returns float
-- Return forecast quantity far a Product at a specific date and convert it for a working day
AS
BEGIN
    Declare @DP int, @wd int,  @rwd int
    Declare @R Float -- Result
    set @R  = 0.0
    Set @DP = DatePart( dw, @Date)

    -- Set Work day for the period
    set  @wd =
          (Select
             (case
               when pr.ForecastType = 0 then 1                                 -- Daily
               when pr.ForecastType = 1 then 5                                 -- Weekly
               when pr.ForecastType = 2 then 1                                 -- Twice a month ( not available yet )
               when pr.ForecastType = 3 then dbo.fdxGetWorkDaysInMonth (@Date) -- Monthtly
              end )
          From dxProduct pr where pr.PK_dxProduct = @FK_dxProduct )

    -- Set Remaining Work day for the period
    set  @rwd =
          (Select
             (case
               when pr.ForecastType = 0 then 1                                          -- Daily
               when pr.ForecastType = 1 then 7 - @DP                                    -- Weekly
               when pr.ForecastType = 2 then 1                                          -- Twice a month ( not available yet )
               when pr.ForecastType = 3 then dbo.fdxGetRemainingWorkDaysInMonth (@Date) -- Monthtly
              end )
          From dxProduct pr where pr.PK_dxProduct = @FK_dxProduct )

    if @rwd <= 0 set @rwd = 1


    if @DP in (2,3,4,5,6)
      Set @R = ( (dbo.fdxGetProductForecastQuantity ( @FK_dxProduct ,@Date )* @rwd / @wd ) -
                  dbo.fdxGetCumulativeExpedition( @FK_dxProduct ,@Date ) ) / @rwd
    if @R < 0.0 set @R = 0

    Return @R
end
GO
