SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-26
-- Description:	Insert Product Transaction for Cost Rollup correction
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxInventoryCostRollupCorrection] @TransactionDate Datetime
as
BEGIN           
  Declare @RoundingDifferenceAmount float
  Declare @FK_dxAccount__Imputation int
  Set @RoundingDifferenceAmount = ( Select RoundingDifferenceAmount from dxAccountConfiguration )
  Set @FK_dxAccount__Imputation = ( Select FK_dxAccount__RoundingDifference from dxAccountConfiguration )
  
  -- First we delete all cost rollup transaction passed this date
  Delete from dxAccountTransaction where KindOfDocument = 26 and TransactionDate >= @TransactionDate
  Delete from dxProductTransaction where KindOfDocument = 26 and TransactionDate >= @TransactionDate

  INSERT INTO [dbo].[dxProductTransaction]
           ([TransactionType]
           ,[FK_dxWarehouse]
           ,[FK_dxProduct]
           ,[TransactionDate]
           ,[Lot]
           ,[FK_dxLocation]
           ,[Description]
           ,[Amount]
           ,[KindOfDocument]
           ,[PrimaryKeyValue]
           ,[MaterialStandardCost]
           ,[FK_dxAccount__CorrectionMaterial])
    
  SELECT
    2
   ,pt.FK_dxWarehouse                                    as 'FK_dxWarehouse'
   ,pt.FK_dxProduct                                      as 'FK_dxProduct'
   ,@TransactionDate
   ,pt.Lot                                               as 'Lot'
   ,pt.FK_dxLocation                                     as 'FK_dxLocation'
   ,Convert(varchar(100),Max(pr.ID) +', '+ pt.Lot +', '+ Max(pr.Description))  as 'Description'
   ,0.0                                                  as 'TotalRealAmount' 
   ,26   -- Inventory Cost Rollup Correction
   ,convert(int, Datepart(yyyy,@TransactionDate) * 10000 + Datepart(mm,@TransactionDate) * 100 + Datepart(dd,@TransactionDate)) 
   ,Round((Round(Sum(pt.Quantity),6) * dbo.fdxGetStandardMaterialCost ( pt.FK_dxProduct, @TransactionDate ))-
           Round( Sum( dbo.fdxGLMaterialStandardCost (
                      pt.KindofDocument, pt.PhaseMaterialStandardCostVariance,pt.MaterialStandardCost,
                      pt.quantity,pt.TransactionDate) ),2),2) as 'TotalMaterialCostAmount'
  
   
   ,max(pc.FK_dxAccount__AdjustmentCostRollup)
  
  FROM dbo.dxProduct pr
  left join dbo.dxProductTransaction pt ON pt.FK_dxProduct = pr.PK_dxProduct 
  left join dbo.dxProductCategory pc on (pc.PK_dxProductCategory = pr.FK_dxProductCategory ) 
  WHERE pt.TransactionDate <= @TransactionDate
     
  Group by 
     pt.FK_dxWarehouse
    ,pt.FK_dxLocation
    ,pt.FK_dxProduct
    ,Lot
  Having
         --(abs(Round(Sum(pt.Quantity),6)) > 0.0000001 ) and
         (abs(Round((Round(Sum(pt.Quantity),6) * dbo.fdxGetStandardMaterialCost ( pt.FK_dxProduct, @TransactionDate ))-
           Round( Sum( dbo.fdxGLMaterialStandardCost (
                      pt.KindofDocument, pt.PhaseMaterialStandardCostVariance,pt.MaterialStandardCost,
                      pt.quantity,pt.TransactionDate) ),2),2)) > 0.01 ) 
           
END
GO
