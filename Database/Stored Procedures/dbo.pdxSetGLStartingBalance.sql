SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pdxSetGLStartingBalance]
  @PK_dxBankReconciliation int = -1

AS
 Declare @GLStartingBalance float;
 Declare @BankStartingBalance float;
 Declare @FK_dxBankAccount int
 Declare @StartDate Datetime

 Select @FK_dxBankAccount = FK_dxBankAccount,
        @StartDate = StartDate
 from dxBankReconciliation where PK_dxBankReconciliation = @PK_dxBankReconciliation

 Set @GLStartingBalance = (  Select Coalesce( sum(t.Amount), 0.0 ) from dxBankReconciliation c, dxAccountTransaction t
                             where c.PK_dxBankReconciliation = @PK_dxBankReconciliation
                               and t.FK_dxAccount = ( select FK_dxAccount__GL from dxBankAccount where PK_dxBankAccount =
                                                    ( select FK_dxBankAccount from dxBankReconciliation where PK_dxBankReconciliation = @PK_dxBankReconciliation ) )
                               and t.TransactionDate < c.StartDate ) ;

 Set @BankStartingBalance = ( Select top 1 EndingBalanceAmount from dxBankReconciliation
                               where FK_dxBankAccount = @FK_dxBankAccount
                                 and StartDate < @StartDate order by  StartDate desc )

 BEGIN TRANSACTION
    Update dxBankReconciliation
        set GLStartingBalanceAmount = @GLStartingBalance ,
            StartingBalanceAmount   = Coalesce(@BankStartingBalance, 0.0)
    where PK_dxBankReconciliation = @PK_dxBankReconciliation ;
 COMMIT
GO
