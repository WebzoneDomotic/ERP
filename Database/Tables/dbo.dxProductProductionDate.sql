CREATE TABLE [dbo].[dxProductProductionDate]
(
[PK_dxProductProductionDate] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProduct] [int] NOT NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxProductManagementDate_Lot] DEFAULT ('0'),
[ProductionDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductProductionDate] ADD CONSTRAINT [PK_dxProductProductionDate] PRIMARY KEY CLUSTERED  ([PK_dxProductProductionDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductProductionDate_FK_dxProduct] ON [dbo].[dxProductProductionDate] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxProductManagementDate] ON [dbo].[dxProductProductionDate] ([FK_dxProduct], [Lot]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductProductionDate] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxProductProductionDate] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
