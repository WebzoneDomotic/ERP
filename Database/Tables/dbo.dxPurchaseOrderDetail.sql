CREATE TABLE [dbo].[dxPurchaseOrderDetail]
(
[PK_dxPurchaseOrderDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPurchaseOrder] [int] NOT NULL,
[Closed] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Closed] DEFAULT ((0)),
[ExpectedReceptionDate] [datetime] NOT NULL,
[FK_dxProduct] [int] NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Lot] DEFAULT ('0'),
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Quantity] DEFAULT ((0.0)),
[ReceivedQuantity] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_ReceivedQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit__Quantity] [int] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_FK_dxScaleUnit__Quantity] DEFAULT ((1)),
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_UnitAmount] DEFAULT ((0.0)),
[FK_dxScaleUnit__UnitAmount] [int] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_FK_dxScaleUnit__UnitAmount] DEFAULT ((1)),
[ProductQuantity] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_ProductQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_FK_dxScaleUnit] DEFAULT ((1)),
[Amount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Amount] DEFAULT ((0.0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Discount] DEFAULT ((0.0)),
[DiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_DiscountAmount] DEFAULT ((0.0)),
[TotalAmountBeforeTax] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_TotalAmountBeforeTax] DEFAULT ((0.0)),
[Tax1Amount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Tax1Amount] DEFAULT ((0.0)),
[Tax2Amount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Tax2Amount] DEFAULT ((0.0)),
[Tax3Amount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Tax3Amount] DEFAULT ((0.0)),
[TaxAmount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_TaxAmount] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_TotalAmount] DEFAULT ((0.0)),
[FK_dxAccount__Expense] [int] NULL,
[ApplyTax1] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_ApplyTax1] DEFAULT ((1)),
[ApplyTax2] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_ApplyTax2] DEFAULT ((1)),
[ApplyTax3] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_ApplyTax3] DEFAULT ((1)),
[Tax1Rate] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Tax1Rate] DEFAULT ((0.0)),
[Tax2Rate] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Tax2Rate] DEFAULT ((0.0)),
[Tax3Rate] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Tax3Rate] DEFAULT ((0.0)),
[FK_dxProject] [int] NULL,
[Rank] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_Rank] DEFAULT ((0.0)),
[DefaultReleaseQuantity] [int] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_DefaultReleaseQuantity] DEFAULT ((0.0)),
[AlertQuantity] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_AlertQuantity] DEFAULT ((0.0)),
[FK_dxShippingServiceType] [int] NULL,
[UnitAmountVariance] [float] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_UnitAmountVariance] DEFAULT ((0.0)),
[VendorCode] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_VendorCode] DEFAULT (''),
[PriceRequest] [bit] NOT NULL CONSTRAINT [DF_dxPurchaseOrderDetail_PriceRequest] DEFAULT ((0)),
[FK_dxWarehouse] [int] NULL,
[FK_dxLocation] [int] NULL,
[ContainerNumber] [varchar] (100) COLLATE French_CI_AS NULL,
[BillOfLadingNumber] [varchar] (100) COLLATE French_CI_AS NULL,
[Note] [varchar] (8000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPurchaseOrderDetail.trAuditDelete] ON [dbo].[dxPurchaseOrderDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPurchaseOrderDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPurchaseOrderDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPurchaseOrderDetail, FK_dxPurchaseOrder, Closed, ExpectedReceptionDate, FK_dxProduct, Lot, Description, Quantity, ReceivedQuantity, FK_dxScaleUnit__Quantity, UnitAmount, FK_dxScaleUnit__UnitAmount, ProductQuantity, FK_dxScaleUnit, Amount, Discount, DiscountAmount, TotalAmountBeforeTax, Tax1Amount, Tax2Amount, Tax3Amount, TaxAmount, TotalAmount, FK_dxAccount__Expense, ApplyTax1, ApplyTax2, ApplyTax3, Tax1Rate, Tax2Rate, Tax3Rate, FK_dxProject, Rank, DefaultReleaseQuantity, AlertQuantity, FK_dxShippingServiceType, UnitAmountVariance, VendorCode, PriceRequest, FK_dxWarehouse, FK_dxLocation, ContainerNumber, BillOfLadingNumber, Note from deleted
 Declare @PK_dxPurchaseOrderDetail int, @FK_dxPurchaseOrder int, @Closed Bit, @ExpectedReceptionDate DateTime, @FK_dxProduct int, @Lot varchar(50), @Description varchar(2000), @Quantity Float, @ReceivedQuantity Float, @FK_dxScaleUnit__Quantity int, @UnitAmount Float, @FK_dxScaleUnit__UnitAmount int, @ProductQuantity Float, @FK_dxScaleUnit int, @Amount Float, @Discount Float, @DiscountAmount Float, @TotalAmountBeforeTax Float, @Tax1Amount Float, @Tax2Amount Float, @Tax3Amount Float, @TaxAmount Float, @TotalAmount Float, @FK_dxAccount__Expense int, @ApplyTax1 Bit, @ApplyTax2 Bit, @ApplyTax3 Bit, @Tax1Rate Float, @Tax2Rate Float, @Tax3Rate Float, @FK_dxProject int, @Rank Float, @DefaultReleaseQuantity int, @AlertQuantity Float, @FK_dxShippingServiceType int, @UnitAmountVariance Float, @VendorCode varchar(50), @PriceRequest Bit, @FK_dxWarehouse int, @FK_dxLocation int, @ContainerNumber varchar(100), @BillOfLadingNumber varchar(100), @Note varchar(8000)

 OPEN pk_cursordxPurchaseOrderDetail
 FETCH NEXT FROM pk_cursordxPurchaseOrderDetail INTO @PK_dxPurchaseOrderDetail, @FK_dxPurchaseOrder, @Closed, @ExpectedReceptionDate, @FK_dxProduct, @Lot, @Description, @Quantity, @ReceivedQuantity, @FK_dxScaleUnit__Quantity, @UnitAmount, @FK_dxScaleUnit__UnitAmount, @ProductQuantity, @FK_dxScaleUnit, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxAccount__Expense, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Tax1Rate, @Tax2Rate, @Tax3Rate, @FK_dxProject, @Rank, @DefaultReleaseQuantity, @AlertQuantity, @FK_dxShippingServiceType, @UnitAmountVariance, @VendorCode, @PriceRequest, @FK_dxWarehouse, @FK_dxLocation, @ContainerNumber, @BillOfLadingNumber, @Note
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPurchaseOrderDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder', @FK_dxPurchaseOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', @Closed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpectedReceptionDate', @ExpectedReceptionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', @Lot
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', @Quantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReceivedQuantity', @ReceivedQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', @FK_dxScaleUnit__Quantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', @UnitAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__UnitAmount', @FK_dxScaleUnit__UnitAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', @ProductQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', @FK_dxScaleUnit
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
        select @pkdataaudit, 'FK_dxAccount__Expense', @FK_dxAccount__Expense
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax1', @ApplyTax1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax2', @ApplyTax2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax3', @ApplyTax3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Rate', @Tax1Rate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Rate', @Tax2Rate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Rate', @Tax3Rate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', @FK_dxProject
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DefaultReleaseQuantity', @DefaultReleaseQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AlertQuantity', @AlertQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', @FK_dxShippingServiceType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmountVariance', @UnitAmountVariance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorCode', @VendorCode
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PriceRequest', @PriceRequest
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', @FK_dxWarehouse
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', @FK_dxLocation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ContainerNumber', @ContainerNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillOfLadingNumber', @BillOfLadingNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
FETCH NEXT FROM pk_cursordxPurchaseOrderDetail INTO @PK_dxPurchaseOrderDetail, @FK_dxPurchaseOrder, @Closed, @ExpectedReceptionDate, @FK_dxProduct, @Lot, @Description, @Quantity, @ReceivedQuantity, @FK_dxScaleUnit__Quantity, @UnitAmount, @FK_dxScaleUnit__UnitAmount, @ProductQuantity, @FK_dxScaleUnit, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxAccount__Expense, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Tax1Rate, @Tax2Rate, @Tax3Rate, @FK_dxProject, @Rank, @DefaultReleaseQuantity, @AlertQuantity, @FK_dxShippingServiceType, @UnitAmountVariance, @VendorCode, @PriceRequest, @FK_dxWarehouse, @FK_dxLocation, @ContainerNumber, @BillOfLadingNumber, @Note
 END

 CLOSE pk_cursordxPurchaseOrderDetail 
 DEALLOCATE pk_cursordxPurchaseOrderDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPurchaseOrderDetail.trAuditInsUpd] ON [dbo].[dxPurchaseOrderDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPurchaseOrderDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPurchaseOrderDetail from inserted;
 set @tablename = 'dxPurchaseOrderDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPurchaseOrderDetail
 FETCH NEXT FROM pk_cursordxPurchaseOrderDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPurchaseOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder', FK_dxPurchaseOrder from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Closed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', Closed from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExpectedReceptionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpectedReceptionDate', ExpectedReceptionDate from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReceivedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReceivedQuantity', ReceivedQuantity from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', FK_dxScaleUnit__Quantity from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__UnitAmount', FK_dxScaleUnit__UnitAmount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProductQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', ProductQuantity from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Discount', Discount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', DiscountAmount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmountBeforeTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', TotalAmountBeforeTax from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', Tax1Amount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', Tax2Amount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', Tax3Amount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', TaxAmount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Expense )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Expense', FK_dxAccount__Expense from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax1', ApplyTax1 from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax2', ApplyTax2 from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax3', ApplyTax3 from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Rate', Tax1Rate from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Rate', Tax2Rate from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Rate', Tax3Rate from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DefaultReleaseQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DefaultReleaseQuantity', DefaultReleaseQuantity from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AlertQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AlertQuantity', AlertQuantity from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingServiceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', FK_dxShippingServiceType from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmountVariance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmountVariance', UnitAmountVariance from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( VendorCode )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorCode', VendorCode from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PriceRequest )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PriceRequest', PriceRequest from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ContainerNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ContainerNumber', ContainerNumber from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BillOfLadingNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillOfLadingNumber', BillOfLadingNumber from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxPurchaseOrderDetail where PK_dxPurchaseOrderDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPurchaseOrderDetail INTO @keyvalue
 END

 CLOSE pk_cursordxPurchaseOrderDetail 
 DEALLOCATE pk_cursordxPurchaseOrderDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPurchaseOrderDetail.trBuildList] ON [dbo].[dxPurchaseOrderDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;
   declare @DocList varchar(150);

   set @FKi = ( SELECT Coalesce(max(FK_dxPurchaseOrder ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxPurchaseOrder ),-1) from deleted  )
   if (@FKi < @FKd) set @FK = @FKd else  set @FK = @FKi

   Set  @DocList = Null ;
   Select  @DocList =
              case dbo.fdxIncluded( Coalesce(Convert(varchar(100),  ContainerNumber ),'') , @DocList )  when 1 then  @DocList
              else  COALESCE(@DocList  + ',', '') + Coalesce(Convert(varchar(10),  ContainerNumber ),'')
              end  from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK and not FK_dxPurchaseOrder is null and not ContainerNumber is null
   Update dxPurchaseOrder set ContainerNumber =  Coalesce(@DocList, '') where PK_dxPurchaseOrder = @FK

   Set  @DocList = Null ;
   Select  @DocList =
              case dbo.fdxIncluded( Coalesce(Convert(varchar(100),  BillOfLadingNumber ),'') , @DocList )  when 1 then  @DocList
              else  COALESCE(@DocList  + ',', '') + Coalesce(Convert(varchar(10),   BillOfLadingNumber ),'')
              end  from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK and not FK_dxPurchaseOrder is null  and not BillOfLadingNumber is null
   Update dxPurchaseOrder set  BillOfLadingNumber =  Coalesce(@DocList, '') where PK_dxPurchaseOrder = @FK

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPurchaseOrderDetail.trUpdateSum] ON [dbo].[dxPurchaseOrderDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;

   set @FKi  = ( SELECT Coalesce(max(FK_dxPurchaseOrder ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxPurchaseOrder ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   update dxPurchaseOrder
         set
         Closed               = ( select Convert( bit, coalesce(min( Convert( int, Closed) ),0))  from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         HavingReception      = ( select Convert( bit, coalesce(sum( ReceivedQuantity), 0.0 ) )   from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         Amount               = ( select coalesce(sum( Amount ),0.0)                from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         DiscountAmount       = ( select coalesce(sum( DiscountAmount),0.0)         from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         TotalAmountBeforeTax = ( select coalesce(sum( TotalAmountBeforeTax ),0.0)  from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         Tax1Amount           = ( select coalesce(sum( Tax1Amount ),0.0)   from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         Tax2Amount           = ( select coalesce(sum( Tax2Amount ),0.0)   from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         Tax3Amount           = ( select coalesce(sum( Tax3Amount ),0.0)   from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         TaxAmount            = ( select coalesce(sum( TaxAmount  ),0.0)   from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         TotalAmount          = ( select coalesce(sum( TotalAmount ),0.0)  from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK ) ,
         BalanceAmount        = ( select coalesce(sum( TotalAmount ),0.0)  from dxPurchaseOrderDetail where FK_dxPurchaseOrder = @FK )
   where PK_dxPurchaseOrder = @FK

   -- Update the expense account
   Update pd
      set pd.FK_dxAccount__Expense = dbo.fdxGetVendorImputationAccount ( 1, pd.PK_dxPurchaseOrderDetail )
   From inserted ie
   left join deleted de on ( de.PK_dxPurchaseOrderDetail = ie.PK_dxPurchaseOrderDetail)
   left join dxPurchaseOrderDetail pd on ( pd.PK_dxPurchaseOrderDetail = ie.PK_dxPurchaseOrderDetail)
   left join dxPurchaseOrder po on (po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder)
   where po.Posted = 0
     and pd.Closed = 0
     and ((ie.FK_dxAccount__Expense is null) or ( ie.FK_dxProduct <> de.FK_dxProduct))
     and abs(pd.ReceivedQuantity) < 0.0000001

END
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [PK_dxPurchaseOrderDetail] PRIMARY KEY CLUSTERED  ([PK_dxPurchaseOrderDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxAccount__Expense] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxAccount__Expense]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxLocation] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxProduct] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxProject] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxPurchaseOrder] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxPurchaseOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxScaleUnit] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxScaleUnit__Quantity] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxScaleUnit__Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxScaleUnit__UnitAmount] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxScaleUnit__UnitAmount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxShippingServiceType] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxShippingServiceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchaseOrderDetail_FK_dxWarehouse] ON [dbo].[dxPurchaseOrderDetail] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Expense_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxAccount__Expense]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxPurchaseOrder_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxPurchaseOrder]) REFERENCES [dbo].[dxPurchaseOrder] ([PK_dxPurchaseOrder])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Quantity_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxScaleUnit__Quantity]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__UnitAmount_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxScaleUnit__UnitAmount]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxShippingServiceType_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxShippingServiceType]) REFERENCES [dbo].[dxShippingServiceType] ([PK_dxShippingServiceType])
GO
ALTER TABLE [dbo].[dxPurchaseOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxPurchaseOrderDetail] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
