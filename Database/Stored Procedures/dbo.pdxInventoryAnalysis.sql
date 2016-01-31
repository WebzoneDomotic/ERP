SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 26 Août 2012
-- Description:	Récupérer la valeur des inventaire à une date
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxInventoryAnalysis] @ADate Datetime
as
Begin
  --Declare @ADate Datetime
  --Set @ADate = '2012-08-08'

  SELECT
    @ADate                       as 'TransactionDate'
   ,pt.FK_dxWarehouse            as 'FK_dxWarehouse'
   ,pt.FK_dxProduct              as 'FK_dxProduct'
   ,pt.FK_dxLocation             as 'FK_dxLocation'
   ,Max(pr.ID)                   as 'ProductCode'
   ,Max(pr.OtherID)              as 'OldProductCode'
   ,Max(pr.Description)          as 'ProductDescription'
   ,pt.Lot                       as 'Lot'
   ,Round(Sum(pt.Quantity),6)    as 'Quantity'
   ,Round(Sum(pt.Amount),2)      as 'TotalRealAmount'
   ,Round(Sum( dbo.fdxGLMaterialStandardCost (
                    KindofDocument, pt.PhaseMaterialStandardCostVariance,pt.MaterialStandardCost,
                    pt.quantity,pt.TransactionDate)) ,2)  as 'TotalMaterialCostAmount'
   ,Round(Sum( dbo.fdxGLLaborStandardCost (
                    KindofDocument, pt.PhaseLaborStandardCostVariance,pt.LaborStandardCost,
                    pt.quantity,pt.TransactionDate)) ,2)  as 'TotalLaborCostAmount'
  FROM dbo.dxProduct pr
  Left join dbo.dxProductTransaction pt ON pt.FK_dxProduct = pr.PK_dxProduct
  Left join dbo.dxScaleUnit su ON su.PK_dxScaleUnit = pr.FK_dxScaleUnit
  Left join dbo.dxProductCategory pc ON pc.PK_dxProductCategory = pr.FK_dxProductCategory
  WHERE pt.TransactionDate <= @ADate

  Group by
     pt.FK_dxWarehouse
    ,pt.FK_dxLocation
    ,pt.FK_dxProduct
    ,Lot

  Having  Not (
          (abs(Round(Sum(pt.Quantity),6)) <=0.0)
      and (abs(Round(Sum(pt.Amount)  ,6)) <=0.0)
      and (abs(Round(Sum( dbo.fdxGLMaterialStandardCost (
                    KindofDocument, pt.PhaseMaterialStandardCostVariance,pt.MaterialStandardCost,
                    pt.quantity,pt.TransactionDate)) ,2)) <=0.0))

End
GO
