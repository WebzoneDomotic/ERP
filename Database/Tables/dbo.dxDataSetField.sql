CREATE TABLE [dbo].[dxDataSetField]
(
[PK_dxDataSetField] [int] NOT NULL IDENTITY(1, 1),
[ColumnName] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FK_dxDataSet] [int] NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[NewItem] [bit] NOT NULL CONSTRAINT [DF__dxDataSet__NewIt__2704CA5F] DEFAULT ((0)),
[Original] [bit] NOT NULL CONSTRAINT [DF__dxDataSet__Origi__27F8EE98] DEFAULT ((0)),
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDataSetField] ADD CONSTRAINT [PK_dxDataSetField] PRIMARY KEY NONCLUSTERED  ([PK_dxDataSetField]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDataSetField_FK_dxDataSet] ON [dbo].[dxDataSetField] ([FK_dxDataSet]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxDataSetField] ON [dbo].[dxDataSetField] ([FK_dxDataSet], [ColumnName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDataSetField] ADD CONSTRAINT [dxConstraint_FK_dxDataSet_dxDataSetField] FOREIGN KEY ([FK_dxDataSet]) REFERENCES [dbo].[dxDataSet] ([PK_dxDataSet])
GO
