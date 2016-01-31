SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-02-03
-- Description:	Create Accounting Transaction for a Payment Detail
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pdxPostPaymentDetail] @FK_dxPayment int, @ResetTransaction int
AS
BEGIN


  SET NOCOUNT ON

  set @ResetTransaction = Coalesce( @ResetTransaction, 0)

  Declare @FK_dxCurrency__System int, @Journal int
  Select
      @FK_dxCurrency__System = FK_dxCurrency__System
  from dxAccountConfiguration

  Declare @KOD   int -- Kind of Document
  Declare @PK    int -- Primary key value of Document
  Declare @Entry int -- Entry

  set @KOD     = 10
  set @Journal = 40
  set @PK = @FK_dxPayment

  -- Search for entry linked with this Document
  Select @Entry = PK_dxEntry from dxEntry where KindOfDocument = @KOD  and PrimaryKeyValue = @PK
  -- If not found then create it
  if @Entry is Null Insert into dxEntry ( KindOfDocument,  PrimaryKeyValue )  values( @KOD  , @PK )
  -- Search again
  Select @Entry = PK_dxEntry from dxEntry where KindOfDocument =@KOD  and PrimaryKeyValue = @PK
  -- Delete Accounting Transaction Entry for this Document
  Delete from dxAccountTransaction
   where PrimaryKeyValue = @PK
     and KindOfDocument = @KOD

  -- Payment - Credit the Advance Vendor Account
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxPayment )
  Select
        @Entry
       ,py.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,pa.FK_dxAccount
       ,Convert(varchar(100),'Avance fournisseur '+Coalesce(','+ pa.Reference,''))
       ,dbo.fdxCT( py.PaidAmount + py.ImputationAmount )
       ,dbo.fdxDT( py.PaidAmount + py.ImputationAmount )
       ,pa.FK_dxCurrency ,0 ,@KOD, @PK, @PK
  From dbo.dxPaymentInvoice py
  left join dxPayment  pa on ( pa.PK_dxPayment = py.FK_dxPayment)
  left join dxBankAccount ba on (ba.PK_dxBankAccount = pa.FK_dxBankAccount)
  left join dxVendor   cl on ( cl.PK_dxVendor  = pa.FK_dxVendor )
  left join dxPeriod   pe on ( py.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = pa.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( py.PaidAmount + py.ImputationAmount ) > 0.0001
    and (py.FK_dxPayment = @PK)
    and (py.Posted = 0 or @ResetTransaction =1)

  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxPayment )
  Select
        @Entry
       ,py.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,pa.FK_dxAccount
       ,Convert(varchar(100),'Autre imputation '+Coalesce( py.Description,''))
       ,dbo.fdxCT( py.Amount )
       ,dbo.fdxDT( py.Amount )
       ,pa.FK_dxCurrency ,0 ,@KOD, @PK, @PK
  From dbo.dxPaymentImputation py
  left join dxPayment  pa on ( pa.PK_dxPayment = py.FK_dxPayment)
  left join dxBankAccount ba on (ba.PK_dxBankAccount = pa.FK_dxBankAccount)
  left join dxVendor   cl on ( cl.PK_dxVendor  = pa.FK_dxVendor )
  left join dxPeriod   pe on ( py.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = pa.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( py.Amount ) > 0.0001
    and (py.FK_dxPayment = @PK)
    and (py.Posted = 0 or @ResetTransaction =1)

  -- Payment - Debit the Payable Account
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxPayment )
  Select
        @Entry
       ,py.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,cu.FK_dxAccount__Payable
       ,Convert(varchar(100),'Payer la facture CAP '+Convert(varchar,py.FK_dxPayableInvoice)+Coalesce(','+ pa.Reference,''))
       ,dbo.fdxDT( py.PaidAmount )
       ,dbo.fdxCT( py.PaidAmount )
       ,pa.FK_dxCurrency ,0 ,@KOD, @PK, @PK
  From dbo.dxPaymentInvoice py
  left join dxPayment  pa on ( pa.PK_dxPayment = py.FK_dxPayment)
  left join dxBankAccount ba on (ba.PK_dxBankAccount = pa.FK_dxBankAccount)
  left join dxVendor   cl on ( cl.PK_dxVendor  = pa.FK_dxVendor )
  left join dxPeriod   pe on ( py.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = pa.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( py.PaidAmount ) > 0.0001
    and (py.FK_dxPayment = @PK)
    and (py.Posted = 0 or @ResetTransaction =1)

  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxPayment )
  Select
        @Entry
       ,py.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,py.FK_dxAccount__InvoiceImputation
       ,Convert(varchar(100),'Payer la facture avec imputation '+Convert(varchar,py.FK_dxPayableInvoice)+Coalesce(','+ pa.Reference,''))
       ,dbo.fdxDT( py.ImputationAmount )
       ,dbo.fdxCT( py.ImputationAmount )
       ,pa.FK_dxCurrency ,0 ,@KOD, @PK, @PK
  From dbo.dxPaymentInvoice py
  left join dxPayment  pa on ( pa.PK_dxPayment = py.FK_dxPayment)
  left join dxBankAccount ba on (ba.PK_dxBankAccount = pa.FK_dxBankAccount)
  left join dxVendor   cl on ( cl.PK_dxVendor  = pa.FK_dxVendor )
  left join dxPeriod   pe on ( py.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = pa.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( py.ImputationAmount ) > 0.0001
    and (py.FK_dxPayment = @PK)
    and (py.Posted = 0 or @ResetTransaction =1)

  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxPayment )
  Select
        @Entry
       ,py.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,py.FK_dxAccount
       ,Convert(varchar(100),'Payer la facture avec autre imputation '+Coalesce( py.Description,''))
       ,dbo.fdxDT( py.Amount )
       ,dbo.fdxCT( py.Amount )
       ,pa.FK_dxCurrency ,0 ,@KOD, @PK, @PK
  From dbo.dxPaymentImputation py
  left join dxPayment  pa on ( pa.PK_dxPayment = py.FK_dxPayment)
  left join dxBankAccount ba on (ba.PK_dxBankAccount = pa.FK_dxBankAccount)
  left join dxVendor   cl on ( cl.PK_dxVendor  = pa.FK_dxVendor )
  left join dxPeriod   pe on ( py.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = pa.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( py.Amount ) > 0.0001
    and (py.FK_dxPayment = @PK)
    and (py.Posted = 0 or @ResetTransaction =1)

  Update dxPaymentInvoice    set Posted = 1  Where FK_dxPayment = @FK_dxPayment and Posted = 0
  Update dxPaymentImputation set Posted = 1  Where FK_dxPayment = @FK_dxPayment and Posted = 0
  Exec [dbo].[pdxValidateEntry]
  Exec [dbo].[pdxUpdateAccountPeriod]
END
GO
