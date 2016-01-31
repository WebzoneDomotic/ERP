CREATE TABLE [dbo].[dxBatchPrintingCheque]
(
[PK_BatchPrintingCheque] [int] NOT NULL IDENTITY(1, 1),
[StartingChequeNumber] [int] NOT NULL CONSTRAINT [DF_dxBatchPrintingCheque_StartingChequeNumber] DEFAULT ((0)),
[FK_dxPayment__From] [int] NOT NULL,
[FK_dxPayment__To] [int] NOT NULL,
[FK_dxBankAccount] [int] NOT NULL,
[Printed] [bit] NOT NULL CONSTRAINT [DF_dxBatchPrintingCheque_Printed] DEFAULT ((0)),
[PrintedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxBatchPrintingCheque] ADD CONSTRAINT [PK_dxBatchPrintingCheque] PRIMARY KEY CLUSTERED  ([PK_BatchPrintingCheque]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBatchPrintingCheque_FK_dxBankAccount] ON [dbo].[dxBatchPrintingCheque] ([FK_dxBankAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBatchPrintingCheque_FK_dxPayment__From] ON [dbo].[dxBatchPrintingCheque] ([FK_dxPayment__From]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBatchPrintingCheque_FK_dxPayment__To] ON [dbo].[dxBatchPrintingCheque] ([FK_dxPayment__To]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxBatchPrintingCheque] ADD CONSTRAINT [dxConstraint_FK_dxBankAccount_dxBatchPrintingCheque] FOREIGN KEY ([FK_dxBankAccount]) REFERENCES [dbo].[dxBankAccount] ([PK_dxBankAccount])
GO
ALTER TABLE [dbo].[dxBatchPrintingCheque] ADD CONSTRAINT [dxConstraint_FK_dxPayment__From_dxBatchPrintingCheque] FOREIGN KEY ([FK_dxPayment__From]) REFERENCES [dbo].[dxPayment] ([PK_dxPayment])
GO
ALTER TABLE [dbo].[dxBatchPrintingCheque] ADD CONSTRAINT [dxConstraint_FK_dxPayment__To_dxBatchPrintingCheque] FOREIGN KEY ([FK_dxPayment__To]) REFERENCES [dbo].[dxPayment] ([PK_dxPayment])
GO
