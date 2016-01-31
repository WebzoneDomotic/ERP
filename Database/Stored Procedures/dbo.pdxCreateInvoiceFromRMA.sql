SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-05-07
-- Description:	Create Invoice From RMA
-- --------------------------------------------------------------------------------------------
CREATE Procedure [dbo].[pdxCreateInvoiceFromRMA] @PK_dxRMA int
as
Begin

  Declare @PK_dxInvoice int;
  Declare @newseed int ;
  --set @newseed = ( select coalesce(max(PK_dxInvoice),20000) from dxInvoice ) ;
  --DBCC CHECKIDENT ( 'dxInvoice' , RESEED, @newseed  );

  -- Create invoice
  Insert Into dxInvoice (
    FK_dxClient,
    FK_dxCurrency,
    TransactionDate,
    FK_dxAddress__Billing,
    FK_dxAddress__Shipping,
    CreditNote,
    FK_dxTax,
    FK_dxTerms,
    FK_dxFOB,
    FK_dxShipVia,
    FK_dxNote,
    Note
  )
  Select
    re.FK_dxClient,
    Coalesce(MAX(po.FK_dxCurrency), MAX(ve.FK_dxCurrency)) FK_dxCurrency,
    Max(re.TransactionDate) TransactionDate,
    Coalesce(Max(po.FK_dxAddress__Billing), Max(ai.PK_dxAddress)) FK_dxAddress__Billing,
    Coalesce(Max(po.FK_dxAddress__Shipping), Max(ad.PK_dxAddress)) FK_dxAddress__Shipping,
    1,
    Coalesce(Coalesce(Max(po.FK_dxTax), Max(ad.FK_dxTax)), 1) FK_dxTax,
    Coalesce(MAX(ve.FK_dxTerms), 1) FK_dxTerms,
    Coalesce(Coalesce(Max(po.FK_dxFOB), Max(ve.FK_dxFOB)), 1) FK_dxFOB,
    Coalesce(Coalesce(Coalesce(Max(re.FK_dxShipVia), Max(po.FK_dxShipVia)), Max(ve.FK_dxShipVia)), 1) FK_dxShipVia,
    Coalesce(Coalesce(Max(re.FK_dxNote), Max(po.FK_dxNote)), Max(ve.FK_dxNote)) FK_dxNote,
    Coalesce(Coalesce(Max(re.Note), Max(po.Note)), Max(ve.Note)) Note

  from dxRMA re
  left outer join dxClient              ve on ( ve.PK_dxClient             = re.FK_dxClient )
  left outer join dxRMADetail           rd on ( rd.FK_dxRMA                = re.PK_dxRMA )
  left outer join dxProduct             pr on ( pr.PK_dxProduct            = rd.FK_dxProduct )
  left outer join dxClientOrderDetail   pd on ( pd.PK_dxClientOrderDetail  = rd.FK_dxClientOrderDetail )
  left outer join dxClientOrder         po on ( po.PK_dxClientOrder        = pd.FK_dxClientOrder )
  left outer join dxAddress             ai on ( ai.FK_dxClient             = ve.PK_dxClient and ai.DefaultInvoicing = 1 and ai.Active = 1)
  left outer join dxAddress             ad on ( ad.FK_dxClient             = ve.PK_dxClient and ai.DefaultShipping = 1 and ai.Active = 1)
  where re.PK_dxRMA  = @PK_dxRMA
  and   re.Posted = 1

  Group by re.FK_dxClient ;

  set @PK_dxInvoice = ( select coalesce(max(PK_dxInvoice),20000) from dxInvoice ) ;

  INSERT INTO [dxInvoiceDetail]
             ([FK_dxInvoice]
             ,[FK_dxProject]
             ,[FK_dxProduct]
             ,[Lot]
             ,[Description]
             ,[Quantity]
             ,[FK_dxScaleUnit__Quantity]
             ,[UnitAmount]
             ,[FK_dxScaleUnit__UnitAmount]
             ,[FK_dxScaleUnit]
             ,[Discount]
             ,[FK_dxAccount__Revenue]
             ,[ApplyTax1]
             ,[ApplyTax2]
             ,[ApplyTax3]
             ,[FK_dxClientOrder]
             ,[FK_dxRMADetail])

  Select
    @PK_dxInvoice,
    pd.FK_dxProject,
    Coalesce(rd.FK_dxProduct, pd.FK_dxProduct) FK_dxProduct,
    rd.Lot,
    rd.Description,
    rd.ReturnedQuantity * -1 ReturnedQuantity,
    Coalesce(Coalesce(rd.FK_dxScaleUnit__Quantity, pd.FK_dxScaleUnit__Quantity), 1) FK_dxScaleUnit__Quantity,
    Coalesce(pd.UnitAmount,0.0) UnitAmount,
    Coalesce(pd.FK_dxScaleUnit__UnitAmount, 0.0) FK_dxScaleUnit__UnitAmount,
    Coalesce(pd.FK_dxScaleUnit, rd.FK_dxScaleUnit) FK_dxScaleUnit,
    Coalesce(pd.Discount, 0) Discount,
    pd.FK_dxAccount__Revenue,
    Coalesce(pd.ApplyTax1, pr.ApplyTax1) ApplyTax1,
    Coalesce(pd.ApplyTax2, pr.ApplyTax1) ApplyTax2,
    Coalesce(pd.ApplyTax3, pr.ApplyTax1) ApplyTax3,
    pd.FK_dxClientOrder,
    rd.PK_dxRMADetail

  from dxRMADetail rd
  left outer join dxRMA                 re on ( re.PK_dxRMA                = rd.FK_dxRMA )
  left outer join dxProduct             pr on ( pr.PK_dxProduct            = rd.FK_dxProduct )
  left outer join dxClientOrderDetail   pd on ( pd.PK_dxClientOrderDetail  = rd.FK_dxClientOrderDetail )
  left outer join dxClientOrder         po on ( po.PK_dxClientOrder        = pd.FK_dxClientOrder )
  left outer join dxClient              ve on ( ve.PK_dxClient             = po.FK_dxClient )

  where re.PK_dxRMA  = @PK_dxRMA
  and   re.Posted = 1 ;

  Exec dbo.pdxCalculateInvoice  @PK_dxInvoice = @PK_dxInvoice ;

  -- Update Taxes

  Update pd
       set  pd.FK_dxAccount__AR_Tax1 = ta.FK_dxAccount__AR_Tax1
           ,pd.FK_dxAccount__AR_Tax2 = ta.FK_dxAccount__AR_Tax2
           ,pd.FK_dxAccount__AR_Tax3 = ta.FK_dxAccount__AR_Tax3
           ,pd.Tax1Rate  = Coalesce(( Select Top 1 Tax1Rate From dxTaxDetail
                                       where FK_dxTax = ta.PK_dxTax and Effectivedate <= ei.Transactiondate
                                       order by EffectiveDate desc ), 0.0)
           ,pd.Tax2Rate  = Coalesce(( Select Top 1 Tax2Rate From dxTaxDetail
                                       where FK_dxTax = ta.PK_dxTax and Effectivedate <= ei.Transactiondate
                                       order by EffectiveDate desc ), 0.0)
           ,pd.Tax3Rate  = Coalesce(( Select Top 1 Tax3Rate From dxTaxDetail
                                       where FK_dxTax = ta.PK_dxTax and Effectivedate <= ei.Transactiondate
                                       order by EffectiveDate desc ), 0.0)
           ,pd.FK_dxAccount__Receivable = cu.FK_dxAccount__Receivable
    From dxInvoice ei
    left join dxInvoiceDetail pd on (pd.FK_dxInvoice = ei.PK_dxInvoice )
    left join dxTax ta on (ei.FK_dxTax = ta.PK_dxTax )
    left join dxCurrency cu on (ei.FK_dxCurrency = cu.PK_dxCurrency )
    Where PK_dxInvoice = @PK_dxInvoice


  Select @PK_dxInvoice as PK_dxInvoice ;

end
GO
