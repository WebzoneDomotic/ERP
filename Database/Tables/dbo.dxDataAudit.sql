CREATE TABLE [dbo].[dxDataAudit]
(
[PK_dxDataAudit] [int] NOT NULL IDENTITY(1, 1),
[AuditType] [char] (1) COLLATE French_CI_AS NOT NULL,
[PrimaryKeyValue] [int] NULL,
[TableName] [varchar] (50) COLLATE French_CI_AS NULL,
[AuditDate] [datetime] NOT NULL,
[UserName] [varchar] (100) COLLATE French_CI_AS NULL,
[FK_dxUser] [varchar] (128) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDataAudit] ADD CONSTRAINT [PK_dxDataAudit] PRIMARY KEY CLUSTERED  ([PK_dxDataAudit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_AuditDate] ON [dbo].[dxDataAudit] ([AuditDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDataAudit_FK_dxUser] ON [dbo].[dxDataAudit] ([FK_dxUser]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxDataAudit] ON [dbo].[dxDataAudit] ([TableName], [PrimaryKeyValue]) ON [PRIMARY]
GO
