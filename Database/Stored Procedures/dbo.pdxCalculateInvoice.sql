SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-11-25
-- Description:	Calcul d'une Facture client
-- --------------------------------------------------------------------------------------------
create procedure [dbo].[pdxCalculateInvoice] ( @PK_dxInvoice int )
as
BEGIN
  Declare @PK_DocumentDetail int
  Set nocount on
  Exec('DISABLE TRIGGER [dbo].[dxInvoice.trAuditInsUpd] ON [dbo].[dxInvoice]')
  Exec('DISABLE TRIGGER [dbo].[dxInvoiceDetail.trAuditInsUpd] ON [dbo].[dxInvoiceDetail]')
  Declare cr_CalculateInvoice CURSOR FAST_FORWARD for SELECT PK_dxInvoiceDetail from dxInvoiceDetail where FK_dxInvoice = @PK_dxInvoice
  -- Open cursor 
  Open cr_CalculateInvoice
  Fetch NEXT FROM cr_CalculateInvoice INTO @PK_DocumentDetail ;
  -- Calculate all the Invoice Details
  While @@FETCH_STATUS = 0
  Begin
     Exec dbo.pdxCalculateDocumentDetail @PK_Doc = @PK_DocumentDetail, @Document = 'dxInvoiceDetail'
     FETCH NEXT FROM cr_CalculateInvoice INTO @PK_DocumentDetail ;
  End
  Close cr_CalculateInvoice 
  Deallocate cr_CalculateInvoice
  Exec('ENABLE TRIGGER [dbo].[dxInvoiceDetail.trAuditInsUpd] ON [dbo].[dxInvoiceDetail]')
  Exec('ENABLE TRIGGER [dbo].[dxInvoice.trAuditInsUpd] ON [dbo].[dxInvoice]')
  Set nocount Off
END
GO
