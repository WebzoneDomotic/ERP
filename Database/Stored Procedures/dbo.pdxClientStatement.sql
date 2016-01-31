SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 16 mai 2012
-- Description:	État de compte
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxClientStatement] ( @AgingDate Datetime, @Posted int = 1 )
as
begin
   Select i.FK_dxCurrency, d.ID as Currency, l.PK_dxClient , l.ID ClientCode,  l.Name ClientName, i.PK_dxInvoice, i.ID InvoiceNumber,
          i.TransactionDate as InvoiceDate, @AgingDate as AgingDate,
          DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) as NumberOfDays,
          i.TotalAmount as InvoiceAmount,

          dbo.fdxGetAddress( ( select PK_dxAddress from dxAddress where FK_dxClient = l.PK_dxClient and DefaultInvoicing =1 ),0,0) as Address ,

         ( select sum(cr.PaidAmount)  from dxCashReceiptInvoice cr where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate ) as TotalPaidAmount,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  0 and 30  then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N30 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  31 and 60 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N60 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  61 and 90 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N90 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) between  91 and 120 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N120 ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) > 120 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as N120P ,

         case when DATEDIFF ( Day, i.TransactionDate , @AgingDate  ) >= 31 then
           i.TotalAmount -( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr  where i.PK_dxInvoice = cr.FK_dxInvoice
           and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ) else 0.0 end as DueAmount ,

         d.Symbol+d.ID as Symbol,

         Round(i.TotalAmount,2) -Round(( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr
                           where i.PK_dxInvoice = cr.FK_dxInvoice
                             and (cr.posted = 1 or cr.posted = @Posted) and cr.TransactionDate <= @AgingDate  ),2) as BalanceAmount
   from dxInvoice i
   inner join dxClient   l on (l.PK_dxClient = i.FK_dxClient )
   inner join dxCurrency d on (d.PK_dxCurrency = i.FK_dxCurrency )

   where i.TransactionDate <= @AgingDate and i.posted = 1
     and (Round(i.TotalAmount,2) -Round(( select Coalesce(sum(cr.PaidAmount),0.0)  from dxCashReceiptInvoice cr
                            where i.PK_dxInvoice = cr.FK_dxInvoice
                              and (cr.posted = 1 or cr.posted = @Posted)
                              and cr.TransactionDate <= @AgingDate ),2)) <> 0.0
     and i.FK_dxClient in ( Select PK_Value from #dxPrimaryKeySelectionList)

   Union all

    Select
       cr.FK_dxCurrency, d.ID as Currency, l.PK_dxClient , l.ID ClientCode,  l.Name ClientName, cr.PK_dxCashReceipt, 'CR '+convert(varchar(50),cr.ID)  CashReceiptNumber,
       cr.TransactionDate as InvoiceDate, @AgingDate as AgingDate,
          DATEDIFF ( Day, cr.TransactionDate , @AgingDate  ) as NumberOfDays,
          -1.0 * cr.TotalAmount as CashReceiptAmount

      , dbo.fdxGetAddress( ( select PK_dxAddress from dxAddress where FK_dxClient = l.PK_dxClient and DefaultInvoicing =1 ),0,0) as Address


     ,-1.0 * Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)
              from dxCashReceiptInvoice ci
             where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
               and ci.posted = 1
               and ci.TransactionDate <= @AgingDate ),2) InvoiceAmount


    ,-1.0 * case when DATEDIFF ( Day, cr.TransactionDate , @AgingDate  ) between  0 and 30  then  Round((cr.TotalAmount
          - Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)
                    from dxCashReceiptInvoice ci
                   where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and ci.posted = 1
                     and ci.TransactionDate <= @AgingDate ),2)
        - Round(( select Coalesce(sum(cm.Amount),0.0)
                    from dxCashReceiptImputation cm
                   where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and cm.posted = 1
                     and cm.TransactionDate <= @AgingDate ),2)),2)
     else 0.0 end N30
    ,-1.0 * case when DATEDIFF ( Day, cr.TransactionDate , @AgingDate  ) between  31 and 60  then  Round((cr.TotalAmount
          - Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)
                    from dxCashReceiptInvoice ci
                   where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and ci.posted = 1
                     and ci.TransactionDate <= @AgingDate ),2)
        - Round(( select Coalesce(sum(cm.Amount),0.0)
                    from dxCashReceiptImputation cm
                   where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and cm.posted = 1
                     and cm.TransactionDate <= @AgingDate ),2)),2)
     else 0.0 end N60
    ,-1.0 * case when DATEDIFF ( Day, cr.TransactionDate , @AgingDate  ) between  61 and 90  then  Round((cr.TotalAmount
          - Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)
                    from dxCashReceiptInvoice ci
                   where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and ci.posted = 1
                     and ci.TransactionDate <= @AgingDate ),2)
        - Round(( select Coalesce(sum(cm.Amount),0.0)
                    from dxCashReceiptImputation cm
                   where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and cm.posted = 1
                     and cm.TransactionDate <= @AgingDate ),2)),2)
     else 0.0 end N90
    ,-1.0 * case when DATEDIFF ( Day, cr.TransactionDate , @AgingDate  ) between  91 and 120  then  Round((cr.TotalAmount
          - Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)
                    from dxCashReceiptInvoice ci
                   where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and ci.posted = 1
                     and ci.TransactionDate <= @AgingDate ),2)
        - Round(( select Coalesce(sum(cm.Amount),0.0)
                    from dxCashReceiptImputation cm
                   where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and cm.posted = 1
                     and cm.TransactionDate <= @AgingDate ),2)),2)
     else 0.0 end N120
    ,-1.0 * case when DATEDIFF ( Day, cr.TransactionDate , @AgingDate  ) > 120 then   Round((cr.TotalAmount
          - Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)
                    from dxCashReceiptInvoice ci
                   where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and ci.posted = 1
                     and ci.TransactionDate <= @AgingDate ),2)
        - Round(( select Coalesce(sum(cm.Amount),0.0)
                    from dxCashReceiptImputation cm
                   where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and cm.posted = 1
                     and cm.TransactionDate <= @AgingDate ),2)),2)
     else 0.0 end N120P

     ,-1.0 * case when DATEDIFF ( Day, cr.TransactionDate , @AgingDate  ) >= 31 then   Round((cr.TotalAmount
          - Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)
                    from dxCashReceiptInvoice ci
                   where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and ci.posted = 1
                     and ci.TransactionDate <= @AgingDate ),2)
        - Round(( select Coalesce(sum(cm.Amount),0.0)
                    from dxCashReceiptImputation cm
                   where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and cm.posted = 1
                     and cm.TransactionDate <= @AgingDate ),2)),2)
     else 0.0 end DueAmount

     , d.Symbol+d.ID as Symbol

    ,-1.0 * Round((cr.TotalAmount
          - Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)
                    from dxCashReceiptInvoice ci
                   where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and ci.posted = 1
                     and ci.TransactionDate <= @AgingDate ),2)
        - Round(( select Coalesce(sum(cm.Amount),0.0)
                    from dxCashReceiptImputation cm
                   where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                     and cm.posted = 1
                     and cm.TransactionDate <= @AgingDate ),2)),2) UnusedAmount

 From dxCashReceipt cr
 inner join dxClient   l on (l.PK_dxClient = cr.FK_dxClient )
 inner join dxCurrency d on (d.PK_dxCurrency = cr.FK_dxCurrency )
 where exists ( select 1 from  dxAccountTransaction tr where     tr.KindOfDocument = 2
                                        and PrimaryKeyValue   = cr.PK_dxCashReceipt )
   and cr.TransactionDate <= @AgingDate
   and cr.Posted = 1
   and ABS((cr.TotalAmount

        - ( Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)  from dxCashReceiptInvoice ci
                            where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                              and ci.posted = 1
                              and ci.TransactionDate <= @AgingDate ),2)
           + Round(( select Coalesce(sum(cm.Amount),0.0)  from dxCashReceiptImputation cm
                            where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                              and cm.posted = 1
                              and cm.TransactionDate <= @AgingDate ),2)))) > 0.00000001
    and cr.FK_dxClient in ( Select PK_Value from #dxPrimaryKeySelectionList)

  Order by l.ID ,i.TransactionDate asc
end;
GO
