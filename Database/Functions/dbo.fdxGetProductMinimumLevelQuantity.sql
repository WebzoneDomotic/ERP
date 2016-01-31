SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetProductMinimumLevelQuantity] ( @FK_dxProduct int ,@Date Datetime )
returns float
-- Return safety stock for a Product at a specific date
AS
BEGIN
  Declare @Week int, @Month int, @Year int, @Quantity float

  set @Year  = DATEPART( yy, @Date)
  set @Month = DatePart( mm, @Date)
  set @Week  = DatePart( ww, @Date)

  -- Priority by week
  set @Quantity = Coalesce(( select Max(MinimumLevelQuantity) from  dxProductForecastPerWeek
                                   where  FK_dxProduct = @FK_dxProduct
                                     and   [Year] = @Year
                                     and   [Week] = @Week ), 0.0 )
  -- if not found in the month get it from product table
  if @Quantity = 0.0
    set @Quantity = Coalesce(( select MinimumLevelQuantity from  dxProduct
                                     where  PK_dxProduct = @FK_dxProduct ), 0.0 )
  RETURN @Quantity
end
GO
