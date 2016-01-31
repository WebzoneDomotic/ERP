SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-02-03
-- Description:	Create Accounting Transaction for a Payment
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pdxPostPayment] @FK_dxPayment int
AS
BEGIN

  SET NOCOUNT ON

  Declare @FK_dxCurrency__System int, @Journal int
  Declare @TransactionDate Datetime

  -- Validate Accounting Period
  set @TransactionDate = ( Select TransactionDate from dxPayment where PK_dxPayment =  @FK_dxPayment )
  exec [dbo].[pdxValidateAccountingPeriod] @Date = @TransactionDate

  Select @FK_dxCurrency__System = FK_dxCurrency__System from dxAccountConfiguration

  Declare @KOD   int -- Kind of Document
  Declare @PK    int -- Primary key value of Document
  Declare @Entry int -- Entry

  set @KOD     = 4
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

  -- Payment - Credit the Bank
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxPayment )
  Select
        @Entry
       ,py.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,ba.FK_dxAccount__GL
       ,Convert(varchar(100),'Déboursé '+Coalesce(','+ py.Reference,''))
       ,dbo.fdxCT( py.TotalAmount )
       ,dbo.fdxDT( py.TotalAmount )
       ,py.FK_dxCurrency ,0 ,@KOD, @PK, @PK
  From dbo.dxPayment py
  left join dxBankAccount ba on (ba.PK_dxBankAccount = py.FK_dxBankAccount)
  left join dxVendor   cl on ( cl.PK_dxVendor  = py.FK_dxVendor )
  left join dxPeriod   pe on ( py.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = py.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( py.TotalAmount ) > 0.0001
    and py.PK_dxPayment = @PK

  -- Payment - Debit the supplier advance account
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxPayment )
  Select
        @Entry
       ,py.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,py.FK_dxAccount
       ,Convert(varchar(100),'Avance fournisseur '+Coalesce(','+ py.Reference,''))
       ,dbo.fdxDT( py.TotalAmount )
       ,dbo.fdxCT( py.TotalAmount )
       ,py.FK_dxCurrency ,0 ,@KOD, @PK, @PK
  From dbo.dxPayment py
  left join dxBankAccount ba on (ba.PK_dxBankAccount = py.FK_dxBankAccount)
  left join dxVendor   cl on ( cl.PK_dxVendor  = py.FK_dxVendor )
  left join dxPeriod   pe on ( py.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = py.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( py.TotalAmount ) > 0.0001
    and py.PK_dxPayment = @PK

  Update dxPayment set Posted = 1  Where PK_dxPayment = @FK_dxPayment and Posted = 0
  Update dxPayment set PaymentCompleted = 1  Where PK_dxPayment = @FK_dxPayment and Posted = 1 and Abs(UnusedAmount) < 0.000001
  Exec [dbo].[pdxValidateEntry]
  Exec [dbo].[pdxUpdateAccountPeriod]
END
GO
