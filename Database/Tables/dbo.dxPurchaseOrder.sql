CREATE TABLE [dbo].[dxPurchaseOrder]
(
[PK_dxPurchaseOrder] [int] NOT NULL IDENTITY(30000, 1),
[ID] AS ([PK_dxPurchaseOrder]),
[FK_dxVendor] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxAddress__Billing] [int] NULL,
[BillingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxAddress__Shipping] [int] NULL,
[ShippingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxProject] [int] NULL,
[FK_dxTax] [int] NOT NULL,
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_FK_dxCurrency] DEFAULT ((1)),
[FK_dxFOB] [int] NULL,
[FOB] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxShipVia] [int] NULL,
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[BlanketOrder] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_BlanketOrder] DEFAULT ((0)),
[FK_dxEmployee__Purchasing] [int] NULL,
[Closed] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_Closed] DEFAULT ((0)),
[HavingReception] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_HavingReception] DEFAULT ((0)),
[Amount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_Amount] DEFAULT ((0.0)),
[DiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_DiscountAmount] DEFAULT ((0.0)),
[TotalAmountBeforeTax] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_TotalAmountBeforeTax] DEFAULT ((0.0)),
[Tax1Amount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_Tax1Amount] DEFAULT ((0.0)),
[Tax2Amount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_Tax2Amount] DEFAULT ((0.0)),
[Tax3Amount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_Tax3Amount] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_TotalAmount] DEFAULT ((0.0)),
[TaxAmount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_TaxAmount] DEFAULT ((0.0)),
[BalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_BalanceAmount] DEFAULT ((0.0)),
[FK_dxEmployee__ApprovedBy] [int] NULL,
[FK_dxEmployee__DoneBy] [int] NULL,
[FK_dxEmployee__RequestBy] [int] NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_Posted] DEFAULT ((0)),
[FK_dxPurchaseOrder__BlanketOrder] [int] NULL,
[ExpirationDate] [datetime] NULL,
[ReleaseNumber] [int] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_ReleaseNumber] DEFAULT ((0)),
[FK_dxShippingServiceType] [int] NULL,
[FK_dxPaymentType] [int] NULL,
[RMA] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_RMA] DEFAULT ((0)),
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxPurchaseOrder_DocumentStatus] DEFAULT ((0)),
[FK_dxDeclarationDismantling] [int] NULL,
[FK_dxOrderStatus] [int] NULL,
[ContainerNumber] [varchar] (2000) COLLATE French_CI_AS NULL,
[BillOfLadingNumber] [varchar] (2000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPurchaseOrder.trAuditDelete] ON [dbo].[dxPurchaseOrder]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPurchaseOrder'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPurchaseOrder CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPurchaseOrder, ID, FK_dxVendor, TransactionDate, Description, FK_dxAddress__Billing, BillingAddress, FK_dxAddress__Shipping, ShippingAddress, FK_dxProject, FK_dxTax, FK_dxNote, Note, FK_dxCurrency, FK_dxFOB, FOB, FK_dxShipVia, ShipVia, BlanketOrder, FK_dxEmployee__Purchasing, Closed, HavingReception, Amount, DiscountAmount, TotalAmountBeforeTax, Tax1Amount, Tax2Amount, Tax3Amount, TotalAmount, TaxAmount, BalanceAmount, FK_dxEmployee__ApprovedBy, FK_dxEmployee__DoneBy, FK_dxEmployee__RequestBy, Posted, FK_dxPurchaseOrder__BlanketOrder, ExpirationDate, ReleaseNumber, FK_dxShippingServiceType, FK_dxPaymentType, RMA, DocumentStatus, FK_dxDeclarationDismantling, FK_dxOrderStatus, ContainerNumber, BillOfLadingNumber from deleted
 Declare @PK_dxPurchaseOrder int, @ID int, @FK_dxVendor int, @TransactionDate DateTime, @Description varchar(500), @FK_dxAddress__Billing int, @BillingAddress varchar(1000), @FK_dxAddress__Shipping int, @ShippingAddress varchar(1000), @FK_dxProject int, @FK_dxTax int, @FK_dxNote int, @Note varchar(2000), @FK_dxCurrency int, @FK_dxFOB int, @FOB varchar(500), @FK_dxShipVia int, @ShipVia varchar(500), @BlanketOrder Bit, @FK_dxEmployee__Purchasing int, @Closed Bit, @HavingReception Bit, @Amount Float, @DiscountAmount Float, @TotalAmountBeforeTax Float, @Tax1Amount Float, @Tax2Amount Float, @Tax3Amount Float, @TotalAmount Float, @TaxAmount Float, @BalanceAmount Float, @FK_dxEmployee__ApprovedBy int, @FK_dxEmployee__DoneBy int, @FK_dxEmployee__RequestBy int, @Posted Bit, @FK_dxPurchaseOrder__BlanketOrder int, @ExpirationDate DateTime, @ReleaseNumber int, @FK_dxShippingServiceType int, @FK_dxPaymentType int, @RMA Bit, @DocumentStatus int, @FK_dxDeclarationDismantling int, @FK_dxOrderStatus int, @ContainerNumber varchar(2000), @BillOfLadingNumber varchar(2000)

 OPEN pk_cursordxPurchaseOrder
 FETCH NEXT FROM pk_cursordxPurchaseOrder INTO @PK_dxPurchaseOrder, @ID, @FK_dxVendor, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @FK_dxProject, @FK_dxTax, @FK_dxNote, @Note, @FK_dxCurrency, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @BlanketOrder, @FK_dxEmployee__Purchasing, @Closed, @HavingReception, @Amount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TotalAmount, @TaxAmount, @BalanceAmount, @FK_dxEmployee__ApprovedBy, @FK_dxEmployee__DoneBy, @FK_dxEmployee__RequestBy, @Posted, @FK_dxPurchaseOrder__BlanketOrder, @ExpirationDate, @ReleaseNumber, @FK_dxShippingServiceType, @FK_dxPaymentType, @RMA, @DocumentStatus, @FK_dxDeclarationDismantling, @FK_dxOrderStatus, @ContainerNumber, @BillOfLadingNumber
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPurchaseOrder, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', @FK_dxProject
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'BlanketOrder', @BlanketOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Purchasing', @FK_dxEmployee__Purchasing
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', @Closed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HavingReception', @HavingReception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', @Amount
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
        select @pkdataaudit, 'TotalAmount', @TotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', @TaxAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BalanceAmount', @BalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__ApprovedBy', @FK_dxEmployee__ApprovedBy
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__DoneBy', @FK_dxEmployee__DoneBy
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__RequestBy', @FK_dxEmployee__RequestBy
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder__BlanketOrder', @FK_dxPurchaseOrder__BlanketOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpirationDate', @ExpirationDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ReleaseNumber', @ReleaseNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', @FK_dxShippingServiceType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'RMA', @RMA
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeclarationDismantling', @FK_dxDeclarationDismantling
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxOrderStatus', @FK_dxOrderStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ContainerNumber', @ContainerNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillOfLadingNumber', @BillOfLadingNumber
FETCH NEXT FROM pk_cursordxPurchaseOrder INTO @PK_dxPurchaseOrder, @ID, @FK_dxVendor, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @FK_dxProject, @FK_dxTax, @FK_dxNote, @Note, @FK_dxCurrency, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @BlanketOrder, @FK_dxEmployee__Purchasing, @Closed, @HavingReception, @Amount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TotalAmount, @TaxAmount, @BalanceAmount, @FK_dxEmployee__ApprovedBy, @FK_dxEmployee__DoneBy, @FK_dxEmployee__RequestBy, @Posted, @FK_dxPurchaseOrder__BlanketOrder, @ExpirationDate, @ReleaseNumber, @FK_dxShippingServiceType, @FK_dxPaymentType, @RMA, @DocumentStatus, @FK_dxDeclarationDismantling, @FK_dxOrderStatus, @ContainerNumber, @BillOfLadingNumber
 END

 CLOSE pk_cursordxPurchaseOrder 
 DEALLOCATE pk_cursordxPurchaseOrder
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPurchaseOrder.trAuditInsUpd] ON [dbo].[dxPurchaseOrder] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPurchaseOrder CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPurchaseOrder from inserted;
 set @tablename = 'dxPurchaseOrder' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPurchaseOrder
 FETCH NEXT FROM pk_cursordxPurchaseOrder INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Billing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Billing', FK_dxAddress__Billing from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BillingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillingAddress', BillingAddress from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Shipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Shipping', FK_dxAddress__Shipping from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShippingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShippingAddress', ShippingAddress from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', FK_dxTax from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', FK_dxFOB from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', FOB from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', FK_dxShipVia from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BlanketOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'BlanketOrder', BlanketOrder from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__Purchasing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Purchasing', FK_dxEmployee__Purchasing from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Closed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', Closed from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HavingReception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HavingReception', HavingReception from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', DiscountAmount from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmountBeforeTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', TotalAmountBeforeTax from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', Tax1Amount from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', Tax2Amount from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', Tax3Amount from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', TaxAmount from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BalanceAmount', BalanceAmount from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__ApprovedBy )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__ApprovedBy', FK_dxEmployee__ApprovedBy from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__DoneBy )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__DoneBy', FK_dxEmployee__DoneBy from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__RequestBy )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__RequestBy', FK_dxEmployee__RequestBy from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPurchaseOrder__BlanketOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder__BlanketOrder', FK_dxPurchaseOrder__BlanketOrder from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExpirationDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpirationDate', ExpirationDate from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReleaseNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ReleaseNumber', ReleaseNumber from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingServiceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', FK_dxShippingServiceType from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RMA )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'RMA', RMA from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDeclarationDismantling )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeclarationDismantling', FK_dxDeclarationDismantling from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxOrderStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxOrderStatus', FK_dxOrderStatus from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ContainerNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ContainerNumber', ContainerNumber from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BillOfLadingNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillOfLadingNumber', BillOfLadingNumber from dxPurchaseOrder where PK_dxPurchaseOrder = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPurchaseOrder INTO @keyvalue
 END

 CLOSE pk_cursordxPurchaseOrder 
 DEALLOCATE pk_cursordxPurchaseOrder
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxPurchaseOrder.trCheckImputationAccount] ON [dbo].[dxPurchaseOrder]
AFTER UPDATE
AS
Begin
 Declare @Message VARCHAR(2000)
 If ((Select MAX(CAST(Posted AS INT)) FROM INSERTED) = 1 AND
     (Select MAX(CAST(Posted AS INT)) FROM DELETED) = 0)
 begin
   -- Check if account is null
   (Select Top 1 @Message =pd.Description + ' - '+ 'Le compte d''imputation doit avoir une valeur / Imputation account must have a value' From inserted po
       left join dxPurchaseOrderDetail pd on ( pd.FK_dxPurchaseOrder = po.PK_dxPurchaseOrder)
       where pd.FK_dxAccount__Expense is null )
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
CREATE TRIGGER [dbo].[dxPurchaseOrder.trDelete] ON [dbo].[dxPurchaseOrder]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  delete from dxPurchaseOrderDetail where FK_dxPurchaseOrder in (SELECT PK_dxPurchaseOrder FROM deleted) ;
  delete from dxPurchaseOrder       where PK_dxPurchaseOrder in (SELECT PK_dxPurchaseOrder FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [PK_dxPurchaseOrder] PRIMARY KEY CLUSTERED  ([PK_dxPurchaseOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxAddress__Billing] ON [dbo].[dxPurchaseOrder] ([FK_dxAddress__Billing]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxAddress__Shipping] ON [dbo].[dxPurchaseOrder] ([FK_dxAddress__Shipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxCurrency] ON [dbo].[dxPurchaseOrder] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxDeclarationDismantling] ON [dbo].[dxPurchaseOrder] ([FK_dxDeclarationDismantling]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxEmployee__ApprovedBy] ON [dbo].[dxPurchaseOrder] ([FK_dxEmployee__ApprovedBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxEmployee__DoneBy] ON [dbo].[dxPurchaseOrder] ([FK_dxEmployee__DoneBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxEmployee__Purchasing] ON [dbo].[dxPurchaseOrder] ([FK_dxEmployee__Purchasing]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxEmployee__RequestBy] ON [dbo].[dxPurchaseOrder] ([FK_dxEmployee__RequestBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxFOB] ON [dbo].[dxPurchaseOrder] ([FK_dxFOB]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxNote] ON [dbo].[dxPurchaseOrder] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxOrderStatus] ON [dbo].[dxPurchaseOrder] ([FK_dxOrderStatus]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxPaymentType] ON [dbo].[dxPurchaseOrder] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxProject] ON [dbo].[dxPurchaseOrder] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxPurchaseOrder__BlanketOrder] ON [dbo].[dxPurchaseOrder] ([FK_dxPurchaseOrder__BlanketOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxShippingServiceType] ON [dbo].[dxPurchaseOrder] ([FK_dxShippingServiceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxShipVia] ON [dbo].[dxPurchaseOrder] ([FK_dxShipVia]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxTax] ON [dbo].[dxPurchaseOrder] ([FK_dxTax]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrder_FK_dxVendor] ON [dbo].[dxPurchaseOrder] ([FK_dxVendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxPurchaseOrderDate] ON [dbo].[dxPurchaseOrder] ([TransactionDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Billing_dxPurchaseOrder] FOREIGN KEY ([FK_dxAddress__Billing]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Shipping_dxPurchaseOrder] FOREIGN KEY ([FK_dxAddress__Shipping]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxPurchaseOrder] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxDeclarationDismantling_dxPurchaseOrder] FOREIGN KEY ([FK_dxDeclarationDismantling]) REFERENCES [dbo].[dxDeclarationDismantling] ([PK_dxDeclarationDismantling])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__ApprovedBy_dxPurchaseOrder] FOREIGN KEY ([FK_dxEmployee__ApprovedBy]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__DoneBy_dxPurchaseOrder] FOREIGN KEY ([FK_dxEmployee__DoneBy]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__Purchasing_dxPurchaseOrder] FOREIGN KEY ([FK_dxEmployee__Purchasing]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__RequestBy_dxPurchaseOrder] FOREIGN KEY ([FK_dxEmployee__RequestBy]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxFOB_dxPurchaseOrder] FOREIGN KEY ([FK_dxFOB]) REFERENCES [dbo].[dxFOB] ([PK_dxFOB])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxPurchaseOrder] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxOrderStatus_dxPurchaseOrder] FOREIGN KEY ([FK_dxOrderStatus]) REFERENCES [dbo].[dxOrderStatus] ([PK_dxOrderStatus])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxPurchaseOrder] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxPurchaseOrder] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxPurchaseOrder__BlanketOrder_dxPurchaseOrder] FOREIGN KEY ([FK_dxPurchaseOrder__BlanketOrder]) REFERENCES [dbo].[dxPurchaseOrder] ([PK_dxPurchaseOrder])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxShippingServiceType_dxPurchaseOrder] FOREIGN KEY ([FK_dxShippingServiceType]) REFERENCES [dbo].[dxShippingServiceType] ([PK_dxShippingServiceType])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxShipVia_dxPurchaseOrder] FOREIGN KEY ([FK_dxShipVia]) REFERENCES [dbo].[dxShipVia] ([PK_dxShipVia])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxPurchaseOrder] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
ALTER TABLE [dbo].[dxPurchaseOrder] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxPurchaseOrder] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
