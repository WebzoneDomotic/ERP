CREATE TABLE [dbo].[dxTablePermission]
(
[PK_dxTablePermission] [int] NOT NULL IDENTITY(1, 1),
[FK_dxUserGroup] [int] NOT NULL,
[FK_dxTable] [int] NOT NULL,
[InsertRecord] [bit] NOT NULL CONSTRAINT [DF_dxTableSecurity_InsertRecord] DEFAULT ((0)),
[UpdateRecord] [bit] NOT NULL CONSTRAINT [DF_dxTableSecurity_UpdateRecord] DEFAULT ((0)),
[DeleteRecord] [bit] NOT NULL CONSTRAINT [DF_dxTableSecurity_DeleteRecord] DEFAULT ((0)),
[PrintRecord] [bit] NOT NULL CONSTRAINT [DF_dxTableSecurity_PrintRecord] DEFAULT ((0)),
[HiddenFields] [varchar] (8000) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxTablePermission_HiddenFields] DEFAULT (''),
[SQLFilter] [varchar] (8000) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxTablePermission_SQLFilter] DEFAULT (''),
[SQLWhere] [varchar] (8000) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxTablePermission_SQLWhere] DEFAULT (''),
[ReadonlyFields] [varchar] (8000) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxTablePermission_ReadonlyFields] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxTablePermission] ADD CONSTRAINT [PK_dxTableSecurity] PRIMARY KEY CLUSTERED  ([PK_dxTablePermission]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTablePermission_FK_dxTable] ON [dbo].[dxTablePermission] ([FK_dxTable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTablePermission_FK_dxUserGroup] ON [dbo].[dxTablePermission] ([FK_dxUserGroup]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxTablePermission] ADD CONSTRAINT [dxConstraint_FK_dxTable_dxTablePermission] FOREIGN KEY ([FK_dxTable]) REFERENCES [dbo].[dxTable] ([PK_dxTable])
GO
ALTER TABLE [dbo].[dxTablePermission] ADD CONSTRAINT [dxConstraint_FK_dxUserGroup_dxTablePermission] FOREIGN KEY ([FK_dxUserGroup]) REFERENCES [dbo].[dxUserGroup] ([PK_dxUserGroup])
GO
