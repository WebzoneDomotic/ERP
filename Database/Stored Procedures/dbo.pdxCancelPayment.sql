SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 9 septembre 2012
-- Description:	Cancel a payment
-- --------------------------------------------------------------------------------------------
CREATE procedure [dbo].[pdxCancelPayment]  @FK_dxPayment int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Declare @FK_dxPayment__Cancellation int, @CancelDate Datetime, @PaymentDate Datetime
	
	-- Get Starting Date from First Open Period
	Set @CancelDate  = ( Select top 1 StartDate from dxPeriod where AccountingIsClosed = 0 order by PK_dxPeriod asc )
	
	-- Get Max Transaction Date on this payment
	Set @PaymentDate = ( Select TransactionDate from dxPayment where PK_dxPayment = @FK_dxPayment )
	if @PaymentDate > @CancelDate set @CancelDate = @PaymentDate
	Set @PaymentDate = Coalesce(( Select max(TransactionDate) from dxPaymentInvoice where FK_dxPayment = @FK_dxPayment ), @CancelDate)
	if @PaymentDate > @CancelDate set @CancelDate = @PaymentDate
	Set @PaymentDate = Coalesce(( Select max(TransactionDate) from dxPaymentImputation where FK_dxPayment = @FK_dxPayment ), @CancelDate)
	if @PaymentDate > @CancelDate set @CancelDate = @PaymentDate
		
	INSERT INTO [dbo].[dxPayment]
           ([FK_dxVendor]
           ,[PaidTo]
           ,[Address]
           ,[TransactionDate]
           ,[FK_dxCurrency]
           ,[FK_dxPaymentType]
           ,[FK_dxBankAccount]
           ,[ChequeNumber]
           ,[Reference]
           ,[TotalAmount]
           ,[TextAmount]
           ,[InvoiceAmount]
           ,[ImputationAmount]
           ,[UnusedAmount]
           ,[Posted]
           ,[PaymentCompleted]
           ,[NumberOfPrint]
           ,[FK_dxAccount]
           ,[FK_dxPaymentPlanning]
           ,[DocumentStatus])

    SELECT [FK_dxVendor]
          ,[PaidTo]
          ,[Address]
          ,@CancelDate
          ,[FK_dxCurrency]
          ,[FK_dxPaymentType]
          ,[FK_dxBankAccount]
          ,[ChequeNumber]
          ,Convert(varchar(255),'Renversement / Reversal '+Coalesce([Reference],''))
          ,-1.0 *[TotalAmount]
          ,[TextAmount]
          ,-1.0 *[InvoiceAmount]
          ,-1.0 *[ImputationAmount]
          ,-1.0 *[UnusedAmount]
          ,0
          ,0
          ,0
          ,[FK_dxAccount]
          ,Null
          ,[DocumentStatus]
    FROM [dbo].[dxPayment] where PK_dxPayment = @FK_dxPayment
    
    SET @FK_dxPayment__Cancellation = (SELECT IDENT_CURRENT('dxPayment')); 

    INSERT INTO [dbo].[dxPaymentInvoice]
           ([FK_dxPayment]
           ,[FK_dxPayableInvoice]
           ,[PaidAmount]
           ,[TotalAmount]
           ,[BalanceAmount]
           ,[NewBalanceAmount]
           ,[TransactionDate]
           ,[Posted]
           ,[ImputationAmount]
           ,[FK_dxAccount__InvoiceImputation])
    SELECT 
       @FK_dxPayment__Cancellation
      ,[FK_dxPayableInvoice]
      ,-1.0 *[PaidAmount]
      ,[TotalAmount]
      ,[TotalAmount]
      ,[TotalAmount]
      ,@CancelDate
      ,0
      ,-1.0 *[ImputationAmount]
      ,[FK_dxAccount__InvoiceImputation]
    FROM [dbo].[dxPaymentInvoice] where FK_dxPayment = @FK_dxPayment
   
   
    INSERT INTO [dbo].[dxPaymentImputation]
           ([FK_dxPayment]
           ,[Description]
           ,[FK_dxAccount]
           ,[Amount]
           ,[TransactionDate]
           ,[Posted])
    SELECT 
       @FK_dxPayment__Cancellation
      ,'Annulé / Canceled '+Coalesce([Description],'')
      ,[FK_dxAccount]
      ,-1.0 * [Amount]
      ,@CancelDate
      ,0
    FROM [dbo].[dxPaymentImputation]where FK_dxPayment = @FK_dxPayment

    Execute dbo.pdxPostPayment       @FK_dxPayment__Cancellation
    Execute dbo.pdxPostPaymentDetail @FK_dxPayment__Cancellation, 0
    
    Update dxPayment 
         set [TextAmount] = 'Annulé / Canceled ' 
           , [FK_dxPayment__Canceled] = @FK_dxPayment
    where PK_dxPayment = @FK_dxPayment__Cancellation 
    Update dxPayment 
         set [Reference]  = 'Annulé / Canceled ' + Coalesce(Reference,'')
           , [Canceled]   = 1
    where PK_dxPayment = @FK_dxPayment 
	
END
GO
