CREATE TABLE [dbo].[dxUserGroupMember]
(
[PK_dxUserGroupMember] [int] NOT NULL IDENTITY(1, 1),
[FK_dxUser] [int] NOT NULL,
[FK_dxUserGroup] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxUserGroupMember] ADD CONSTRAINT [PK_dxUserGroupMember] PRIMARY KEY CLUSTERED  ([PK_dxUserGroupMember]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxUserGroupMember_FK_dxUser] ON [dbo].[dxUserGroupMember] ([FK_dxUser]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxUserGroupMember_FK_dxUserGroup] ON [dbo].[dxUserGroupMember] ([FK_dxUserGroup]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxUserGroupMember] ADD CONSTRAINT [dxConstraint_FK_dxUser_dxUserGroupMember] FOREIGN KEY ([FK_dxUser]) REFERENCES [dbo].[dxUser] ([PK_dxUser])
GO
ALTER TABLE [dbo].[dxUserGroupMember] ADD CONSTRAINT [dxConstraint_FK_dxUserGroup_dxUserGroupMember] FOREIGN KEY ([FK_dxUserGroup]) REFERENCES [dbo].[dxUserGroup] ([PK_dxUserGroup])
GO
