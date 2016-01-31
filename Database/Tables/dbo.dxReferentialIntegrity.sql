CREATE TABLE [dbo].[dxReferentialIntegrity]
(
[PK_dxReferentialIntegrity] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxReferentialIntegrity]),
[FK_dxAccountType] [int] NULL,
[FK_dxAccount] [int] NULL,
[FK_dxProjectCategory] [int] NULL,
[FK_dxProject] [int] NULL,
[FK_dxScaleUnit] [int] NULL,
[FK_dxCurrency] [int] NULL,
[FK_dxJournal] [int] NULL,
[FK_dxTax] [int] NULL,
[FK_dxUser] [int] NULL,
[FK_dxUserGroup] [int] NULL,
[FK_dxPaymentType] [int] NULL,
[FK_dxReconciliationTransactionType] [int] NULL,
[FK_dxParameter] [int] NULL,
[FK_dxSetup] [int] NULL,
[FK_dxSetupOption] [int] NULL,
[FK_dxWarehouse] [int] NULL,
[FK_dxAccountUsage] [int] NULL,
[FK_dxTerms] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [PK_dxReferentialIntegrity] PRIMARY KEY CLUSTERED  ([PK_dxReferentialIntegrity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxAccount] ON [dbo].[dxReferentialIntegrity] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxAccountType] ON [dbo].[dxReferentialIntegrity] ([FK_dxAccountType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxAccountUsage] ON [dbo].[dxReferentialIntegrity] ([FK_dxAccountUsage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxCurrency] ON [dbo].[dxReferentialIntegrity] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxJournal] ON [dbo].[dxReferentialIntegrity] ([FK_dxJournal]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxParameter] ON [dbo].[dxReferentialIntegrity] ([FK_dxParameter]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxPaymentType] ON [dbo].[dxReferentialIntegrity] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxProject] ON [dbo].[dxReferentialIntegrity] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxProjectCategory] ON [dbo].[dxReferentialIntegrity] ([FK_dxProjectCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxReconciliationTransactionType] ON [dbo].[dxReferentialIntegrity] ([FK_dxReconciliationTransactionType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxScaleUnit] ON [dbo].[dxReferentialIntegrity] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxSetup] ON [dbo].[dxReferentialIntegrity] ([FK_dxSetup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxSetupOption] ON [dbo].[dxReferentialIntegrity] ([FK_dxSetupOption]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxTax] ON [dbo].[dxReferentialIntegrity] ([FK_dxTax]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxTerms] ON [dbo].[dxReferentialIntegrity] ([FK_dxTerms]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxUser] ON [dbo].[dxReferentialIntegrity] ([FK_dxUser]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxUserGroup] ON [dbo].[dxReferentialIntegrity] ([FK_dxUserGroup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReferentialIntegrity_FK_dxWarehouse] ON [dbo].[dxReferentialIntegrity] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxReferentialIntegrity] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxAccountType_dxReferentialIntegrity] FOREIGN KEY ([FK_dxAccountType]) REFERENCES [dbo].[dxAccountType] ([PK_dxAccountType])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxAccountUsage_dxReferentialIntegrity] FOREIGN KEY ([FK_dxAccountUsage]) REFERENCES [dbo].[dxAccountUsage] ([PK_dxAccountUsage])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxReferentialIntegrity] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxJournal_dxReferentialIntegrity] FOREIGN KEY ([FK_dxJournal]) REFERENCES [dbo].[dxJournal] ([PK_dxJournal])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxParameter_dxReferentialIntegrity] FOREIGN KEY ([FK_dxParameter]) REFERENCES [dbo].[dxParameter] ([PK_dxParameter])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxReferentialIntegrity] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxReferentialIntegrity] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxProjectCategory_dxReferentialIntegrity] FOREIGN KEY ([FK_dxProjectCategory]) REFERENCES [dbo].[dxProjectCategory] ([PK_dxProjectCategory])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxReconciliationTransactionType_dxReferentialIntegrity] FOREIGN KEY ([FK_dxReconciliationTransactionType]) REFERENCES [dbo].[dxReconciliationTransactionType] ([PK_dxReconciliationTransactionType])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxReferentialIntegrity] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxSetup_dxReferentialIntegrity] FOREIGN KEY ([FK_dxSetup]) REFERENCES [dbo].[dxSetup] ([PK_dxSetup])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxSetupOption_dxReferentialIntegrity] FOREIGN KEY ([FK_dxSetupOption]) REFERENCES [dbo].[dxSetupOption] ([PK_dxSetupOption])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxReferentialIntegrity] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxTerms_dxReferentialIntegrity] FOREIGN KEY ([FK_dxTerms]) REFERENCES [dbo].[dxTerms] ([PK_dxTerms])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxUser_dxReferentialIntegrity] FOREIGN KEY ([FK_dxUser]) REFERENCES [dbo].[dxUser] ([PK_dxUser])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxUserGroup_dxReferentialIntegrity] FOREIGN KEY ([FK_dxUserGroup]) REFERENCES [dbo].[dxUserGroup] ([PK_dxUserGroup])
GO
ALTER TABLE [dbo].[dxReferentialIntegrity] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxReferentialIntegrity] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
