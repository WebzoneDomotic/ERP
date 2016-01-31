CREATE TABLE [dbo].[dxParameter]
(
[PK_dxParameter] [int] NOT NULL IDENTITY(1, 1),
[ADate] [datetime] NULL,
[APeriod] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxParameter] ADD CONSTRAINT [PK_dxParameter] PRIMARY KEY CLUSTERED  ([PK_dxParameter]) ON [PRIMARY]
GO
