CREATE TABLE [dbo].[dxDataAuditDetail]
(
[PK_dxDataAuditDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxDataAudit] [int] NOT NULL,
[FieldName] [varchar] (50) COLLATE French_CI_AS NULL,
[ValueAsInteger] [int] NULL,
[ValueAsString] [varchar] (8000) COLLATE French_CI_AS NULL,
[ValueAsBoolean] [bit] NULL,
[ValueAsFloat] [float] NULL,
[ValueAsDate] [datetime] NULL,
[ValueAsMemo] [text] COLLATE French_CI_AS NULL,
[ValueAsBlob] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDataAuditDetail] ADD CONSTRAINT [PK_dxDataAuditDetail] PRIMARY KEY CLUSTERED  ([PK_dxDataAuditDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDataAuditDetail_FK_dxDataAudit] ON [dbo].[dxDataAuditDetail] ([FK_dxDataAudit]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDataAuditDetail] ADD CONSTRAINT [dxConstraint_FK_dxDataAudit_dxDataAuditDetail] FOREIGN KEY ([FK_dxDataAudit]) REFERENCES [dbo].[dxDataAudit] ([PK_dxDataAudit])
GO
