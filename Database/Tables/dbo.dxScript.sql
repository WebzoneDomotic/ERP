CREATE TABLE [dbo].[dxScript]
(
[PK_dxScript] [int] NOT NULL IDENTITY(1, 1),
[DBVersion] [int] NULL,
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[Script] [text] COLLATE French_CI_AS NULL,
[LogResult] [text] COLLATE French_CI_AS NULL,
[DateExecuted] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxScript] ADD CONSTRAINT [PK_dxScript] PRIMARY KEY CLUSTERED  ([PK_dxScript]) ON [PRIMARY]
GO
