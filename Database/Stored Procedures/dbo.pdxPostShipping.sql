SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2013-01-28
-- Description:	Post Shipping
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxPostShipping]  @FK_dxShipping int
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

  Declare @ClientActive bit, @ItemClosed bit, @OnHold bit,@Posted bit

  BEGIN TRY

      While @CountRecNo <> ( select count(*) from @RecList )
      begin
          -- Get Prior Count Value
          Select @CountRecNo =count(*) from @RecList
          Set @RecNo = null
          -- Init Variable
          SELECT Top 1
            @RecNo= sd.PK_dxShippingDetail
            -- nTransactionType }
            -- 0 - Quantity Ajustment
            -- 1 - Average cost Ajustment
            -- 2 - Add an Amount to total Amount
            -- 3 - Quantity & Cost Adjustment
           ,@TransactionType = 0
           ,@Inventory = sd.FK_dxWarehouse
           ,@Product = sd.FK_dxProduct
           ,@Description = Convert (varchar(255),sd.Description )
           ,@Lot = Convert (varchar(50),sd.Lot )
           ,@Location = sd.FK_dxLocation
           ,@TransactionDate = sp.TransactionDate
           ,@Quantity = round(-1.0 * sd.Quantity,6)
           ,@AmountPerUnit = 0.0
           ,@Amount = 0.0
           ,@kdDocument = 12
           ,@PKMaster = sp.PK_dxShipping
           ,@PKDetail = sd.PK_dxShippingDetail
           ,@LinkedProductTransaction  = 0
           ,@Status  = 0
           ,@FK_dxLocation__PriorPhase = Null
           ,@PhaseNumber  = -1
           ,@PriorPhase  = 0
           ,@DoNotGenerateGLEntry = 0
           ,@NewTransaction  = -1
           ,@ClientActive = cl.Active
           ,@ItemClosed = od.Closed
           ,@OnHold = co.OnHold
           ,@Posted = co.Posted

         FROM dxShippingDetail sd
         left join dxShipping sp on ( sp.PK_dxShipping = sd.FK_dxShipping )
         left join dxClient   cl on ( cl.PK_dxClient   = sp.FK_dxClient )
         left join dxClientOrderDetail  od on ( od.PK_dxClientOrderDetail = sd.FK_dxClientOrderDetail )
         left join dxClientOrder        co on ( co.PK_dxClientOrder       = od.FK_dxClientOrder )
         Where PK_dxShipping = @FK_dxShipping
           and PK_dxShippingdetail not in ( Select RecNo From @RecList )
           and sp.Posted = 0
         order by sd.rank

         -- Validate shipping
         Set @Inventory_Message = ''
         if @ClientActive = 0 set @Inventory_Message = 'Le client est inactif / Client is inactive.'
         if @ItemClosed   = 1 set @Inventory_Message = 'La commande est fermée pour cet item / The order is closed for this item. '
         if @OnHold       = 1 set @Inventory_Message = 'La commande est retenue / The order is on hold. '
         if @Posted       = 0 set @Inventory_Message = 'La commande n''est pas reportée, vérifier avec les ventes / The order is not posted, check with sales departement. '
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
      Update dxShipping set Posted = 1 where PK_dxShipping = @FK_dxShipping

      Execute [dbo].[pdxUpdateShippedQuantityOnPO] @FK_dxShipping
      Execute [dbo].[pdxCreateInvoiceFromShipping] @FK_dxShipping


  END TRY
  BEGIN CATCH
     RAISERROR (@Inventory_Message, 16, 1)
  END CATCH
end
GO
