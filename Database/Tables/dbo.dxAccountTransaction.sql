CREATE TABLE [dbo].[dxAccountTransaction]
(
[PK_dxAccountTransaction] [int] NOT NULL IDENTITY(1, 1),
[FK_dxEntry] [int] NOT NULL,
[FK_dxJournal] [int] NOT NULL,
[FK_dxPeriod] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[FK_dxAccount] [int] NOT NULL,
[CT] [float] NOT NULL CONSTRAINT [DF_dxAccountTransaction_CT] DEFAULT ((0.0)),
[DT] [float] NOT NULL CONSTRAINT [DF_dxAccountTransaction_DT] DEFAULT ((0.0)),
[FK_dxCurrency] [int] NOT NULL,
[Description] [varchar] (100) COLLATE French_CI_AS NULL,
[EndOfPeriodInventory] [bit] NOT NULL CONSTRAINT [DF_dxAccountTransaction_EndOfPeriodInventory] DEFAULT ((0)),
[EndOfPeriodTransaction] [bit] NOT NULL CONSTRAINT [DF_dxAccountTransaction_EndOfPeriodTransaction] DEFAULT ((0)),
[EndOfYearTransaction] [bit] NOT NULL CONSTRAINT [DF_dxAccountTransaction_EndOfYearTransaction] DEFAULT ((0)),
[KindOfDocument] [int] NOT NULL,
[PrimaryKeyValue] [int] NOT NULL,
[FK_dxJournalEntryDetail] [int] NULL,
[FK_dxPayableInvoiceDetail] [int] NULL,
[FK_dxInvoiceDetail] [int] NULL,
[FK_dxPayment] [int] NULL,
[FK_dxCashReceipt] [int] NULL,
[FK_dxBankReconciliationDetail] [int] NULL,
[Amount] AS ([DT]-[CT]),
[Reversed] [bit] NOT NULL CONSTRAINT [DF_dxAccountTransaction_Reversed] DEFAULT ((0)),
[KEY_dxReceptionDetail] [int] NULL,
[KEY_dxShippingDetail] [int] NULL,
[KEY_dxRMADetail] [int] NULL,
[CurrencyRate] [float] NOT NULL CONSTRAINT [DF_dxAccountTransaction_CurrencyRate] DEFAULT ((1.0)),
[FK_dxAccrualPayableCorrection] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountTransaction.trGLEntryAfterUpdate] ON [dbo].[dxAccountTransaction]
AFTER INSERT, UPDATE, DELETE
AS
Begin
  SET NOCOUNT ON

  --Do some validation
  -- Check if period is closed for updated transaction
  if ( Select Max(Convert(int,AccountingIsClosed))
         from inserted at
         left join dxPeriod pe on (pe.PK_dxPeriod = at.FK_dxPeriod)
        -- Do not raise error if it is a end of period transaction or a currency entry
        where at.EndOfPeriodTransaction = 0 and FK_dxJournal <> 60 and at.EndOfYearTransaction = 0 ) = 1
  begin
     ROLLBACK TRANSACTION
     RAISERROR('La période est fermée / Period is closed.', 16, 1)
     RETURN
  end
  -- Check if period is closed for deleted transaction
  if ( Select Max(Convert(int,AccountingIsClosed))
         from deleted at
         left join dxPeriod pe on (pe.PK_dxPeriod = at.FK_dxPeriod)
         -- Do not raise error if it is a end of period transaction or a currency entry
        where  at.EndOfPeriodTransaction = 0 and FK_dxJournal <> 60 and at.EndOfYearTransaction = 0 ) = 1
  begin
     ROLLBACK TRANSACTION
     RAISERROR('La période est fermée / Period is closed.', 16, 1)
     RETURN
  end
  -- Check if we have a reconciliation Next to this transaction , we should not touch the bank account
  if exists (Select at.FK_dxAccount from dxBankReconciliation br
                     inner join dxBankAccount ba on ( ba.PK_dxBankAccount = br.FK_dxBankAccount )
                     inner join inserted at on ( at.FK_dxAccount = ba.FK_dxAccount__GL )
             where not at.FK_dxAccount is null
               and at.TransactionDate <= br.EndDate
               and br.Posted = 1
                 )
  begin
     ROLLBACK TRANSACTION
     RAISERROR('Conciliation existante pour la période, impossible d''affecter la banque.', 16, 1)
     RETURN
  end

  -- Buffer Transantion in order to update it when we close or delete an Entry
  Insert into dxAccountPeriodToUpdate (FK_dxEntry,FK_dxAccount,FK_dxPeriod) Select Distinct FK_dxEntry,FK_dxAccount,FK_dxPeriod from Inserted

End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountTransaction.trGLEntryCurrency] ON [dbo].[dxAccountTransaction]
FOR INSERT, UPDATE
AS
  SET NOCOUNT ON
  -- -------------------------------------------------------------------------------------------------
  -- Generate a foreign exchange transaction  if it is the case
  -- -------------------------------------------------------------------------------------------------
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodTransaction,KindOfDocument,PrimaryKeyValue,CurrencyRate )
  Select
         gl.FK_dxEntry, gl.TransactionDate , 60 , gl.FK_dxPeriod
       , co.FK_dxAccount__ForeignExchangeExpense
       , convert ( varchar(100), gl.Description )
       , Round(case when
                gl.Amount - Round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2) > 0.001 then
            Abs(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2)) else 0.0 end ,2)
       , Round(case when
                gl.Amount - Round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2) < -0.001 then
            Abs(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2)) else 0.0 end,2)
       ,co.FK_dxCurrency__System  ,0 ,gl.KindOfDocument , gl.PrimaryKeyValue
       ,case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end

  From inserted gl
  left join dxAccount ac on ( ac.PK_dxAccount =  gl.FK_dxAccount )
  left join dxPeriod  pe on ( pe.PK_dxPeriod  =  gl.FK_dxPeriod )
  left join dxCurrencyDetail cd on ( cd.FK_dxPeriod =  gl.FK_dxPeriod) and ( ac.FK_dxCurrency = cd.FK_dxCurrency)
  -- Récupérer le compte du taux de change
  left outer join inserted gf on (gf.FK_dxAccount = ac.FK_dxAccount__ForeignExchangeReference) and (gf.FK_dxPeriod =  gl.FK_dxPeriod)
  left outer join dxAccountConfiguration co on ( PK_dxAccountConfiguration =1)
  Where pe.PK_dxPeriod = gl.FK_dxPeriod
    and Abs(gl.Amount) > 0.001
    and (not ac.FK_dxAccount__ForeignExchangeReference is null)
    -- Exclusion des comptes de bilan non réévalués
    and (not( ac.FK_dxAccountType = 1 and ac.RevaluationOfBalanceSheetAccount = 0 ))
    and gl.EndOfYearTransaction = 0
    and  Abs(Round(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2),2)) > 0.001

  -- ----------------------------------------------------------------------------------------------------
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodTransaction,KindOfDocument,PrimaryKeyValue,CurrencyRate )
  Select
         gl.FK_dxEntry, gl.TransactionDate , 60 , gl.FK_dxPeriod
       , ac.FK_dxAccount__ForeignExchangeReference
       , convert ( varchar(100), gl.Description )
       , Round(case when
                gl.Amount - Round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2) < -0.001 then
            Abs(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2)) else 0.0 end,2)
       , Round(case when
                gl.Amount - Round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2) > 0.001 then
            Abs(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2)) else 0.0 end,2)
       ,co.FK_dxCurrency__System  ,0 ,gl.KindOfDocument , gl.PrimaryKeyValue
       ,case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end

  From inserted gl
  left join dxAccount ac on ( ac.PK_dxAccount =  gl.FK_dxAccount )
  left join dxPeriod  pe on ( pe.PK_dxPeriod  =  gl.FK_dxPeriod )
  left  join dxCurrencyDetail cd on ( cd.FK_dxPeriod =  gl.FK_dxPeriod) and ( ac.FK_dxCurrency = cd.FK_dxCurrency)
  -- Récupérer le compte du taux de change
  left outer join inserted gf on (gf.FK_dxAccount = ac.FK_dxAccount__ForeignExchangeReference) and (gf.FK_dxPeriod =  gl.FK_dxPeriod)
  left outer join dxAccountConfiguration co on ( PK_dxAccountConfiguration =1)
  Where pe.PK_dxPeriod = gl.FK_dxPeriod
    and Abs(gl.Amount) > 0.001
    and (not ac.FK_dxAccount__ForeignExchangeReference is null)
    -- Exclusion des comptes de bilan non réévalués
    and (not( ac.FK_dxAccountType = 1 and ac.RevaluationOfBalanceSheetAccount = 0 ))
    and gl.EndOfYearTransaction = 0
    and  Abs(Round(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2),2)) > 0.001

  SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountTransaction.trLogUnpostTransaction] ON [dbo].[dxAccountTransaction]
FOR DELETE
AS
BEGIN
     Insert into dxAccountPeriodToUpdate (FK_dxEntry,FK_dxAccount,FK_dxPeriod)
     Select Distinct FK_dxEntry,FK_dxAccount,FK_dxPeriod from Deleted

     -- Insert (+) leg
     INSERT INTO [dbo].[dxUnpostAccountTransaction]
           ([Key_dxEntry]
           ,[KEY_dxJournal]
           ,[KEY_dxPeriod]
           ,[TransactionDate]
           ,[KEY_dxAccount]
           ,[CT]
           ,[DT]
           ,[KEY_dxCurrency]
           ,[Description]
           ,[EndOfPeriodInventory]
           ,[EndOfPeriodTransaction]
           ,[EndOfYearTransaction]
           ,[KindOfDocument]
           ,[PrimaryKeyValue]
           ,[KEY_dxJournalEntryDetail]
           ,[KEY_dxPayableInvoiceDetail]
           ,[KEY_dxInvoiceDetail]
           ,[KEY_dxPayment]
           ,[KEY_dxCashReceipt]
           ,[KEY_dxBankReconciliationDetail])

     SELECT
            [FK_dxEntry]
           ,[FK_dxJournal]
           ,[FK_dxPeriod]
           ,[TransactionDate]
           ,[FK_dxAccount]
           ,[CT]
           ,[DT]
           ,[FK_dxCurrency]
           ,[Description]
           ,[EndOfPeriodInventory]
           ,[EndOfPeriodTransaction]
           ,[EndOfYearTransaction]
           ,[KindOfDocument]
           ,[PrimaryKeyValue]
           ,[FK_dxJournalEntryDetail]
           ,[FK_dxPayableInvoiceDetail]
           ,[FK_dxInvoiceDetail]
           ,[FK_dxPayment]
           ,[FK_dxCashReceipt]
           ,[FK_dxBankReconciliationDetail]
     from deleted where FK_dxJournal <> 60 -- Exclude Currency Transaction

     -- Insert (-) leg
     INSERT INTO [dbo].[dxUnpostAccountTransaction]
           ([Key_dxEntry]
           ,[KEY_dxJournal]
           ,[KEY_dxPeriod]
           ,[TransactionDate]
           ,[KEY_dxAccount]
           ,[CT]
           ,[DT]
           ,[KEY_dxCurrency]
           ,[Description]
           ,[EndOfPeriodInventory]
           ,[EndOfPeriodTransaction]
           ,[EndOfYearTransaction]
           ,[KindOfDocument]
           ,[PrimaryKeyValue]
           ,[KEY_dxJournalEntryDetail]
           ,[KEY_dxPayableInvoiceDetail]
           ,[KEY_dxInvoiceDetail]
           ,[KEY_dxPayment]
           ,[KEY_dxCashReceipt]
           ,[KEY_dxBankReconciliationDetail])

     SELECT
            [FK_dxEntry]
           ,[FK_dxJournal]
           ,[FK_dxPeriod]
           ,[TransactionDate]
           ,[FK_dxAccount]
           ,[DT]
           ,[CT]
           ,[FK_dxCurrency]
           ,[Description]
           ,[EndOfPeriodInventory]
           ,[EndOfPeriodTransaction]
           ,[EndOfYearTransaction]
           ,[KindOfDocument]
           ,[PrimaryKeyValue]
           ,[FK_dxJournalEntryDetail]
           ,[FK_dxPayableInvoiceDetail]
           ,[FK_dxInvoiceDetail]
           ,[FK_dxPayment]
           ,[FK_dxCashReceipt]
           ,[FK_dxBankReconciliationDetail]
     from deleted where FK_dxJournal <> 60 -- Exclude Currency Transaction
END
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [PK_dxAccountTransaction] PRIMARY KEY CLUSTERED  ([PK_dxAccountTransaction]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxAccountTransactionEndOfYearTransaction] ON [dbo].[dxAccountTransaction] ([EndOfYearTransaction]) INCLUDE ([FK_dxPeriod], [FK_dxAccount], [Amount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxAccount] ON [dbo].[dxAccountTransaction] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxAccountTransactionAccountPeriod] ON [dbo].[dxAccountTransaction] ([FK_dxAccount], [FK_dxPeriod]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxAccrualPayableCorrection] ON [dbo].[dxAccountTransaction] ([FK_dxAccrualPayableCorrection]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxBankReconciliationDetail] ON [dbo].[dxAccountTransaction] ([FK_dxBankReconciliationDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxCashReceipt] ON [dbo].[dxAccountTransaction] ([FK_dxCashReceipt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxCurrency] ON [dbo].[dxAccountTransaction] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxEntry] ON [dbo].[dxAccountTransaction] ([FK_dxEntry]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxInvoiceDetail] ON [dbo].[dxAccountTransaction] ([FK_dxInvoiceDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxJournal] ON [dbo].[dxAccountTransaction] ([FK_dxJournal]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxJournalEntryDetail] ON [dbo].[dxAccountTransaction] ([FK_dxJournalEntryDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxPayableInvoiceDetail] ON [dbo].[dxAccountTransaction] ([FK_dxPayableInvoiceDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxPayment] ON [dbo].[dxAccountTransaction] ([FK_dxPayment]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountTransaction_FK_dxPeriod] ON [dbo].[dxAccountTransaction] ([FK_dxPeriod]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxAccountTransactionReception] ON [dbo].[dxAccountTransaction] ([KEY_dxReceptionDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxAccountTransactionRMA] ON [dbo].[dxAccountTransaction] ([KEY_dxRMADetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxAccountTransactionShipping] ON [dbo].[dxAccountTransaction] ([KEY_dxShippingDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxAccountTransaction] ON [dbo].[dxAccountTransaction] ([TransactionDate], [KindOfDocument]) INCLUDE ([PK_dxAccountTransaction]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxAccountTransaction] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxAccrualPayableCorrection_dxAccountTransaction] FOREIGN KEY ([FK_dxAccrualPayableCorrection]) REFERENCES [dbo].[dxAccrualPayableCorrection] ([PK_dxAccrualPayableCorrection])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxBankReconciliationDetail_dxAccountTransaction] FOREIGN KEY ([FK_dxBankReconciliationDetail]) REFERENCES [dbo].[dxBankReconciliationDetail] ([PK_dxBankReconciliationDetail])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxCashReceipt_dxAccountTransaction] FOREIGN KEY ([FK_dxCashReceipt]) REFERENCES [dbo].[dxCashReceipt] ([PK_dxCashReceipt])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxAccountTransaction] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxEntry_dxAccountTransaction] FOREIGN KEY ([FK_dxEntry]) REFERENCES [dbo].[dxEntry] ([PK_dxEntry])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxInvoiceDetail_dxAccountTransaction] FOREIGN KEY ([FK_dxInvoiceDetail]) REFERENCES [dbo].[dxInvoiceDetail] ([PK_dxInvoiceDetail])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxJournal_dxAccountTransaction] FOREIGN KEY ([FK_dxJournal]) REFERENCES [dbo].[dxJournal] ([PK_dxJournal])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxJournalEntryDetail_dxAccountTransaction] FOREIGN KEY ([FK_dxJournalEntryDetail]) REFERENCES [dbo].[dxJournalEntryDetail] ([PK_dxJournalEntryDetail])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxPayableInvoiceDetail_dxAccountTransaction] FOREIGN KEY ([FK_dxPayableInvoiceDetail]) REFERENCES [dbo].[dxPayableInvoiceDetail] ([PK_dxPayableInvoiceDetail])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxPayment_dxAccountTransaction] FOREIGN KEY ([FK_dxPayment]) REFERENCES [dbo].[dxPayment] ([PK_dxPayment])
GO
ALTER TABLE [dbo].[dxAccountTransaction] ADD CONSTRAINT [dxConstraint_FK_dxPeriod_dxAccountTransaction] FOREIGN KEY ([FK_dxPeriod]) REFERENCES [dbo].[dxPeriod] ([PK_dxPeriod])
GO
