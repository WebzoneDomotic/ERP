CREATE TABLE [dbo].[dxComponent]
(
[PK_dxComponent] [int] NOT NULL IDENTITY(1, 1),
[ComponentName] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[NewItem] [bit] NOT NULL CONSTRAINT [DF__dxCompone__NewIt__76619304] DEFAULT ((0)),
[Original] [bit] NOT NULL CONSTRAINT [DF__dxCompone__Origi__7755B73D] DEFAULT ((0)),
[Image] [image] NULL,
[FK_dxForm] [int] NULL,
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxComponent] ADD CONSTRAINT [PK_dxComponent] PRIMARY KEY NONCLUSTERED  ([PK_dxComponent]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxComponent] ON [dbo].[dxComponent] ([ComponentName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxComponent_FK_dxForm] ON [dbo].[dxComponent] ([FK_dxForm]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxComponent] ADD CONSTRAINT [dxConstraint_FK_dxForm_dxComponent] FOREIGN KEY ([FK_dxForm]) REFERENCES [dbo].[dxForm] ([PK_dxForm])
GO
