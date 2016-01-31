SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2013-01-28
-- Description:	Post Inventory Adjustment
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxPostInventoryAdjustment]  @FK_dxInventoryAdjustment int
as
Begin
  SET NOCOUNT ON
  Declare @TransactionType int
        , @Inventory int
        , @Product int
        , @Description varchar(255)
        , @Lot varchar(50)
        , @Location int
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
        , @NewTransaction int = -1
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
            @RecNo= sd.PK_dxInventoryAdjustmentDetail
            -- nTransactionType }
            -- 0 - Quantity Ajustment
            -- 1 - Average cost Ajustment
            -- 2 - Add an Amount to total Amount
            -- 3 - Quantity & Cost Adjustment
            
           ,@TransactionType = Case when Abs(sd.Quantity)             > 0.0000001 and 
                                         Abs(sd.AverageAmountPerUnit) > 0.0000001 then 3
                                    when Abs(sd.Amount)               > 0.0000001 then 2 
                                    when Abs(sd.AverageAmountPerUnit) > 0.0000001 then 1
                                    when Abs(sd.Quantity)             > 0.0000001 then 0 
                               else 0
                               end     
           ,@Inventory = sd.FK_dxWarehouse
           ,@Product = sd.FK_dxProduct
           ,@Description = Convert (varchar(255),sd.Description )
           ,@Lot = Convert (varchar(50),sd.Lot )
           ,@Location = sd.FK_dxLocation
           ,@TransactionDate = sp.TransactionDate
           ,@Quantity      = Round( sd.Quantity,6)
           ,@AmountPerUnit = Round(sd.AverageAmountPerUnit,6)
           ,@Amount        = Case when Abs(sd.Quantity)             > 0.0000001 and 
                                       Abs(sd.AverageAmountPerUnit) > 0.0000001 then 
                                Round(sd.Quantity * sd.AverageAmountPerUnit,2)
                             else
                                Round(sd.Amount,2)
                             end   
           ,@kdDocument    = 9
           ,@PKMaster      = sp.PK_dxInventoryAdjustment
           ,@PKDetail      = sd.PK_dxInventoryAdjustmentDetail
           ,@LinkedProductTransaction  = 0
           ,@Status  = 0
           ,@FK_dxLocation__PriorPhase = Null
           ,@PhaseNumber = -1
           ,@PriorPhase  = 0
           ,@DoNotGenerateGLEntry = sp.DoNotGenerateGLEntry
           ,@NewTransaction  = -1
           ,@Posted = sp.Posted

         FROM dxInventoryAdjustmentDetail sd
         left join dxInventoryAdjustment sp on ( sp.PK_dxInventoryAdjustment = sd.FK_dxInventoryAdjustment )
         Where PK_dxInventoryAdjustment = @FK_dxInventoryAdjustment
           and PK_dxInventoryAdjustmentDetail not in ( Select RecNo From @RecList )
         
         -- Validate Adjustment
         Set @Inventory_Message = ''
         if @Posted       = 1 set @Inventory_Message = N'L''ajustment est déjà reporté / The adjustment is already posted. '
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
            Exec dbo.pdxInsertNewProductTransaction
            @TransactionType
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
           ,@LinkedProductTransaction
           ,@Status
           ,@FK_dxLocation__PriorPhase
           ,@PhaseNumber
           ,@PriorPhase
           ,@DoNotGenerateGLEntry
           ,@NewTransaction
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
      Update dxInventoryAdjustment set Posted = 1 where PK_dxInventoryAdjustment = @FK_dxInventoryAdjustment
  END TRY
  BEGIN CATCH
     RAISERROR (@Inventory_Message, 16, 1)
  END CATCH
end
GO
