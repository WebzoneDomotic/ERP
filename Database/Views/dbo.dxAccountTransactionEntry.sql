SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxAccountTransactionEntry] as
SELECT
    Convert(bit,0) as ReversedTransaction,
     case KindOfDocument
        WHEN 0   THEN 'EJA-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 1   THEN 'Journal Entry-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 2   THEN 'Cash Receipt-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 3   THEN 'Invoice-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 4   THEN 'Payment-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 5   THEN 'Payable Invoice-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 6   THEN 'Reconciliation-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 7   THEN 'Deposit-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 8   THEN 'Cash Receipt Imputation-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 9   THEN 'Inventory Adjustment-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 10  THEN 'Payment Imputation-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 11  THEN 'Reception-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 12  THEN 'Shipment -' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 13  THEN 'Cycle Counting-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 14  THEN 'Inventory Transfer-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 15  THEN 'Declare Phase-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 16  THEN 'Declare Consumption-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 17  THEN 'Declare Finished Product-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 18  THEN 'Declare Labor-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 19  THEN 'C0 Reservation-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 20  THEN 'RMA-' +Convert(varchar(50), PrimaryKeyValue )

     else
       'NONDEF-' +Convert(varchar(50), PrimaryKeyValue )
     end Reference

     ,at.[PK_dxAccountTransaction]
     ,at.[FK_dxEntry]
     ,at.[FK_dxJournal]
     ,at.[FK_dxAccount]
     ,at.[FK_dxPeriod]
     ,( Select Coalesce(Convert(varchar(50),AccountingPeriod),ID) From dxPeriod where PK_dxPeriod = FK_dxPeriod) [Period]
     ,at.[TransactionDate]
     ,( Select ID +', '+ dxAccount.Description From dxAccount where PK_dxAccount = FK_dxAccount) [Account]
     ,at.[CT]
     ,at.[DT]
     ,at.[Amount]
     ,at.[FK_dxCurrency]
     ,Case
        when Not FK_dxJournalEntryDetail   Is Null then ( Select de.Description from  dxJournalEntryDetail de   where PK_dxJournalEntryDetail   = FK_dxJournalEntryDetail)
        when Not FK_dxInvoiceDetail        Is Null then ( Select de.Description from  dxInvoiceDetail de        where PK_dxInvoiceDetail        = FK_dxInvoiceDetail)
        when Not FK_dxPayableInvoiceDetail Is Null then ( Select de.Description from  dxPayableInvoiceDetail de where PK_dxPayableInvoiceDetail = FK_dxPayableInvoiceDetail)
     --   when Not FK_dxCashReceipt          Is Null then ( Select 'Encaissement '+de.ID + ' '+de.Reference+ ' '+de.Description
     --                                                     from  dxCashReceipt de where PK_dxCashReceipt = FK_dxCashReceipt)
      else at.[Description]
      end  [Description]
     ,at.[EndOfPeriodInventory]
     ,at.[EndOfPeriodTransaction]
     ,at.[EndOfYearTransaction]
     ,at.[KindOfDocument]
     ,at.[PrimaryKeyValue]
     ,at.[FK_dxJournalEntryDetail]
     ,at.[FK_dxPayableInvoiceDetail]
     ,at.[FK_dxInvoiceDetail]
     ,at.[FK_dxPayment]
     ,at.[FK_dxCashReceipt]
     ,at.[FK_dxBankReconciliationDetail]

 from dxAccountTransaction at


UNION ALL

SELECT
     Convert(bit,1) as ReversedTransaction,
     case KindOfDocument
        WHEN 0   THEN 'EJA-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 1   THEN 'Journal Entry-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 2   THEN 'Cash Receipt-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 3   THEN 'Invoice-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 4   THEN 'Payment-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 5   THEN 'Payable Invoice-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 6   THEN 'Reconciliation-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 7   THEN 'Deposit-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 8   THEN 'Cash Receipt Imputation-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 9   THEN 'Inventory Adjustment-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 10  THEN 'Payment Imputation-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 11  THEN 'Reception-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 12  THEN 'Shipment -' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 13  THEN 'Cycle Counting-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 14  THEN 'Inventory Transfer-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 15  THEN 'Declare Phase-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 16  THEN 'Declare Consumption-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 17  THEN 'Declare Finished Product-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 18  THEN 'Declare Labor-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 19  THEN 'C0 Reservation-' +Convert(varchar(50), PrimaryKeyValue )
        WHEN 20  THEN 'RMA-' +Convert(varchar(50), PrimaryKeyValue )
      else
       'NONDEF-' +Convert(varchar(50), PrimaryKeyValue )
      end Reference

      ,[PK_dxUnpostAccountTransaction]
      ,[KEY_dxEntry][FK_dxEntry]
      ,[KEY_dxJournal] [FK_dxJournal]
      ,[KEY_dxAccount] [FK_dxAccount]
      ,[KEY_dxPeriod]  [FK_dxPeriod]
      ,( Select ID From dxPeriod where PK_dxPeriod = KEY_dxPeriod) [Period]
      ,[TransactionDate]
      ,( Select ID +', '+ dxAccount.Description From dxAccount where PK_dxAccount = KEY_dxAccount) [Account]
      ,[CT]
      ,[DT]
      ,[Amount]
      ,[KEY_dxCurrency] [FK_dxCurrency]
      ,[Description]
      ,[EndOfPeriodInventory]
      ,[EndOfPeriodTransaction]
      ,[EndOfYearTransaction]
      ,[KindOfDocument]
      ,[PrimaryKeyValue]
      ,[KEY_dxJournalEntryDetail] [FK_dxJournalEntryDetail]
      ,[KEY_dxPayableInvoiceDetail] [FK_dxPayableInvoiceDetail]
      ,[KEY_dxInvoiceDetail] [FK_dxInvoiceDetail]
      ,[KEY_dxPayment] [FK_dxPayment]
      ,[KEY_dxCashReceipt] [FK_dxCashReceipt]
      ,[KEY_dxBankReconciliationDetail][FK_dxBankReconciliationDetail]
  FROM [dbo].[dxUnpostAccountTransaction]
GO
