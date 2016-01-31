SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxSetReconciliatedTransactions]  
  @PK_dxBankReconciliation int = -1

AS
 Declare @InitAmount float, @ChequeAmount float, @DepositAmount float, @TransactionAmount float, @FeeAmount float;

 Set @ChequeAmount      = ( Select Coalesce(sum(Amount),0.0) from dxBankReconciliationDetail where ( not FK_dxPayment is null ) and FK_dxBankReconciliation = @PK_dxBankReconciliation ) ;
 Set @DepositAmount     = ( Select Coalesce(sum(Amount),0.0) from dxBankReconciliationDetail where ( not FK_dxDeposit is null ) and FK_dxBankReconciliation = @PK_dxBankReconciliation ) ;
 Set @TransactionAmount = ( Select Coalesce(sum(Amount),0.0) from dxBankReconciliationDetail where ( not FK_dxJournalEntryDetail is null ) and FK_dxBankReconciliation = @PK_dxBankReconciliation ) ;
 Set @FeeAmount         = ( Select Coalesce(sum(Amount),0.0) from dxBankReconciliationDetail where FK_dxReconciliationTransactionType = 10 and FK_dxBankReconciliation = @PK_dxBankReconciliation ) ;
 Set @InitAmount        = ( Select Coalesce(sum(Amount),0.0) from dxBankReconciliationDetail where FK_dxReconciliationTransactionType = 20 and FK_dxBankReconciliation = @PK_dxBankReconciliation ) ;

 BEGIN TRANSACTION
    Update dxBankReconciliation 
    set InitializationAmount           = @InitAmount,
        ReconcilatedChequeAmount       = @ChequeAmount ,
        ReconciliatedDepositAmount     = @DepositAmount,
        ReconciliatedTransactionAmount = @TransactionAmount,
        ReconciliatedFee               = @FeeAmount
     where PK_dxBankReconciliation = @PK_dxBankReconciliation ;

 COMMIT
GO
