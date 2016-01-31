CREATE TABLE [dbo].[dxDeclarationConsumption]
(
[PK_dxDeclarationConsumption] [int] NOT NULL IDENTITY(1, 1),
[FK_dxDeclaration] [int] NOT NULL,
[FK_dxWarehouse] [int] NOT NULL CONSTRAINT [DF_dxDeclarationConsumption_FK_dxWarehouse] DEFAULT ((1)),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxDeclarationConsumption_FK_dxLocation] DEFAULT ((1)),
[FK_dxProduct] [int] NOT NULL CONSTRAINT [DF_dxDeclarationConsumption_FK_dxProduct] DEFAULT ((1)),
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxDeclarationConsumption_Lot] DEFAULT ('0'),
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxDeclarationConsumption_Quantitty] DEFAULT ((0.0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxDeclarationConsumption_Posted] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create TRIGGER [dbo].[dxDeclarationConsumption.trDeclared] ON [dbo].[dxDeclarationConsumption]
FOR INSERT, UPDATE
AS
  --Change work order status
  if Update(Posted)
    update dxWorkOrder set WorkOrderStatus = 2
     where PK_dxWorkOrder in ( Select FK_dxWorkOrder from dxDeclaration
                              where PK_dxDeclaration in ( Select FK_dxDeclaration From inserted ))
       and WorkOrderStatus <= 1
GO
ALTER TABLE [dbo].[dxDeclarationConsumption] ADD CONSTRAINT [PK_dxDeclarationConsumption] PRIMARY KEY CLUSTERED  ([PK_dxDeclarationConsumption]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationConsumption_FK_dxDeclaration] ON [dbo].[dxDeclarationConsumption] ([FK_dxDeclaration]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationConsumption_FK_dxLocation] ON [dbo].[dxDeclarationConsumption] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationConsumption_FK_dxProduct] ON [dbo].[dxDeclarationConsumption] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationConsumption_FK_dxWarehouse] ON [dbo].[dxDeclarationConsumption] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDeclarationConsumption] ADD CONSTRAINT [dxConstraint_FK_dxDeclaration_dxDeclarationConsumption] FOREIGN KEY ([FK_dxDeclaration]) REFERENCES [dbo].[dxDeclaration] ([PK_dxDeclaration])
GO
ALTER TABLE [dbo].[dxDeclarationConsumption] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxDeclarationConsumption] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxDeclarationConsumption] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxDeclarationConsumption] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxDeclarationConsumption] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxDeclarationConsumption] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
