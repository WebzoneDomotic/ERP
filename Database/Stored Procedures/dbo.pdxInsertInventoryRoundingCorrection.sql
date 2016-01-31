SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-09-02
-- Description:	Insert Product Transaction to Correct Rounding Error
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxInsertInventoryRoundingCorrection] @TransactionDate Datetime
as
BEGIN           
  Declare @RoundingDifferenceAmount float
  Declare @FK_dxAccount__Imputation int
  Set @RoundingDifferenceAmount = ( Select RoundingDifferenceAmount from dxAccountConfiguration )
  Set @FK_dxAccount__Imputation = ( Select FK_dxAccount__RoundingDifference from dxAccountConfiguration )
  
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
           ,[LaborStandardCost]
           ,[OverheadFixedStandardCost]
           ,[OverheadVariableStandardCost]
           
           ,[FK_dxAccount__CorrectionMaterial]
           ,[FK_dxAccount__CorrectionLabor]
           ,[FK_dxAccount__CorrectionOverheadFixed]
           ,[FK_dxAccount__CorrectionOverheadVariable])
    
  SELECT
    2
   ,pt.FK_dxWarehouse                                    as 'FK_dxWarehouse'
   ,pt.FK_dxProduct                                      as 'FK_dxProduct'
   ,@TransactionDate
   ,pt.Lot                                               as 'Lot'
   ,pt.FK_dxLocation                                     as 'FK_dxLocation'
   ,Convert(varchar(100),Max(pr.ID) +', '+ pt.Lot +', '+ Max(pr.Description))  as 'Description'
   ,Round(-1.0 * Sum(pt.Amount),2)                       as 'TotalRealAmount' 
   , 25 -- Inventory Correction
   ,convert(int, Datepart(yyyy,@TransactionDate) * 10000 + Datepart(mm,@TransactionDate) * 100 + Datepart(dd,@TransactionDate)) 
         
   ,Round(-1.0 * Sum( dbo.fdxGLMaterialStandardCost (
                      pt.KindofDocument, pt.PhaseMaterialStandardCostVariance,pt.MaterialStandardCost,
                      pt.quantity,pt.TransactionDate) ),2) as 'TotalMaterialCostAmount'
   ,Round(-1.0 * Sum(dbo.fdxGLLaborStandardCost (
                      pt.KindofDocument, pt.PhaseLaborStandardCostVariance,pt.LaborStandardCost,
                      pt.quantity,pt.TransactionDate) ),2)   as 'TotalLaborCostAmount'
   ,0.0
   ,0.0  
   
   ,@FK_dxAccount__Imputation
   ,@FK_dxAccount__Imputation
   ,@FK_dxAccount__Imputation
   ,@FK_dxAccount__Imputation
    
  FROM dbo.dxProduct pr
  left join dbo.dxProductTransaction pt ON pt.FK_dxProduct = pr.PK_dxProduct 
   
  WHERE pt.TransactionDate <= @TransactionDate
     
  Group by 
     pt.FK_dxWarehouse
    ,pt.FK_dxLocation
    ,pt.FK_dxProduct
    ,Lot
    
  Having 
      -- Quantity = 0
          (abs(Round(Sum(pt.Quantity),6)) <= 0.0000001 )
          
      and (  abs(Round(Sum(pt.Amount)  ,6)) <= @RoundingDifferenceAmount)
      and (  abs(Round(Sum( dbo.fdxGLMaterialStandardCost (
                            pt.KindofDocument, pt.PhaseMaterialStandardCostVariance,pt.MaterialStandardCost,
                            pt.quantity,pt.TransactionDate) ),2)) <= @RoundingDifferenceAmount  )

      -- On exclue les enregistrements ou le total = 0 pour toutes les colonnes      
      and  ( abs(Round(Sum(pt.Amount)  ,6))  +  
             abs(Round(Sum(dbo.fdxGLMaterialStandardCost (
                           pt.KindofDocument, pt.PhaseMaterialStandardCostVariance,pt.MaterialStandardCost,
                           pt.quantity,pt.TransactionDate) ),2)) +
              0.0 +
              0.0
            )  > 0.0    
           
END
GO
