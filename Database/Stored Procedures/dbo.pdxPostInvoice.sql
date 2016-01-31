SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-09-19
-- Description:	Create Accounting Transaction for an Invoice
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxPostInvoice] @FK_dxInvoice int
AS
BEGIN

  SET NOCOUNT ON

  --Declare @FK_dxInvoice int
  --set @FK_dxInvoice = 20001

  Declare @FK_dxCurrency__System int, @Journal int
  Declare @TransactionDate Datetime

  if ( Select Posted from dxInvoice where PK_dxInvoice = @FK_dxInvoice ) = 0
  BEGIN
      -- Validate Accounting Period
      set @TransactionDate = ( Select TransactionDate from dxInvoice where PK_dxInvoice =  @FK_dxInvoice )
      exec [dbo].[pdxValidateAccountingPeriod] @Date = @TransactionDate

      Select @FK_dxCurrency__System = FK_dxCurrency__System from dxAccountConfiguration

      Declare @KOD   int -- Kind of Document
      Declare @PK    int -- Primary key value of Document
      Declare @Entry int -- Entry

      set @KOD = 3
      set @Journal = 30
      set @PK  = @FK_dxInvoice

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

      -- Receivable Account - Debit
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxInvoiceDetail )
      Select
            @Entry
           ,iv.TransactionDate
           ,@Journal
           ,pe.PK_dxPeriod
           ,cu.FK_dxAccount__Receivable
           ,Convert(varchar(100),id.Description)
           ,dbo.fdxDT( id.TotalAmount )
           ,dbo.fdxCT( id.TotalAmount )
           ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
           ,id.PK_dxInvoiceDetail
      From dbo.dxInvoiceDetail id
      left outer join dxInvoice  iv on ( iv.PK_dxInvoice = id.FK_dxInvoice )
      left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
      left outer join dxClient   cl on ( cl.PK_dxClient  = iv.FK_dxClient )
      left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
      left outer join dxAccount  ac on ( ac.PK_dxAccount = cu.FK_dxAccount__Receivable )
      Where abs( id.TotalAmount ) > 0.0001
        and id.FK_dxInvoice = @PK

      --Discount
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxInvoiceDetail )
      Select
            @Entry
           ,iv.TransactionDate
           ,@Journal
           ,pe.PK_dxPeriod
           ,id.FK_dxAccount__Discount
           ,Convert(varchar(100),id.Description)
           ,dbo.fdxDT( id.DiscountAmount )
           ,dbo.fdxCT( id.DiscountAmount )
           ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
           ,id.PK_dxInvoiceDetail
      From dbo.dxInvoiceDetail id
      left outer join dxInvoice  iv on ( iv.PK_dxInvoice = id.FK_dxInvoice )
      left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
      left outer join dxClient   cl on ( cl.PK_dxClient  = iv.FK_dxClient )
      left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
      left outer join dxAccount  ac on ( ac.PK_dxAccount = id.FK_dxAccount__Discount )
      Where abs( id.DiscountAmount ) > 0.0001
        and id.FK_dxInvoice = @PK

      -- Sales Revenu Account - Credit
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue , FK_dxInvoiceDetail)
      Select
            @Entry
           ,iv.TransactionDate
           ,@Journal
           ,pe.PK_dxPeriod
           ,id.FK_dxAccount__Revenue
           ,Convert(varchar(100),id.Description)
           ,dbo.fdxCT( id.Amount )
           ,dbo.fdxDT( id.Amount )
           ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
           ,id.PK_dxInvoiceDetail
      From dbo.dxInvoiceDetail id
      left outer join dxInvoice  iv on ( iv.PK_dxInvoice = id.FK_dxInvoice )
      left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
      left outer join dxClient   cl on ( cl.PK_dxClient  = iv.FK_dxClient )
      left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
      left outer join dxAccount  ac on ( ac.PK_dxAccount = id.FK_dxAccount__Revenue )
      Where abs( id.Amount ) > 0.0001
        and id.FK_dxInvoice = @PK
        and (    (id.FK_dxShippingDetail is null and id.FK_dxRMADetail is null)
              or (pr.InventoryItem = 0)
              or id.FK_dxProduct is null
             )

      -- Taxe 1 Account - Credit
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxInvoiceDetail )
      Select
            @Entry
           ,iv.TransactionDate
           ,@Journal
           ,pe.PK_dxPeriod
           ,id.FK_dxAccount__AR_Tax1
           ,Convert(varchar(100),id.Description)
           ,dbo.fdxCT( id.Tax1Amount )
           ,dbo.fdxDT( id.Tax1Amount )
           ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
           ,id.PK_dxInvoiceDetail
      From dbo.dxInvoiceDetail id
      left outer join dxInvoice  iv on ( iv.PK_dxInvoice = id.FK_dxInvoice )
      left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
      left outer join dxClient   cl on ( cl.PK_dxClient  = iv.FK_dxClient )
      left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
      left outer join dxAccount  ac on ( ac.PK_dxAccount = id.FK_dxAccount__AR_Tax1 )
      Where abs( id.Tax1Amount ) > 0.0001
        and id.FK_dxInvoice = @PK

      -- Taxe 2 Account - Credit
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxInvoiceDetail )
      Select
            @Entry
           ,iv.TransactionDate
           ,@Journal
           ,pe.PK_dxPeriod
           ,id.FK_dxAccount__AR_Tax2
           ,Convert(varchar(100),id.Description)
           ,dbo.fdxCT( id.Tax2Amount )
           ,dbo.fdxDT( id.Tax2Amount )
           ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
           ,id.PK_dxInvoiceDetail
      From dbo.dxInvoiceDetail id
      left outer join dxInvoice  iv on ( iv.PK_dxInvoice = id.FK_dxInvoice )
      left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
      left outer join dxClient   cl on ( cl.PK_dxClient  = iv.FK_dxClient )
      left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
      left outer join dxAccount  ac on ( ac.PK_dxAccount = id.FK_dxAccount__AR_Tax2 )
      Where abs( id.Tax2Amount ) > 0.0001
        and id.FK_dxInvoice = @PK

      -- Taxe 3 Account - Credit
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxInvoiceDetail )
      Select
            @Entry
           ,iv.TransactionDate
           ,@Journal
           ,pe.PK_dxPeriod
           ,id.FK_dxAccount__AR_Tax3
           ,Convert(varchar(100),id.Description)
           ,dbo.fdxCT( id.Tax3Amount )
           ,dbo.fdxDT( id.Tax3Amount )
           ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
           ,id.PK_dxInvoiceDetail
      From dbo.dxInvoiceDetail id
      left outer join dxInvoice  iv on ( iv.PK_dxInvoice = id.FK_dxInvoice )
      left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
      left outer join dxClient   cl on ( cl.PK_dxClient  = iv.FK_dxClient )
      left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
      left outer join dxCurrency cu on ( cu.PK_dxCurrency = iv.FK_dxCurrency )
      left outer join dxAccount  ac on ( ac.PK_dxAccount = id.FK_dxAccount__AR_Tax3 )
      Where abs( id.Tax3Amount ) > 0.0001
        and id.FK_dxInvoice = @PK


      -- Reverse the Transitory - Accrual Account  - From Shipping
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxInvoiceDetail )
      Select
            @Entry
           ,iv.TransactionDate
           ,@Journal
           ,pe.PK_dxPeriod
           ,Coalesce(tr.FK_dxAccount, id.FK_dxAccount__Revenue)
           ,Coalesce(tr.Description, Convert(varchar(100),id.Description))
           ,Coalesce(tr.CT, dbo.fdxCT( id.Amount))
           ,Coalesce(tr.DT, dbo.fdxDT( id.Amount))
           ,Coalesce(tr.FK_dxCurrency, iv.FK_dxCurrency) ,0 ,@KOD ,@PK
           ,id.PK_dxInvoiceDetail
      From dbo.dxInvoiceDetail id
      left join dxAccountTransaction  tr on (( id.FK_dxShippingDetail = tr.KEY_dxShippingDetail) AND (id.FK_dxRMADetail is null ))
      left outer join dxInvoice  iv on ( iv.PK_dxInvoice = id.FK_dxInvoice )
      left outer join dxProduct  pr on ( pr.PK_dxProduct = id.FK_dxProduct )
      left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
      where id.FK_dxInvoice = @PK
        and not FK_dxShippingDetail is null
        and pr.InventoryItem =1

      -- Reverse the Transitory - Accrual Account  - From RMA
      Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue, FK_dxInvoiceDetail )
      Select
            @Entry
           ,iv.TransactionDate
           ,@Journal
           ,pe.PK_dxPeriod
           ,Coalesce(tr.FK_dxAccount, id.FK_dxAccount__Revenue)
           ,Coalesce(tr.Description, Convert(varchar(100),id.Description))
           ,Coalesce(tr.CT, dbo.fdxCT( id.Amount))
           ,Coalesce(tr.DT, dbo.fdxDT( id.Amount))
           ,Coalesce(tr.FK_dxCurrency, iv.FK_dxCurrency) ,0 ,@KOD ,@PK
           ,id.PK_dxInvoiceDetail
      From dbo.dxInvoiceDetail id
      left join dxAccountTransaction  tr on (( id.FK_dxRMADetail = tr.KEY_dxRMADetail) AND (id.FK_dxShippingDetail is null ))
      left outer join dxInvoice  iv on ( iv.PK_dxInvoice = id.FK_dxInvoice )
      left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
      left join dxProduct pr on ( pr.PK_dxProduct = id.FK_dxProduct )
      Where id.FK_dxInvoice = @PK
       -- and FK_dxShippingDetail is null
        and not FK_dxRMADetail is null
        and pr.InventoryItem = 1
        and Abs(Coalesce(tr.Amount, id.Amount)) > 0.000001

      -- Add custom enties
      EXECUTE dbo.pcxPostInvoice @FK_dxInvoice, @TransactionDate, @KOD, @Entry, @Journal

      Update dxInvoice set Posted = 1 where PK_dxInvoice = @PK and Posted = 0
      Exec [dbo].[pdxValidateEntryByCurrency]
      Exec [dbo].[pdxUpdateAccountPeriod]
  END
END
GO
