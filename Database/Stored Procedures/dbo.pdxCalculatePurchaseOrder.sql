SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-11-25
-- Description:	Calcul d'un Bon de commande Fournisseur
-- --------------------------------------------------------------------------------------------
create procedure [dbo].[pdxCalculatePurchaseOrder] ( @PK_dxPurchaseOrder int )
as
BEGIN
  Declare @PK_DocumentDetail int
  Set nocount on
  Exec('DISABLE TRIGGER [dbo].[dxPurchaseOrder.trAuditInsUpd] ON [dbo].[dxPurchaseOrder]')
  Exec('DISABLE TRIGGER [dbo].[dxPurchaseOrderDetail.trAuditInsUpd] ON [dbo].[dxPurchaseOrderDetail]')
  Declare cr_CalculatePurchaseOrder CURSOR FAST_FORWARD for SELECT PK_dxPurchaseOrderDetail from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @PK_dxPurchaseOrder
  -- Open cursor 
  Open cr_CalculatePurchaseOrder
  Fetch NEXT FROM cr_CalculatePurchaseOrder INTO @PK_DocumentDetail ;
  -- Calculate all the Purchase Order Details
  While @@FETCH_STATUS = 0
  Begin
     Exec dbo.pdxCalculateDocumentDetail @PK_Doc = @PK_DocumentDetail, @Document = 'dxPurchaseOrderDetail'
     FETCH NEXT FROM cr_CalculatePurchaseOrder INTO @PK_DocumentDetail ;
  End
  Close cr_CalculatePurchaseOrder 
  Deallocate cr_CalculatePurchaseOrder
  Exec('ENABLE TRIGGER [dbo].[dxPurchaseOrderDetail.trAuditInsUpd] ON [dbo].[dxPurchaseOrderDetail]')
  Exec('ENABLE TRIGGER [dbo].[dxPurchaseOrder.trAuditInsUpd] ON [dbo].[dxPurchaseOrder]')
  Set nocount Off
END
GO
