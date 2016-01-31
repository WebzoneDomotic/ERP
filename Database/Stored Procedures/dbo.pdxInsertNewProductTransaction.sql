SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2013-01-28
-- Description:	Insert New Product Transaction
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxInsertNewProductTransaction]
    @TransactionType int
   ,@Inventory int
   ,@Product int
   ,@Description varchar(255)
   ,@Lot varchar(50)
   ,@Location int
   ,@TransactionDate Datetime
   ,@Quantity Float
   ,@AmountPerUnit Float
   ,@Amount Float
   ,@kdDocument int
   ,@PKMaster int
   ,@PKDetail int
   ,@LinkedProductTransaction int = 0
   ,@Status Int = 0
   ,@FK_dxLocation__PriorPhase int= -1
   ,@PhaseNumber int = -1
   ,@PriorPhase bit = 0
   ,@DoNotGenerateGLEntry bit = 0
   ,@NewTransaction int = -1 OUTPUT
AS
Begin
   SET NOCOUNT ON
   Declare @FK_dxPeriod int,@ProductInventory bit  ;
   -- Transaction fail if = -1

   -- nTransactionType
   -- 0 - Quantity Ajustment
   -- 1 - Average cost Ajustment
   -- 2 - Add an Amount to total Amount
   -- 3 - Quantity & Cost Adjustment

   Select @ProductInventory = InventoryItem From dxProduct where PK_dxProduct = @Product

   if @ProductInventory = 1
   begin
     -- Inserting Transaction
     Insert into dbo.dxProductTransaction (
        TransactionType,
        FK_dxWarehouse,
        FK_dxProduct,
        TransactionDate,
        Lot,
        FK_dxLocation,
        Description,
        Quantity,
        AmountPerUnit,
        Amount,

        MaterialCostVariance,
        LaborStandardCost,
        OverheadFixedCostVariance,
        OverheadVariableCostVariance,

        InStockQuantiy,
        AverageAmountPerUnit,
        TotalAmount,
        KindOfDocument,
        PrimaryKeyValue,
        Status,
        FK_dxLocation__PriorPhase,
        PhaseNumber,
        PriorPhase,
        LinkedProductTransaction
      , FK_dxInventoryAdjustmentDetail
      , FK_dxReceptionDetail
      , FK_dxPayableInvoiceDetail
      , FK_dxDeclaration
      , FK_dxDeclarationConsumption
      , FK_dxInventoryTransferDetail
      , FK_dxWorkOrderFinishedProduct
      , FK_dxDeclarationLabor
      , FK_dxClientOrderDetail
      , FK_dxShippingDetail
      , FK_dxRMADetail
      , FK_dxDeclarationDismantling
      , DoNotGenerateGLEntry)

      Values (
       @TransactionType
      ,@Inventory
      ,@Product
      ,@TransactionDate
      ,@Lot
      ,@Location
      ,Convert( varchar(225), @Description )
      ,@Quantity
      ,@AmountPerUnit
      ,@Amount

      ,case when @Status=0 then @Amount else 0.0 end -- MaterialCostVariance,
      ,case when @Status=1 then @Amount else 0.0 end -- LaborCostVariance,
      ,case when @Status=2 then @Amount else 0.0 end -- OverheadFixedCostVariance,
      ,case when @Status=3 then @Amount else 0.0 end -- OverheadVariableCostVariance,

      ,0.0  --InStockQuantiy
      ,0.0  --AverageAmountPerUnit
      ,0.0  --TotalAmount
      ,@KdDocument
      ,@PKMaster
      ,@Status
      ,@FK_dxLocation__PriorPhase
      ,@PhaseNumber
      ,@PriorPhase
      ,@LinkedProductTransaction

      ,case when @KdDocument=9  then @PKDetail else Null end --FK_dxInventoryAdjustmentDetail
      ,case when @KdDocument=11 then @PKDetail else Null end --FK_dxReceptionDetail
      ,case when @KdDocument=5  then @PKDetail else Null end --FK_dxPayableInvoiceDetail
      ,case when @KdDocument=15 then @PKDetail else Null end --FK_dxDeclaration
      ,case when @KdDocument=16 then @PKDetail else Null end --FK_dxDeclarationConsumption
      ,case when @KdDocument=14 then @PKDetail else Null end --FK_dxInventoryTransferDetail
      ,case when @KdDocument=17 then @PKDetail else Null end --FK_dxWorkOrderFinishedProduct
      ,case when @KdDocument=18 then @PKDetail else Null end --FK_dxDeclarationLabor
      ,case when @KdDocument=19 then @PKDetail else Null end --FK_dxClientOrderDetail
      ,case when @KdDocument=12 then @PKDetail else Null end --FK_dxShippingDetail
      ,case when @KdDocument=20 then @PKDetail else Null end --FK_dxRMADetail
      ,case when @KdDocument=21 then @PKDetail else Null end --FK_dxDeclarationDismantling
      ,@DoNotGenerateGLEntry) ;

     --Select @Output=SCOPE_IDENTITY()
     Select @NewTransaction = IDENT_CURRENT ('dxProductTransaction')

     -- We have to check all transaction after the new transaction an recalculate the Qty and $ for the future transactions }
     Set @TransactionDate = DateAdd(dd,-1,@TransactionDate)

     Exec dbo.pdxRecalculateInventory  @NewTransaction, @TransactionDate, @Inventory, @Location,@Product, @Lot, '' ;
  end -- If inventory Item
end
GO
