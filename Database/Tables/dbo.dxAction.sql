CREATE TABLE [dbo].[dxAction]
(
[PK_dxAction] [int] NOT NULL IDENTITY(1, 1),
[ActionName] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[NewItem] [bit] NOT NULL CONSTRAINT [DF__dxAction__NewIte__1ED998B2] DEFAULT ((0)),
[Original] [bit] NOT NULL CONSTRAINT [DF__dxAction__Origin__1FCDBCEB] DEFAULT ((0)),
[Image] [image] NULL,
[FK_dxForm] [int] NULL,
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAction] ADD CONSTRAINT [PK_dxAction] PRIMARY KEY NONCLUSTERED  ([PK_dxAction]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxAction] ON [dbo].[dxAction] ([ActionName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAction_FK_dxForm] ON [dbo].[dxAction] ([FK_dxForm]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAction] ADD CONSTRAINT [dxConstraint_FK_dxForm_dxAction] FOREIGN KEY ([FK_dxForm]) REFERENCES [dbo].[dxForm] ([PK_dxForm])
GO
