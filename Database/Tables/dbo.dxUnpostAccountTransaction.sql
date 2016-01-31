CREATE TABLE [dbo].[dxUnpostAccountTransaction]
(
[PK_dxUnpostAccountTransaction] [int] NOT NULL IDENTITY(1, 1),
[Key_dxEntry] [int] NOT NULL,
[KEY_dxJournal] [int] NOT NULL,
[KEY_dxPeriod] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[KEY_dxAccount] [int] NOT NULL,
[CT] [float] NOT NULL CONSTRAINT [DF_dxUnpostAccountTransaction_CT] DEFAULT ((0.0)),
[DT] [float] NOT NULL CONSTRAINT [DF_dxUnpostAccountTransaction_DT] DEFAULT ((0.0)),
[KEY_dxCurrency] [int] NOT NULL,
[Description] [varchar] (100) COLLATE French_CI_AS NULL,
[EndOfPeriodInventory] [bit] NOT NULL CONSTRAINT [DF_dxUnpostAccountTransaction_EndOfPeriodInventory] DEFAULT ((0)),
[EndOfPeriodTransaction] [bit] NOT NULL CONSTRAINT [DF_dxUnpostAccountTransaction_EndOfPeriodTransaction] DEFAULT ((0)),
[EndOfYearTransaction] [bit] NOT NULL CONSTRAINT [DF_dxUnpostAccountTransaction_EndOfYearTransaction] DEFAULT ((0)),
[KindOfDocument] [int] NOT NULL,
[PrimaryKeyValue] [int] NOT NULL,
[KEY_dxJournalEntryDetail] [int] NULL,
[KEY_dxPayableInvoiceDetail] [int] NULL,
[KEY_dxInvoiceDetail] [int] NULL,
[KEY_dxPayment] [int] NULL,
[KEY_dxCashReceipt] [int] NULL,
[KEY_dxBankReconciliationDetail] [int] NULL,
[Amount] AS ([DT]-[CT])
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxUnpostAccountTransaction] ADD CONSTRAINT [PK_dxUnpostAccountTransaction] PRIMARY KEY CLUSTERED  ([PK_dxUnpostAccountTransaction]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxUnpostAccountTransactionEntry] ON [dbo].[dxUnpostAccountTransaction] ([Key_dxEntry]) ON [PRIMARY]
GO
