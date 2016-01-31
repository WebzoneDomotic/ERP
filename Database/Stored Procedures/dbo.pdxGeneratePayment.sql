SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-02-03
-- Description:	Génération des payments à partir de la planification
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxGeneratePayment]  @FK_dxPaymentPlanning int
as
Begin
  --Declare @FK_dxPaymentPlanning int
  --Set @FK_dxPaymentPlanning = 1
  Declare @LastChequeNumber int
  Declare @PaymentDate Datetime
  set @PaymentDate = ( Select PaymentDate from dxPaymentPlanning where PK_dxPaymentPlanning =  @FK_dxPaymentPlanning )

  exec [dbo].[pdxValidateAccountingPeriod] @Date = @PaymentDate

	-- Create payment for each supplier for this bank account
	Insert into dxPayment (
			 [FK_dxPaymentPlanning]
			,[FK_dxVendor]
			,[PaidTo]
			,[Address]
			,[TransactionDate]
			,[FK_dxPaymentType]
			,[FK_dxBankAccount]
			,[FK_dxCurrency]
			,[FK_dxAccount]
			,[TotalAmount]
			,[UnusedAmount] )

	SELECT
		   pd.[FK_dxPaymentPlanning]
		  ,pd.[FK_dxVendor]
		  , (Select Top 1 CompanyName From dxAddress where FK_dxVendor = pd.FK_dxVendor
									order by  DefaultPayment Desc )
		  ,[dbo].[fdxGetAddress] ( (Select Top 1 PK_dxAddress From dxAddress where FK_dxVendor = pd.FK_dxVendor
									order by  DefaultPayment Desc ) ,3,0)
		  ,pp.[PaymentDate]
		  ,   10 [FK_dxPaymentType] -- Cheque
		  ,pp.[FK_dxBankAccount]
		  ,ba.FK_dxCurrency
		  ,Coalesce(( Select MAX(PK_dxAccount) from dxAccount ac where ac.FK_dxAccountUsage = 32
														   and ac.FK_dxCurrency = ba.FK_dxCurrency ), 9999) [FK_dxAccount]
		  ,Sum(pd.[AmountToPay]) [AmountToPay]
		  ,Sum(pd.[AmountToPay]) [UnusedAmount]

	  FROM [dbo].[dxPaymentPlanningDetail] pd
	  left join dxPaymentPlanning pp on ( pp.PK_dxPaymentPlanning = pd.FK_dxPaymentPlanning)
	  left join dxVendor          ve on ( ve.PK_dxVendor = pd.FK_dxVendor )
	  left join dxBankAccount     ba on ( ba.PK_dxBankAccount = pp.FK_dxBankAccount)
	Where pd.FK_dxPaymentPlanning = @FK_dxPaymentPlanning
   and pp.Approuved = 0
	 and Not exists ( select 1 from dxPayment py where py.FK_dxPaymentPlanning = pp.PK_dxPaymentPlanning
												 and   py.FK_dxVendor = pd.FK_dxVendor )
	Group by
		   [FK_dxPaymentPlanning]
		  ,[FK_dxVendor]
		  ,[PaymentDate]
		  ,pp.[FK_dxBankAccount]
		  ,ba.FK_dxCurrency

	-- Insert all the invoice attach to those payment
	Insert into dxPaymentInvoice (
		 FK_dxPayment
		,FK_dxPayableInvoice
		,TransactionDate
		,PaidAmount
		,TotalAmount )
	SELECT
		  py.PK_dxPayment
	   ,pd.FK_dxPayableInvoice
	   ,pp.[PaymentDate]
	   ,pd.AmountToPay
	   ,pd.AmountToPay

	  FROM [dbo].[dxPaymentPlanningDetail] pd
	  left join dxPayment         py on ( py.FK_dxPaymentPlanning = pd.FK_dxPaymentPlanning and py.FK_dxVendor = pd.FK_dxVendor)
	  left join dxPaymentPlanning pp on ( pp.PK_dxPaymentPlanning = pd.FK_dxPaymentPlanning)
	  left join dxVendor          ve on ( ve.PK_dxVendor = pd.FK_dxVendor )
	  left join dxBankAccount     ba on ( ba.PK_dxBankAccount = pp.FK_dxBankAccount)
	  where pd.FK_dxPaymentPlanning = @FK_dxPaymentPlanning
     and  pp.Approuved = 0


	 -- Prepare Batch Printing

	 Declare @FK_dxBankAccount int,@FK_dxPayment__From int,@FK_dxPayment__To int
	 Set @FK_dxBankAccount = ( Select FK_dxBankAccount From dxPaymentPlanning where PK_dxPaymentPlanning = @FK_dxPaymentPlanning)
	 Delete from dbo.dxBatchPrintingCheque where Printed =0
	 -- Retrive last Printed Cheque Number
	 Select Top 1 @FK_dxPayment__From = FK_dxPayment__From, @FK_dxPayment__To = FK_dxPayment__To
	   From dbo.dxBatchPrintingCheque
	  where FK_dxbankAccount = @FK_dxBankAccount
	    and Printed =1
	  order by PrintedDate Desc

	 set @FK_dxPayment__From = Coalesce( @FK_dxPayment__From, -1)
	 set @FK_dxPayment__To   = Coalesce( @FK_dxPayment__To  , -1)

	 set @LastChequeNumber =
	           Coalesce(( Select MAX(ChequeNumber) From dxPayment
	                     where PK_dxPayment between @FK_dxPayment__From and @FK_dxPayment__To
	                       and FK_dxPaymentType = 10
	                       and FK_dxBankAccount = @FK_dxBankAccount),0)

	 Insert into dbo.dxBatchPrintingCheque (
		 StartingChequeNumber
		,FK_dxPayment__From
		,FK_dxPayment__To
		,FK_dxBankAccount )
	 Select
	     @LastChequeNumber + 1
		,( Select Min(PK_dxPayment) from dxPayment where FK_dxPaymentType = 10 and FK_dxBankAccount = @FK_dxBankAccount and ChequeNumber = 0 and NumberofPrint = 0)
		,( Select Max(PK_dxPayment) from dxPayment where FK_dxPaymentType = 10 and FK_dxBankAccount = @FK_dxBankAccount and ChequeNumber = 0 and NumberofPrint = 0)
		, @FK_dxBankAccount

     update dxPaymentPlanning set Approuved = 1 where PK_dxPaymentPlanning = @FK_dxPaymentPlanning

 end
GO
