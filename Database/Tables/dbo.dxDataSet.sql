CREATE TABLE [dbo].[dxDataSet]
(
[PK_dxDataSet] [int] NOT NULL IDENTITY(1, 1),
[TableName] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[NewItem] [bit] NOT NULL CONSTRAINT [DF__dxDataSet__NewIt__2334397B] DEFAULT ((0)),
[Original] [bit] NOT NULL CONSTRAINT [DF__dxDataSet__Origi__24285DB4] DEFAULT ((0)),
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDataSet] ADD CONSTRAINT [PK_dxDataSet] PRIMARY KEY NONCLUSTERED  ([PK_dxDataSet]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxDataSet] ON [dbo].[dxDataSet] ([TableName]) ON [PRIMARY]
GO
