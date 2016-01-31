CREATE TABLE [dbo].[dxInvoiceDetail]
(
[PK_dxInvoiceDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxInvoice] [int] NOT NULL,
[FK_dxProject] [int] NULL,
[FK_dxProduct] [int] NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxInvoiceDetail_Lot] DEFAULT ('0'),
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Quantity] DEFAULT ((0)),
[FK_dxScaleUnit__Quantity] [int] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_FK_dxScaleUnit__Quantity] DEFAULT ((1)),
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_UnitAmount] DEFAULT ((0.0)),
[FK_dxScaleUnit__UnitAmount] [int] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_FK_dxScaleUnit__UnitAmount] DEFAULT ((1)),
[ProductQuantity] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_ProductQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_FK_dxScaleUnit] DEFAULT ((1)),
[Amount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Amount] DEFAULT ((0.0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Discount] DEFAULT ((0.0)),
[DiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_DiscountAmount] DEFAULT ((0.0)),
[TotalAmountBeforeTax] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_TotalAmountbeforeTax] DEFAULT ((0.0)),
[Tax1Amount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Tax1Amount] DEFAULT ((0.0)),
[Tax2Amount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Tax2Amount] DEFAULT ((0)),
[Tax3Amount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Tax3Amount] DEFAULT ((0)),
[TaxAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_TaxAmount] DEFAULT ((0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_TotalAmount] DEFAULT ((0)),
[FK_dxAccount__Discount] [int] NULL,
[FK_dxAccount__Revenue] [int] NULL,
[FK_dxAccount__AR_Tax1] [int] NULL,
[FK_dxAccount__AR_Tax2] [int] NULL,
[FK_dxAccount__AR_Tax3] [int] NULL,
[FK_dxAccount__Receivable] [int] NULL,
[ApplyTax1] [bit] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_ApplyTax1] DEFAULT ((1)),
[ApplyTax2] [bit] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_ApplyTax2] DEFAULT ((1)),
[ApplyTax3] [bit] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_ApplyTax3] DEFAULT ((1)),
[Tax1Rate] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Tax1Rate] DEFAULT ((0.0)),
[Tax2Rate] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Tax2Rate] DEFAULT ((0.0)),
[Tax3Rate] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Tax3Rate] DEFAULT ((0.0)),
[FK_dxShipping] [int] NULL,
[FK_dxShippingDetail] [int] NULL,
[FK_dxClientOrder] [int] NULL,
[Rank] [float] NOT NULL CONSTRAINT [DF_dxInvoiceDetail_Rank] DEFAULT ((0.0)),
[FK_dxRMADetail] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInvoiceDetail.trAuditDelete] ON [dbo].[dxInvoiceDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxInvoiceDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxInvoiceDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInvoiceDetail, FK_dxInvoice, FK_dxProject, FK_dxProduct, Lot, Description, Quantity, FK_dxScaleUnit__Quantity, UnitAmount, FK_dxScaleUnit__UnitAmount, ProductQuantity, FK_dxScaleUnit, Amount, Discount, DiscountAmount, TotalAmountBeforeTax, Tax1Amount, Tax2Amount, Tax3Amount, TaxAmount, TotalAmount, FK_dxAccount__Discount, FK_dxAccount__Revenue, FK_dxAccount__AR_Tax1, FK_dxAccount__AR_Tax2, FK_dxAccount__AR_Tax3, FK_dxAccount__Receivable, ApplyTax1, ApplyTax2, ApplyTax3, Tax1Rate, Tax2Rate, Tax3Rate, FK_dxShipping, FK_dxShippingDetail, FK_dxClientOrder, Rank, FK_dxRMADetail from deleted
 Declare @PK_dxInvoiceDetail int, @FK_dxInvoice int, @FK_dxProject int, @FK_dxProduct int, @Lot varchar(50), @Description varchar(2000), @Quantity Float, @FK_dxScaleUnit__Quantity int, @UnitAmount Float, @FK_dxScaleUnit__UnitAmount int, @ProductQuantity Float, @FK_dxScaleUnit int, @Amount Float, @Discount Float, @DiscountAmount Float, @TotalAmountBeforeTax Float, @Tax1Amount Float, @Tax2Amount Float, @Tax3Amount Float, @TaxAmount Float, @TotalAmount Float, @FK_dxAccount__Discount int, @FK_dxAccount__Revenue int, @FK_dxAccount__AR_Tax1 int, @FK_dxAccount__AR_Tax2 int, @FK_dxAccount__AR_Tax3 int, @FK_dxAccount__Receivable int, @ApplyTax1 Bit, @ApplyTax2 Bit, @ApplyTax3 Bit, @Tax1Rate Float, @Tax2Rate Float, @Tax3Rate Float, @FK_dxShipping int, @FK_dxShippingDetail int, @FK_dxClientOrder int, @Rank Float, @FK_dxRMADetail int

 OPEN pk_cursordxInvoiceDetail
 FETCH NEXT FROM pk_cursordxInvoiceDetail INTO @PK_dxInvoiceDetail, @FK_dxInvoice, @FK_dxProject, @FK_dxProduct, @Lot, @Description, @Quantity, @FK_dxScaleUnit__Quantity, @UnitAmount, @FK_dxScaleUnit__UnitAmount, @ProductQuantity, @FK_dxScaleUnit, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxAccount__Discount, @FK_dxAccount__Revenue, @FK_dxAccount__AR_Tax1, @FK_dxAccount__AR_Tax2, @FK_dxAccount__AR_Tax3, @FK_dxAccount__Receivable, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Tax1Rate, @Tax2Rate, @Tax3Rate, @FK_dxShipping, @FK_dxShippingDetail, @FK_dxClientOrder, @Rank, @FK_dxRMADetail
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxInvoiceDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInvoice', @FK_dxInvoice
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
        select @pkdataaudit, 'FK_dxAccount__Revenue', @FK_dxAccount__Revenue
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax1', @FK_dxAccount__AR_Tax1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax2', @FK_dxAccount__AR_Tax2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax3', @FK_dxAccount__AR_Tax3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Receivable', @FK_dxAccount__Receivable
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
        select @pkdataaudit, 'FK_dxShipping', @FK_dxShipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingDetail', @FK_dxShippingDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', @FK_dxClientOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRMADetail', @FK_dxRMADetail
FETCH NEXT FROM pk_cursordxInvoiceDetail INTO @PK_dxInvoiceDetail, @FK_dxInvoice, @FK_dxProject, @FK_dxProduct, @Lot, @Description, @Quantity, @FK_dxScaleUnit__Quantity, @UnitAmount, @FK_dxScaleUnit__UnitAmount, @ProductQuantity, @FK_dxScaleUnit, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxAccount__Discount, @FK_dxAccount__Revenue, @FK_dxAccount__AR_Tax1, @FK_dxAccount__AR_Tax2, @FK_dxAccount__AR_Tax3, @FK_dxAccount__Receivable, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Tax1Rate, @Tax2Rate, @Tax3Rate, @FK_dxShipping, @FK_dxShippingDetail, @FK_dxClientOrder, @Rank, @FK_dxRMADetail
 END

 CLOSE pk_cursordxInvoiceDetail 
 DEALLOCATE pk_cursordxInvoiceDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInvoiceDetail.trAuditInsUpd] ON [dbo].[dxInvoiceDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxInvoiceDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInvoiceDetail from inserted;
 set @tablename = 'dxInvoiceDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxInvoiceDetail
 FETCH NEXT FROM pk_cursordxInvoiceDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxInvoice )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInvoice', FK_dxInvoice from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', FK_dxScaleUnit__Quantity from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__UnitAmount', FK_dxScaleUnit__UnitAmount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProductQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', ProductQuantity from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Discount', Discount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', DiscountAmount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmountBeforeTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', TotalAmountBeforeTax from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', Tax1Amount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', Tax2Amount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', Tax3Amount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', TaxAmount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Discount', FK_dxAccount__Discount from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Revenue )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Revenue', FK_dxAccount__Revenue from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AR_Tax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax1', FK_dxAccount__AR_Tax1 from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AR_Tax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax2', FK_dxAccount__AR_Tax2 from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AR_Tax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax3', FK_dxAccount__AR_Tax3 from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Receivable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Receivable', FK_dxAccount__Receivable from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax1', ApplyTax1 from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax2', ApplyTax2 from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax3', ApplyTax3 from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Rate', Tax1Rate from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Rate', Tax2Rate from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Rate', Tax3Rate from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipping', FK_dxShipping from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingDetail', FK_dxShippingDetail from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', FK_dxClientOrder from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxRMADetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRMADetail', FK_dxRMADetail from dxInvoiceDetail where PK_dxInvoiceDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxInvoiceDetail INTO @keyvalue
 END

 CLOSE pk_cursordxInvoiceDetail 
 DEALLOCATE pk_cursordxInvoiceDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInvoiceDetail.trBuildList] ON [dbo].[dxInvoiceDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  declare @FK int, @FKi int , @FKd int ;
   declare @DocList varchar(150);

   set @FKi  = ( SELECT Coalesce(max(FK_dxInvoice ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxInvoice ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   set @DocList = null ;
   select  @DocList =
              case dbo.fdxIncluded( Coalesce(Convert(varchar(10),  FK_dxShipping),'') , @DocList )  when 1 then  @DocList
              else  COALESCE(@DocList  + ',', '') + Coalesce(Convert(varchar(10),  FK_dxShipping),'')
              end  from dxInvoiceDetail where FK_dxInvoice = @FK and not FK_dxShipping is null
   update  dxInvoice set ListOfShipping =  Coalesce(@DocList, '')  where PK_dxInvoice = @FK ;
   set @DocList = null ;

   select  @DocList =
              case dbo.fdxIncluded( Coalesce(Convert(varchar(10),  FK_dxClientOrder),'') , @DocList )  when 1 then  @DocList
              else  COALESCE(@DocList  + ',', '') + Coalesce(Convert(varchar(10),  FK_dxClientOrder),'')
              end  from dxInvoiceDetail where FK_dxInvoice = @FK and not FK_dxClientOrder is null
   update  dxInvoice set ListOfOrder =  Coalesce(@DocList, '')  where PK_dxInvoice = @FK

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInvoiceDetail.trUpdateSum] ON [dbo].[dxInvoiceDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  ----declare @FK int, @FKi int , @FKd int ;

  ----set @FKi  = ( SELECT Coalesce(max(FK_dxInvoice ),-1) from inserted )
  ----set @FKd = ( SELECT Coalesce(max(FK_dxInvoice ),-1) from deleted )
  ----if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

  ----update dxInvoice set
  ----   Amount               = ( select Coalesce(sum( Amount ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ),
  ----   DiscountAmount       = ( select Coalesce(sum( DiscountAmount       ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ),
  ----   TotalAmountBeforeTax = ( select Coalesce(sum( TotalAmountBeforeTax ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ),
  ----   Tax1Amount           = ( select Coalesce(sum( Tax1Amount           ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ),
  ----   Tax2Amount           = ( select Coalesce(sum( Tax2Amount           ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ),
  ----   Tax3Amount           = ( select Coalesce(sum( Tax3Amount           ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ),
  ----   TaxAmount            = ( select Coalesce(sum( TaxAmount            ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ),
  ----   TotalAmount          = ( select Coalesce(sum( TotalAmount          ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ),
  ----   BalanceAmount        = ( select Coalesce(sum( TotalAmount          ), 0.0) from dxInvoiceDetail where FK_dxInvoice = @FK ) -
  ----                          ( select Coalesce(sum( PaidAmount           ), 0.0) from dxCashReceiptInvoice where FK_dxInvoice = @FK and posted = 1 )
  ----where PK_dxInvoice = @FK ;

 update iv set
     Amount               = ( select Coalesce(sum( Amount               ), 0.0) from dxInvoiceDetail where FK_dxInvoice = iv.PK_dxInvoice ),
     DiscountAmount       = ( select Coalesce(sum( DiscountAmount       ), 0.0) from dxInvoiceDetail where FK_dxInvoice = iv.PK_dxInvoice ),
     TotalAmountBeforeTax = ( select Coalesce(sum( TotalAmountBeforeTax ), 0.0) from dxInvoiceDetail where FK_dxInvoice = iv.PK_dxInvoice ),
     Tax1Amount           = ( select Coalesce(sum( Tax1Amount           ), 0.0) from dxInvoiceDetail where FK_dxInvoice = iv.PK_dxInvoice ),
     Tax2Amount           = ( select Coalesce(sum( Tax2Amount           ), 0.0) from dxInvoiceDetail where FK_dxInvoice = iv.PK_dxInvoice ),
     Tax3Amount           = ( select Coalesce(sum( Tax3Amount           ), 0.0) from dxInvoiceDetail where FK_dxInvoice = iv.PK_dxInvoice ),
     TaxAmount            = ( select Coalesce(sum( TaxAmount            ), 0.0) from dxInvoiceDetail where FK_dxInvoice = iv.PK_dxInvoice ),
     TotalAmount          = ( select Coalesce(sum( TotalAmount          ), 0.0) from dxInvoiceDetail where FK_dxInvoice = iv.PK_dxInvoice ),
     BalanceAmount        = Round(( select Coalesce(sum( TotalAmount    ), 0.0) from dxInvoiceDetail      where FK_dxInvoice = iv.PK_dxInvoice ) -
                                  ( select Coalesce(sum( PaidAmount     ), 0.0) from dxCashReceiptInvoice where FK_dxInvoice = iv.PK_dxInvoice and posted = 1 ),2)
  From dxInvoice iv where iv.PK_dxInvoice in ( select FK_dxInvoice from inserted union all Select FK_dxInvoice from deleted ) ;

END
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [CK_dxInvoiceDetail_Discount] CHECK (([Discount]>=(0.0) AND [Discount]<=(100.0)))
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [PK_dxInvoiceDetail] PRIMARY KEY CLUSTERED  ([PK_dxInvoiceDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxAccount__AR_Tax1] ON [dbo].[dxInvoiceDetail] ([FK_dxAccount__AR_Tax1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxAccount__AR_Tax2] ON [dbo].[dxInvoiceDetail] ([FK_dxAccount__AR_Tax2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxAccount__AR_Tax3] ON [dbo].[dxInvoiceDetail] ([FK_dxAccount__AR_Tax3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxAccount__Discount] ON [dbo].[dxInvoiceDetail] ([FK_dxAccount__Discount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxAccount__Receivable] ON [dbo].[dxInvoiceDetail] ([FK_dxAccount__Receivable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxAccount__Revenue] ON [dbo].[dxInvoiceDetail] ([FK_dxAccount__Revenue]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxClientOrder] ON [dbo].[dxInvoiceDetail] ([FK_dxClientOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxInvoice] ON [dbo].[dxInvoiceDetail] ([FK_dxInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxProduct] ON [dbo].[dxInvoiceDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxProject] ON [dbo].[dxInvoiceDetail] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxRMADetail] ON [dbo].[dxInvoiceDetail] ([FK_dxRMADetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxScaleUnit] ON [dbo].[dxInvoiceDetail] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxScaleUnit__Quantity] ON [dbo].[dxInvoiceDetail] ([FK_dxScaleUnit__Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxScaleUnit__UnitAmount] ON [dbo].[dxInvoiceDetail] ([FK_dxScaleUnit__UnitAmount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxShipping] ON [dbo].[dxInvoiceDetail] ([FK_dxShipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInvoiceDetail_FK_dxShippingDetail] ON [dbo].[dxInvoiceDetail] ([FK_dxShippingDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxInvoiceDetail] ON [dbo].[dxInvoiceDetail] ([PK_dxInvoiceDetail], [FK_dxInvoice]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AR_Tax1_dxInvoiceDetail] FOREIGN KEY ([FK_dxAccount__AR_Tax1]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AR_Tax2_dxInvoiceDetail] FOREIGN KEY ([FK_dxAccount__AR_Tax2]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AR_Tax3_dxInvoiceDetail] FOREIGN KEY ([FK_dxAccount__AR_Tax3]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Discount_dxInvoiceDetail] FOREIGN KEY ([FK_dxAccount__Discount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Receivable_dxInvoiceDetail] FOREIGN KEY ([FK_dxAccount__Receivable]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Revenue_dxInvoiceDetail] FOREIGN KEY ([FK_dxAccount__Revenue]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxClientOrder_dxInvoiceDetail] FOREIGN KEY ([FK_dxClientOrder]) REFERENCES [dbo].[dxClientOrder] ([PK_dxClientOrder])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxInvoice_dxInvoiceDetail] FOREIGN KEY ([FK_dxInvoice]) REFERENCES [dbo].[dxInvoice] ([PK_dxInvoice])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxInvoiceDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxInvoiceDetail] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxRMADetail_dxInvoiceDetail] FOREIGN KEY ([FK_dxRMADetail]) REFERENCES [dbo].[dxRMADetail] ([PK_dxRMADetail])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxInvoiceDetail] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Quantity_dxInvoiceDetail] FOREIGN KEY ([FK_dxScaleUnit__Quantity]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__UnitAmount_dxInvoiceDetail] FOREIGN KEY ([FK_dxScaleUnit__UnitAmount]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxShipping_dxInvoiceDetail] FOREIGN KEY ([FK_dxShipping]) REFERENCES [dbo].[dxShipping] ([PK_dxShipping])
GO
ALTER TABLE [dbo].[dxInvoiceDetail] ADD CONSTRAINT [dxConstraint_FK_dxShippingDetail_dxInvoiceDetail] FOREIGN KEY ([FK_dxShippingDetail]) REFERENCES [dbo].[dxShippingDetail] ([PK_dxShippingDetail])
GO
