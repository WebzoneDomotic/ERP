CREATE TABLE [dbo].[dxWarehouse]
(
[PK_dxWarehouse] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NULL,
[Name] [varchar] (255) COLLATE French_CI_AS NULL,
[TotalAmount] [float] NULL CONSTRAINT [DF_dxWarehouse_TotalAmount] DEFAULT ((0)),
[ExternalWarehouse] [bit] NULL CONSTRAINT [DF_dxWarehouse_ExternalWarehouse] DEFAULT ((0)),
[Quarantine] [bit] NOT NULL CONSTRAINT [DF_dxWarehouse_Quarantine] DEFAULT ((0)),
[FK_dxAccount__Material] [int] NULL,
[FK_dxAccount__Labor] [int] NULL,
[FK_dxAccount__OverheadFixed] [int] NULL,
[FK_dxAccount__OverheadVariable] [int] NULL,
[FK_dxInventoryGroup] [int] NULL,
[InventoryIsClosed] [bit] NOT NULL CONSTRAINT [DF_dxWarehouse_InventoryIsClosed] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxWarehouse] ADD CONSTRAINT [PK_dxWarehouse] PRIMARY KEY CLUSTERED  ([PK_dxWarehouse]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWarehouse_FK_dxAccount__Labor] ON [dbo].[dxWarehouse] ([FK_dxAccount__Labor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWarehouse_FK_dxAccount__Material] ON [dbo].[dxWarehouse] ([FK_dxAccount__Material]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWarehouse_FK_dxAccount__OverheadFixed] ON [dbo].[dxWarehouse] ([FK_dxAccount__OverheadFixed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWarehouse_FK_dxAccount__OverheadVariable] ON [dbo].[dxWarehouse] ([FK_dxAccount__OverheadVariable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWarehouse_FK_dxInventoryGroup] ON [dbo].[dxWarehouse] ([FK_dxInventoryGroup]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxWarehouse] ON [dbo].[dxWarehouse] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxWarehouse] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Labor_dxWarehouse] FOREIGN KEY ([FK_dxAccount__Labor]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxWarehouse] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Material_dxWarehouse] FOREIGN KEY ([FK_dxAccount__Material]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxWarehouse] ADD CONSTRAINT [dxConstraint_FK_dxAccount__OverheadFixed_dxWarehouse] FOREIGN KEY ([FK_dxAccount__OverheadFixed]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxWarehouse] ADD CONSTRAINT [dxConstraint_FK_dxAccount__OverheadVariable_dxWarehouse] FOREIGN KEY ([FK_dxAccount__OverheadVariable]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxWarehouse] ADD CONSTRAINT [dxConstraint_FK_dxInventoryGroup_dxWarehouse] FOREIGN KEY ([FK_dxInventoryGroup]) REFERENCES [dbo].[dxInventoryGroup] ([PK_dxInventoryGroup])
GO
