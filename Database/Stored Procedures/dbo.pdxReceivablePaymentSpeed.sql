SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-08
-- Description:	Client Payment Speed
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pdxReceivablePaymentSpeed]  @AgingDate Datetime , @FK_dxClient int, @Posted int = 1
AS
Begin
   Set @AgingDate = Coalesce( @AgingDate, GetDate())
   Set @FK_dxClient = Coalesce( @FK_dxClient, -1)
   
   Select i.FK_dxCurrency, l.PK_dxClient as FK_dxClient, l.ID ClientCode,  l.Name ClientName, i.PK_dxInvoice, i.ID InvoiceNumber,
          i.TransactionDate as InvoiceDate,
          DatePart(yy,i.TransactionDate) as Year,
          DatePart(mm,i.TransactionDate) as Month,
          
          DATEDIFF ( Day, i.TransactionDate , Coalesce((Select max(TransactionDate) 
                                                  from dxCashReceiptInvoice py 
                                                  where i.PK_dxInvoice = py.FK_dxInvoice),  @AgingDate)  ) as NumberOfDays,
         (Select max(TransactionDate)from dxCashReceiptInvoice py where i.PK_dxInvoice = py.FK_dxInvoice) LastPaymentDate,
         i.TotalAmount as InvoiceAmount,

         ( select sum(cr.PaidAmount)  from dxCashReceiptInvoice cr where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate ) as TotalPaidAmount,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  0 and 30  then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N30 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  31 and 45 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N45 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  46 and 60 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N60 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  61 and 90 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N90 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  91 and 120 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N120 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) > 120  then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate ) else 0.0 end as N120P ,

         Round(i.TotalAmount,2) -Round(( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr
                           where i.PK_dxInvoice = cr.FK_dxInvoice
                             and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ),2) as BalanceAmount
   from dxInvoice i
   inner join dxClient   l on (l.PK_dxClient = i.FK_dxClient )
   inner join dxCurrency d on (d.PK_dxCurrency = i.FK_dxCurrency )

   where i.TransactionDate <= @AgingDate
     and i.posted = 1
     and i.FK_dxClient = @FK_dxClient
end
GO
