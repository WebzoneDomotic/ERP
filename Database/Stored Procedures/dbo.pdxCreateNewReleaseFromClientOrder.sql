SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-03-26
-- Description:	Création du shipping une commande client
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxCreateNewReleaseFromClientOrder] @FK_dxClientOrder int , @ReleaseDate Datetime
as
begin
   Declare @Posted integer
   Declare @NewReleaseNumber int
   Declare @CurrentShipping int

   -- Check if we have a shipping related to this clientOrder not posted
   set @Posted            = Coalesce(( Select Min(Convert(integer,Posted)) from dxShipping where FK_dxClientOrder = @FK_dxClientOrder ), 1)
   set @CurrentShipping   = Coalesce(( Select Max(PK_dxShipping)           from dxShipping where FK_dxClientOrder = @FK_dxClientOrder and Posted = 0 ), -1)
   set @NewReleaseNumber  = Coalesce(( Select Max(ReleaseNumber)+1 from dxShipping where FK_dxClientOrder = @FK_dxClientOrder ), 1)

   -- If we didnt find an unposted shipping related
   -- to this client order we create one
   if @Posted = 1
   begin
     insert into dxShipping
      ( FK_dxClient
      , TransactionDate
      , FK_dxAddress__Billing
      , BillingAddress
      , FK_dxAddress__Shipping
      , ShippingAddress
      , FK_dxFOB
      , FK_dxShipVia
      , FK_dxShippingServiceType
      , FK_dxClientOrder
      , ReleaseNumber )

     Select
        FK_dxClient
      , ExpectedDeliveryDate
      , FK_dxAddress__Billing
      , BillingAddress
      , FK_dxAddress__Shipping
      , ShippingAddress
      , FK_dxFOB
      , FK_dxShipVia
      , FK_dxShippingServiceType
      , @FK_dxClientOrder
      , @NewReleaseNumber
     From dxClientOrder
    where PK_dxClientOrder = @FK_dxClientOrder
      and Closed = 0
   end else
   -- we update unposted current release with new information
   begin
     Update sh
     set sh.FK_dxClient              = co.FK_dxClient
       , sh.TransactionDate          = co.ExpectedDeliveryDate
       , sh.FK_dxAddress__Billing    = co.FK_dxAddress__Billing
       , sh.BillingAddress           = co.BillingAddress
       , sh.FK_dxAddress__Shipping   = co.FK_dxAddress__Shipping
       , sh.ShippingAddress          = co.ShippingAddress
       , sh.FK_dxFOB                 = co.FK_dxFOB
       , sh.FK_dxShipVia             = co.FK_dxShipVia
       , sh.FK_dxShippingServiceType = co.FK_dxShippingServiceType
     From dxShipping sh
     left join dxClientOrder co on (co.PK_dxClientOrder = sh.FK_dxClientOrder)
     where sh.PK_dxShipping = @CurrentShipping
       and sh.Posted        = 0
   end
end
GO
