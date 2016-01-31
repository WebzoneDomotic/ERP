CREATE TABLE [dbo].[dxControlProperty]
(
[PK_dxControlProperty] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE French_CI_AS NULL,
[OrderPosition] [int] NOT NULL CONSTRAINT [DF_dxControlProperty_OrderPosition] DEFAULT ((0)),
[TopPosition] [int] NOT NULL CONSTRAINT [DF_dxControlProperty_TopPosition] DEFAULT ((0)),
[LeftPosition] [int] NOT NULL CONSTRAINT [DF_dxControlProperty_LeftPosition] DEFAULT ((0)),
[Width] [int] NOT NULL CONSTRAINT [DF_dxControlProperty_Width] DEFAULT ((25)),
[Height] [int] NOT NULL CONSTRAINT [DF_dxControlProperty_Height] DEFAULT ((25)),
[Visible] [bit] NOT NULL CONSTRAINT [DF_dxControlProperty_Visible] DEFAULT ((1)),
[Settings] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxControlProperty] ADD CONSTRAINT [PK_dxControlProperty] PRIMARY KEY CLUSTERED  ([PK_dxControlProperty]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxControlProperty] ON [dbo].[dxControlProperty] ([ID]) ON [PRIMARY]
GO
