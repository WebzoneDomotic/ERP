SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[pdxInsertInventoryCorrection] 
            @FK_dxWarehouse int
           ,@FK_dxProduct int
           ,@TransactionDate Datetime
           ,@Lot varchar(50)
           ,@FK_dxLocation int
           ,@Description varchar(100)
           ,@Amount float
           

           ,@MaterialStandardCost float
           ,@LaborStandardCost float
           ,@OverheadFixedStandardCost float
           ,@OverheadVariableStandardCost float
           
           ,@FK_dxAccount__CorrectionMaterial int
           ,@FK_dxAccount__CorrectionLabor int
           ,@FK_dxAccount__CorrectionOverheadFixed int
           ,@FK_dxAccount__CorrectionOverheadVariable int
as
BEGIN           

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
    
   Select     
            2
           ,@FK_dxWarehouse
           ,@FK_dxProduct
           ,@TransactionDate
           ,@Lot
           ,@FK_dxLocation
           ,Convert(varchar(100),@Description)
           ,@Amount
           , 25 -- Inventory Correction
           , Datepart(yyyy,@TransactionDate) * 10000 + Datepart(mm,@TransactionDate) * 100 +  + Datepart(dd,@TransactionDate)

           ,@MaterialStandardCost
           ,@LaborStandardCost
           ,@OverheadFixedStandardCost
           ,@OverheadVariableStandardCost
           
           ,@FK_dxAccount__CorrectionMaterial
           ,@FK_dxAccount__CorrectionLabor
           ,@FK_dxAccount__CorrectionOverheadFixed
           ,@FK_dxAccount__CorrectionOverheadVariable
END
GO
