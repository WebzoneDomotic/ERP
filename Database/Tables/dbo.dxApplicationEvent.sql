CREATE TABLE [dbo].[dxApplicationEvent]
(
[PK_dxApplicationEvent] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxApplicationEvent] ADD CONSTRAINT [PK_dxApplicationEvent] PRIMARY KEY CLUSTERED  ([PK_dxApplicationEvent]) ON [PRIMARY]
GO
