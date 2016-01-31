SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-11-25
-- Description:	Calcul d'un Bon de commande Client
-- --------------------------------------------------------------------------------------------
create procedure [dbo].[pdxCalculateClientOrder] ( @PK_dxClientOrder int )
as
BEGIN
  Declare @PK_DocumentDetail int
  Set nocount on
  Exec('DISABLE TRIGGER [dbo].[dxClientOrder.trAuditInsUpd] ON [dbo].[dxClientOrder]')
  Exec('DISABLE TRIGGER [dbo].[dxClientOrderDetail.trAuditInsUpd] ON [dbo].[dxClientOrderDetail]')
  Declare cr_CalculateClientOrder CURSOR FAST_FORWARD for SELECT PK_dxClientOrderDetail from dxClientOrderDetail where FK_dxClientOrder = @PK_dxClientOrder
  -- Open cursor 
  Open cr_CalculateClientOrder
  Fetch NEXT FROM cr_CalculateClientOrder INTO @PK_DocumentDetail ;
  -- Calculate all the Client Order Details
  While @@FETCH_STATUS = 0
  Begin
     Exec dbo.pdxCalculateDocumentDetail @PK_Doc = @PK_DocumentDetail, @Document = 'dxClientOrderDetail'
     FETCH NEXT FROM cr_CalculateClientOrder INTO @PK_DocumentDetail ;
  End
  Close cr_CalculateClientOrder 
  Deallocate cr_CalculateClientOrder
  Exec('ENABLE TRIGGER [dbo].[dxClientOrderDetail.trAuditInsUpd] ON [dbo].[dxClientOrderDetail]')
  Exec('ENABLE TRIGGER [dbo].[dxClientOrder.trAuditInsUpd] ON [dbo].[dxClientOrder]')
  Set nocount Off
END
GO
