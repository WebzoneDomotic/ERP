SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetVendorUnitCost] (  @FK_dxVendor int, @FK_dxProduct int,  @Date Datetime, @Quantity float ) 
--Returns Cost Of an Item
returns Float
as
BEGIN
 RETURN(
     Select top 1
       case VolumeUnitAmount When 0.0 then
          case LevelUnitAmount When 0.0 then
             case LastPurchaseUnitAmount When 0.0 then
              [dbo].[fdxGetProductCost] ( @FK_dxProduct,  @Date)
             else LastPurchaseUnitAmount end
          else LevelUnitAmount end
       else VolumeUnitAmount end UnitAmount
     from dxUnitCost
     where PK_dxVendor  = @FK_dxVendor
       and PK_dxProduct = @FK_dxProduct
       and EffectiveDate <= @Date
       and LowerBoundQuantity <= @Quantity
     order by PK_dxVendor, PK_dxProduct, PK_dxCostLevel Desc, EffectiveDate Desc, LowerBoundQuantity Desc
     )
END
GO
