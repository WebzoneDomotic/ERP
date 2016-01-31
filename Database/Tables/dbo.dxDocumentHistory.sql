CREATE TABLE [dbo].[dxDocumentHistory]
(
[PK_dxDocumentHistory] [int] NOT NULL IDENTITY(1, 1),
[FK_dxApplicationEvent] [int] NOT NULL CONSTRAINT [DF_dxDocumentHistory_ActionType] DEFAULT ((0)),
[FK_dxUser] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL CONSTRAINT [DF_dxDocumentHistory_TransactionDate] DEFAULT (getdate()),
[TableName] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxDocumentHistory_TableName] DEFAULT ('Not defined'),
[PrimaryKeyValue] [int] NULL CONSTRAINT [DF_dxDocumentHistory_PrimaryKeyValue] DEFAULT ((0)),
[ErrorMessage] [varchar] (500) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDocumentHistory] ADD CONSTRAINT [PK_dxDocumentHistory] PRIMARY KEY CLUSTERED  ([PK_dxDocumentHistory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDocumentHistory_FK_dxApplicationEvent] ON [dbo].[dxDocumentHistory] ([FK_dxApplicationEvent]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDocumentHistory_FK_dxUser] ON [dbo].[dxDocumentHistory] ([FK_dxUser]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxDocumentHistory] ON [dbo].[dxDocumentHistory] ([TransactionDate], [FK_dxUser], [FK_dxApplicationEvent]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDocumentHistory] ADD CONSTRAINT [dxConstraint_FK_dxApplicationEvent_dxDocumentHistory] FOREIGN KEY ([FK_dxApplicationEvent]) REFERENCES [dbo].[dxApplicationEvent] ([PK_dxApplicationEvent])
GO
ALTER TABLE [dbo].[dxDocumentHistory] ADD CONSTRAINT [dxConstraint_FK_dxUser_dxDocumentHistory] FOREIGN KEY ([FK_dxUser]) REFERENCES [dbo].[dxUser] ([PK_dxUser])
GO
