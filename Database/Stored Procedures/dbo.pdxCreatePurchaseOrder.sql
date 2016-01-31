SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-11-28
-- Description:	Création d'un Bon de commande Fournisseur
-- --------------------------------------------------------------------------------------------
create  procedure [dbo].[pdxCreatePurchaseOrder] ( @FK_dxVendor int, @Date Datetime, @CreateNewPO int = 1 )
as
begin
  Set NOCOUNT on
  -- Set the auto increment to the highest value
  Declare @newseed int, @PK_dxPurchaseOrder int ;
  --set @newseed = ( select coalesce(max(PK_dxPurchaseOrder),30000) from dxPurchaseOrder ) ;
  --DBCC CHECKIDENT ( 'dxPurchaseOrder' , RESEED, @newseed  );

  Set @PK_dxPurchaseOrder  =
       Coalesce(( Select Max(po.PK_dxPurchaseOrder)
                    from dxPurchaseOrderDetail pd
                    left join dxPurchaseOrder po on (po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder)
                   where po.FK_dxVendor = @FK_dxVendor
                     and pd.ExpectedReceptionDate = @Date
                     and po.Posted = 0
                     and po.Closed = 0 ),-1)

  if @CreateNewPO = 1 Set @PK_dxPurchaseOrder = -1

  if @PK_dxPurchaseOrder < 0
  begin
    insert into dxPurchaseOrder (
       FK_dxVendor
      ,FK_dxCurrency
      ,TransactionDate
      --,FK_dxTerms
      ,FK_dxAddress__Billing
      ,BillingAddress
      ,FK_dxAddress__Shipping
      ,ShippingAddress
      ,FK_dxTax
      ,FK_dxFOB
      ,FK_dxShipVia
      ,FK_dxShippingServiceType)
    Select
      PK_dxVendor as FK_dxVendor
     ,FK_dxCurrency
     , dbo.fdxGetDateNoTime(GetDate()) --@Date
     --,FK_dxTerms
     -- Ordered From and Billing Address
     , Coalesce( ( Select top 1 PK_dxAddress from dxAddress where FK_dxVendor = ve.PK_dxVendor and DefaultPayment = 1 ),
                 ( Select top 1 PK_dxAddress from dxAddress where FK_dxVendor = ve.PK_dxVendor order by DefaultPayment desc ))as FK_dxAddress__Billing
     ,dbo.fdxGetAddress ( Coalesce( ( Select top 1 PK_dxAddress from dxAddress where FK_dxVendor = ve.PK_dxVendor and DefaultPayment = 1 ),
                                    ( Select top 1 PK_dxAddress from dxAddress where FK_dxVendor = ve.PK_dxVendor order by DefaultPayment desc )),1,0 ) as BillingAddress
     -- Shipping to Address
     , Coalesce( ( Select top 1 PK_dxAddress from dxAddress where NOT FK_dxSetup is null and DefaultShipping = 1 ),
                 ( Select top 1 PK_dxAddress from dxAddress where NOT FK_dxSetup is null order by DefaultShipping desc ))as FK_dxAddress__Shipping

     ,dbo.fdxGetAddress ( Coalesce( ( Select top 1 PK_dxAddress from dxAddress where NOT FK_dxSetup is null and DefaultShipping = 1 ),
                 ( Select top 1 PK_dxAddress from dxAddress where NOT FK_dxSetup is null order by DefaultShipping desc )),1,0 ) as ShippingAddress
     , 1 -- Default
     ,ve.FK_dxFOB
     ,ve.FK_dxShipVia
     ,ve.FK_dxShippingServiceType
    From dxVendor ve where PK_dxVendor = @FK_dxVendor
    -- Get the PK
    set @PK_dxPurchaseOrder = ( Select IDENT_CURRENT('dxPurchaseOrder') );
  end

  -- Update Taxes group corresponding to the shipping address
  Update dxPurchaseOrder set FK_dxTax = Coalesce(( Select Max(FK_dxTax) from dxAddress where PK_dxAddress =
              ( select FK_dxAddress__Shipping from dxPurchaseOrder where PK_dxPurchaseOrder = @PK_dxPurchaseOrder )), 1)
  where PK_dxPurchaseOrder = @PK_dxPurchaseOrder
  Set NOCOUNT off
end
GO
