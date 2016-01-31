CREATE TABLE [dbo].[dxMessage]
(
[PK_dxMessage] [int] NOT NULL IDENTITY(1, 1),
[MessageName] [varchar] (255) COLLATE French_CI_AS NULL,
[MessageType] [int] NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[NewItem] [bit] NOT NULL CONSTRAINT [DF__dxMessage__NewIt__10AB74EC] DEFAULT ((0)),
[Original] [bit] NOT NULL CONSTRAINT [DF__dxMessage__Origi__119F9925] DEFAULT ((0)),
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxMessage] ADD CONSTRAINT [PK_dxMessage] PRIMARY KEY NONCLUSTERED  ([PK_dxMessage]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxMessage] ON [dbo].[dxMessage] ([MessageName]) ON [PRIMARY]
GO
