CREATE TABLE [dbo].[dxForm]
(
[PK_dxForm] [int] NOT NULL IDENTITY(1, 1),
[FormName] [nvarchar] (255) COLLATE French_CI_AS NULL,
[ClassName] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[NewItem] [bit] NOT NULL CONSTRAINT [DF__dxForm__NewItem__084B3915] DEFAULT ((0)),
[Original] [bit] NOT NULL CONSTRAINT [DF__dxForm__Original__093F5D4E] DEFAULT ((0)),
[Image] [image] NULL,
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxForm] ADD CONSTRAINT [PK_dxForm] PRIMARY KEY NONCLUSTERED  ([PK_dxForm]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxForm] ON [dbo].[dxForm] ([FormName]) ON [PRIMARY]
GO
