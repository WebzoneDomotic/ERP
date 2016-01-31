SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------
   -- Kind of document
   -- kdJournalEntry           = 1  ;
   -- kdCashReceipt            = 2  ;
   -- kdInvoice                = 3  ;
   -- kdPayment                = 4  ;
   -- kdPayableInvoice         = 5  ;
   -- kdReconciliation         = 6  ;
   -- kdDeposit                = 7  ;
   -- kdCashReceiptImputation  = 8  ;
   -- kdInventoryAdjustment    = 9  ;
   -- kdPaymentImputation      = 10 ;
   -- kdReception              = 11 ;
   -- kdShipment               = 12 ;
   -- kdCycleCounting          = 13 ;
   -- kdInventoryTransfer      = 14 ;
   -- kdDeclaration            = 15 ;
   -- kdDeclarationConsumption = 16 ;
   -- kdFinishedProduct        = 17 ;
   -- kdDeclarationLabor       = 18 ;
   -- kdClientOrderReservation = 19 ;
   -- kdRMA                    = 20 ;

CREATE PROCEDURE [dbo].[pdxPrepareInventoryAccountingEntry] @KindOfDocument int
AS
BEGIN
  -- Create Accounting entry
  Insert into dxEntry ( KindOfDocument,  PrimaryKeyValue )
  Select Distinct ei.KindOfDocument , ei.PrimaryKeyValue from dxProductTransactionToUpdate pu
        left outer join  dxProductTransaction ei on ( pu.FK_dxProductTransaction = ei.PK_dxProductTransaction and pu.KindOfDocument = @KindOfDocument )
        where ( not exists ( select 1 from dxEntry en where en.KindOfDocument = ei.KindOfDocument and en.PrimaryKeyValue = ei.PrimaryKeyValue))
          and pu.KindOfDocument = @KindOfDocument
          and not ei.KindOfDocument is null
          and not ei.PrimaryKeyValue is null
 -- Delete Accounting Transaction Entry
  Delete from dxAccountTransaction
   where PrimaryKeyValue in ( select ei.FK_dxProductTransaction from dxProductTransactionToUpdate ei )
     and KindOfDocument = @KindOfDocument
END
GO
