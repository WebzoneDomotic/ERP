SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxSetGLTransactionAmount]  
  @PK_dxBankReconciliation int = -1

AS
 Declare @GLTransactionAmount float;
 -- kdJournalEntry    = 1  
 -- kdCashReceipt     = 2  
 -- kdInvoice         = 3  
 -- kdPayment         = 4  
 -- kdPayableInvoice  = 5  
 -- kdReconciliation  = 6  
 Set @GLTransactionAmount = ( Select Coalesce(sum(Amount),0.0) from dxBankReconciliation c, dxAccountTransaction t
                          where c.PK_dxBankReconciliation = @PK_dxBankReconciliation
                            and t.FK_dxAccount = ( select FK_dxAccount__GL from dxBankAccount where PK_dxBankAccount = 
                                                 ( select FK_dxBankAccount from dxBankReconciliation where PK_dxBankReconciliation = @PK_dxBankReconciliation ) )
                            and t.KindOfDocument = 1
                            and t.TransactionDate between c.StartDate and c.EndDate ) ;
 BEGIN TRANSACTION
    Update dxBankReconciliation 
       set GLTransactionAmount   = @GLTransactionAmount
      where PK_dxBankReconciliation = @PK_dxBankReconciliation ;
 COMMIT
GO
