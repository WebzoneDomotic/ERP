CREATE TABLE [dbo].[dxClientOrderDetail]
(
[PK_dxClientOrderDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxClientOrder] [int] NOT NULL,
[Closed] [bit] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Closed] DEFAULT ((0)),
[ExpectedDeliveryDate] [datetime] NOT NULL,
[FK_dxProduct] [int] NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Lot] DEFAULT ('0'),
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Quantity] DEFAULT ((0.0)),
[ShippedQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_ShippedQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit__Quantity] [int] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_FK_dxScaleUnit__Quantity] DEFAULT ((1)),
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_UnitAmount] DEFAULT ((0.0)),
[FK_dxScaleUnit__UnitAmount] [int] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_FK_dxScaleUnit__UnitAmount] DEFAULT ((1)),
[ProductQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_ProductQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_FK_dxScaleUnit] DEFAULT ((1)),
[Amount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Amount] DEFAULT ((0.0)),
[Discount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Discount] DEFAULT ((0.0)),
[DiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_DiscountAmount] DEFAULT ((0.0)),
[TotalAmountBeforeTax] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_TotalAmountBeforeTax] DEFAULT ((0.0)),
[Tax1Amount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Tax1Amount] DEFAULT ((0.0)),
[Tax2Amount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Tax2Amount] DEFAULT ((0.0)),
[Tax3Amount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Tax3Amount] DEFAULT ((0.0)),
[TaxAmount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_TaxAmount] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_TotalAmount] DEFAULT ((0.0)),
[FK_dxAccount__Revenue] [int] NULL,
[ApplyTax1] [bit] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_ApplyTax1] DEFAULT ((1)),
[ApplyTax2] [bit] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_ApplyTax2] DEFAULT ((1)),
[ApplyTax3] [bit] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_ApplyTax3] DEFAULT ((1)),
[Tax1Rate] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Tax1Rate] DEFAULT ((0.0)),
[Tax2Rate] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Tax2Rate] DEFAULT ((0.0)),
[Tax3Rate] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Tax3Rate] DEFAULT ((0.0)),
[FK_dxProject] [int] NULL,
[FK_dxLocation__Reserved] [int] NULL,
[FK_dxWarehouse] [int] NULL,
[FK_dxLocation] [int] NULL,
[Rank] [float] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_Rank] DEFAULT ((0.0)),
[AutoCalculated] [bit] NOT NULL CONSTRAINT [DF_dxClientOrderDetail_AutoCalculated] DEFAULT ((0)),
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxClientPromotion] [int] NULL,
[SkidID] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxClientOrderDetail_SkidID] DEFAULT ('')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientOrderDetail.trAuditDelete] ON [dbo].[dxClientOrderDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientOrderDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientOrderDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientOrderDetail, FK_dxClientOrder, Closed, ExpectedDeliveryDate, FK_dxProduct, Lot, Description, Quantity, ShippedQuantity, FK_dxScaleUnit__Quantity, UnitAmount, FK_dxScaleUnit__UnitAmount, ProductQuantity, FK_dxScaleUnit, Amount, Discount, DiscountAmount, TotalAmountBeforeTax, Tax1Amount, Tax2Amount, Tax3Amount, TaxAmount, TotalAmount, FK_dxAccount__Revenue, ApplyTax1, ApplyTax2, ApplyTax3, Tax1Rate, Tax2Rate, Tax3Rate, FK_dxProject, FK_dxLocation__Reserved, FK_dxWarehouse, FK_dxLocation, Rank, AutoCalculated, Note, FK_dxClientPromotion, SkidID from deleted
 Declare @PK_dxClientOrderDetail int, @FK_dxClientOrder int, @Closed Bit, @ExpectedDeliveryDate DateTime, @FK_dxProduct int, @Lot varchar(50), @Description varchar(2000), @Quantity Float, @ShippedQuantity Float, @FK_dxScaleUnit__Quantity int, @UnitAmount Float, @FK_dxScaleUnit__UnitAmount int, @ProductQuantity Float, @FK_dxScaleUnit int, @Amount Float, @Discount Float, @DiscountAmount Float, @TotalAmountBeforeTax Float, @Tax1Amount Float, @Tax2Amount Float, @Tax3Amount Float, @TaxAmount Float, @TotalAmount Float, @FK_dxAccount__Revenue int, @ApplyTax1 Bit, @ApplyTax2 Bit, @ApplyTax3 Bit, @Tax1Rate Float, @Tax2Rate Float, @Tax3Rate Float, @FK_dxProject int, @FK_dxLocation__Reserved int, @FK_dxWarehouse int, @FK_dxLocation int, @Rank Float, @AutoCalculated Bit, @Note varchar(2000), @FK_dxClientPromotion int, @SkidID varchar(50)

 OPEN pk_cursordxClientOrderDetail
 FETCH NEXT FROM pk_cursordxClientOrderDetail INTO @PK_dxClientOrderDetail, @FK_dxClientOrder, @Closed, @ExpectedDeliveryDate, @FK_dxProduct, @Lot, @Description, @Quantity, @ShippedQuantity, @FK_dxScaleUnit__Quantity, @UnitAmount, @FK_dxScaleUnit__UnitAmount, @ProductQuantity, @FK_dxScaleUnit, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxAccount__Revenue, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Tax1Rate, @Tax2Rate, @Tax3Rate, @FK_dxProject, @FK_dxLocation__Reserved, @FK_dxWarehouse, @FK_dxLocation, @Rank, @AutoCalculated, @Note, @FK_dxClientPromotion, @SkidID
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientOrderDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', @FK_dxClientOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', @Closed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpectedDeliveryDate', @ExpectedDeliveryDate
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
        select @pkdataaudit, 'ShippedQuantity', @ShippedQuantity
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
        select @pkdataaudit, 'FK_dxAccount__Revenue', @FK_dxAccount__Revenue
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Reserved', @FK_dxLocation__Reserved
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', @FK_dxWarehouse
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', @FK_dxLocation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AutoCalculated', @AutoCalculated
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientPromotion', @FK_dxClientPromotion
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SkidID', @SkidID
FETCH NEXT FROM pk_cursordxClientOrderDetail INTO @PK_dxClientOrderDetail, @FK_dxClientOrder, @Closed, @ExpectedDeliveryDate, @FK_dxProduct, @Lot, @Description, @Quantity, @ShippedQuantity, @FK_dxScaleUnit__Quantity, @UnitAmount, @FK_dxScaleUnit__UnitAmount, @ProductQuantity, @FK_dxScaleUnit, @Amount, @Discount, @DiscountAmount, @TotalAmountBeforeTax, @Tax1Amount, @Tax2Amount, @Tax3Amount, @TaxAmount, @TotalAmount, @FK_dxAccount__Revenue, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Tax1Rate, @Tax2Rate, @Tax3Rate, @FK_dxProject, @FK_dxLocation__Reserved, @FK_dxWarehouse, @FK_dxLocation, @Rank, @AutoCalculated, @Note, @FK_dxClientPromotion, @SkidID
 END

 CLOSE pk_cursordxClientOrderDetail 
 DEALLOCATE pk_cursordxClientOrderDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientOrderDetail.trAuditInsUpd] ON [dbo].[dxClientOrderDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientOrderDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientOrderDetail from inserted;
 set @tablename = 'dxClientOrderDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientOrderDetail
 FETCH NEXT FROM pk_cursordxClientOrderDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', FK_dxClientOrder from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Closed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', Closed from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExpectedDeliveryDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpectedDeliveryDate', ExpectedDeliveryDate from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShippedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ShippedQuantity', ShippedQuantity from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', FK_dxScaleUnit__Quantity from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__UnitAmount', FK_dxScaleUnit__UnitAmount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProductQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', ProductQuantity from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Discount', Discount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountAmount', DiscountAmount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmountBeforeTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmountBeforeTax', TotalAmountBeforeTax from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Amount', Tax1Amount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Amount', Tax2Amount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Amount', Tax3Amount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TaxAmount', TaxAmount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Revenue )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Revenue', FK_dxAccount__Revenue from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax1', ApplyTax1 from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax2', ApplyTax2 from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax3', ApplyTax3 from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Rate', Tax1Rate from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Rate', Tax2Rate from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Rate', Tax3Rate from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation__Reserved )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Reserved', FK_dxLocation__Reserved from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AutoCalculated )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AutoCalculated', AutoCalculated from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientPromotion )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientPromotion', FK_dxClientPromotion from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SkidID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SkidID', SkidID from dxClientOrderDetail where PK_dxClientOrderDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientOrderDetail INTO @keyvalue
 END

 CLOSE pk_cursordxClientOrderDetail 
 DEALLOCATE pk_cursordxClientOrderDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientOrderDetail.trUpdateSum] ON [dbo].[dxClientOrderDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  --declare @FK int, @FKi int , @FKd int ;
  --set @FKi = ( SELECT Coalesce(max(FK_dxClientOrder ),-1) from inserted )
  --set @FKd = ( SELECT Coalesce(max(FK_dxClientOrder ),-1) from deleted )
  --if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

  update co set
     co.Amount               = ( select Coalesce(sum( Amount               ), 0.0) from dxClientOrderDetail where FK_dxClientOrder = co.PK_dxClientOrder ),
     co.DiscountAmount       = ( select Coalesce(sum( DiscountAmount       ), 0.0) from dxClientOrderDetail where FK_dxClientOrder = co.PK_dxClientOrder ),
     co.TotalAmountBeforeTax = ( select Coalesce(sum( TotalAmountBeforeTax ), 0.0) from dxClientOrderDetail where FK_dxClientOrder = co.PK_dxClientOrder ),
     co.Tax1Amount           = ( select Coalesce(sum( Tax1Amount           ), 0.0) from dxClientOrderDetail where FK_dxClientOrder = co.PK_dxClientOrder ),
     co.Tax2Amount           = ( select Coalesce(sum( Tax2Amount           ), 0.0) from dxClientOrderDetail where FK_dxClientOrder = co.PK_dxClientOrder ),
     co.Tax3Amount           = ( select Coalesce(sum( Tax3Amount           ), 0.0) from dxClientOrderDetail where FK_dxClientOrder = co.PK_dxClientOrder ),
     co.TaxAmount            = ( select Coalesce(sum( TaxAmount            ), 0.0) from dxClientOrderDetail where FK_dxClientOrder = co.PK_dxClientOrder ),
     co.TotalAmount          = ( select Coalesce(sum( TotalAmount          ), 0.0) from dxClientOrderDetail where FK_dxClientOrder = co.PK_dxClientOrder )
  from dxClientOrder co where co.PK_dxClientOrder in ( select FK_dxClientOrder from inserted union all Select FK_dxClientOrder from deleted )
  --  where PK_dxClientOrder = @FK ;
END
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [CK_dxClientOrderDetail_Discount] CHECK (([Discount]>=(0.0) AND [Discount]<=(100.0)))
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [PK_dxClientOrderDetail] PRIMARY KEY CLUSTERED  ([PK_dxClientOrderDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxClientOrderDetailDeliveryDate] ON [dbo].[dxClientOrderDetail] ([ExpectedDeliveryDate] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxAccount__Revenue] ON [dbo].[dxClientOrderDetail] ([FK_dxAccount__Revenue]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxClientOrder] ON [dbo].[dxClientOrderDetail] ([FK_dxClientOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxClientPromotion] ON [dbo].[dxClientOrderDetail] ([FK_dxClientPromotion]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxLocation] ON [dbo].[dxClientOrderDetail] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxLocation__Reserved] ON [dbo].[dxClientOrderDetail] ([FK_dxLocation__Reserved]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxProduct] ON [dbo].[dxClientOrderDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxProject] ON [dbo].[dxClientOrderDetail] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxScaleUnit] ON [dbo].[dxClientOrderDetail] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxScaleUnit__Quantity] ON [dbo].[dxClientOrderDetail] ([FK_dxScaleUnit__Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxScaleUnit__UnitAmount] ON [dbo].[dxClientOrderDetail] ([FK_dxScaleUnit__UnitAmount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientOrderDetail_FK_dxWarehouse] ON [dbo].[dxClientOrderDetail] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Revenue_dxClientOrderDetail] FOREIGN KEY ([FK_dxAccount__Revenue]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxClientOrder_dxClientOrderDetail] FOREIGN KEY ([FK_dxClientOrder]) REFERENCES [dbo].[dxClientOrder] ([PK_dxClientOrder])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxClientPromotion_dxClientOrderDetail] FOREIGN KEY ([FK_dxClientPromotion]) REFERENCES [dbo].[dxClientPromotion] ([PK_dxClientPromotion])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxClientOrderDetail] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation__Reserved_dxClientOrderDetail] FOREIGN KEY ([FK_dxLocation__Reserved]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxClientOrderDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxClientOrderDetail] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxClientOrderDetail] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Quantity_dxClientOrderDetail] FOREIGN KEY ([FK_dxScaleUnit__Quantity]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__UnitAmount_dxClientOrderDetail] FOREIGN KEY ([FK_dxScaleUnit__UnitAmount]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxClientOrderDetail] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxClientOrderDetail] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
