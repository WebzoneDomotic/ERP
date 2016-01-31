SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-10-08
-- Description:	Create Accounting Transaction for a Payable Invoice
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxPostPayableInvoice] @FK_dxPayableInvoice int
AS
BEGIN

  SET NOCOUNT ON

  Declare @FK_dxCurrency__System int, @Journal int
  Declare @TransactionDate Datetime

  -- Validate Accounting Period
  set @TransactionDate = ( Select TransactionDate from dxPayableInvoice where PK_dxPayableInvoice =  @FK_dxPayableInvoice )
  exec [dbo].[pdxValidateAccountingPeriod] @Date = @TransactionDate

  Select @FK_dxCurrency__System = FK_dxCurrency__System from dxAccountConfiguration

  Declare @KOD   int -- Kind of Document
  Declare @PK    int -- Primary key value of Document
  Declare @Entry int -- Entry

  Declare @TaxesManagedByItem bit

  set @KOD = 5
  set @Journal = 20
  set @PK  = @FK_dxPayableInvoice

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

  Set @TaxesManagedByItem = ( Select TaxesManagedByItem from dxPayableInvoice where PK_dxPayableInvoice = @PK )

  -- Payable Account - Credit - avec taxes par item
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,cu.FK_dxAccount__Payable
       ,Convert(varchar(100),id.Description)
       ,dbo.fdxCT( id.TotalAmount )
       ,dbo.fdxDT( id.TotalAmount )
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left outer join dxPayableInvoice  iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
  left outer join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left outer join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( id.TotalAmount ) > 0.0001
    and id.FK_dxPayableInvoice = @PK
    and iv.TaxesManagedByItem =1

  -- Payable Account - Credit - avec taxes globales
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,cu.FK_dxAccount__Payable
       ,Convert(varchar(100),id.Description)
       ,dbo.fdxCT( id.TotalAmountBeforeTax )
       ,dbo.fdxDT( id.TotalAmountBeforeTax )
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left outer join dxPayableInvoice  iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
  left outer join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left outer join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  Where abs( id.TotalAmountBeforeTax ) > 0.0001
    and id.FK_dxPayableInvoice = @PK
    and iv.TaxesManagedByItem = 0

  -- ---------------------------------------------------------------------------
  -- Payable Account - Global Adjustment
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,cu.FK_dxAccount__Payable
       ,'Ajustement global / Global Adjustment'
       ,dbo.fdxCT( iv.PayableAdjustmentAmount )
       ,dbo.fdxDT( iv.PayableAdjustmentAmount )
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
  From dxPayableInvoice  iv
  left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
  Where abs( iv.PayableAdjustmentAmount ) > 0.0001
    and iv.PK_dxPayableInvoice = @PK

  -- Credit par Global Adjustment
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,cu.FK_dxAccount__PayableAdjustmentAmount
       ,'Ajustement global / Global Adjustment'
       ,dbo.fdxDT( iv.PayableAdjustmentAmount )
       ,dbo.fdxCT( iv.PayableAdjustmentAmount )
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
  From dxPayableInvoice  iv
  left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
  left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
  Where abs( iv.PayableAdjustmentAmount ) > 0.0001
    and iv.PK_dxPayableInvoice = @PK

  -- ---------------------------------------------------------------------------
  -- Gestion des taxes par item ou globalement
  if @TaxesManagedByItem = 1
  begin
    -- Payable Account - Credit Tax 1 Adjustment
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,cu.FK_dxAccount__Payable
         ,'Ajustement de la taxe 1 / Tax 1 Adjustment'
         ,dbo.fdxCT( iv.Tax1AdjustmentAmount )
         ,dbo.fdxDT( iv.Tax1AdjustmentAmount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.Tax1AdjustmentAmount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Credit par Tax1 Adjustment
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,tx.FK_dxAccount__AP_Tax1
         ,'Ajustement de la taxe 1 / Tax 1 Adjustment'
         ,dbo.fdxDT( iv.Tax1AdjustmentAmount )
         ,dbo.fdxCT( iv.Tax1AdjustmentAmount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.Tax1AdjustmentAmount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Payable Account - Credit Tax 2 Adjustment
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,cu.FK_dxAccount__Payable
         ,'Ajustement de la taxe 2 / Tax 2 Adjustment'
         ,dbo.fdxCT( iv.Tax2AdjustmentAmount )
         ,dbo.fdxDT( iv.Tax2AdjustmentAmount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.Tax2AdjustmentAmount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Credit par Tax2 Adjustment
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,tx.FK_dxAccount__AP_Tax2
         ,'Ajustement de la taxe 2 / Tax 2 Adjustment'
         ,dbo.fdxDT( iv.Tax2AdjustmentAmount )
         ,dbo.fdxCT( iv.Tax2AdjustmentAmount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.Tax2AdjustmentAmount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Payable Account - Credit Tax 3 Adjustment
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,cu.FK_dxAccount__Payable
         ,'Ajustement de la taxe 3 / Tax 3 Adjustment'
         ,dbo.fdxCT( iv.Tax3AdjustmentAmount )
         ,dbo.fdxDT( iv.Tax3AdjustmentAmount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.Tax3AdjustmentAmount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Credit par Tax3 Adjustment
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,tx.FK_dxAccount__AP_Tax3
         ,'Ajustement de la taxe 3 / Tax 3 Adjustment'
         ,dbo.fdxDT( iv.Tax3AdjustmentAmount )
         ,dbo.fdxCT( iv.Tax3AdjustmentAmount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.Tax3AdjustmentAmount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK
  end else
  begin
    -- Payable Account - Credit Tax 1 Total
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,cu.FK_dxAccount__Payable
         ,'Total de la taxe 1 / Tax 1 Total'
         ,dbo.fdxCT( iv.TotalTax1Amount )
         ,dbo.fdxDT( iv.TotalTax1Amount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.TotalTax1Amount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Credit par Tax1 Total
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,tx.FK_dxAccount__AP_Tax1
         ,'Total de la taxe 1 / Tax 1 Total'
         ,dbo.fdxDT( iv.TotalTax1Amount )
         ,dbo.fdxCT( iv.TotalTax1Amount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.TotalTax1Amount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Payable Account - Credit Tax 2 Total
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,cu.FK_dxAccount__Payable
         ,'Total de la taxe 2 / Tax 2 Total'
         ,dbo.fdxCT( iv.TotalTax2Amount )
         ,dbo.fdxDT( iv.TotalTax2Amount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.TotalTax2Amount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Credit par Tax2 Total
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,tx.FK_dxAccount__AP_Tax2
         ,'Total de la taxe 2 / Tax 2 Total'
         ,dbo.fdxDT( iv.TotalTax2Amount )
         ,dbo.fdxCT( iv.TotalTax2Amount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.TotalTax2Amount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Payable Account - Credit Tax 3 Total
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,cu.FK_dxAccount__Payable
         ,'Total de la taxe 3 / Tax 3 Total'
         ,dbo.fdxCT( iv.TotalTax3Amount )
         ,dbo.fdxDT( iv.TotalTax3Amount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.TotalTax3Amount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK

    -- Credit par Tax3 Total
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,iv.TransactionDate
         ,@Journal
         ,pe.PK_dxPeriod
         ,tx.FK_dxAccount__AP_Tax3
         ,'Total de la taxe 3 / Tax 3 Total'
         ,dbo.fdxDT( iv.TotalTax3Amount )
         ,dbo.fdxCT( iv.TotalTax3Amount )
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK

    From dxPayableInvoice  iv
    left join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
    left join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
    left join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Payable )
    left join dxTax      tx on  (tx.PK_dxTax = iv.FK_dxTax)
    Where abs( iv.TotalTax3Amount ) > 0.0001
      and iv.PK_dxPayableInvoice = @PK
  end


  --Discount
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,id.FK_dxAccount__Discount
       ,Convert(varchar(100),id.Description)
       ,dbo.fdxCT( id.DiscountAmount )
       ,dbo.fdxDT( id.DiscountAmount )
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left outer join dxPayableInvoice iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
  left outer join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left outer join dxAccount  ac on ( ac.PK_dxAccount  = id.FK_dxAccount__Discount )
  Where abs( id.DiscountAmount ) > 0.0001
    and id.FK_dxPayableInvoice = @PK

  -- Expenses Account - Debit
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,id.FK_dxAccount__Expense
       ,Convert(varchar(100),id.Description)
       ,dbo.fdxDT( id.Amount )
       ,dbo.fdxCT( id.Amount )
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left outer join dxPayableInvoice iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
  left outer join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left outer join dxAccount  ac on ( ac.PK_dxAccount  = id.FK_dxAccount__Expense )
  Where abs( id.Amount ) > 0.0001
    and id.FK_dxPayableInvoice = @PK
    and id.FK_dxReceptionDetail is null

   -- Tax Refund  Go to Expense Account - Debit
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,id.FK_dxAccount__Expense
       ,Convert(varchar(100),'Tax Refund ' +id.Description)
       ,dbo.fdxDT( id.Tax1RefundAmount + id.Tax2RefundAmount + id.Tax3RefundAmount)
       ,dbo.fdxCT( id.Tax1RefundAmount + id.Tax2RefundAmount + id.Tax3RefundAmount)
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left outer join dxPayableInvoice iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
  left outer join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left outer join dxAccount  ac on ( ac.PK_dxAccount  = id.FK_dxAccount__Expense )
  Where abs( id.Tax1RefundAmount + id.Tax2RefundAmount + id.Tax3RefundAmount ) > 0.0001
    and id.FK_dxPayableInvoice = @PK
    and iv.TaxesManagedByItem =1

  -- Taxe 1 Account - Debit
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,id.FK_dxAccount__AP_Tax1
       ,Convert(varchar(100),id.Description)
       ,dbo.fdxDT( id.Tax1Amount - id.Tax1RefundAmount)
       ,dbo.fdxCT( id.Tax1Amount - id.Tax1RefundAmount)
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left outer join dxPayableInvoice iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
  left outer join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left outer join dxAccount  ac on ( ac.PK_dxAccount  = id.FK_dxAccount__AP_Tax1 )
  Where abs( id.Tax1Amount  - id.Tax1RefundAmount ) > 0.0001
    and id.FK_dxPayableInvoice = @PK
    and iv.TaxesManagedByItem = 1

  -- Taxe 2 Account - Debit
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,id.FK_dxAccount__AP_Tax2
       ,Convert(varchar(100),id.Description)
       ,dbo.fdxDT( id.Tax2Amount - id.Tax2RefundAmount )
       ,dbo.fdxCT( id.Tax2Amount - id.Tax2RefundAmount )
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left outer join dxPayableInvoice iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
  left outer join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left outer join dxAccount  ac on ( ac.PK_dxAccount  = id.FK_dxAccount__AP_Tax2 )
  Where abs( id.Tax2Amount - id.Tax2RefundAmount ) > 0.0001
    and id.FK_dxPayableInvoice = @PK
    and iv.TaxesManagedByItem = 1

  -- Taxe 3 Account - Debit
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,id.FK_dxAccount__AP_Tax3
       ,Convert(varchar(100),id.Description)
       ,dbo.fdxDT( id.Tax3Amount - id.Tax3RefundAmount )
       ,dbo.fdxCT( id.Tax3Amount - id.Tax3RefundAmount )
       ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left outer join dxPayableInvoice iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
  left outer join dxVendor   cl on ( cl.PK_dxVendor  = iv.FK_dxVendor )
  left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
  left outer join dxAccount  ac on ( ac.PK_dxAccount  = id.FK_dxAccount__AP_Tax3 )
  Where abs( id.Tax3Amount - id.Tax3RefundAmount ) > 0.0001
    and id.FK_dxPayableInvoice = @PK
    and iv.TaxesManagedByItem = 1

  -- Reverse the Transitory - Accrual Account  - From Reception
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue,FK_dxPayableInvoiceDetail )
  Select
        @Entry
       ,iv.TransactionDate
       ,@Journal
       ,pe.PK_dxPeriod
       ,tr.FK_dxAccount
       ,tr.Description
       -- ,Case when id.Quantity < rd.Quantity then id.Amount else tr.CT end
       -- ,tr.DT
       ,dbo.fdxCT ( (id.Quantity / rd.Quantity) * tr.Amount )
       ,dbo.fdxDT ( (id.Quantity / rd.Quantity) * tr.Amount )
       ,tr.FK_dxCurrency ,0 ,@KOD ,@PK
       ,id.PK_dxPayableInvoiceDetail
  From dbo.dxPayableInvoiceDetail id
  left join dxReceptionDetail       rd on ( id.FK_dxReceptionDetail = rd.PK_dxReceptionDetail)
  left join dxAccountTransaction    tr on (( id.FK_dxReceptionDetail = tr.KEY_dxReceptionDetail) )
  left outer join dxPayableInvoice  iv on ( iv.PK_dxPayableInvoice = id.FK_dxPayableInvoice )
  left outer join dxPeriod          pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
  where id.FK_dxPayableInvoice = @PK
    and not tr.KEY_dxReceptionDetail is null

  Update dxPayableInvoice set Posted = 1 where PK_dxPayableInvoice = @PK and Posted = 0
  Exec [dbo].[pdxValidateEntryByCurrency]
  Exec [dbo].[pdxUpdateAccountPeriod]
END
GO
