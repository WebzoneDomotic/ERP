SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-11-08
-- Description:	Vendor Payment Speed
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxPayablePaymentSpeed]  @AgingDate Datetime , @FK_dxVendor int, @Posted int = 1
as
Begin

    Set @AgingDate = Coalesce( @AgingDate, GetDate())
    Set @FK_dxVendor = Coalesce( @FK_dxVendor, -1)

    Select i.FK_dxCurrency,  l.PK_dxVendor as FK_dxVendor,  l.ID as VendorCode,  l.Name as VendorName, i.PK_dxPayableInvoice,  i.ID InvoiceNumber,
           i.TransactionDate as InvoiceDate,  
           DatePart(yy,i.TransactionDate) as Year,
           DatePart(mm,i.TransactionDate) as Month,
           DATEDIFF ( Day, i.TransactionDate , Coalesce((Select max(TransactionDate) 
                                                  from dxPaymentInvoice py 
                                                  where i.PK_dxPayableInvoice = py.FK_dxPayableInvoice),  @AgingDate)  ) as NumberOfDays,
                                                  
           (Select max(TransactionDate)from dxPaymentInvoice py where i.PK_dxPayableInvoice = py.FK_dxPayableInvoice) LastPaymentDate,                                      
           i.TotalAmount as InvoiceAmount,

          ( select sum(cr.PaidAmount)  from dxPaymentInvoice cr where i.PK_dxPayableInvoice = cr.FK_dxPayableInvoice
            and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <=@AgingDate ) as TotalPaidAmount,

            case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  0 and 30  then
              i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxPaymentInvoice cr  where i.PK_dxPayableInvoice = cr.FK_dxPayableInvoice
              and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N30 ,

            case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  31 and 45 then
              i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxPaymentInvoice cr  where i.PK_dxPayableInvoice = cr.FK_dxPayableInvoice
              and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N45 ,

            case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  46 and 60 then
              i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxPaymentInvoice cr  where i.PK_dxPayableInvoice = cr.FK_dxPayableInvoice
              and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N60 ,

            case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  61 and 90 then
              i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxPaymentInvoice cr  where i.PK_dxPayableInvoice = cr.FK_dxPayableInvoice
              and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N90 ,

            case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  91 and 120 then
              i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxPaymentInvoice cr where i.PK_dxPayableInvoice = cr.FK_dxPayableInvoice
              and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N120 ,

            case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) > 120  then
              i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxPaymentInvoice cr  where i.PK_dxPayableInvoice = cr.FK_dxPayableInvoice
              and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N120P ,

           Round(i.TotalAmount,2) -Round(( select Coalesce(sum(cr.PaidAmount),0.0)  from dxPaymentInvoice cr where i.PK_dxPayableInvoice = cr.FK_dxPayableInvoice
              and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ),2) as BalanceAmount

    from dxPayableInvoice i
         inner join dxVendor l on (l.PK_dxVendor  = i.FK_dxVendor  )
         inner join dxCurrency d on (d.PK_dxCurrency = i.FK_dxCurrency )

    where i.TransactionDate <= @AgingDate
      and i.posted = 1
      and i.FK_dxVendor = @FK_dxVendor
End
GO
