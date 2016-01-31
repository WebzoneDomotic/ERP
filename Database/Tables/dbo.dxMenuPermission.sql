CREATE TABLE [dbo].[dxMenuPermission]
(
[PK_dxMenuPermission] [int] NOT NULL IDENTITY(1, 1),
[FK_dxUserGroup] [int] NOT NULL,
[MenuName] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[MenuCaption] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Visible] [bit] NOT NULL CONSTRAINT [DF_dxMenuPrmission_Visible] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxMenuPermission] ADD CONSTRAINT [PK_dxMenuPrmission] PRIMARY KEY CLUSTERED  ([PK_dxMenuPermission]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxMenuPermission_FK_dxUserGroup] ON [dbo].[dxMenuPermission] ([FK_dxUserGroup]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxMenuPermission] ADD CONSTRAINT [dxConstraint_FK_dxUserGroup_dxMenuPermission] FOREIGN KEY ([FK_dxUserGroup]) REFERENCES [dbo].[dxUserGroup] ([PK_dxUserGroup])
GO
