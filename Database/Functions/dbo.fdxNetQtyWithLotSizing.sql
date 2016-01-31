SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[fdxNetQtyWithLotSizing] (@FK_dxProduct int, @NetRequirements Float)
Returns Float
As
Begin
    Declare @Lot Float
    Set @Lot =@NetRequirements 
   (Select  @Lot = case 
                     when FK_dxLotSizing = 1 then @NetRequirements
                     when FK_dxLotSizing = 2 then 
                             FixedLotSize * CEILING( @NetRequirements / Coalesce(FixedLotSize,1.0) )
                     when FK_dxLotSizing = 3 then 
                          case 
                             when MinLotSize < @NetRequirements then @NetRequirements
                             else MinLotSize
                          end 
                     when FK_dxLotSizing = 4 then EconomicLotSize
                   end 
   From dxProduct where PK_dxProduct = @FK_dxProduct )
   if @Lot = 0 set @Lot = @NetRequirements
   Return @Lot
end
GO
