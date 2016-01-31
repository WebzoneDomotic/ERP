SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxSetOutStandingAmount]  
  @PK_dxBankReconciliation int = -1

AS
  Declare @PaymentAmount float, @DepositAmount float, @CashReceiptAmount float ;
 
  Set @PaymentAmount = ( Select Coalesce(Sum(d.TotalAmount), 0.0) from dxBankReconciliation c , dxPayment d
                                             left outer join dxBankReconciliationDetail r on ( r.FK_dxPayment = d.PK_dxPayment )
                         where d.FK_dxBankAccount = ( select FK_dxBankAccount from dxBankReconciliation where PK_dxBankReconciliation = @PK_dxBankReconciliation  ) 
                         and c.PK_dxBankReconciliation = @PK_dxBankReconciliation 
                         and r.PK_dxBankReconciliationDetail is null 
                         and d.TransactionDate <= c.Enddate
                         and d.posted = 1 ) ;
  Set @DepositAmount = ( Select Coalesce(Sum(d.TotalAmount), 0.0) from dxBankReconciliation c, dxDeposit d 
                                            left outer join dxBankReconciliationDetail r on ( r.FK_dxDeposit = d.PK_dxDeposit )
                         where d.FK_dxBankAccount = ( select FK_dxBankAccount from dxBankReconciliation where PK_dxBankReconciliation = @PK_dxBankReconciliation ) 
                         and c.PK_dxBankReconciliation = @PK_dxBankReconciliation
                         and r.PK_dxBankReconciliationDetail is null 
                         and d.TransactionDate between c.StartDate and c.Enddate 
                         and d.Posted = 1 );
 Set @CashReceiptAmount=( Select Coalesce(Sum(d.TotalAmount), 0.0) from dxBankReconciliation c , dxCashReceipt d
                         where d.FK_dxBankAccount = ( select FK_dxBankAccount from dxBankReconciliation where PK_dxBankReconciliation = @PK_dxBankReconciliation ) 
                         and c.PK_dxBankReconciliation = @PK_dxBankReconciliation
                         and (( d.FK_dxDeposit is null  and d.TransactionDate between c.StartDate and c.Enddate) )
                         and d.Posted = 1 ) ;

  BEGIN TRANSACTION
   Update dxBankReconciliation 
       set OutstandingChequeAmount      = -1.0 * @PaymentAmount ,
           OutstandingDepositAmount     = @DepositAmount ,
           OutStandingCashReceiptAmount = @CashReceiptAmount 
   where PK_dxBankReconciliation = @PK_dxBankReconciliation ;
 COMMIT
GO
