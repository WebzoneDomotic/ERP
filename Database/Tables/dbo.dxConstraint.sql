CREATE TABLE [dbo].[dxConstraint]
(
[PK_dxConstraint] [int] NOT NULL IDENTITY(1, 1),
[TableName] [char] (50) COLLATE French_CI_AS NOT NULL,
[FKFieldName] [char] (50) COLLATE French_CI_AS NOT NULL,
[FieldConstraint] [varchar] (255) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxConstraint] ADD CONSTRAINT [PK_dxConstraint] PRIMARY KEY CLUSTERED  ([PK_dxConstraint]) ON [PRIMARY]
GO
