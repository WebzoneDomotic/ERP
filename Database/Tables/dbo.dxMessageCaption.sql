CREATE TABLE [dbo].[dxMessageCaption]
(
[PK_dxMessageCaption] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (255) COLLATE French_CI_AS NULL,
[ObjectType] [varchar] (50) COLLATE French_CI_AS NULL,
[EnglishCaption] [varchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [varchar] (2000) COLLATE French_CI_AS NULL,
[FrenchCaption] [varchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [varchar] (2000) COLLATE French_CI_AS NULL,
[SpanishCaption] [varchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [varchar] (2000) COLLATE French_CI_AS NULL,
[DoNotUpdate] [bit] NOT NULL CONSTRAINT [DF_dxMessageCaption_DoNotUpdate] DEFAULT ((0)),
[NewItem] [bit] NOT NULL CONSTRAINT [DF_dxMessageCaption_NewItem] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxMessageCaption] ADD CONSTRAINT [PK_dxMessageCaption] PRIMARY KEY CLUSTERED  ([PK_dxMessageCaption]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxMessageCaptionID] ON [dbo].[dxMessageCaption] ([ID]) ON [PRIMARY]
GO
