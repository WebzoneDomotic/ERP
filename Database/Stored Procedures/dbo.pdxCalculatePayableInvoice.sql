SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-11-25
-- Description:	Calcul d'une Facture Fournisseur
-- --------------------------------------------------------------------------------------------
create procedure [dbo].[pdxCalculatePayableInvoice] ( @PK_dxPayableInvoice int )
as
BEGIN
  Declare @PK_DocumentDetail int
  Set nocount on
  Exec('DISABLE TRIGGER [dbo].[dxPayableInvoice.trAuditInsUpd] ON [dbo].[dxPayableInvoice]')
  Exec('DISABLE TRIGGER [dbo].[dxPayableInvoiceDetail.trAuditInsUpd] ON [dbo].[dxPayableInvoiceDetail]')
  Declare cr_CalculatePayableInvoice CURSOR FAST_FORWARD for SELECT PK_dxPayableInvoiceDetail from dxPayableInvoiceDetail where FK_dxPayableInvoice = @PK_dxPayableInvoice
  -- Open cursor 
  Open cr_CalculatePayableInvoice
  Fetch NEXT FROM cr_CalculatePayableInvoice INTO @PK_DocumentDetail ;
  -- Calculate all the Payable Invoice Details
  While @@FETCH_STATUS = 0
  Begin
     Exec dbo.pdxCalculateDocumentDetail @PK_Doc = @PK_DocumentDetail, @Document = 'dxPayableInvoiceDetail'
     FETCH NEXT FROM cr_CalculateInvoice INTO @PK_DocumentDetail ;
  End
  Close cr_CalculatePayableInvoice 
  Deallocate cr_CalculatePayableInvoice
  Exec('ENABLE TRIGGER [dbo].[dxPayableInvoiceDetail.trAuditInsUpd] ON [dbo].[dxPayableInvoiceDetail]')
  Exec('ENABLE TRIGGER [dbo].[dxPayableInvoice.trAuditInsUpd] ON [dbo].[dxPayableInvoice]')
  Set nocount Off
END
GO
