SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-03
-- Description:	Retour le compte de vente selon la matrice de sélection
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetAccountRevenue] (
        @FK_dxCurrency int
      , @FK_dxTax int
      , @FK_dxProjectCategory int
      , @FK_dxProject int
      , @FK_dxClientCategory int
      , @FK_dxClient int
      , @FK_dxPriceLevel int
      , @FK_dxProductCategory int
      , @FK_dxProduct int  )
returns int
as
begin
   Return (
   select
       Top 1
        FK_dxAccount__Revenue
    from dxAccountRevenue
    where (FK_dxCurrency        = @FK_dxCurrency)
      and (FK_dxTax             = @FK_dxTax or FK_dxTax is null)
      and (FK_dxProjectCategory = @FK_dxProjectCategory or FK_dxProjectCategory is null)
      and (FK_dxProject         = @FK_dxProject or FK_dxProject is null)
      and (FK_dxClientCategory  = @FK_dxClientCategory or FK_dxClientCategory is null)
      and (FK_dxClient          = @FK_dxClient or FK_dxClient is null)
      and (FK_dxPriceLevel      = @FK_dxPriceLevel or FK_dxPriceLevel is null)
      and (FK_dxProductCategory = @FK_dxProductCategory or FK_dxProductCategory is null)
      and (FK_dxProduct         = @FK_dxProduct or FK_dxProduct is null)
    order by FK_dxCurrency desc       , FK_dxTax desc,
             FK_dxProjectCategory desc, FK_dxProject desc ,
             FK_dxClientCategory  desc, FK_dxClient desc,
             FK_dxPriceLevel desc     , FK_dxProductCategory desc, FK_dxProduct desc)
end
GO
