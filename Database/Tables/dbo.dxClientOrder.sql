CREATE TABLE [dbo].[dxClientOrder]
(
[PK_dxClientOrder] [int] NOT NULL IDENTITY(50000, 1),
[ID] AS ([PK_dxClientOrder]),
[PONumber] [varchar] (50) COLLATE French_CI_AS NULL,
[FK_dxClient] [int] NOT NULL,
[ExpectedDeliveryDate] [datetime] NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxAddress__Billing] [int] NULL,
[BillingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxAddress__Shipping] [int] NULL,
[ShippingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[Amount] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_Amount] DEFAULT ((0.0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_Discount] DEFAULT ((0.0)),
[DiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_DiscountAmount] DEFAULT ((0.0)),
[TotalAmountBeforeTax] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_TotalAmountBeforeTax] DEFAULT ((0.0)),
[Tax1Amount] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_Tax1Amount] DEFAULT ((0.0)),
[Tax2Amount] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_Tax2Amount] DEFAULT ((0.0)),
[Tax3Amount] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_Tax3Amount] DEFAULT ((0.0)),
[TaxAmount] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_TaxAmount] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxClientOrder_TotalAmount] DEFAULT ((0.0)),
[FK_dxProject] [int] NULL,
[FK_dxTax] [int] NOT NULL CONSTRAINT [DF_dxClientOrder_FK_dxTax] DEFAULT ((1)),
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxClientOrder_FK_dxCurrency] DEFAULT ((1)),
[FK_dxFOB] [int] NULL,
[FOB] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxShipVia] [int] NULL,
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[Closed] [bit] NOT NULL CONSTRAINT [DF_dxClientOrder_Closed] DEFAULT ((0)),
[HavingShippement] [bit] NOT NULL CONSTRAINT [DF_dxClientOrder_HavingShippement] DEFAULT ((0)),
[FK_dxEmployee__Sales] [int] NULL,
[OnHold] [bit] NOT NULL CONSTRAINT [DF_dxClientOrder_OnHold] DEFAULT ((0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxClientOrder_Posted] DEFAULT ((0)),
[FK_dxShippingServiceType] [int] NULL,
[FK_dxEmployee__ApprovedBy] [int] NULL,
[FK_dxEmployee__DoneBy] [int] NULL,
[InternalNote] [varchar] (2000) COLLATE French_CI_AS NULL,
[NumberOfBoxes] [int] NOT NULL CONSTRAINT [DF_dxClientOrder_NumberOfBoxes] DEFAULT ((0)),
[NumberOfCases] [int] NOT NULL CONSTRAINT [DF_dxClientOrder_NumberOfCases] DEFAULT ((0)),
[NumberOfSkids] [int] NOT NULL CONSTRAINT [DF_dxClientOrder_NumberOfSkids] DEFAULT ((0)),
[ExpectedReceptionDate] [datetime] NULL,
[NumberOfPrint] [int] NOT NULL CONSTRAINT [DF_dxClientOrder_NumberOfPrint] DEFAULT ((0)),
[MakeToOrder] [bit] NOT NULL CONSTRAINT [DF_dxClientOrder_MakeToOrder] DEFAULT ((0)),
[HoldTheShipment] [bit] NOT NULL CONSTRAINT [DF_dxClientOrder_HoldTheShipment] DEFAULT ((0)),
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxClientOrder_DocumentStatus] DEFAULT ((0)),
[FK_dxOrderStatus] [int] NULL,
[FK_dxPaymentType] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientOrder.trAuditDelete] ON [dbo].[dxClientOrder]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientOrder'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientOrder CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientOrder, ID, PONumber, FK_dxClient, ExpectedDeliveryDate, TransactionDate, Description, FK_dxAddress__Billing, BillingAddress, FK_dxAddress__Shipping, ShippingAddress, Amount, Discount, DiscountAmount, TotalAmountBeforeTax, Tax1Amount, Tax2Amount, Tax3Amount, TaxAmount, TotalAmount, FK_dxProject, FK_dxTax, FK_dxNote, Note, FK_dxCurrency, FK_dxFOB, FOB, FK_dxShipVia, ShipVia, Closed, HavingShippement, FK_dxEmployee__Sales, OnHold, Posted, FK_dxShippingServiceType, FK_dxEmployee__ApprovedBy, FK_dxEmployee__DoneBy, InternalNote, NumberOfBoxes, NumberOfCases, NumberOfSkids, ExpectedReceptionDate, NumberOfPrint, MakeToOrder, HoldTheShipment, DocumentStatus, FK_dxOrderStatus, FK_dxPaymentType from deleted
 Declare @PK_dxClientOrder int, @ID int, @PONumber varchar(50), @FK_dxClient int, @ExpectedDeliveryDate DateTime, @TransactionDate DateTime, @Description varchar(500), @FK_dxAddress__Billing int, @BillingAddress varchar(1000), @FK_dxAddress__Shipping int, @ShippingAddress varchar(1000), @Amount Float, @Discount Float, @DiscountAmount Float, @TotalAmountBeforeTax Float, @Tax1Amount Float, @Tax2Amount Float, @Tax3Amount Float, @TaxAmount Float, @TotalAmount Float, @FK_dxProject int, @FK_dxTax int, @FK_dxNote int, @Note varchar(2000), @FK_dxCurrency int, @FK_dxFOB int, @FOB varchar(500), @FK_dxShipVia int, @ShipVia varchar(500), @Closed Bit, @HavingShippement Bit, @FK_dxEmployee__Sales int, @OnHold Bit, @Posted Bit, @FK_dxShippingServiceType int, @FK_dxEmployee__ApprovedBy int, @FK_dxEmployee__DoneBy int, @InternalNote varchar(2000), @NumberOfBoxes int, @NumberOfCases int, @NumberOfSkids int, @ExpectedReceptionDate DateTime, @NumberOfPrint int, @MakeToOrder Bit, @HoldTheShipment Bit, @DocumentStatus int, @FK_dxOrderStatus int, @FK_dxPaymentType int

 OPEN pk_cursordxClientOrder
 FETCH NEXT FROM pk_cursordxClientOrder INTO @PK_dxClientOrder, @ID, @PONumber, @FK_dxClient, @ExpectedDeliveryDate, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxProject, @FK_dxTax, @FK_dxNote, @Note, @FK_dxCurrency, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @Closed, @HavingShippement, @FK_dxEmployee__Sales, @OnHold, @Posted, @FK_dxShippingServiceType, @FK_dxEmployee__ApprovedBy, @FK_dxEmployee__DoneBy, @InternalNote, @NumberOfBoxes, @NumberOfCases, @NumberOfSkids, @ExpectedReceptionDate, @NumberOfPrint, @MakeToOrder, @HoldTheShipment, @DocumentStatus, @FK_dxOrderStatus, @FK_dxPaymentType
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientOrder, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PONumber', @PONumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpectedDeliveryDate', @ExpectedDeliveryDate
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
        select @pkdataaudit, 'Closed', @Closed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HavingShippement', @HavingShippement
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Sales', @FK_dxEmployee__Sales
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'OnHold', @OnHold
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', @FK_dxShippingServiceType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__ApprovedBy', @FK_dxEmployee__ApprovedBy
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__DoneBy', @FK_dxEmployee__DoneBy
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'InternalNote', @InternalNote
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfBoxes', @NumberOfBoxes
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfCases', @NumberOfCases
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfSkids', @NumberOfSkids
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpectedReceptionDate', @ExpectedReceptionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfPrint', @NumberOfPrint
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'MakeToOrder', @MakeToOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HoldTheShipment', @HoldTheShipment
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxOrderStatus', @FK_dxOrderStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
FETCH NEXT FROM pk_cursordxClientOrder INTO @PK_dxClientOrder, @ID, @PONumber, @FK_dxClient, @ExpectedDeliveryDate, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxProject, @FK_dxTax, @FK_dxNote, @Note, @FK_dxCurrency, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @Closed, @HavingShippement, @FK_dxEmployee__Sales, @OnHold, @Posted, @FK_dxShippingServiceType, @FK_dxEmployee__ApprovedBy, @FK_dxEmployee__DoneBy, @InternalNote, @NumberOfBoxes, @NumberOfCases, @NumberOfSkids, @ExpectedReceptionDate, @NumberOfPrint, @MakeToOrder, @HoldTheShipment, @DocumentStatus, @FK_dxOrderStatus, @FK_dxPaymentType
 END

 CLOSE pk_cursordxClientOrder 
 DEALLOCATE pk_cursordxClientOrder
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientOrder.trAuditInsUpd] ON [dbo].[dxClientOrder] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientOrder CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientOrder from inserted;
 set @tablename = 'dxClientOrder' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientOrder
 FETCH NEXT FROM pk_cursordxClientOrder INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PONumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PONumber', PONumber from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExpectedDeliveryDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpectedDeliveryDate', ExpectedDeliveryDate from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Billing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Billing', FK_dxAddress__Billing from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BillingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillingAddress', BillingAddress from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Shipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Shipping', FK_dxAddress__Shipping from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShippingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShippingAddress', ShippingAddress from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Discount', Discount from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', DiscountAmount from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmountBeforeTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', TotalAmountBeforeTax from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', Tax1Amount from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', Tax2Amount from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', Tax3Amount from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', TaxAmount from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', FK_dxTax from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', FK_dxFOB from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', FOB from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', FK_dxShipVia from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Closed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', Closed from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HavingShippement )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HavingShippement', HavingShippement from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__Sales )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Sales', FK_dxEmployee__Sales from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OnHold )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'OnHold', OnHold from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingServiceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', FK_dxShippingServiceType from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__ApprovedBy )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__ApprovedBy', FK_dxEmployee__ApprovedBy from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__DoneBy )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__DoneBy', FK_dxEmployee__DoneBy from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InternalNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'InternalNote', InternalNote from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfBoxes )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfBoxes', NumberOfBoxes from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfCases )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfCases', NumberOfCases from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfSkids )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfSkids', NumberOfSkids from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExpectedReceptionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpectedReceptionDate', ExpectedReceptionDate from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfPrint )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfPrint', NumberOfPrint from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MakeToOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'MakeToOrder', MakeToOrder from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HoldTheShipment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HoldTheShipment', HoldTheShipment from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxOrderStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxOrderStatus', FK_dxOrderStatus from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxClientOrder where PK_dxClientOrder = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientOrder INTO @keyvalue
 END

 CLOSE pk_cursordxClientOrder 
 DEALLOCATE pk_cursordxClientOrder
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxClientOrder.trCloseShippingRelease] ON [dbo].[dxClientOrder]
AFTER  UPDATE
AS
BEGIN
   if update(Closed)
      Update dxShipping set Posted = 1
       where FK_dxClientOrder in ( select PK_dxClientOrder from inserted )
         and ListOfOrder = ''
         and Posted = 0
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxClientOrder.trCreateWOFromMTO] ON [dbo].[dxClientOrder]
AFTER UPDATE
AS
BEGIN
   if Update (Posted) 
       Execute pdxCreateWOFromMTO
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientOrder.trUpdateDeliveryDate] ON [dbo].[dxClientOrder]
AFTER INSERT, UPDATE
AS
BEGIN

  Declare @ShippingReleaseDelayInDays int

  If Update(TransactionDate) or Update (ExpectedDeliveryDate) or Update(FK_dxShippingServiceType)
  Begin

     Set @ShippingReleaseDelayInDays = ( select ShippingReleaseDelayInDays from dxSetup where PK_dxSetup = 1)
     -- ExpectedDeliveryDate + Delay must be > or = than the TransactionDate
      Update dxClientOrder
         set ExpectedDeliveryDate = [dbo].[fdxGetPrevNextWorkDay] (DateAdd(dd,-1,ExpectedDeliveryDate),1)
       where PK_dxClientOrder in ( Select PK_dxClientOrder from inserted )

     -- Update Client order Detail
     Update dxClientOrderDetail
       set ExpectedDeliveryDate = [dbo].[fdxGetPrevNextWorkDay] (co.ExpectedDeliveryDate -1.0 ,1)
      From dxClientOrderDetail cd
      Left outer join dxClientOrder co on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
    Where cd.FK_dxClientOrder in ( Select PK_dxClientOrder from inserted )
     --and cd.ExpectedDeliveryDate < co.ExpectedDeliveryDate

    Update dxShipping
       set TransactionDate =  [dbo].[fdxGetPrevNextWorkDay] (co.ExpectedDeliveryDate-1.0,1)
      From dxShipping sh
      Left outer join dxClientOrder co on ( co.PK_dxClientOrder = sh.FK_dxClientOrder )
     Where sh.FK_dxClientOrder in ( Select PK_dxClientOrder from inserted )
       and sh.Posted = 0

    Update co
       Set co.ExpectedReceptionDate = [dbo].[fdxGetPrevNextWorkDay] (co.ExpectedDeliveryDate + Coalesce(sst.ShippingDelayInHours/24,0)-1.0,1)
      From dxCLientOrder co
      Left join dxShippingServiceType sst ON sst.PK_dxShippingServiceType = co.FK_dxShippingServiceType
     Where co.PK_dxCLientOrder in ( Select PK_dxClientOrder from inserted )
  End
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxClientOrder.trUpdateShipping] ON [dbo].[dxClientOrder]
AFTER UPDATE
AS
BEGIN
    UPDATE s
    SET
     s.FK_dxClient = i.FK_dxClient,
     s.TransactionDate = i.TransactionDate,
     s.Description = i.Description,
     s.FK_dxAddress__Billing = i.FK_dxAddress__Billing,
     s.BillingAddress = i.BillingAddress,
     s.FK_dxAddress__Shipping = i.FK_dxAddress__Shipping,
     s.ShippingAddress = i.ShippingAddress,
     s.FK_dxNote = i.FK_dxNote,
     s.Note = i.Note,
     s.FK_dxFOB = i.FK_dxFOB,
     s.FOB = i.FOB,
     s.FK_dxShipVia = i.FK_dxShipVia,
     s.ShipVia = i.ShipVia,
     s.FK_dxShippingServiceType = i.FK_dxShippingServiceType,
     s.FK_dxEmployee__ApprovedBy = i.FK_dxEmployee__ApprovedBy
    FROM INSERTED i
    INNER JOIN dbo.dxShipping s ON s.FK_dxClientOrder = i.PK_dxClientOrder
    WHERE s.Posted = 0
END
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [CK_dxClientOrder_Date] CHECK (([ExpectedDeliveryDate]>=[TransactionDate]))
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [PK_dxClientOrder] PRIMARY KEY CLUSTERED  ([PK_dxClientOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxClientOrderDeliveryDate] ON [dbo].[dxClientOrder] ([ExpectedDeliveryDate] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxAddress__Billing] ON [dbo].[dxClientOrder] ([FK_dxAddress__Billing]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxAddress__Shipping] ON [dbo].[dxClientOrder] ([FK_dxAddress__Shipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxClient] ON [dbo].[dxClientOrder] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxCurrency] ON [dbo].[dxClientOrder] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxEmployee__ApprovedBy] ON [dbo].[dxClientOrder] ([FK_dxEmployee__ApprovedBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxEmployee__DoneBy] ON [dbo].[dxClientOrder] ([FK_dxEmployee__DoneBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxEmployee__Sales] ON [dbo].[dxClientOrder] ([FK_dxEmployee__Sales]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxFOB] ON [dbo].[dxClientOrder] ([FK_dxFOB]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxNote] ON [dbo].[dxClientOrder] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxOrderStatus] ON [dbo].[dxClientOrder] ([FK_dxOrderStatus]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxPaymentType] ON [dbo].[dxClientOrder] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxProject] ON [dbo].[dxClientOrder] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxShippingServiceType] ON [dbo].[dxClientOrder] ([FK_dxShippingServiceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxShipVia] ON [dbo].[dxClientOrder] ([FK_dxShipVia]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrder_FK_dxTax] ON [dbo].[dxClientOrder] ([FK_dxTax]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxClientOrderDate] ON [dbo].[dxClientOrder] ([TransactionDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Billing_dxClientOrder] FOREIGN KEY ([FK_dxAddress__Billing]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Shipping_dxClientOrder] FOREIGN KEY ([FK_dxAddress__Shipping]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxClientOrder] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxClientOrder] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__ApprovedBy_dxClientOrder] FOREIGN KEY ([FK_dxEmployee__ApprovedBy]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__DoneBy_dxClientOrder] FOREIGN KEY ([FK_dxEmployee__DoneBy]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__Sales_dxClientOrder] FOREIGN KEY ([FK_dxEmployee__Sales]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxFOB_dxClientOrder] FOREIGN KEY ([FK_dxFOB]) REFERENCES [dbo].[dxFOB] ([PK_dxFOB])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxClientOrder] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxOrderStatus_dxClientOrder] FOREIGN KEY ([FK_dxOrderStatus]) REFERENCES [dbo].[dxOrderStatus] ([PK_dxOrderStatus])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxClientOrder] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxClientOrder] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxShippingServiceType_dxClientOrder] FOREIGN KEY ([FK_dxShippingServiceType]) REFERENCES [dbo].[dxShippingServiceType] ([PK_dxShippingServiceType])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxShipVia_dxClientOrder] FOREIGN KEY ([FK_dxShipVia]) REFERENCES [dbo].[dxShipVia] ([PK_dxShipVia])
GO
ALTER TABLE [dbo].[dxClientOrder] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxClientOrder] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
