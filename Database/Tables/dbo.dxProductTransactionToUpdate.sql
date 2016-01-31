CREATE TABLE [dbo].[dxProductTransactionToUpdate]
(
[FK_dxProductTransaction] [int] NOT NULL,
[KindOfDocument] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransactionToUpdate_FK_dxProductTransaction] ON [dbo].[dxProductTransactionToUpdate] ([FK_dxProductTransaction]) ON [PRIMARY]
GO
