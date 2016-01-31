SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-11-25
-- Description:	Calcul du détail des documents tel : le po, commande client , facture client et facture fournisseur
-- --------------------------------------------------------------------------------------------
create procedure [dbo].[pdxCalculateDocumentDetail] ( @PK_Doc int, @Document varchar(50) )
as
begin
  Declare  @SQL varchar(8000)
          ,@FK_dxScaleUnit__Qty int, @FK_dxScaleUnit__Amount int, @FK_dxScaleUnit int
          ,@DocumentDate Datetime
          ,@ConvertionFactor Float,@ConvertionFactorQty Float
          ,@Tax1Rate float ,@Tax2Rate float ,@Tax3Rate float
          ,@Tax1Formula varchar(200),@Tax2Formula varchar(200),@Tax3Formula varchar(200)
          ,@Where varchar(500)
          ,@FK_dxAccount__Revenue int,@FK_dxAccount__Expense int, @FK_dxAccount__Discount int,@FK_dxAccount__Receivable int
          ,@FK_dxCurrency int  
          ,@FK_dxTax int
          ,@FK_dxProject int
          ,@FK_dxProjectCategory int
          ,@FK_dxVendor         int, @FK_dxClient int
          ,@FK_dxVendorCategory int, @FK_dxCLientCategory int
          ,@FK_dxCostLevel      int, @FK_dxPriceLevel int
          ,@FK_dxProduct int
          ,@FK_dxProductCategory int
          ,@Filter1 varchar(50) ,@Filter2 varchar(50),@Filter3 varchar(50),@Filter4 varchar(50),@Filter5 varchar(50)
          ,@Filter6 varchar(50) ,@Filter7 varchar(50),@Filter8 varchar(50),@Filter9 varchar(50),@Filter  varchar(500)

  -- Set the where clause 
  set @Where = ' Where PK_'+@Document+'='+ Convert(varchar(10), @PK_Doc)
 
  -- Retrive Document tax code and document date 
  if @Document = 'dxPurchaseOrderDetail'
  begin 
     Select  @DocumentDate        = TransactionDate
           , @FK_dxCurrency       = FK_dxCurrency
           , @FK_dxTax            = FK_dxTax 
             from dxPurchaseOrder where PK_dxPurchaseOrder = ( Select FK_dxPurchaseOrder from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @PK_Doc )
     Select  @FK_dxScaleUnit__Qty    = FK_dxScaleUnit__Quantity
           , @FK_dxScaleUnit__Amount = FK_dxScaleUnit__UnitAmount 
           , @FK_dxScaleUnit         = FK_dxScaleUnit
             from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @PK_Doc 
  end
  else if @Document = 'dxClientOrderDetail' 
  begin
     Select  @DocumentDate = TransactionDate
           , @FK_dxCurrency = FK_dxCurrency
           , @FK_dxTax = FK_dxTax 
             from dxClientOrder where PK_dxClientOrder = ( Select FK_dxClientOrder from  dxClientOrderDetail where PK_dxClientOrderDetail = @PK_Doc )
     Select  @FK_dxScaleUnit__Qty    = FK_dxScaleUnit__Quantity
           , @FK_dxScaleUnit__Amount = FK_dxScaleUnit__UnitAmount 
           , @FK_dxScaleUnit         = FK_dxScaleUnit 
             from dxClientOrderDetail where PK_dxClientOrderDetail = @PK_Doc 
  end
  else if @Document = 'dxPayableInvoiceDetail' 
  begin
     Select  @DocumentDate        = TransactionDate
           , @FK_dxVendor         = FK_dxVendor
           , @FK_dxVendorCategory = Coalesce(( Select FK_dxVendorCategory from dxVendor where PK_dxVendor = FK_dxVendor),-1)
           , @FK_dxCostLevel      = Coalesce(( Select FK_dxCostLevel      from dxVendor where PK_dxVendor = FK_dxVendor),-1)
           , @FK_dxCurrency       = FK_dxCurrency
           , @FK_dxTax            = FK_dxTax 
             from dxPayableInvoice where PK_dxPayableInvoice = ( Select FK_dxPayableInvoice from dxInvoicePayableDetail where PK_dxPayableInvoiceDetail = @PK_Doc )
     Select  @FK_dxScaleUnit__Qty    = FK_dxScaleUnit__Quantity
           , @FK_dxScaleUnit__Amount = FK_dxScaleUnit__UnitAmount 
           , @FK_dxScaleUnit         = FK_dxScaleUnit
           , @FK_dxProjectCategory   = Coalesce(( Select FK_dxProjectCategory from dxProject where PK_dxProject = FK_dxProject),-1)
           , @FK_dxProject           = Coalesce(FK_dxProject,-1)
           , @FK_dxProductCategory   = Coalesce(( Select FK_dxProductCategory from dxProduct where PK_dxProduct = FK_dxProduct),-1)
           , @FK_dxProduct           = Coalesce(FK_dxProduct,-1)
             from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @PK_Doc 
  end
  else if @Document = 'dxInvoiceDetail' 
  begin
     Select  @DocumentDate        = TransactionDate
           , @FK_dxClient         = FK_dxClient
           , @FK_dxClientCategory = Coalesce(( Select FK_dxClientCategory from dxClient where PK_dxClient = FK_dxClient),-1)
           , @FK_dxPriceLevel     = Coalesce(( Select FK_dxPriceLevel     from dxClient where PK_dxClient = FK_dxClient),-1)
           , @FK_dxCurrency       = FK_dxCurrency
           , @FK_dxTax            = FK_dxTax 
             from dxInvoice where PK_dxInvoice = ( Select FK_dxInvoice from dxInvoiceDetail where PK_dxInvoiceDetail = @PK_Doc )
     Select  @FK_dxScaleUnit__Qty    = FK_dxScaleUnit__Quantity
           , @FK_dxScaleUnit__Amount = FK_dxScaleUnit__UnitAmount 
           , @FK_dxScaleUnit         = FK_dxScaleUnit
           , @FK_dxProjectCategory   = Coalesce(( Select FK_dxProjectCategory from dxProject where PK_dxProject = FK_dxProject),-1)
           , @FK_dxProject           = Coalesce(FK_dxProject,-1)
           , @FK_dxProductCategory   = Coalesce(( Select FK_dxProductCategory from dxProduct where PK_dxProduct = FK_dxProduct),-1)
           , @FK_dxProduct           = Coalesce(FK_dxProduct,-1)
             from dxInvoiceDetail where PK_dxInvoiceDetail = @PK_Doc 
  end
  -- Retrive tax rate and formula according to document date
  Select top 1 @Tax1Rate    = Coalesce(td.Tax1Rate, 0.0)
             , @Tax2Rate    = Coalesce(td.Tax2Rate, 0.0) 
             , @Tax3Rate    = Coalesce(td.Tax3Rate, 0.0)
             , @Tax1Formula = Coalesce(td.Tax1Formula, '0.0') 
             , @Tax2Formula = Coalesce(td.Tax2Formula, '0.0') 
             , @Tax3Formula = Coalesce(td.Tax3Formula, '0.0')  
  from dxTaxDetail td
  left outer join dxTax tx on ( tx.PK_dxTax = td.FK_dxTax) 
  where FK_dxTax = @FK_dxTax and EffectiveDate <=@DocumentDate
  Order by EffectiveDate Desc

  if @Tax1Formula = '' set @Tax1Formula = '0.0'
  if @Tax2Formula = '' set @Tax2Formula = '0.0'
  if @Tax3Formula = '' set @Tax3Formula = '0.0'

  --Caculate The Amount
  set @ConvertionFactor    = Coalesce((Select Top 1 Factor from dxFactorTable
                               where FK_dxScaleUnit__In = @FK_dxScaleUnit__Qty
                                 and FK_dxScaleUnit__Out= @FK_dxScaleUnit__Amount
                            Order by STEPS asc
                                ), 1.0)

  set @ConvertionFactorQty = Coalesce((Select Top 1 Factor from dxFactorTable
                               where FK_dxScaleUnit__In = @FK_dxScaleUnit__Qty
                                 and FK_dxScaleUnit__Out= @FK_dxScaleUnit
                            Order by STEPS asc
                               ), 1.0)
  set @SQL = 'Update ' + @Document + ' set Amount = Round(Quantity * ' +Convert( varchar(20), @ConvertionFactor)+' * UnitAmount , 2)' + @Where  
  Exec ( @SQL ) ; 
  -- Calculate Product Quantity
  set @SQL = 'Update ' + @Document + ' set ProductQuantity = Round( Quantity * ' +Convert( varchar(20), @ConvertionFactorQty)+', 6)' + @Where  
  Exec ( @SQL ) ; 
  -- Calculate Discount Amount
  set @SQL = 'Update ' + @Document + ' set DiscountAmount= Round(Amount * Discount /100.0 , 2)' + @Where  
  Exec ( @SQL ) ; 
   -- Calculate Total Amount Before taxes
  set @SQL = 'Update ' + @Document + ' set TotalAmountBeforeTax= Round(Amount - DiscountAmount , 2)' + @Where  
  Exec ( @SQL ) ; 

  -- Update Document detail - Taxes parameters
  set @SQL = 'Update ' + @Document + ' set Tax1Rate='+ 
              convert(varchar(20),@Tax1Rate)+', Tax2Rate='+
              convert(varchar(20),@Tax2Rate)+', Tax3Rate='+
              convert(varchar(20),@Tax3Rate)+ @Where 
  Exec ( @SQL ) ;  
 
  --Update dxTax Amount
  set @SQL = 'Update ' + @Document + ' set Tax1Amount = Round( Convert(float, ApplyTax1) * ' + @Tax1Formula + ',2) '+@Where
  Exec ( @SQL ) ; 
  set @SQL = 'Update ' + @Document + ' set Tax2Amount = Round( Convert(float, ApplyTax2) * ' + @Tax2Formula + ',2) '+@Where
  Exec ( @SQL ) ; 
  set @SQL = 'Update ' + @Document + ' set Tax3Amount = Round( Convert(float, ApplyTax3) * ' + @Tax3Formula + ',2) '+@Where
  Exec ( @SQL ) ; 
  --Update Total Amount
  set @SQL ='Update ' + @Document + ' set TaxAmount   = Round(Tax1Amount + Tax2Amount + Tax3Amount,2),'+
                                         'TotalAmount = Round(TotalAmountBeforeTax + Tax1Amount + Tax2Amount + Tax3Amount,2) '+@Where
  Exec ( @SQL ) ;
  -- Retrieve Revenue Account, Discount Account, and Receivable Account for the Invoice Detail
  If @Document = 'dxInvoiceDetail'
  begin
    select
       Top 1
       @FK_dxAccount__Revenue  = FK_dxAccount__Revenue,
       @FK_dxAccount__Discount = FK_dxAccount__Discount
    from dxAccountRevenue
    where (FK_dxCurrency        = @FK_dxCurrency)
      and (FK_dxTax             = @FK_dxTax or FK_dxTax is null)
      and (FK_dxProjectCategory = @FK_dxProjectCategory or FK_dxProjectCategory is null)
      and (FK_dxProject         = @FK_dxProject or FK_dxProject is null)
      and (FK_dxCLientCategory  = @FK_dxCLientCategory or FK_dxCLientCategory is null)
      and (FK_dxClient          = @FK_dxClient or FK_dxClient is null)
      and (FK_dxPriceLevel      = @FK_dxPriceLevel or FK_dxPriceLevel is null)
      and (FK_dxProductCategory = @FK_dxProductCategory or FK_dxProductCategory is null)
      and (FK_dxProduct         = @FK_dxProduct or FK_dxProduct is null)
    order by FK_dxCurrency desc       , FK_dxTax desc,
             FK_dxProjectCategory desc, FK_dxProject desc ,
             FK_dxCLientCategory  desc, FK_dxClient desc,
             FK_dxPriceLevel desc     , FK_dxProductCategory desc, FK_dxProduct desc

    set @SQL = 'Update ' + @Document +
               ' set  FK_dxAccount__Revenue  = '+Coalesce(convert(varchar(20),@FK_dxAccount__Revenue ),' Null ') +
               '     ,FK_dxAccount__Discount = '+Coalesce(convert(varchar(20),@FK_dxAccount__Discount),' 9999 ') +
               '     ,FK_dxAccount__Receivable = '+
               '    ( Select FK_dxAccount__Receivable from dxCurrency where PK_dxCurrency = ' + Convert(varchar(20), @FK_dxCurrency) +')' +
              @Where
    Exec ( @SQL ) ;
  end else
 -- Retrieve Expense Account, Discount Account, and Receivabe Account for the Invoice Detail
  If @Document = 'dxPayableInvoiceDetail'
  begin
    select
       Top 1
       @FK_dxAccount__Expense  = FK_dxAccount__Expense,
       @FK_dxAccount__Discount = FK_dxAccount__Discount
    from dxAccountExpense
    where (FK_dxCurrency        = @FK_dxCurrency)
      and (FK_dxTax             = @FK_dxTax or FK_dxTax is null)
      and (FK_dxProjectCategory = @FK_dxProjectCategory or FK_dxProjectCategory is null)
      and (FK_dxProject         = @FK_dxProject or FK_dxProject is null)
      and (FK_dxVendorCategory  = @FK_dxVendorCategory or FK_dxVendorCategory is null)
      and (FK_dxVendor          = @FK_dxVendor or FK_dxVendor is null)
      and (FK_dxCostLevel       = @FK_dxCostLevel or FK_dxCostLevel is null)
      and (FK_dxProductCategory = @FK_dxProductCategory or FK_dxProductCategory is null)
      and (FK_dxProduct         = @FK_dxProduct or FK_dxProduct is null)
    order by FK_dxCurrency desc       , FK_dxTax desc,
             FK_dxProjectCategory desc, FK_dxProject desc ,
             FK_dxVendorCategory  desc, FK_dxVendor desc,
             FK_dxCostLevel desc      , FK_dxProductCategory desc, FK_dxProduct desc

    set @SQL = 'Update ' + @Document +
               ' set  FK_dxAccount__Expense  = '+Coalesce(convert(varchar(20),@FK_dxAccount__Expense ),' Null ') +
               '     ,FK_dxAccount__Discount = '+Coalesce(convert(varchar(20),@FK_dxAccount__Discount),' 9999 ') +
               '     ,FK_dxAccount__Payable = '+
               '    ( Select FK_dxAccount__Payable from dxCurrency where PK_dxCurrency = ' + Convert(varchar(20), @FK_dxCurrency) +')' +
              @Where
    Exec ( @SQL ) ;
  end

end
GO
