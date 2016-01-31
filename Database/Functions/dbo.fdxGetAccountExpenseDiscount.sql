SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-03
-- Description:	Retour le compte de dépense escompte selon la matrice de sélection
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetAccountExpenseDiscount] (
        @FK_dxCurrency int
      , @FK_dxTax int
      , @FK_dxProjectCategory int
      , @FK_dxProject int
      , @FK_dxVendorCategory int
      , @FK_dxVendor int
      , @FK_dxCostLevel int
      , @FK_dxProductCategory int
      , @FK_dxProduct int  )
returns int
as
begin
   Return (
   select
       Top 1
        FK_dxAccount__Discount
    from dxAccountExpense
    where (FK_dxCurrency        = @FK_dxCurrency)
      and (FK_dxTax             = @FK_dxTax or FK_dxTax is null)
      and (FK_dxProjectCategory = @FK_dxProjectCategory or FK_dxProjectCategory is null)
      and (FK_dxProject         = @FK_dxProject or FK_dxProject is null)
      and (FK_dxVendorCategory  = @FK_dxVendorCategory or FK_dxVendorCategory is null)
      and (FK_dxVendor          = @FK_dxVendor or FK_dxVendor is null)
      and (FK_dxCostLevel       = @FK_dxCostLevel or FK_dxCostLevel is null)
      and (FK_dxProductCategory = @FK_dxProductCategory or FK_dxProductCategory is null)
      and (FK_dxProduct         = @FK_dxProduct or FK_dxProduct is null)
    order by FK_dxCurrency desc       , FK_dxTax desc,
             FK_dxProjectCategory desc, FK_dxProject desc ,
             FK_dxVendorCategory  desc, FK_dxVendor desc,
             FK_dxCostLevel desc      , FK_dxProductCategory desc, FK_dxProduct desc)
end
GO
