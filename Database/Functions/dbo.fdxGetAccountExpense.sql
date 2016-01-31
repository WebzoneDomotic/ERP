SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-06-03
-- Description:	Retour le compte d'imputation fournisseur selon la matrice de sélection
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetAccountExpense] (
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
   Declare @FK_dxAccount int
   Return @FK_dxAccount
end
GO
