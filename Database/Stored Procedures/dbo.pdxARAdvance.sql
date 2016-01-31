SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 16mai 2012
-- Description:	Analyse des avances client
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pdxARAdvance]  @AgingDate Datetime  
as  
begin
 Select
      PK_dxCashReceipt as FK_dxCashReceipt
    , FK_dxClient
    , TransactionDate [Date]
    , FK_dxAccount
    , FK_dxCurrency
    , FK_dxPaymentType
    , FK_dxBankAccount
    , TotalAmount
    ,Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)  from dxCashReceiptInvoice ci
                            where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                              and ci.posted = 1 
                              and ci.TransactionDate <= @AgingDate ),2) InvoiceAmount
                              
    ,Round(( select Coalesce(sum(cm.Amount),0.0)  from dxCashReceiptImputation cm
                            where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                              and cm.posted = 1 
                              and cm.TransactionDate <= @AgingDate ),2) ImputationAmount  
                                                      
    ,Round((cr.TotalAmount
  
        - Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)  from dxCashReceiptInvoice ci
                            where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                              and ci.posted = 1 
                              and ci.TransactionDate <= @AgingDate ),2)
        - Round(( select Coalesce(sum(cm.Amount),0.0)  from dxCashReceiptImputation cm
                            where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                              and cm.posted = 1 
                              and cm.TransactionDate <= @AgingDate ),2)),2) UnusedAmount
                              
    , (Select sum( Amount ) from dxAccountTransaction at 
       where FK_dxAccount = cr.FK_dxAccount 
         and at.TransactionDate <= @AgingDate ) GLAmount                         
     
 From dxCashReceipt cr 
 
 where exists ( select 1 from  dxAccountTransaction tr where     tr.KindOfDocument = 2
                                        and PrimaryKeyValue   = cr.PK_dxCashReceipt )
   and cr.TransactionDate <= @AgingDate
   and  cr.Posted = 1
   and ABS((cr.TotalAmount
  
        - ( Round(( select Coalesce(sum(ci.PaidAmount+ci.ImputationAmount),0.0)  from dxCashReceiptInvoice ci
                            where ci.FK_dxCashReceipt = cr.PK_dxCashReceipt
                              and ci.posted = 1 
                              and ci.TransactionDate <= @AgingDate ),2)
           + Round(( select Coalesce(sum(cm.Amount),0.0)  from dxCashReceiptImputation cm
                            where cm.FK_dxCashReceipt = cr.PK_dxCashReceipt
                              and cm.posted = 1 
                              and cm.TransactionDate <= @AgingDate ),2)))) > 0.00000001
end
GO
