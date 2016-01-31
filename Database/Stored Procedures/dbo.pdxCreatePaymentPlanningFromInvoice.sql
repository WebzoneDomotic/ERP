SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-03-23
-- Description:	Création d'une planification de paiement à partir d'une facture à payer
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxCreatePaymentPlanningFromInvoice]  @FK_dxPayableInvoice int 
as
Begin

  --Declare  @FK_dxPayableInvoice int
  --Set  @FK_dxPayableInvoice =48536 

  Declare @PK_dxPaymentPlanning int;
  Declare @newseed int ;
  set @PK_dxPaymentPlanning = -1
  --set @newseed = ( select coalesce(max(PK_dxPaymentPlanning),1) from dxPaymentPlanning ) ;
  --DBCC CHECKIDENT ( 'dxPaymentPlanning' , RESEED, @newseed  );

  -- Check if we have already an invoice for this PaymentPlanning
  set @PK_dxPaymentPlanning = Coalesce((Select Max(FK_dxPaymentPlanning) from dxPaymentPlanningDetail where FK_dxPayableInvoice = @FK_dxPayableInvoice),-1 )
  -- if we  dont have an invoice we create it
  if @PK_dxPaymentPlanning = -1 
  begin
    Print @PK_dxPaymentPlanning
    Insert Into dxPaymentPlanning (
         [PaymentDate]
        ,[NumberOfChequeToDo]
        ,[FK_dxBankAccount]
       )   
    Select
        TransactionDate
       ,1 
       ,Coalesce(ve.FK_dxBankAccount, ( Select top 1 ba.PK_dxBankAccount from dxBankAccount ba where FK_dxCurrency = py.FK_dxCurrency))
    From dxPayableInvoice py
    left join dxVendor ve on (  ve.PK_dxVendor = py.FK_dxVendor )
    where PK_dxPayableInvoice = @FK_dxPayableInvoice
      and Posted = 1
    -- Get the Primary Key  
    set @PK_dxPaymentPlanning = ( Select IDENT_CURRENT('dxPaymentPlanning') );
    -- Insert detail in this Planning
    INSERT INTO [dxPaymentPlanningDetail]
             (      
             [FK_dxPaymentPlanning]
            ,[Approuved]
            ,[FK_dxVendor]
            ,[FK_dxPayableInvoice]
            ,[InvoiceDate]
            ,[SuggestPaymentDate]
            ,[NumberOfDays]
            ,[ActualBalanceAmount]
            ,[AmountToPay]
            ,[FK_dxCurrency])
            
     Select
         @PK_dxPaymentPlanning
        ,1
        ,py.FK_dxVendor
        ,@FK_dxPayableInvoice
        ,py.TransactionDate
        ,py.TransactionDate
        ,0
        ,py.TotalAmount  
        ,py.TotalAmount
        ,py.FK_dxCurrency
     From dxPayableInvoice py where PK_dxPayableInvoice = @FK_dxPayableInvoice
   end 

   Select @PK_dxPaymentPlanning  as PK_dxPaymentPlanning
end
GO
