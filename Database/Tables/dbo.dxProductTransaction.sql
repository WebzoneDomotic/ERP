CREATE TABLE [dbo].[dxProductTransaction]
(
[PK_dxProductTransaction] [int] NOT NULL IDENTITY(1, 1),
[TransactionType] [int] NOT NULL CONSTRAINT [DF_dxProductTransaction_TransactionType] DEFAULT ((0)),
[FK_dxWarehouse] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL CONSTRAINT [DF_dxProductTransaction_TransactionDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxProductTransaction_Lot] DEFAULT ('0'),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxProductTransaction_FK_dxLocation] DEFAULT ((1)),
[Dimension] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_Dimension] DEFAULT ((0.0)),
[Description] [varchar] (255) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxProductTransaction_Description] DEFAULT (''),
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_Quantity] DEFAULT ((0)),
[AmountPerUnit] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_CostPerQuantity] DEFAULT ((0)),
[Amount] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_Cost] DEFAULT ((0)),
[InStockQuantiy] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_InStockQuantiy] DEFAULT ((0)),
[AverageAmountPerUnit] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_AverageCostPerQuantity] DEFAULT ((0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_TotalCost] DEFAULT ((0.0)),
[KindOfDocument] [int] NOT NULL,
[PrimaryKeyValue] [int] NULL,
[Status] [int] NOT NULL CONSTRAINT [DF_dxProductTransaction_Status] DEFAULT ((0)),
[LinkedProductTransaction] [int] NOT NULL CONSTRAINT [DF_dxProductTransaction_LinkedProductTransaction] DEFAULT ((0)),
[FK_dxInventoryAdjustmentDetail] [int] NULL,
[FK_dxReceptionDetail] [int] NULL,
[FK_dxPayableInvoiceDetail] [int] NULL,
[FK_dxDeclaration] [int] NULL,
[FK_dxDeclarationConsumption] [int] NULL,
[FK_dxDeclarationLabor] [int] NULL,
[FK_dxInventoryTransferDetail] [int] NULL,
[FK_dxWorkOrderFinishedProduct] [int] NULL,
[FK_dxClientOrderDetail] [int] NULL,
[FK_dxShippingDetail] [int] NULL,
[FK_dxRMADetail] [int] NULL,
[MaterialCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_MaterialCost] DEFAULT ((0.0)),
[LaborCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_LaborCost] DEFAULT ((0.0)),
[OverheadFixedCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_OverheadFixedCost] DEFAULT ((0.0)),
[OverheadVariableCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_OverheadVariableCost] DEFAULT ((0.0)),
[MaterialCostVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_MaterialCostVariance] DEFAULT ((0.0)),
[LaborCostVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_LaborCostVariance] DEFAULT ((0.0)),
[OverheadFixedCostVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_OverheadFixedCostVariance] DEFAULT ((0.0)),
[OverheadVariableCostVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_OverheadVariableCostVariance] DEFAULT ((0.0)),
[MaterialCostNetVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_MaterialCostNetVariance] DEFAULT ((0.0)),
[LaborCostNetVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_LaborCostNetVariance] DEFAULT ((0.0)),
[OverheadFixedCostNetVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_OverheadFixedCostNetVariance] DEFAULT ((0.0)),
[OverheadVariableCostNetVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_OverheadVariableCostNetVariance] DEFAULT ((0.0)),
[MaterialStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_MaterialStandardCost] DEFAULT ((0.0)),
[LaborStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_LaborStandardCost] DEFAULT ((0.0)),
[OverheadFixedStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_OverheadFixedStandardCost] DEFAULT ((0.0)),
[OverheadVariableStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_OverheadVariableStandardCost] DEFAULT ((0.0)),
[PhaseNumber] [int] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseNumber] DEFAULT ((-1)),
[PriorPhase] [bit] NOT NULL CONSTRAINT [DF_dxProductTransaction_PriorPhase] DEFAULT ((0)),
[FK_dxLocation__PriorPhase] [int] NULL,
[PhaseMaterialStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseMaterialStandardCost] DEFAULT ((0.0)),
[PhaseMaterialStandardCostVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseMaterialStandardCostVariance] DEFAULT ((0.0)),
[PhaseLaborStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseLaborStandardCost] DEFAULT ((0.0)),
[PhaseOverheadFixedStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseOverheadFixedStandardCost] DEFAULT ((0.0)),
[PhaseOverheadVariableStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseOverheadVariableStandardCost] DEFAULT ((0.0)),
[PhaseLaborStandardCostVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseLaborStandardCostVariance] DEFAULT ((0.0)),
[PhaseOverheadFixedStandardCostVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseOverheadFixedStandardCostVariance] DEFAULT ((0.0)),
[PhaseOverheadVariableStandardCostVariance] [float] NOT NULL CONSTRAINT [DF_dxProductTransaction_PhaseOverheadVariableStandardCostVariance] DEFAULT ((0.0)),
[FK_dxDeclarationDismantling] [int] NULL,
[DoNotGenerateAccountEntry] [bit] NOT NULL CONSTRAINT [DF_dxProductTransaction_DoNotGenerateAccountEntry] DEFAULT ((0)),
[DoNotGenerateGLEntry] [bit] NOT NULL CONSTRAINT [DF_dxProductTransaction_DoNotGenerateGLEntry] DEFAULT ((0)),
[FK_dxAccount__CorrectionMaterial] [int] NULL,
[FK_dxAccount__CorrectionLabor] [int] NULL,
[FK_dxAccount__CorrectionOverheadFixed] [int] NULL,
[FK_dxAccount__CorrectionOverheadVariable] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dbo.dxProductTransaction.trValidate] ON [dbo].[dxProductTransaction]
AFTER UPDATE
AS 
BEGIN
  DECLARE @Message VARCHAR(4000)
  -- -------------------------------------
  -- Validation si l'entrepôt permet une entrée ou une  sortie d'inventaire --
  -- -------------------------------------
  SELECT TOP 1 @Message = 'Erreur M.I.P.' + CHAR(13)
                        + 'L''entrepôt est fermé, aucune transaction n''est permise.'
  FROM INSERTED it
  INNER JOIN dbo.dxWarehouse wa ON wa.PK_dxWarehouse = it.FK_dxWarehouse
  WHERE wa.InventoryIsClosed = 1 -- Entrepôt 500 Guindon (Quarantaine)
  
  -- --------------
  -- Traitement de l'erreur --
  -- --------------
  IF LEN(COALESCE(@Message, '')) > 0
  BEGIN
   SET @Message = @Message
   RAISERROR(@Message, 16, 1)
   ROLLBACK TRANSACTION
  END
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Insert Accounting Transaction linked with the inventory
CREATE TRIGGER [dbo].[dxProductTransaction.trDeleteProductTransaction] ON [dbo].[dxProductTransaction]
FOR DELETE
AS
BEGIN
      SET NOCOUNT ON
      -- Update Product Lot
      Insert into dbo.dxProductLot ( FK_dxWarehouse , FK_dxProduct, FK_dxLocation, Lot )
        select distinct FK_dxWarehouse , FK_dxProduct, FK_dxLocation , Lot from Deleted pt
      where ( not exists ( select 1 from dbo.dxProductLot a2
                         where a2.FK_dxWarehouse = pt.FK_dxWarehouse
                           and a2.FK_dxProduct   = pt.FK_dxProduct
                           and a2.FK_dxLocation  = pt.FK_dxLocation
                           and a2.Lot            = pt.Lot ))
      Update pl set
        pl.TotalAmount = ( select Round(coalesce( sum(pt.Amount), 0.0 ),2) from dbo.dxProductTransaction pt
                            where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                              and pt.FK_dxProduct   = pl.FK_dxProduct
                              and pt.FK_dxLocation  = pl.FK_dxLocation
                              and pt.Lot            = pl.Lot  ),
        pl.InStockQuantity = ( select Round(coalesce( sum(Quantity), 0.0 ),6) from dbo.dxProductTransaction pt
                            where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                              and pt.FK_dxProduct   = pl.FK_dxProduct
                              and pt.FK_dxLocation  = pl.FK_dxLocation
                              and pt.Lot            = pl.Lot  )
      From deleted de
      left join dbo.dxProductLot pl on
      (      de.FK_dxWarehouse = pl.FK_dxWarehouse
         and de.FK_dxProduct   = pl.FK_dxProduct
         and de.FK_dxLocation  = pl.FK_dxLocation
         and de.Lot            = pl.Lot )

      ------------------------------------------------------------------------------------
      -- Delete Accounting entry
      Delete from dxAccountTransaction
      where FK_dxEntry in ( Select en.PK_dxEntry from Deleted ie
                              left outer join dxEntry en on (    en.KindOfDocument  = ie.KindOfDocument
                                                             and en.PrimaryKeyValue = ie.PrimaryKeyValue )
                            )
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProductTransaction.trInsProduct] ON [dbo].[dxProductTransaction]
AFTER UPDATE, INSERT
AS
BEGIN
  SET NOCOUNT ON
  -- Update Product Lot
  Insert into dbo.dxProductLot ( FK_dxWarehouse , FK_dxProduct, FK_dxLocation, Lot )
    select distinct FK_dxWarehouse , FK_dxProduct, FK_dxLocation , Lot from inserted pt
  where ( not exists ( select 1 from dbo.dxProductLot a2
                     where a2.FK_dxWarehouse = pt.FK_dxWarehouse
                       and a2.FK_dxProduct   = pt.FK_dxProduct
                       and a2.FK_dxLocation  = pt.FK_dxLocation
                       and a2.Lot           = pt.Lot ))
  Update pl set
    pl.TotalAmount = ( select Round(coalesce( sum(pt.Amount), 0.0 ),2) from dbo.dxProductTransaction pt
                        where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                          and pt.FK_dxProduct   = pl.FK_dxProduct
                          and pt.FK_dxLocation  = pl.FK_dxLocation
                          and pt.Lot            = pl.Lot  ),
    pl.InStockQuantity = ( select Round(coalesce( sum(Quantity), 0.0 ),6) from dbo.dxProductTransaction pt
                        where pt.FK_dxWarehouse = pl.FK_dxWarehouse
                          and pt.FK_dxProduct   = pl.FK_dxProduct
                          and pt.FK_dxLocation  = pl.FK_dxLocation
                          and pt.Lot            = pl.Lot  )
  From inserted de
  left join dbo.dxProductLot pl on
  (      de.FK_dxWarehouse = pl.FK_dxWarehouse
     and de.FK_dxProduct   = pl.FK_dxProduct
     and de.FK_dxLocation  = pl.FK_dxLocation
     and de.Lot            = pl.Lot )

  -- Update production Date
  insert into dxProductProductionDate (FK_dxProduct,Lot, ProductionDate)
  select Distinct
      ie.FK_dxProduct
    , ie.lot
    , Coalesce( DateAdd(dd, -pr.LifeSpanInDays, rd.ExpirationDate), rd.LotDate, TransactionDate) from inserted ie
  left outer join dxReceptionDetail rd on (rd.PK_dxReceptionDetail = ie.FK_dxReceptionDetail )
  left outer join dxProduct pr on ( pr.PK_dxProduct = rd.FK_dxProduct)
  where not exists ( select 1 from  dxProductProductionDate pm where pm.FK_dxProduct = ie.FK_dxProduct and pm.Lot = ie.Lot )

  -- Buffer on transactions to update
  insert into dxProductTransactionToUpdate ( FK_dxProductTransaction, KindOfDocument )
  Select ie.PK_dxProductTransaction, ie.KindOfDocument from inserted ie
  where not exists ( select 1 from  dxProductTransactionToUpdate pm
                      where pm.FK_dxProductTransaction = ie.PK_dxProductTransaction
                        and pm.KindOfDocument          = ie.KindOfDocument )
END
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [PK_dxProductTransaction] PRIMARY KEY CLUSTERED  ([PK_dxProductTransaction]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxAccount__CorrectionLabor] ON [dbo].[dxProductTransaction] ([FK_dxAccount__CorrectionLabor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxAccount__CorrectionMaterial] ON [dbo].[dxProductTransaction] ([FK_dxAccount__CorrectionMaterial]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxAccount__CorrectionOverheadFixed] ON [dbo].[dxProductTransaction] ([FK_dxAccount__CorrectionOverheadFixed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxAccount__CorrectionOverheadVariable] ON [dbo].[dxProductTransaction] ([FK_dxAccount__CorrectionOverheadVariable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxClientOrderDetail] ON [dbo].[dxProductTransaction] ([FK_dxClientOrderDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxDeclaration] ON [dbo].[dxProductTransaction] ([FK_dxDeclaration]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxDeclarationConsumption] ON [dbo].[dxProductTransaction] ([FK_dxDeclarationConsumption]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxDeclarationDismantling] ON [dbo].[dxProductTransaction] ([FK_dxDeclarationDismantling]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxDeclarationLabor] ON [dbo].[dxProductTransaction] ([FK_dxDeclarationLabor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxInventoryAdjustmentDetail] ON [dbo].[dxProductTransaction] ([FK_dxInventoryAdjustmentDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxInventoryTransferDetail] ON [dbo].[dxProductTransaction] ([FK_dxInventoryTransferDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxLocation] ON [dbo].[dxProductTransaction] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxLocation__PriorPhase] ON [dbo].[dxProductTransaction] ([FK_dxLocation__PriorPhase]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxPayableInvoiceDetail] ON [dbo].[dxProductTransaction] ([FK_dxPayableInvoiceDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxProduct] ON [dbo].[dxProductTransaction] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxReceptionDetail] ON [dbo].[dxProductTransaction] ([FK_dxReceptionDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxRMADetail] ON [dbo].[dxProductTransaction] ([FK_dxRMADetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxShippingDetail] ON [dbo].[dxProductTransaction] ([FK_dxShippingDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxWarehouse] ON [dbo].[dxProductTransaction] ([FK_dxWarehouse]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxProductTransactionProductLot] ON [dbo].[dxProductTransaction] ([FK_dxWarehouse], [FK_dxLocation], [FK_dxProduct], [Lot], [TransactionDate], [PhaseNumber], [LinkedProductTransaction], [PK_dxProductTransaction]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductTransaction_FK_dxWorkOrderFinishedProduct] ON [dbo].[dxProductTransaction] ([FK_dxWorkOrderFinishedProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxProductTransactionLink] ON [dbo].[dxProductTransaction] ([LinkedProductTransaction]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxProductTransactionPrimaryKeyValue] ON [dbo].[dxProductTransaction] ([PrimaryKeyValue], [KindOfDocument]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxProductTransaction] ON [dbo].[dxProductTransaction] ([TransactionDate], [KindOfDocument]) INCLUDE ([PK_dxProductTransaction]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CorrectionLabor_dxProductTransaction] FOREIGN KEY ([FK_dxAccount__CorrectionLabor]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CorrectionMaterial_dxProductTransaction] FOREIGN KEY ([FK_dxAccount__CorrectionMaterial]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CorrectionOverheadFixed_dxProductTransaction] FOREIGN KEY ([FK_dxAccount__CorrectionOverheadFixed]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CorrectionOverheadVariable_dxProductTransaction] FOREIGN KEY ([FK_dxAccount__CorrectionOverheadVariable]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxClientOrderDetail_dxProductTransaction] FOREIGN KEY ([FK_dxClientOrderDetail]) REFERENCES [dbo].[dxClientOrderDetail] ([PK_dxClientOrderDetail])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxDeclaration_dxProductTransaction] FOREIGN KEY ([FK_dxDeclaration]) REFERENCES [dbo].[dxDeclaration] ([PK_dxDeclaration])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxDeclarationConsumption_dxProductTransaction] FOREIGN KEY ([FK_dxDeclarationConsumption]) REFERENCES [dbo].[dxDeclarationConsumption] ([PK_dxDeclarationConsumption])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxDeclarationDismantling_dxProductTransaction] FOREIGN KEY ([FK_dxDeclarationDismantling]) REFERENCES [dbo].[dxDeclarationDismantling] ([PK_dxDeclarationDismantling])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxDeclarationLabor_dxProductTransaction] FOREIGN KEY ([FK_dxDeclarationLabor]) REFERENCES [dbo].[dxDeclarationLabor] ([PK_dxDeclarationLabor])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxInventoryAdjustmentDetail_dxProductTransaction] FOREIGN KEY ([FK_dxInventoryAdjustmentDetail]) REFERENCES [dbo].[dxInventoryAdjustmentDetail] ([PK_dxInventoryAdjustmentDetail])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxInventoryTransferDetail_dxProductTransaction] FOREIGN KEY ([FK_dxInventoryTransferDetail]) REFERENCES [dbo].[dxInventoryTransferDetail] ([PK_dxInventoryTransferDetail])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxProductTransaction] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxLocation__PriorPhase_dxProductTransaction] FOREIGN KEY ([FK_dxLocation__PriorPhase]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxPayableInvoiceDetail_dxProductTransaction] FOREIGN KEY ([FK_dxPayableInvoiceDetail]) REFERENCES [dbo].[dxPayableInvoiceDetail] ([PK_dxPayableInvoiceDetail])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxProductTransaction] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxReceptionDetail_dxProductTransaction] FOREIGN KEY ([FK_dxReceptionDetail]) REFERENCES [dbo].[dxReceptionDetail] ([PK_dxReceptionDetail])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxRMADetail_dxProductTransaction] FOREIGN KEY ([FK_dxRMADetail]) REFERENCES [dbo].[dxRMADetail] ([PK_dxRMADetail])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxShippingDetail_dxProductTransaction] FOREIGN KEY ([FK_dxShippingDetail]) REFERENCES [dbo].[dxShippingDetail] ([PK_dxShippingDetail])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxProductTransaction] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
ALTER TABLE [dbo].[dxProductTransaction] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrderFinishedProduct_dxProductTransaction] FOREIGN KEY ([FK_dxWorkOrderFinishedProduct]) REFERENCES [dbo].[dxWorkOrderFinishedProduct] ([PK_dxWorkOrderFinishedProduct])
GO
