SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxSetEndingBalance]  
  @PK_dxBankReconciliation int = -1

AS
 BEGIN TRANSACTION
    Update dxBankReconciliation 
    set AdjustedGLBalance               = GLEndingBalanceAmount + ReconciliatedFee ,
        CalculatedGLEndingBalanceAmount = StartingBalanceAmount + InitializationAmount + ReconcilatedChequeAmount +
                                          ReconciliatedDepositAmount + ReconciliatedTransactionAmount + ReconciliatedFee +
                                          OutStandingChequeAmount + OutStandingDepositAmount + OutStandingCashReceiptAmount 
    where PK_dxBankReconciliation = @PK_dxBankReconciliation ;
    
    Update dxBankReconciliation 
    set DeltaAmount = CalculatedGLEndingBalanceAmount - AdjustedGLBalance
    where PK_dxBankReconciliation = @PK_dxBankReconciliation ;

 COMMIT
GO
