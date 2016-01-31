SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2013-01-28
-- Description:	Post Inventory Transfer
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxPostInventoryTransfer]  @FK_dxInventoryTransfer int
as
Begin
  SET NOCOUNT ON
  Declare @TransactionType int
        , @Inventory int
        , @Inventory_In int
        , @Product int
        , @Description varchar(255)
        , @Lot varchar(50)
        , @Lot_In varchar(50)
        , @Location int
        , @Location_In int
        , @TransactionDate Datetime
        , @Quantity Float
        , @AmountPerUnit Float
        , @Amount Float
        , @kdDocument int
        , @PKMaster int
        , @PKDetail int
        , @LinkedProductTransaction int = 0
        , @Status Int = 0
        , @FK_dxLocation__PriorPhase int= -1
        , @PhaseNumber int = -1
        , @PriorPhase bit = 0
        , @DoNotGenerateGLEntry bit = 0
        , @NewTransaction_Out int = -1
        , @RecNo int = -1
        , @CountRecNo int = -1
  Declare @RecList Table ( RecNo int )
  Declare @Inventory_Message varchar(8000)

  Declare @Posted bit

  BEGIN TRY

      While @CountRecNo <> ( select count(*) from @RecList )
      begin
          -- Get Prior Count Value
          Select @CountRecNo =count(*) from @RecList
          Set @RecNo = null
          -- Init Variable
          SELECT Top 1
            @RecNo= sd.PK_dxInventoryTransferDetail
            -- nTransactionType }
            -- 0 - Quantity Ajustment
            -- 1 - Average cost Ajustment
            -- 2 - Add an Amount to total Amount
            -- 3 - Quantity & Cost Adjustment
            
           ,@TransactionType = 0    
           ,@Inventory       = sd.FK_dxWarehouse__Out
           ,@Inventory_In    = sd.FK_dxWarehouse__In
           ,@Product         = sd.FK_dxProduct
           ,@Description     = Coalesce(Convert (varchar(255),pr.Description ),'')
           ,@Lot             = Upper(Convert (varchar(50),sd.Lot))
           ,@Lot_In          = Upper(Case when sd.NewLot = '' then Convert(varchar(50),sd.Lot) else Convert(varchar(50),sd.NewLot ) end )
           ,@Location        = sd.FK_dxLocation__Out
           ,@Location_In     = sd.FK_dxLocation__In
           ,@TransactionDate = sp.TransactionDate
           ,@Quantity        = Round( sd.Quantity,6)
           ,@AmountPerUnit   = 0.0
           ,@Amount          = 0.0
           ,@kdDocument      = 14  -- Transfer
           ,@PKMaster        = sp.PK_dxInventoryTransfer
           ,@PKDetail        = sd.PK_dxInventoryTransferDetail
           ,@LinkedProductTransaction  = 0
           ,@Status          = 0
           ,@FK_dxLocation__PriorPhase = Null
           ,@PhaseNumber     = -1
           ,@PriorPhase      = 0
           ,@DoNotGenerateGLEntry = 0
           ,@NewTransaction_Out  = -1
           ,@Posted = sp.Posted

         FROM dxInventoryTransferDetail sd
         left join dxInventoryTransfer sp on ( sp.PK_dxInventoryTransfer = sd.FK_dxInventoryTransfer )
         left join dxProduct pr on ( pr.PK_dxProduct = sd.FK_dxProduct )
         Where PK_dxInventoryTransfer = @FK_dxInventoryTransfer
           and PK_dxInventoryTransferDetail not in ( Select RecNo From @RecList )
         
         -- Validate Adjustment
         Set @Inventory_Message = ''
         if @Posted  = 1 set @Inventory_Message = N'Le transfert est déjà reporté / The inventory transfer is already posted. '
         if @Inventory_Message <> '' RAISERROR (@Inventory_Message, 16, 1)

         -- If not process all item the continue inserting productransactions
         If not @RecNo is null
         begin
            -- Set Inventory Message
            Set @Inventory_Message = 'Inventaire négatif non permis / Negative inventory not allowed'+ char(13)+
                                     'Item     : ' + @Description + char(13)+
                                     'Lot      : ' + @Lot + char(13)+
                                     'Quantité : ' + Convert(varchar(50), Abs(@Quantity))+ char(13)+
                                     'Date     : ' + Convert(varchar(50), @TransactionDate , 111)

            Insert into @RecList (RecNo) values( @RecNo )
            
            -- In Transaction (3)
            Exec dbo.pdxInsertNewProductTransaction
            3
           ,@Inventory_In
           ,@Product
           ,@Description
           ,@Lot_In
           ,@Location_In
           ,@TransactionDate
           ,@Quantity
           ,@AmountPerUnit
           ,@Amount
           ,@kdDocument
           ,@PKMaster
           ,@PKDetail
           ,@LinkedProductTransaction
           ,@Status
           ,@FK_dxLocation__PriorPhase
           ,@PhaseNumber
           ,@PriorPhase
           ,@DoNotGenerateGLEntry
           ,@NewTransaction = @NewTransaction_Out OUTPUT
           
            -- Out Transaction (0)
            Set @Quantity = -1.0 * @Quantity ;
            
            Exec dbo.pdxInsertNewProductTransaction
            0
           ,@Inventory
           ,@Product
           ,@Description
           ,@Lot
           ,@Location
           ,@TransactionDate
           ,@Quantity
           ,@AmountPerUnit
           ,@Amount
           ,@kdDocument
           ,@PKMaster
           ,@PKDetail
           ,@NewTransaction_Out -- Linked Product Transaction
           ,@Status
           ,@FK_dxLocation__PriorPhase
           ,@PhaseNumber
           ,@PriorPhase
           ,@DoNotGenerateGLEntry
           ,@NewTransaction = -1
           
           
         end
      end  --While @CountRecNo <> ( select count(*) from @RecList )

      Execute [dbo].[pdxProductTransactionCorrection]
      Execute [dbo].[pdxProductTransactionCostRollup]
      Execute [dbo].[pdxProductTransactionDeclarationMaterial]
      Execute [dbo].[pdxProductTransactionDeclarationPhase]
      Execute [dbo].[pdxProductTransactionFinishProduct]
      Execute [dbo].[pdxProductTransactionReception]
      Execute [dbo].[pdxProductTransactionReservation]
      Execute [dbo].[pdxProductTransactionRMA]
      Execute [dbo].[pdxProductTransactionShipping]
      Execute [dbo].[pdxProductTransactionTransfer]
      Execute [dbo].[pdxProductTransactionAdjustment]

      Execute [dbo].[pdxValidateEntry]
      Execute [dbo].[pdxUpdateAccountPeriod]
      
      -- We have finish set status to Posted
      Update dxInventoryTransfer set Posted = 1 where PK_dxInventoryTransfer = @FK_dxInventoryTransfer
  END TRY
  BEGIN CATCH
     RAISERROR (@Inventory_Message, 16, 1)
  END CATCH
end
GO
