SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxSetGLEndingBalance]  
  @PK_dxBankReconciliation int = -1

AS
 Declare @GLEndingBalance float;
 Set @GLEndingBalance = (  Select Coalesce( sum(t.Amount), 0.0 ) from dxBankReconciliation c, dxAccountTransaction t
                             where c.PK_dxBankReconciliation = @PK_dxBankReconciliation
                               and t.FK_dxAccount = ( select FK_dxAccount__GL from dxBankAccount where PK_dxBankAccount = 
                                                    ( select FK_dxBankAccount from dxBankReconciliation where PK_dxBankReconciliation = @PK_dxBankReconciliation ) )
                               and t.TransactionDate <= c.EndDate ) ;
 BEGIN TRANSACTION
    Update dxBankReconciliation set GLEndingBalanceAmount = @GLEndingBalance where PK_dxBankReconciliation = @PK_dxBankReconciliation ;
 COMMIT
GO
