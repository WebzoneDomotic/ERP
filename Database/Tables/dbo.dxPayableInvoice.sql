CREATE TABLE [dbo].[dxPayableInvoice]
(
[PK_dxPayableInvoice] [int] NOT NULL IDENTITY(10000, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[FK_dxVendor] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TransactionDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxAddress__Billing] [int] NULL,
[BillingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxAddress__Shipping] [int] NULL,
[ShippingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Amount] DEFAULT ((0.0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Discount] DEFAULT ((0.0)),
[DiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_DiscountAmount] DEFAULT ((0.0)),
[TotalAmountBeforeTax] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TotalAmountBeforeTax] DEFAULT ((0.0)),
[Tax1Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Tax1Amount] DEFAULT ((0.0)),
[Tax2Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Tax2Amount] DEFAULT ((0.0)),
[Tax3Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Tax3Amount] DEFAULT ((0.0)),
[TaxAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TaxAmount] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TotalAmount] DEFAULT ((0.0)),
[InvoiceAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_InvoiceAmount] DEFAULT ((0.0)),
[BalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_BalanceAmount] DEFAULT ((0.0)),
[FK_dxTax] [int] NOT NULL CONSTRAINT [DF_dxPayableInvoice_FK_dxTax] DEFAULT ((1)),
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxPayableInvoice_FK_dxCurrency] DEFAULT ((1)),
[FK_dxFOB] [int] NULL,
[FOB] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxShipVia] [int] NULL,
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxTerms] [int] NOT NULL CONSTRAINT [DF_dxPayableInvoice_FK_dxTerms] DEFAULT ((1)),
[SuggestPaymentDate] [datetime] NOT NULL CONSTRAINT [DF_dxPayableInvoice_SuggestPaymentDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[SuggestDiscountDate] [datetime] NOT NULL CONSTRAINT [DF_dxPayableInvoice_SuggestDiscountDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[SuggestInterestDate] [datetime] NOT NULL CONSTRAINT [DF_dxPayableInvoice_SuggestInterestDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[TermsDiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TermsDiscountAmount] DEFAULT ((0.0)),
[TermsInterestAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TermsInterestAmount] DEFAULT ((0.0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Posted] DEFAULT ((0)),
[ListOfReception] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxPayableInvoice_ListOfReception] DEFAULT (''),
[FreightCost] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_FreightCost] DEFAULT ((0.0)),
[FreightCharges] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_FreightCharges] DEFAULT ((0.0)),
[WithholdInvoicePayment] [bit] NOT NULL CONSTRAINT [DF_dxPayableInvoice_WithholdInvoicePayment] DEFAULT ((0)),
[Tax1AdjustmentAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Tax1AdjustmentAmount] DEFAULT ((0.0)),
[Tax2AdjustmentAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Tax2AdjustmentAmount] DEFAULT ((0.0)),
[Tax3AdjustmentAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_Tax3AdjustmentAmount] DEFAULT ((0.0)),
[FK_dxPaymentType] [int] NULL,
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxPayableInvoice_DocumentStatus] DEFAULT ((0)),
[TaxesManagedByItem] [bit] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TaxesManagedByItem] DEFAULT ((1)),
[TotalTax1Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TotalTax1Amount] DEFAULT ((0.0)),
[TotalTax2Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TotalTax2Amount] DEFAULT ((0.0)),
[TotalTax3Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_TotalTax3Amount] DEFAULT ((0.0)),
[PayableAdjustmentAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoice_PayableAdjustmentAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoice.trAuditDelete] ON [dbo].[dxPayableInvoice]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPayableInvoice'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPayableInvoice CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayableInvoice, ID, FK_dxVendor, TransactionDate, Description, FK_dxAddress__Billing, BillingAddress, FK_dxAddress__Shipping, ShippingAddress, Amount, Discount, DiscountAmount, TotalAmountBeforeTax, Tax1Amount, Tax2Amount, Tax3Amount, TaxAmount, TotalAmount, InvoiceAmount, BalanceAmount, FK_dxTax, FK_dxNote, Note, FK_dxCurrency, FK_dxFOB, FOB, FK_dxShipVia, ShipVia, FK_dxTerms, SuggestPaymentDate, SuggestDiscountDate, SuggestInterestDate, TermsDiscountAmount, TermsInterestAmount, Posted, ListOfReception, FreightCost, FreightCharges, WithholdInvoicePayment, Tax1AdjustmentAmount, Tax2AdjustmentAmount, Tax3AdjustmentAmount, FK_dxPaymentType, DocumentStatus, TaxesManagedByItem, TotalTax1Amount, TotalTax2Amount, TotalTax3Amount, PayableAdjustmentAmount from deleted
 Declare @PK_dxPayableInvoice int, @ID varchar(50), @FK_dxVendor int, @TransactionDate DateTime, @Description varchar(500), @FK_dxAddress__Billing int, @BillingAddress varchar(1000), @FK_dxAddress__Shipping int, @ShippingAddress varchar(1000), @Amount Float, @Discount Float, @DiscountAmount Float, @TotalAmountBeforeTax Float, @Tax1Amount Float, @Tax2Amount Float, @Tax3Amount Float, @TaxAmount Float, @TotalAmount Float, @InvoiceAmount Float, @BalanceAmount Float, @FK_dxTax int, @FK_dxNote int, @Note varchar(2000), @FK_dxCurrency int, @FK_dxFOB int, @FOB varchar(500), @FK_dxShipVia int, @ShipVia varchar(500), @FK_dxTerms int, @SuggestPaymentDate DateTime, @SuggestDiscountDate DateTime, @SuggestInterestDate DateTime, @TermsDiscountAmount Float, @TermsInterestAmount Float, @Posted Bit, @ListOfReception varchar(500), @FreightCost Float, @FreightCharges Float, @WithholdInvoicePayment Bit, @Tax1AdjustmentAmount Float, @Tax2AdjustmentAmount Float, @Tax3AdjustmentAmount Float, @FK_dxPaymentType int, @DocumentStatus int, @TaxesManagedByItem Bit, @TotalTax1Amount Float, @TotalTax2Amount Float, @TotalTax3Amount Float, @PayableAdjustmentAmount Float

 OPEN pk_cursordxPayableInvoice
 FETCH NEXT FROM pk_cursordxPayableInvoice INTO @PK_dxPayableInvoice, @ID, @FK_dxVendor, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @InvoiceAmount, @BalanceAmount, @FK_dxTax, @FK_dxNote, @Note, @FK_dxCurrency, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @FK_dxTerms, @SuggestPaymentDate, @SuggestDiscountDate, @SuggestInterestDate, @TermsDiscountAmount, @TermsInterestAmount, @Posted, @ListOfReception, @FreightCost, @FreightCharges, @WithholdInvoicePayment, @Tax1AdjustmentAmount, @Tax2AdjustmentAmount, @Tax3AdjustmentAmount, @FK_dxPaymentType, @DocumentStatus, @TaxesManagedByItem, @TotalTax1Amount, @TotalTax2Amount, @TotalTax3Amount, @PayableAdjustmentAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPayableInvoice, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
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
        select @pkdataaudit, 'InvoiceAmount', @InvoiceAmount
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfReception', @ListOfReception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FreightCost', @FreightCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FreightCharges', @FreightCharges
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'WithholdInvoicePayment', @WithholdInvoicePayment
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1AdjustmentAmount', @Tax1AdjustmentAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2AdjustmentAmount', @Tax2AdjustmentAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3AdjustmentAmount', @Tax3AdjustmentAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'TaxesManagedByItem', @TaxesManagedByItem
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalTax1Amount', @TotalTax1Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalTax2Amount', @TotalTax2Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalTax3Amount', @TotalTax3Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PayableAdjustmentAmount', @PayableAdjustmentAmount
FETCH NEXT FROM pk_cursordxPayableInvoice INTO @PK_dxPayableInvoice, @ID, @FK_dxVendor, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @InvoiceAmount, @BalanceAmount, @FK_dxTax, @FK_dxNote, @Note, @FK_dxCurrency, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @FK_dxTerms, @SuggestPaymentDate, @SuggestDiscountDate, @SuggestInterestDate, @TermsDiscountAmount, @TermsInterestAmount, @Posted, @ListOfReception, @FreightCost, @FreightCharges, @WithholdInvoicePayment, @Tax1AdjustmentAmount, @Tax2AdjustmentAmount, @Tax3AdjustmentAmount, @FK_dxPaymentType, @DocumentStatus, @TaxesManagedByItem, @TotalTax1Amount, @TotalTax2Amount, @TotalTax3Amount, @PayableAdjustmentAmount
 END

 CLOSE pk_cursordxPayableInvoice 
 DEALLOCATE pk_cursordxPayableInvoice
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoice.trAuditInsUpd] ON [dbo].[dxPayableInvoice] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPayableInvoice CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayableInvoice from inserted;
 set @tablename = 'dxPayableInvoice' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPayableInvoice
 FETCH NEXT FROM pk_cursordxPayableInvoice INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Billing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Billing', FK_dxAddress__Billing from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BillingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillingAddress', BillingAddress from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Shipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Shipping', FK_dxAddress__Shipping from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShippingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShippingAddress', ShippingAddress from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Discount', Discount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', DiscountAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmountBeforeTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', TotalAmountBeforeTax from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', Tax1Amount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', Tax2Amount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', Tax3Amount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', TaxAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InvoiceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InvoiceAmount', InvoiceAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BalanceAmount', BalanceAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', FK_dxTax from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', FK_dxFOB from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', FOB from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', FK_dxShipVia from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTerms )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms', FK_dxTerms from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SuggestPaymentDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestPaymentDate', SuggestPaymentDate from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SuggestDiscountDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestDiscountDate', SuggestDiscountDate from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SuggestInterestDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestInterestDate', SuggestInterestDate from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TermsDiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsDiscountAmount', TermsDiscountAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TermsInterestAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsInterestAmount', TermsInterestAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ListOfReception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfReception', ListOfReception from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FreightCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FreightCost', FreightCost from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FreightCharges )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FreightCharges', FreightCharges from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( WithholdInvoicePayment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'WithholdInvoicePayment', WithholdInvoicePayment from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1AdjustmentAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1AdjustmentAmount', Tax1AdjustmentAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2AdjustmentAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2AdjustmentAmount', Tax2AdjustmentAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3AdjustmentAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3AdjustmentAmount', Tax3AdjustmentAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxesManagedByItem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'TaxesManagedByItem', TaxesManagedByItem from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalTax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalTax1Amount', TotalTax1Amount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalTax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalTax2Amount', TotalTax2Amount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalTax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalTax3Amount', TotalTax3Amount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PayableAdjustmentAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PayableAdjustmentAmount', PayableAdjustmentAmount from dxPayableInvoice where PK_dxPayableInvoice = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPayableInvoice INTO @keyvalue
 END

 CLOSE pk_cursordxPayableInvoice 
 DEALLOCATE pk_cursordxPayableInvoice
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoice.trCheckImputationAccount] ON [dbo].[dxPayableInvoice]
AFTER UPDATE
AS
Begin
 Declare @Message VARCHAR(2000)
 If ((Select MAX(CAST(Posted AS INT)) FROM INSERTED) = 1 AND
     (Select MAX(CAST(Posted AS INT)) FROM DELETED) = 0)
 begin
   -- Check if account is null
   (Select Top 1 @Message =pd.Description + ' - '+ 'Le compte d''imputation doit avoir une valeur / Imputation account must have a value' From inserted po
       left join dxPayableInvoiceDetail pd on ( pd.FK_dxPayableInvoice = po.PK_dxPayableInvoice)
       where pd.FK_dxAccount__Expense is null
         and abs(pd.TotalAmount) > 0.000001 )
   -- Raise error if account is null
   If Len(Coalesce(@Message,'')) > 0
   Begin
     RAISERROR(@Message, 16, 1)
     ROLLBACK TRANSACTION
   end
 end
end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoice.trDelete] ON [dbo].[dxPayableInvoice]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  delete from dxPayableInvoiceDetail where FK_dxPayableInvoice in (SELECT PK_dxPayableInvoice FROM deleted) ;
  delete from dxPayableInvoice       where PK_dxPayableInvoice in (SELECT PK_dxPayableInvoice FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoice.trUpdateFreightCharges] ON [dbo].[dxPayableInvoice]
AFTER UPDATE
AS
BEGIN
  if update ( FreightCharges )
      update dxPayableInvoiceDetail set
         FreightCharges  =  Round(( select sum(FreightCharges) from dxPayableInvoice
                              where PK_dxPayableInvoice = dxPayableInvoiceDetail.FK_dxPayableInvoice
                            )
                            * ( case when Quantity < 0.001 then 0.001 else Quantity end )
                            / ( Select sum( case when pd.Quantity < 0.001 then 0.001 else pd.Quantity end ) from dxPayableInvoiceDetail pd
                                           left outer join dxProduct pr on (pr.PK_dxProduct = pd.FK_dxProduct)
                                           where pd.FK_dxPayableInvoice = dxPayableInvoiceDetail.FK_dxPayableInvoice
                                             and pr.Freight = 0
                                             and pr.InventoryItem = 1 ),2)
       where FK_dxPayableInvoice in ( Select PK_dxPayableInvoice from inserted where posted = 0)
         and ( Select Freight from dxProduct where PK_dxProduct = dxPayableInvoiceDetail.FK_dxProduct) = 0;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoice.trUpdateSum] ON [dbo].[dxPayableInvoice]
AFTER INSERT, UPDATE
AS
BEGIN

  if    Update( Amount ) or Update( DiscountAmount ) or Update( TotalAmountBeforeTax ) or Update( DiscountAmount )
     or Update( PayableAdjustmentAmount )
     or Update( TaxesManagedByItem )
     or Update( Tax1Amount )           or Update( Tax2Amount )           or Update( Tax3Amount )
     or Update( TotalTax1Amount )      or Update( TotalTax2Amount )      or Update( TotalTax3Amount )
     or Update( Tax1AdjustmentAmount ) or Update( Tax2AdjustmentAmount ) or Update( Tax3AdjustmentAmount )
  begin
      update dxPayableInvoice set
           TaxAmount     = Case
                             when TaxesManagedByItem = 0 then  TotalTax1Amount + TotalTax2Amount + TotalTax3Amount
                             when TaxesManagedByItem = 1 then  Tax1Amount      + Tax2Amount      + Tax3Amount      + Tax1AdjustmentAmount + Tax2AdjustmentAmount + Tax3AdjustmentAmount
                           end
         , TotalAmount   = Case
                             when TaxesManagedByItem = 0 then  TotalAmountBeforeTax + PayableAdjustmentAmount + TotalTax1Amount + TotalTax2Amount + TotalTax3Amount
                             when TaxesManagedByItem = 1 then  TotalAmountBeforeTax + PayableAdjustmentAmount + Tax1Amount      + Tax2Amount      + Tax3Amount      + Tax1AdjustmentAmount  + Tax2AdjustmentAmount  + Tax3AdjustmentAmount
                           end
         , BalanceAmount = Case
                             when TaxesManagedByItem = 0 then  TotalAmountBeforeTax + PayableAdjustmentAmount + TotalTax1Amount + TotalTax2Amount + TotalTax3Amount -
                                                               ( select Coalesce(sum( PaidAmount ), 0.0) from dxPaymentInvoice where FK_dxPayableInvoice in ( Select PK_dxPayableInvoice From inserted ) and posted = 1 )
                             when TaxesManagedByItem = 1 then  TotalAmountBeforeTax + PayableAdjustmentAmount + Tax1Amount      + Tax2Amount      + Tax3Amount      + Tax1AdjustmentAmount  + Tax2AdjustmentAmount  + Tax3AdjustmentAmount -
                                                               ( select Coalesce(sum( PaidAmount ), 0.0) from dxPaymentInvoice where FK_dxPayableInvoice in ( Select PK_dxPayableInvoice From inserted ) and posted = 1 )
                           end
      where PK_dxPayableInvoice in ( Select PK_dxPayableInvoice From inserted )
        and Posted = 0
  end
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoice.trUpdateTax] ON [dbo].[dxPayableInvoice]
AFTER INSERT, UPDATE
AS
BEGIN
  -- Set tax Account
  if Update( FK_dxTax )
  Update pd
     set  pd.FK_dxAccount__AP_Tax1 = ta.FK_dxAccount__AP_Tax1
         ,pd.FK_dxAccount__AP_Tax2 = ta.FK_dxAccount__AP_Tax2
         ,pd.FK_dxAccount__AP_Tax3 = ta.FK_dxAccount__AP_Tax3
         ,pd.Tax1Rate  = Coalesce(( Select Top 1 Tax1Rate From dxTaxDetail
                                     where FK_dxTax = ta.PK_dxTax and Effectivedate <= ei.Transactiondate
                                     order by EffectiveDate desc ), 0.0)
         ,pd.Tax2Rate  = Coalesce(( Select Top 1 Tax2Rate From dxTaxDetail
                                     where FK_dxTax = ta.PK_dxTax and Effectivedate <= ei.Transactiondate
                                     order by EffectiveDate desc ), 0.0)
         ,pd.Tax3Rate  = Coalesce(( Select Top 1 Tax3Rate From dxTaxDetail
                                     where FK_dxTax = ta.PK_dxTax and Effectivedate <= ei.Transactiondate
                                     order by EffectiveDate desc ), 0.0)
         ,pd.FK_dxAccount__Payable = cu.FK_dxAccount__Payable
  From inserted ei
  left join dxPayableInvoiceDetail pd on (pd.FK_dxPayableInvoice = ei.PK_dxPayableInvoice )
  left join dxTax ta on (ei.FK_dxTax = ta.PK_dxTax )
  left join dxCurrency cu on (ei.FK_dxCurrency = cu.PK_dxCurrency )

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoice.trUpdateTerms] ON [dbo].[dxPayableInvoice]
AFTER UPDATE
AS
BEGIN
  declare @FK int, @FKi int , @FKd int ;

  set @FK  = ( SELECT Coalesce(max(PK_dxPayableInvoice ),-1) from inserted )

  update dxPayableInvoice set
     TermsDiscountAmount  = ( select  Round ( dxPayableInvoice.TotalAmount * ( TermsDiscount / 100 ), 2 ) From dxTerms t where t.PK_dxTerms = dxPayableInvoice.FK_dxTerms ),
     TermsInterestAmount  = ( select  Round ( dxPayableInvoice.TotalAmount * ( TermsDueRate  / 100 ), 2 ) From dxTerms t where t.PK_dxTerms = dxPayableInvoice.FK_dxTerms ),
     SuggestPaymentDate   = ( select  case t.DueDaysMatchNextCalendarDay when 0 then
                                      dateadd( day , t.TermsDueDays , dxPayableInvoice.TransactionDate )
                                      else
                                      dateadd( day , t.TermsDueDays  ,  dateadd(  month, 1, dateadd( day, -datepart(day, dxPayableInvoice.TransactionDate  )+1,   dxPayableInvoice.TransactionDate ) ) )  end
                              From dxTerms t where t.PK_dxTerms = dxPayableInvoice.FK_dxTerms ),
     SuggestDiscountDate  = ( select case t.DiscountDaysMatchNextCalendarDay when 0 then
                                     dateadd( day , t.TermsDiscountDays , dxPayableInvoice.TransactionDate )
                                     else
                                     dateadd( day , t.TermsDiscountDays  ,  dateadd(  month, 1, dateadd( day, -datepart(day, dxPayableInvoice.TransactionDate  )+1,   dxPayableInvoice.TransactionDate ) ) )  end
                              From dxTerms t where t.PK_dxTerms = dxPayableInvoice.FK_dxTerms ),
     SuggestInterestDate =  ( select case t.DueDaysMatchNextCalendarDay when 0 then
                                     dateadd( day , t.TermsDueDays +30 , dxPayableInvoice.TransactionDate )
                                     else
                                     dateadd( day , t.TermsDueDays +30 ,  dateadd(  month, 1, dateadd( day, -datepart(day, dxPayableInvoice.TransactionDate  )+1,   dxPayableInvoice.TransactionDate ) ) )  end
                              From dxTerms t where t.PK_dxTerms = dxPayableInvoice.FK_dxTerms )
  where PK_dxPayableInvoice = @FK ;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxPayableInvoice.trValidateBalanceAmount] ON [dbo].[dxPayableInvoice]
AFTER INSERT, UPDATE
AS
BEGIN
 If Update(BalanceAmount)
      if Coalesce( (Select max(1) From inserted
                     where ((Round(TotalAmount,2) > 0.0) and ((Round(BalanceAmount,2) < 0.0) or (Round(BalanceAmount,2) > Round(TotalAmount,2))))
                        or ((Round(TotalAmount,2) < 0.0) and ((Round(BalanceAmount,2) > 0.0) or (Round(BalanceAmount,2) < Round(TotalAmount,2)))) ), 0) = 1
      begin
        RAISERROR('La balance est invalide. Impossible de payer plus que le montant de la facture / Invalid Balance Amount. Your are not allowed to paid more than the amount of the invoice.', 16, 1)
        RETURN
      end
END
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [PK_dxPayableInvoice] PRIMARY KEY CLUSTERED  ([PK_dxPayableInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxAddress__Billing] ON [dbo].[dxPayableInvoice] ([FK_dxAddress__Billing]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxAddress__Shipping] ON [dbo].[dxPayableInvoice] ([FK_dxAddress__Shipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxCurrency] ON [dbo].[dxPayableInvoice] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxFOB] ON [dbo].[dxPayableInvoice] ([FK_dxFOB]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxNote] ON [dbo].[dxPayableInvoice] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxPaymentType] ON [dbo].[dxPayableInvoice] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxShipVia] ON [dbo].[dxPayableInvoice] ([FK_dxShipVia]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxTax] ON [dbo].[dxPayableInvoice] ([FK_dxTax]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxTerms] ON [dbo].[dxPayableInvoice] ([FK_dxTerms]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoice_FK_dxVendor] ON [dbo].[dxPayableInvoice] ([FK_dxVendor]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxPayableInvoice] ON [dbo].[dxPayableInvoice] ([ID], [FK_dxVendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxPayableInvoiceDate] ON [dbo].[dxPayableInvoice] ([TransactionDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Billing_dxPayableInvoice] FOREIGN KEY ([FK_dxAddress__Billing]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Shipping_dxPayableInvoice] FOREIGN KEY ([FK_dxAddress__Shipping]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxPayableInvoice] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxFOB_dxPayableInvoice] FOREIGN KEY ([FK_dxFOB]) REFERENCES [dbo].[dxFOB] ([PK_dxFOB])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxPayableInvoice] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxPayableInvoice] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxShipVia_dxPayableInvoice] FOREIGN KEY ([FK_dxShipVia]) REFERENCES [dbo].[dxShipVia] ([PK_dxShipVia])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxPayableInvoice] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxTerms_dxPayableInvoice] FOREIGN KEY ([FK_dxTerms]) REFERENCES [dbo].[dxTerms] ([PK_dxTerms])
GO
ALTER TABLE [dbo].[dxPayableInvoice] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxPayableInvoice] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
