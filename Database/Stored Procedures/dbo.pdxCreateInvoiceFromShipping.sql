SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-04-12
-- Description:	Création de la facture à partir d'une livraison
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxCreateInvoiceFromShipping] @PK_dxShipping int
as
Begin
  Declare @PK_dxInvoice int;
  Declare @newseed int ;
  --set @newseed = ( select coalesce(max(PK_dxInvoice),20000) from dxInvoice ) ;
  --DBCC CHECKIDENT ( 'dxInvoice' , RESEED, @newseed  );

  -- Check if we have already an invoice for this shipping
  set @PK_dxInvoice = Coalesce(( Select Max(PK_dxInvoice) from dxInvoice where FK_dxShipping = @PK_dxShipping and Posted = 0 ),-1)

  -- if we  dont have an invoice we create it
  if @PK_dxInvoice = -1
  begin
    Insert Into dxInvoice (
    FK_dxClient,
    FK_dxCurrency,
    TransactionDate,
    FK_dxShipping,
    FK_dxAddress__Billing,
    FK_dxAddress__Shipping,
    FK_dxTax,
    FK_dxTerms,
    FK_dxFOB,
    FK_dxShipVia,
    FK_dxNote,
    FK_dxPaymentType,
    Note
    )
    Select
    po.FK_dxClient,
    MAX(po.FK_dxCurrency),
    Max(re.TransactionDate),
    @PK_dxShipping,
    Max(po.FK_dxAddress__Billing),
    Max(po.FK_dxAddress__Shipping),
    Max(po.FK_dxTax),
    MAX(FK_dxTerms),
    Max(po.FK_dxFOB),
    Max(re.FK_dxShipVia),
    Max(po.FK_dxNote),
    Max(Coalesce(po.FK_dxPaymentType, ve.FK_dxPaymentType) ),
    Max(po.Note)

    from dxShippingDetail rd
    left join dxShipping            re on ( re.PK_dxShipping           = rd.FK_dxShipping )
    left join dxProduct             pr on ( pr.PK_dxProduct            = rd.FK_dxProduct )
    left join dxClientOrderDetail   pd on ( pd.PK_dxClientOrderDetail  = rd.FK_dxClientOrderDetail )
    left join dxClientOrder         po on ( po.PK_dxClientOrder        = rd.FK_dxClientOrder )
    left join dxClient              ve on ( ve.PK_dxClient             = po.FK_dxClient )

    where re.PK_dxShipping  = @PK_dxShipping
    and   abs( rd.Quantity - rd.BilledQuantity ) > 0.0000001
    and   rd.ConsiderAsBilled = 0
    and   re.Posted = 1
    Group by po.FK_dxClient ;
    -- Get the invoice PK
    set @PK_dxInvoice = Coalesce(( Select Max(PK_dxInvoice) from dxInvoice where FK_dxShipping = @PK_dxShipping and Posted = 0 ),-1)
  end else
    Delete from dxInvoiceDetail where FK_dxInvoice = @PK_dxInvoice;


  -- Update the invoice date with the date of the shipping data
  Update dxInvoice set TransactionDate = ( Select TransactionDate From dxShipping where PK_dxShipping = @PK_dxShipping )
  where PK_dxInvoice = @PK_dxInvoice;

  -- Insert detail that we have to ship
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
             ,[FK_dxAccount__AR_Tax1]
             ,[FK_dxAccount__AR_Tax2]
             ,[FK_dxAccount__AR_Tax3]
             ,[ApplyTax1]
             ,[ApplyTax2]
             ,[ApplyTax3]
             ,[FK_dxShipping]
             ,[FK_dxShippingDetail]
             ,[FK_dxClientOrder], RANK)
  Select

    @PK_dxInvoice,
    pd.FK_dxProject,
    pd.FK_dxProduct,
    rd.Lot,
    pd.Description,
    rd.Quantity,
    pd.FK_dxScaleUnit__Quantity,
    pd.UnitAmount,
    pd.FK_dxScaleUnit__UnitAmount,
    pd.FK_dxScaleUnit,
    pd.Discount,
    pd.FK_dxAccount__Revenue,
    ( select FK_dxAccount__AR_Tax1 from dbo.dxTax where PK_dxTax = Coalesce(ad.FK_dxTax,1) ),
    ( select FK_dxAccount__AR_Tax2 from dbo.dxTax where PK_dxTax = Coalesce(ad.FK_dxTax,1) ),
    ( select FK_dxAccount__AR_Tax3 from dbo.dxTax where PK_dxTax = Coalesce(ad.FK_dxTax,1) ),
    pd.ApplyTax1,
    pd.ApplyTax2,
    pd.ApplyTax3,
    rd.FK_dxShipping,
    rd.PK_dxShippingDetail,
    rd.FK_dxClientOrder, Coalesce(pd.RANK,0)

  from dxShippingDetail rd
  left join dxShipping            re on ( re.PK_dxShipping           = rd.FK_dxShipping )
  left join dxAddress             ad on ( ad.PK_dxAddress            = re.FK_dxAddress__Shipping)
  left join dxProduct             pr on ( pr.PK_dxProduct            = rd.FK_dxProduct )
  left join dxClientOrderDetail   pd on ( pd.PK_dxClientOrderDetail  = rd.FK_dxClientOrderDetail )
  left join dxClientOrder         po on ( po.PK_dxClientOrder        = rd.FK_dxClientOrder )
  left join dxClient              ve on ( ve.PK_dxClient             = po.FK_dxClient )

  where re.PK_dxShipping  = @PK_dxShipping
  --and   abs( rd.Quantity - rd.BilledQuantity ) > 0.0000001
  and   rd.Quantity >= 0.0
  and   rd.ConsiderAsBilled = 0
  and   re.Posted = 1 ;

  Exec dbo.pdxCalculateInvoice  @PK_dxInvoice = @PK_dxInvoice ;

  -- Return invoice number
  Select @PK_dxInvoice as PK_dxInvoice ;
end
GO
