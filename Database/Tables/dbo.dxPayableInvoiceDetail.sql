CREATE TABLE [dbo].[dxPayableInvoiceDetail]
(
[PK_dxPayableInvoiceDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPayableInvoice] [int] NOT NULL,
[FK_dxProject] [int] NULL,
[FK_dxProduct] [int] NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Lot] DEFAULT ('0'),
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Quantity] DEFAULT ((0.0)),
[FK_dxScaleUnit__Quantity] [int] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_FK_dxScaleUnit__Quantity] DEFAULT ((1)),
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_UnitAmount] DEFAULT ((0.0)),
[FK_dxScaleUnit__UnitAmount] [int] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_FK_dxScaleUnit__UnitAmount] DEFAULT ((1)),
[ProductQuantity] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_ProductQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_FK_dxScaleUnit] DEFAULT ((1)),
[Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Amount] DEFAULT ((0.0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Discount] DEFAULT ((0.0)),
[DiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_DiscountAmount] DEFAULT ((0.0)),
[TotalAmountBeforeTax] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_TotalAmountBeforeTax] DEFAULT ((0.0)),
[Tax1Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax1Amount] DEFAULT ((0.0)),
[Tax2Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax2Amount] DEFAULT ((0.0)),
[Tax3Amount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax3Amount] DEFAULT ((0.0)),
[TaxAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_TaxAmount] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_TotalAmount] DEFAULT ((0.0)),
[FK_dxAccount__Discount] [int] NULL,
[FK_dxAccount__Expense] [int] NULL,
[FK_dxAccount__AP_Tax1] [int] NULL,
[FK_dxAccount__AP_Tax2] [int] NULL,
[FK_dxAccount__AP_Tax3] [int] NULL,
[FK_dxAccount__Payable] [int] NULL,
[ApplyTax1] [bit] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_ApplyTax1] DEFAULT ((1)),
[ApplyTax2] [bit] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_ApplyTax2] DEFAULT ((1)),
[ApplyTax3] [bit] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_ApplyTax3] DEFAULT ((1)),
[Tax1Rate] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax1Rate] DEFAULT ((0.0)),
[Tax2Rate] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax2Rate] DEFAULT ((0.0)),
[Tax3Rate] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax3Rate] DEFAULT ((0.0)),
[FK_dxReception] [int] NULL,
[FK_dxReceptionDetail] [int] NULL,
[FK_dxPurchaseOrder] [int] NULL,
[FreightCost] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_FreightCost] DEFAULT ((0.0)),
[FreightCharges] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_FreightCharges] DEFAULT ((0.0)),
[Rank] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Rank] DEFAULT ((1.0)),
[Tax1RefundAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax1RefundAmount] DEFAULT ((0.0)),
[Tax2RefundAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax2RefundAmount] DEFAULT ((0.0)),
[Tax3RefundAmount] [float] NOT NULL CONSTRAINT [DF_dxPayableInvoiceDetail_Tax3RefundAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoiceDetail.trAuditDelete] ON [dbo].[dxPayableInvoiceDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPayableInvoiceDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPayableInvoiceDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayableInvoiceDetail, FK_dxPayableInvoice, FK_dxProject, FK_dxProduct, Lot, Description, Quantity, FK_dxScaleUnit__Quantity, UnitAmount, FK_dxScaleUnit__UnitAmount, ProductQuantity, FK_dxScaleUnit, Amount, Discount, DiscountAmount, TotalAmountBeforeTax, Tax1Amount, Tax2Amount, Tax3Amount, TaxAmount, TotalAmount, FK_dxAccount__Discount, FK_dxAccount__Expense, FK_dxAccount__AP_Tax1, FK_dxAccount__AP_Tax2, FK_dxAccount__AP_Tax3, FK_dxAccount__Payable, ApplyTax1, ApplyTax2, ApplyTax3, Tax1Rate, Tax2Rate, Tax3Rate, FK_dxReception, FK_dxReceptionDetail, FK_dxPurchaseOrder, FreightCost, FreightCharges, Rank, Tax1RefundAmount, Tax2RefundAmount, Tax3RefundAmount from deleted
 Declare @PK_dxPayableInvoiceDetail int, @FK_dxPayableInvoice int, @FK_dxProject int, @FK_dxProduct int, @Lot varchar(50), @Description varchar(2000), @Quantity Float, @FK_dxScaleUnit__Quantity int, @UnitAmount Float, @FK_dxScaleUnit__UnitAmount int, @ProductQuantity Float, @FK_dxScaleUnit int, @Amount Float, @Discount Float, @DiscountAmount Float, @TotalAmountBeforeTax Float, @Tax1Amount Float, @Tax2Amount Float, @Tax3Amount Float, @TaxAmount Float, @TotalAmount Float, @FK_dxAccount__Discount int, @FK_dxAccount__Expense int, @FK_dxAccount__AP_Tax1 int, @FK_dxAccount__AP_Tax2 int, @FK_dxAccount__AP_Tax3 int, @FK_dxAccount__Payable int, @ApplyTax1 Bit, @ApplyTax2 Bit, @ApplyTax3 Bit, @Tax1Rate Float, @Tax2Rate Float, @Tax3Rate Float, @FK_dxReception int, @FK_dxReceptionDetail int, @FK_dxPurchaseOrder int, @FreightCost Float, @FreightCharges Float, @Rank Float, @Tax1RefundAmount Float, @Tax2RefundAmount Float, @Tax3RefundAmount Float

 OPEN pk_cursordxPayableInvoiceDetail
 FETCH NEXT FROM pk_cursordxPayableInvoiceDetail INTO @PK_dxPayableInvoiceDetail, @FK_dxPayableInvoice, @FK_dxProject, @FK_dxProduct, @Lot, @Description, @Quantity, @FK_dxScaleUnit__Quantity, @UnitAmount, @FK_dxScaleUnit__UnitAmount, @ProductQuantity, @FK_dxScaleUnit, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxAccount__Discount, @FK_dxAccount__Expense, @FK_dxAccount__AP_Tax1, @FK_dxAccount__AP_Tax2, @FK_dxAccount__AP_Tax3, @FK_dxAccount__Payable, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Tax1Rate, @Tax2Rate, @Tax3Rate, @FK_dxReception, @FK_dxReceptionDetail, @FK_dxPurchaseOrder, @FreightCost, @FreightCharges, @Rank, @Tax1RefundAmount, @Tax2RefundAmount, @Tax3RefundAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPayableInvoiceDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoice', @FK_dxPayableInvoice
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', @FK_dxProject
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
        select @pkdataaudit, 'FK_dxAccount__Discount', @FK_dxAccount__Discount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Expense', @FK_dxAccount__Expense
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax1', @FK_dxAccount__AP_Tax1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax2', @FK_dxAccount__AP_Tax2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax3', @FK_dxAccount__AP_Tax3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Payable', @FK_dxAccount__Payable
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
        select @pkdataaudit, 'FK_dxReception', @FK_dxReception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReceptionDetail', @FK_dxReceptionDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder', @FK_dxPurchaseOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FreightCost', @FreightCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FreightCharges', @FreightCharges
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1RefundAmount', @Tax1RefundAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2RefundAmount', @Tax2RefundAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3RefundAmount', @Tax3RefundAmount
FETCH NEXT FROM pk_cursordxPayableInvoiceDetail INTO @PK_dxPayableInvoiceDetail, @FK_dxPayableInvoice, @FK_dxProject, @FK_dxProduct, @Lot, @Description, @Quantity, @FK_dxScaleUnit__Quantity, @UnitAmount, @FK_dxScaleUnit__UnitAmount, @ProductQuantity, @FK_dxScaleUnit, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxAccount__Discount, @FK_dxAccount__Expense, @FK_dxAccount__AP_Tax1, @FK_dxAccount__AP_Tax2, @FK_dxAccount__AP_Tax3, @FK_dxAccount__Payable, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Tax1Rate, @Tax2Rate, @Tax3Rate, @FK_dxReception, @FK_dxReceptionDetail, @FK_dxPurchaseOrder, @FreightCost, @FreightCharges, @Rank, @Tax1RefundAmount, @Tax2RefundAmount, @Tax3RefundAmount
 END

 CLOSE pk_cursordxPayableInvoiceDetail 
 DEALLOCATE pk_cursordxPayableInvoiceDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoiceDetail.trAuditInsUpd] ON [dbo].[dxPayableInvoiceDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPayableInvoiceDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayableInvoiceDetail from inserted;
 set @tablename = 'dxPayableInvoiceDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPayableInvoiceDetail
 FETCH NEXT FROM pk_cursordxPayableInvoiceDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayableInvoice )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoice', FK_dxPayableInvoice from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', FK_dxScaleUnit__Quantity from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__UnitAmount', FK_dxScaleUnit__UnitAmount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProductQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', ProductQuantity from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Discount', Discount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', DiscountAmount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmountBeforeTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', TotalAmountBeforeTax from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', Tax1Amount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', Tax2Amount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', Tax3Amount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', TaxAmount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Discount', FK_dxAccount__Discount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Expense )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Expense', FK_dxAccount__Expense from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AP_Tax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax1', FK_dxAccount__AP_Tax1 from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AP_Tax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax2', FK_dxAccount__AP_Tax2 from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AP_Tax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax3', FK_dxAccount__AP_Tax3 from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Payable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Payable', FK_dxAccount__Payable from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax1', ApplyTax1 from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax2', ApplyTax2 from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax3', ApplyTax3 from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Rate', Tax1Rate from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Rate', Tax2Rate from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Rate', Tax3Rate from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReception', FK_dxReception from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReceptionDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReceptionDetail', FK_dxReceptionDetail from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPurchaseOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder', FK_dxPurchaseOrder from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FreightCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FreightCost', FreightCost from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FreightCharges )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FreightCharges', FreightCharges from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1RefundAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1RefundAmount', Tax1RefundAmount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2RefundAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2RefundAmount', Tax2RefundAmount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3RefundAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3RefundAmount', Tax3RefundAmount from dxPayableInvoiceDetail where PK_dxPayableInvoiceDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPayableInvoiceDetail INTO @keyvalue
 END

 CLOSE pk_cursordxPayableInvoiceDetail 
 DEALLOCATE pk_cursordxPayableInvoiceDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoiceDetail.trBuildList] ON [dbo].[dxPayableInvoiceDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;
   declare @DocList varchar(150);

   set @FKi  = ( SELECT Coalesce(max(FK_dxPayableInvoice ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxPayableInvoice ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   select  @DocList =
              case dbo.fdxIncluded(Coalesce( Convert(varchar(10),  FK_dxReception),'') , @DocList )  when 1 then  @DocList
              else  COALESCE(@DocList  + ',', '') + Coalesce(Convert(varchar(10),  FK_dxReception),'')
              end  from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK and not FK_dxReception is null
   update  dxPayableInvoice set ListOfReception =  Coalesce(@DocList, '')  where PK_dxPayableInvoice = @FK
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoiceDetail.trUpdateSum] ON [dbo].[dxPayableInvoiceDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  declare @FK int, @FKi int , @FKd int ;


  set @FKi  = ( SELECT Coalesce(max(FK_dxPayableInvoice ),-1) from inserted )
  set @FKd = ( SELECT Coalesce(max(FK_dxPayableInvoice ),-1) from deleted )
  if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

  update dxPayableInvoice set
      Amount               = ( select Coalesce(sum( Amount ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK )
    , DiscountAmount       = ( select Coalesce(sum( DiscountAmount       ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK )
    , TotalAmountBeforeTax = ( select Coalesce(sum( TotalAmountBeforeTax ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK )
    , Tax1Amount           = ( select Coalesce(sum( Tax1Amount           ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK )
    , Tax2Amount           = ( select Coalesce(sum( Tax2Amount           ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK )
    , Tax3Amount           = ( select Coalesce(sum( Tax3Amount           ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK )
   --  TaxAmount            = ( select Coalesce(sum( TaxAmount            ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK ),
   --  TotalAmount          = ( select Coalesce(sum( TotalAmount          ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK ),
   --  BalanceAmount        = ( select Coalesce(sum( TotalAmount          ), 0.0) from dxPayableInvoiceDetail where FK_dxPayableInvoice = @FK ) -
   --                         ( select Coalesce(sum( PaidAmount           ), 0.0) from dxPaymentInvoice       where FK_dxPayableInvoice = @FK and posted = 1 )
  where PK_dxPayableInvoice = @FK ;

  if not( Update( FK_dxAccount__AP_Tax1 ) or Update( FK_dxAccount__AP_Tax2 )or Update( FK_dxAccount__AP_Tax3 )or Update( FK_dxAccount__Payable ))
  Update pd
     set  pd.FK_dxAccount__AP_Tax1 = ta.FK_dxAccount__AP_Tax1
         ,pd.FK_dxAccount__AP_Tax2 = ta.FK_dxAccount__AP_Tax2
         ,pd.FK_dxAccount__AP_Tax3 = ta.FK_dxAccount__AP_Tax3
         ,pd.FK_dxAccount__Payable = cu.FK_dxAccount__Payable
  From inserted ei
  left join dxPayableInvoiceDetail pd on (pd.PK_dxPayableInvoiceDetail = ei.PK_dxPayableInvoiceDetail )
  left join dxPayableInvoice pa on (pa.PK_dxPayableInvoice = ei.FK_dxPayableInvoice )
  left join dxTax ta on (pa.FK_dxTax = ta.PK_dxTax )
  left join dxCurrency cu on (pa.FK_dxCurrency = cu.PK_dxCurrency )

   -- Update the expense account
   Update pd
      set pd.FK_dxAccount__Expense = dbo.fdxGetVendorImputationAccount ( 2, pd.PK_dxPayableInvoiceDetail )
   From inserted ie
   left join deleted de on ( de.PK_dxPayableInvoiceDetail = ie.PK_dxPayableInvoiceDetail )
   left join dxPayableInvoiceDetail pd on ( pd.PK_dxPayableInvoiceDetail = ie.PK_dxPayableInvoiceDetail)
   left join dxPayableInvoice po on (po.PK_dxPayableInvoice = pd.FK_dxPayableInvoice)
   where po.Posted = 0
     and not pd.FK_dxProduct is null
     and (ie.FK_dxAccount__Expense is null
     or    Not pd.FK_dxReceptionDetail is null
     or  (ie.FK_dxProduct <> de.FK_dxProduct) )

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayableInvoiceDetail.trUpdateTaxGroup] ON [dbo].[dxPayableInvoiceDetail]
AFTER INSERT
AS
BEGIN
  if update ( FK_dxReceptionDetail )
  Begin
     Update pa
       Set FK_dxTax = Coalesce(( Select FK_dxTax from dxPurchaseOrder po
                        Left join dxPurchaseOrderDetail pd on ( pd.FK_dxPurchaseOrder = PK_dxPurchaseOrder)
                        left join dxReceptionDetail rd on ( rd.FK_dxPurchaseOrderDetail = pd.PK_dxPurchaseOrderDetail)
                        Where rd.PK_dxReceptionDetail = ie.FK_dxReceptionDetail
                       ) ,1)
     From dxPayableInvoice pa
     left join inserted ie on ( ie.FK_dxPayableInvoice = pa.PK_dxPayableInvoice )
     where pa.PK_dxPayableInvoice in ( Select FK_dxPayableInvoice from inserted)
       and pa.Posted =0
       and not ie.FK_dxReceptionDetail is null
  End
END
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [PK_dxPayableInvoiceDetail] PRIMARY KEY CLUSTERED  ([PK_dxPayableInvoiceDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxAccount__AP_Tax1] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxAccount__AP_Tax1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxAccount__AP_Tax2] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxAccount__AP_Tax2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxAccount__AP_Tax3] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxAccount__AP_Tax3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxAccount__Discount] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxAccount__Discount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxAccount__Expense] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxAccount__Expense]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxAccount__Payable] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxAccount__Payable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxPayableInvoice] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxPayableInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxProduct] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxProject] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxPurchaseOrder] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxPurchaseOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxReception] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxReception]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxReceptionDetail] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxReceptionDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxScaleUnit] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxScaleUnit__Quantity] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxScaleUnit__Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayableInvoiceDetail_FK_dxScaleUnit__UnitAmount] ON [dbo].[dxPayableInvoiceDetail] ([FK_dxScaleUnit__UnitAmount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxPayableInvoiceDetail] ON [dbo].[dxPayableInvoiceDetail] ([PK_dxPayableInvoiceDetail], [FK_dxPayableInvoice]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AP_Tax1_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxAccount__AP_Tax1]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AP_Tax2_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxAccount__AP_Tax2]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AP_Tax3_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxAccount__AP_Tax3]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Discount_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxAccount__Discount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Expense_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxAccount__Expense]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Payable_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxAccount__Payable]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxPayableInvoice_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxPayableInvoice]) REFERENCES [dbo].[dxPayableInvoice] ([PK_dxPayableInvoice])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxPurchaseOrder_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxPurchaseOrder]) REFERENCES [dbo].[dxPurchaseOrder] ([PK_dxPurchaseOrder])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxReception_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxReception]) REFERENCES [dbo].[dxReception] ([PK_dxReception])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxReceptionDetail_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxReceptionDetail]) REFERENCES [dbo].[dxReceptionDetail] ([PK_dxReceptionDetail])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Quantity_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxScaleUnit__Quantity]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxPayableInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__UnitAmount_dxPayableInvoiceDetail] FOREIGN KEY ([FK_dxScaleUnit__UnitAmount]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
