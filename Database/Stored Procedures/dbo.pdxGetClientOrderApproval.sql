SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 09 mars 2012
-- Description:	Vérification du crédit délinquant
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxGetClientOrderApproval]  @FK_dxClientOrder int
as
begin

   Declare @AR Table ( NumberOfDays float, Aging float )
   Declare @AgingDate Datetime
   Declare @FK_dxClient int
   Declare @CurrentOrderAmount float
   Declare @FK_dxEmployee__ApprovedBy int
   Declare @OrderOverTotalAmount Float
   Declare @CurrentOrdersOverTotalAmount Float
   Declare @OverdueAccountTotalAmount Float
   Declare @OverdueAccountInDays int
   Declare @CreditLimit Float

   Set @AgingDate = GETDATE()
   Select   @FK_dxClient =FK_dxClient
          , @CurrentOrderAmount = TotalAmount
          , @FK_dxEmployee__ApprovedBy=FK_dxEmployee__ApprovedBy
          , @OrderOverTotalAmount         = OrderOverTotalAmount
          , @CurrentOrdersOverTotalAmount = CurrentOrdersOverTotalAmount
          , @OverdueAccountTotalAmount    = OverdueAccountTotalAmount
          , @OverdueAccountInDays         = OverdueAccountInDays
          , @CreditLimit                  = CreditLimit
   from dbo.dxClientOrder co
   left outer join dxClient cl on ( cl.PK_dxClient = co.FK_dxClient )
   where PK_dxClientOrder =  @FK_dxClientOrder

   insert into @AR
   Select
         DATEDIFF(day,i.TransactionDate, @AgingDate )
       , Round(i.TotalAmount,2) -Round(( select Coalesce(sum(cr.PaidAmount),0.0)  from dbo.dxCashReceiptInvoice cr
                           where i.PK_dxInvoice = cr.FK_dxInvoice
                             and cr.posted = 1 and cr.TransactionDate <= @AgingDate  ),2)
   from dbo.dxInvoice i
   inner join dbo.dxClient   l on (l.PK_dxClient = i.FK_dxClient )
   inner join dbo.dxCurrency d on (d.PK_dxCurrency = i.FK_dxCurrency )
   where i.TransactionDate <=  @AgingDate and i.posted = 1
     and i.FK_dxClient = @FK_dxClient

   Select
     max(NumberOfDays) as MaxDueDays
   , sum(Aging)        as AgingAmount
   , Coalesce(( Select SUM(cd.TotalAmount) From dbo.dxClientOrderDetail cd
         left outer join dxClientOrder co on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
        where co.FK_dxClient = @FK_dxclient and cd.Closed = 0 ),0.0) as UnShippedOrdersTotalAmount
   , Coalesce(@CurrentOrderAmount,0.0) as CurrentOrderAmount
   , @FK_dxEmployee__ApprovedBy  as FK_dxEmployee__ApprovedBy
   , @CreditLimit as CreditLimit
   , Coalesce(@OrderOverTotalAmount,0.0) as OrderOverTotalAmount
   , Coalesce(@CurrentOrdersOverTotalAmount,0.0) as CurrentOrdersOverTotalAmount
   , Coalesce(@OverdueAccountTotalAmount,0.0) as OverdueAccountTotalAmount
   , Coalesce(@OverdueAccountInDays,0.0) as OverdueAccountInDays
   from @AR
   where Aging <> 0.0
end
GO
