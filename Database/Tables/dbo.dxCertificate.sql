CREATE TABLE [dbo].[dxCertificate]
(
[PK_dxCertificate] [int] NOT NULL IDENTITY(1, 1),
[ObjectType] [int] NOT NULL,
[ObjectName] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[PrimaryKey] [int] NOT NULL,
[FK_dxUser__DeliveredTo] [int] NOT NULL,
[DeliveredOn] [datetime] NOT NULL CONSTRAINT [DF__dxCertifi__Deliv__04E4BC85] DEFAULT (getdate()),
[ValidUntil] [datetime] NOT NULL CONSTRAINT [DF__dxCertifi__Valid__05D8E0BE] DEFAULT (dateadd(minute,(5),getdate())),
[IsExclusive] [bit] NOT NULL CONSTRAINT [DF__dxCertifi__IsExc__06CD04F7] DEFAULT ((1)),
[SystemUser] [varchar] (255) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF__dxCertifi__Syste__07C12930] DEFAULT (suser_sname()),
[ApplicationHandle] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCertificate] ADD CONSTRAINT [PK_dxCertificate] PRIMARY KEY CLUSTERED  ([PK_dxCertificate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCertificate_FK_dxUser__DeliveredTo] ON [dbo].[dxCertificate] ([FK_dxUser__DeliveredTo]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxCertificate] ON [dbo].[dxCertificate] ([ObjectType], [ObjectName], [PrimaryKey]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCertificate] ADD CONSTRAINT [dxConstraint_FK_dxUser__DeliveredTo_dxCertificate] FOREIGN KEY ([FK_dxUser__DeliveredTo]) REFERENCES [dbo].[dxUser] ([PK_dxUser])
GO
