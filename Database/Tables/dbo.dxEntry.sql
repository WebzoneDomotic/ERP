CREATE TABLE [dbo].[dxEntry]
(
[PK_dxEntry] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxEntry]),
[TransactionDate] AS (getdate()),
[KindOfDocument] [int] NOT NULL,
[PrimaryKeyValue] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxEntry] ADD CONSTRAINT [PK_dxEntry] PRIMARY KEY CLUSTERED  ([PK_dxEntry]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxEntry] ON [dbo].[dxEntry] ([KindOfDocument], [PrimaryKeyValue]) ON [PRIMARY]
GO
