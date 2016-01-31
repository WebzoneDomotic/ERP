CREATE TABLE [dbo].[dxInvoice]
(
[PK_dxInvoice] [int] NOT NULL IDENTITY(20000, 1),
[FK_dxClient] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL CONSTRAINT [DF_dxInvoice_TransactionDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxAddress__Billing] [int] NULL,
[BillingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxAddress__Shipping] [int] NULL,
[ShippingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[Amount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_Amount] DEFAULT ((0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_Discount] DEFAULT ((0)),
[DiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_DiscountAmount] DEFAULT ((0)),
[TotalAmountBeforeTax] [float] NOT NULL CONSTRAINT [DF_dxInvoice_TotalAmountbeforeTax] DEFAULT ((0)),
[Tax1Amount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_Tax1Amount] DEFAULT ((0)),
[Tax2Amount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_Tax2Amount] DEFAULT ((0)),
[Tax3Amount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_Tax3Amount] DEFAULT ((0)),
[TaxAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_TaxAmount] DEFAULT ((0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_TotalAmount] DEFAULT ((0)),
[BalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_BalanceAmount] DEFAULT ((0)),
[FK_dxTax] [int] NOT NULL CONSTRAINT [DF_dxInvoice_FK_dxTax] DEFAULT ((1)),
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxInvoice_FK_dxCurrency] DEFAULT ((1)),
[FK_dxFOB] [int] NULL CONSTRAINT [DF_dxInvoice_FK_dxFOB] DEFAULT ((1)),
[FOB] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxShipVia] [int] NULL CONSTRAINT [DF_dxInvoice_FK_dxShipVia] DEFAULT ((1)),
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxTerms] [int] NOT NULL CONSTRAINT [DF_dxInvoice_FK_dxTerms] DEFAULT ((1)),
[SuggestPaymentDate] [datetime] NOT NULL CONSTRAINT [DF_dxInvoice_SuggestPaymentDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[SuggestDiscountDate] [datetime] NOT NULL CONSTRAINT [DF_dxInvoice_SuggestDiscountDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[SuggestInterestDate] [datetime] NOT NULL CONSTRAINT [DF_dxInvoice_SuggestInterestDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[TermsDiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_TermsDiscountAmount] DEFAULT ((0.0)),
[TermsInterestAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoice_TermsInterestAmount] DEFAULT ((0.0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxInvoice_Posted] DEFAULT ((0)),
[FK_dxEmployee__Sales] [int] NULL,
[ListOfShipping] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxInvoice_ListOfShipping] DEFAULT (''),
[ListOfOrder] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxInvoice_ListOfOrder] DEFAULT (''),
[FK_dxShipping] [int] NULL,
[ID] AS (CONVERT([varchar](50),[PK_dxInvoice],(0))),
[NumberOfPrint] [int] NOT NULL CONSTRAINT [DF_dxInvoice_NumberOfPrint] DEFAULT ((0)),
[CreditNote] [bit] NOT NULL CONSTRAINT [DF_dxInvoice_CreditNote] DEFAULT ((0)),
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxInvoice_DocumentStatus] DEFAULT ((0)),
[FK_dxPaymentType] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInvoice.trAuditDelete] ON [dbo].[dxInvoice]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxInvoice'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxInvoice CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInvoice, FK_dxClient, TransactionDate, Description, FK_dxAddress__Billing, BillingAddress, FK_dxAddress__Shipping, ShippingAddress, Amount, Discount, DiscountAmount, TotalAmountBeforeTax, Tax1Amount, Tax2Amount, Tax3Amount, TaxAmount, TotalAmount, BalanceAmount, FK_dxTax, FK_dxNote, Note, FK_dxCurrency, FK_dxFOB, FOB, FK_dxShipVia, ShipVia, FK_dxTerms, SuggestPaymentDate, SuggestDiscountDate, SuggestInterestDate, TermsDiscountAmount, TermsInterestAmount, Posted, FK_dxEmployee__Sales, ListOfShipping, ListOfOrder, FK_dxShipping, ID, NumberOfPrint, CreditNote, DocumentStatus, FK_dxPaymentType from deleted
 Declare @PK_dxInvoice int, @FK_dxClient int, @TransactionDate DateTime, @Description varchar(500), @FK_dxAddress__Billing int, @BillingAddress varchar(1000), @FK_dxAddress__Shipping int, @ShippingAddress varchar(1000), @Amount Float, @Discount Float, @DiscountAmount Float, @TotalAmountBeforeTax Float, @Tax1Amount Float, @Tax2Amount Float, @Tax3Amount Float, @TaxAmount Float, @TotalAmount Float, @BalanceAmount Float, @FK_dxTax int, @FK_dxNote int, @Note varchar(2000), @FK_dxCurrency int, @FK_dxFOB int, @FOB varchar(500), @FK_dxShipVia int, @ShipVia varchar(500), @FK_dxTerms int, @SuggestPaymentDate DateTime, @SuggestDiscountDate DateTime, @SuggestInterestDate DateTime, @TermsDiscountAmount Float, @TermsInterestAmount Float, @Posted Bit, @FK_dxEmployee__Sales int, @ListOfShipping varchar(500), @ListOfOrder varchar(500), @FK_dxShipping int, @ID varchar(50), @NumberOfPrint int, @CreditNote Bit, @DocumentStatus int, @FK_dxPaymentType int

 OPEN pk_cursordxInvoice
 FETCH NEXT FROM pk_cursordxInvoice INTO @PK_dxInvoice, @FK_dxClient, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @BalanceAmount, @FK_dxTax, @FK_dxNote, @Note, @FK_dxCurrency, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @FK_dxTerms, @SuggestPaymentDate, @SuggestDiscountDate, @SuggestInterestDate, @TermsDiscountAmount, @TermsInterestAmount, @Posted, @FK_dxEmployee__Sales, @ListOfShipping, @ListOfOrder, @FK_dxShipping, @ID, @NumberOfPrint, @CreditNote, @DocumentStatus, @FK_dxPaymentType
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxInvoice, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Billing', @FK_dxAddress__Billing
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillingAddress', @BillingAddress
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Shipping', @FK_dxAddress__Shipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShippingAddress', @ShippingAddress
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', @Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Discount', @Discount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', @DiscountAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', @TotalAmountBeforeTax
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', @Tax1Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', @Tax2Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', @Tax3Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', @TaxAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', @TotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BalanceAmount', @BalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', @FK_dxTax
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', @FK_dxNote
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', @FK_dxFOB
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', @FOB
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', @FK_dxShipVia
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', @ShipVia
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms', @FK_dxTerms
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestPaymentDate', @SuggestPaymentDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestDiscountDate', @SuggestDiscountDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestInterestDate', @SuggestInterestDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsDiscountAmount', @TermsDiscountAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsInterestAmount', @TermsInterestAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Sales', @FK_dxEmployee__Sales
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfShipping', @ListOfShipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfOrder', @ListOfOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipping', @FK_dxShipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfPrint', @NumberOfPrint
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'CreditNote', @CreditNote
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
FETCH NEXT FROM pk_cursordxInvoice INTO @PK_dxInvoice, @FK_dxClient, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @BalanceAmount, @FK_dxTax, @FK_dxNote, @Note, @FK_dxCurrency, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @FK_dxTerms, @SuggestPaymentDate, @SuggestDiscountDate, @SuggestInterestDate, @TermsDiscountAmount, @TermsInterestAmount, @Posted, @FK_dxEmployee__Sales, @ListOfShipping, @ListOfOrder, @FK_dxShipping, @ID, @NumberOfPrint, @CreditNote, @DocumentStatus, @FK_dxPaymentType
 END

 CLOSE pk_cursordxInvoice 
 DEALLOCATE pk_cursordxInvoice
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInvoice.trAuditInsUpd] ON [dbo].[dxInvoice] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxInvoice CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInvoice from inserted;
 set @tablename = 'dxInvoice' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxInvoice
 FETCH NEXT FROM pk_cursordxInvoice INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Billing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Billing', FK_dxAddress__Billing from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BillingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillingAddress', BillingAddress from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Shipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Shipping', FK_dxAddress__Shipping from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShippingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShippingAddress', ShippingAddress from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Discount', Discount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', DiscountAmount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmountBeforeTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', TotalAmountBeforeTax from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', Tax1Amount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', Tax2Amount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', Tax3Amount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', TaxAmount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BalanceAmount', BalanceAmount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', FK_dxTax from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', FK_dxFOB from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', FOB from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', FK_dxShipVia from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTerms )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms', FK_dxTerms from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SuggestPaymentDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestPaymentDate', SuggestPaymentDate from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SuggestDiscountDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestDiscountDate', SuggestDiscountDate from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SuggestInterestDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestInterestDate', SuggestInterestDate from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TermsDiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsDiscountAmount', TermsDiscountAmount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TermsInterestAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsInterestAmount', TermsInterestAmount from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__Sales )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Sales', FK_dxEmployee__Sales from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ListOfShipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfShipping', ListOfShipping from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ListOfOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfOrder', ListOfOrder from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipping', FK_dxShipping from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfPrint )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfPrint', NumberOfPrint from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CreditNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'CreditNote', CreditNote from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxInvoice where PK_dxInvoice = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxInvoice INTO @keyvalue
 END

 CLOSE pk_cursordxInvoice 
 DEALLOCATE pk_cursordxInvoice
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInvoice.trDelete] ON [dbo].[dxInvoice]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  delete from dxInvoiceDetail where FK_dxInvoice in (SELECT PK_dxInvoice FROM deleted) ;
  delete from dxInvoice       where PK_dxInvoice in (SELECT PK_dxInvoice FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInvoice.trUpdateTerms] ON [dbo].[dxInvoice]
AFTER UPDATE
AS
BEGIN
  declare @FK int, @FKi int , @FKd int ;

  set @FK  = ( SELECT Coalesce(max(PK_dxInvoice ),-1) from inserted )

  update dxInvoice set
     TermsDiscountAmount  = ( select  Round ( dxInvoice.TotalAmount * ( TermsDiscount / 100 ), 2 ) From dxTerms t where t.PK_dxTerms = dxInvoice.FK_dxTerms ),
     TermsInterestAmount  = ( select  Round ( dxInvoice.TotalAmount * ( TermsDueRate  / 100 ), 2 ) From dxTerms t where t.PK_dxTerms = dxInvoice.FK_dxTerms ),
     SuggestPaymentDate   = ( select  case t.DueDaysMatchNextCalendarDay when 0 then
                                      dateadd( day , t.TermsDueDays , dxInvoice.TransactionDate )
                                      else
                                      dateadd( day , t.TermsDueDays  ,  dateadd(  month, 1, dateadd( day, -datepart(day, dxInvoice.TransactionDate  )+1,   dxInvoice.TransactionDate ) ) )  end
                              From dxTerms t where t.PK_dxTerms = dxInvoice.FK_dxTerms ),
     SuggestDiscountDate  = ( select case t.DiscountDaysMatchNextCalendarDay when 0 then
                                     dateadd( day , t.TermsDiscountDays , dxInvoice.TransactionDate )
                                     else
                                     dateadd( day , t.TermsDiscountDays  ,  dateadd(  month, 1, dateadd( day, -datepart(day, dxInvoice.TransactionDate  )+1,   dxInvoice.TransactionDate ) ) )  end
                              From dxTerms t where t.PK_dxTerms = dxInvoice.FK_dxTerms ),
     SuggestInterestDate =  ( select case t.DueDaysMatchNextCalendarDay when 0 then
                                     dateadd( day , t.TermsDueDays +30 , dxInvoice.TransactionDate )
                                     else
                                     dateadd( day , t.TermsDueDays +30 ,  dateadd(  month, 1, dateadd( day, -datepart(day, dxInvoice.TransactionDate  )+1,   dxInvoice.TransactionDate ) ) )  end
                              From dxTerms t where t.PK_dxTerms = dxInvoice.FK_dxTerms )
  where PK_dxInvoice = @FK ;
END
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [PK_dxInvoice] PRIMARY KEY CLUSTERED  ([PK_dxInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxAddress__Billing] ON [dbo].[dxInvoice] ([FK_dxAddress__Billing]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxAddress__Shipping] ON [dbo].[dxInvoice] ([FK_dxAddress__Shipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxClient] ON [dbo].[dxInvoice] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxCurrency] ON [dbo].[dxInvoice] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxEmployee__Sales] ON [dbo].[dxInvoice] ([FK_dxEmployee__Sales]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxFOB] ON [dbo].[dxInvoice] ([FK_dxFOB]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxNote] ON [dbo].[dxInvoice] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxPaymentType] ON [dbo].[dxInvoice] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxShipping] ON [dbo].[dxInvoice] ([FK_dxShipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxShipVia] ON [dbo].[dxInvoice] ([FK_dxShipVia]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxTax] ON [dbo].[dxInvoice] ([FK_dxTax]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoice_FK_dxTerms] ON [dbo].[dxInvoice] ([FK_dxTerms]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxInvoiceDate] ON [dbo].[dxInvoice] ([TransactionDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Billing_dxInvoice] FOREIGN KEY ([FK_dxAddress__Billing]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Shipping_dxInvoice] FOREIGN KEY ([FK_dxAddress__Shipping]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxInvoice] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxInvoice] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__Sales_dxInvoice] FOREIGN KEY ([FK_dxEmployee__Sales]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxFOB_dxInvoice] FOREIGN KEY ([FK_dxFOB]) REFERENCES [dbo].[dxFOB] ([PK_dxFOB])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxInvoice] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxInvoice] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxShipping_dxInvoice] FOREIGN KEY ([FK_dxShipping]) REFERENCES [dbo].[dxShipping] ([PK_dxShipping])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxShipVia_dxInvoice] FOREIGN KEY ([FK_dxShipVia]) REFERENCES [dbo].[dxShipVia] ([PK_dxShipVia])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxInvoice] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
ALTER TABLE [dbo].[dxInvoice] ADD CONSTRAINT [dxConstraint_FK_dxTerms_dxInvoice] FOREIGN KEY ([FK_dxTerms]) REFERENCES [dbo].[dxTerms] ([PK_dxTerms])
GO
