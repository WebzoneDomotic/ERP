SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxCalculateReconciliation]  
  @Reconciliation int = -1
AS
  EXECUTE pdxSetStartingDate              @PK_dxBankReconciliation = @Reconciliation ;
  EXECUTE pdxSetOutStandingAmount         @PK_dxBankReconciliation = @Reconciliation ;
  EXECUTE pdxSetGLStartingBalance         @PK_dxBankReconciliation = @Reconciliation ;
  EXECUTE pdxSetGLChequeAmount            @PK_dxBankReconciliation = @Reconciliation ;
  EXECUTE pdxSetGLDepositAmount           @PK_dxBankReconciliation = @Reconciliation ;
  EXECUTE pdxSetGLTransactionAmount       @PK_dxBankReconciliation = @Reconciliation ;
  EXECUTE pdxSetGLEndingBalance           @PK_dxBankReconciliation = @Reconciliation ;
  EXECUTE pdxSetReconciliatedTransactions @PK_dxBankReconciliation = @Reconciliation ;
  EXECUTE pdxSetEndingBalance             @PK_dxBankReconciliation = @Reconciliation ;
GO
