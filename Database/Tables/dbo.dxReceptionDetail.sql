CREATE TABLE [dbo].[dxReceptionDetail]
(
[PK_dxReceptionDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxReception] [int] NOT NULL,
[FK_dxPurchaseOrder] [int] NOT NULL,
[FK_dxPurchaseOrderDetail] [int] NOT NULL,
[FK_dxWarehouse] [int] NULL,
[FK_dxLocation] [int] NULL,
[FK_dxProduct] [int] NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxReceptionDetail_Lot] DEFAULT ('0'),
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxReceptionDetail_Quantity] DEFAULT ((0.0)),
[BilledQuantity] [float] NOT NULL CONSTRAINT [DF_dxReceptionDetail_BilledQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit__Quantity] [int] NOT NULL CONSTRAINT [DF_dxReceptionDetail_FK_dxScaleUnit__Quantity] DEFAULT ((1)),
[ProductQuantity] [float] NOT NULL CONSTRAINT [DF_dxReceptionDetail_ProductQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxReceptionDetail_FK_dxScaleUnit] DEFAULT ((1)),
[CurrencyRate] [float] NOT NULL CONSTRAINT [DF_dxReceptionDetail_CurrencyRate] DEFAULT ((1.0)),
[ConsiderAsBilled] [bit] NOT NULL CONSTRAINT [DF_dxReceptionDetail_ConsideredAsBill] DEFAULT ((0)),
[LotDate] [datetime] NULL,
[ExpirationDate] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReceptionDetail.trAuditDelete] ON [dbo].[dxReceptionDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxReceptionDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxReceptionDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReceptionDetail, FK_dxReception, FK_dxPurchaseOrder, FK_dxPurchaseOrderDetail, FK_dxWarehouse, FK_dxLocation, FK_dxProduct, Lot, Description, Quantity, BilledQuantity, FK_dxScaleUnit__Quantity, ProductQuantity, FK_dxScaleUnit, CurrencyRate, ConsiderAsBilled, LotDate, ExpirationDate from deleted
 Declare @PK_dxReceptionDetail int, @FK_dxReception int, @FK_dxPurchaseOrder int, @FK_dxPurchaseOrderDetail int, @FK_dxWarehouse int, @FK_dxLocation int, @FK_dxProduct int, @Lot varchar(50), @Description varchar(2000), @Quantity Float, @BilledQuantity Float, @FK_dxScaleUnit__Quantity int, @ProductQuantity Float, @FK_dxScaleUnit int, @CurrencyRate Float, @ConsiderAsBilled Bit, @LotDate DateTime, @ExpirationDate DateTime

 OPEN pk_cursordxReceptionDetail
 FETCH NEXT FROM pk_cursordxReceptionDetail INTO @PK_dxReceptionDetail, @FK_dxReception, @FK_dxPurchaseOrder, @FK_dxPurchaseOrderDetail, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Description, @Quantity, @BilledQuantity, @FK_dxScaleUnit__Quantity, @ProductQuantity, @FK_dxScaleUnit, @CurrencyRate, @ConsiderAsBilled, @LotDate, @ExpirationDate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxReceptionDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReception', @FK_dxReception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder', @FK_dxPurchaseOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrderDetail', @FK_dxPurchaseOrderDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', @FK_dxWarehouse
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', @FK_dxLocation
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
        select @pkdataaudit, 'BilledQuantity', @BilledQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', @FK_dxScaleUnit__Quantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', @ProductQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', @FK_dxScaleUnit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CurrencyRate', @CurrencyRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ConsiderAsBilled', @ConsiderAsBilled
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'LotDate', @LotDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpirationDate', @ExpirationDate
FETCH NEXT FROM pk_cursordxReceptionDetail INTO @PK_dxReceptionDetail, @FK_dxReception, @FK_dxPurchaseOrder, @FK_dxPurchaseOrderDetail, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Description, @Quantity, @BilledQuantity, @FK_dxScaleUnit__Quantity, @ProductQuantity, @FK_dxScaleUnit, @CurrencyRate, @ConsiderAsBilled, @LotDate, @ExpirationDate
 END

 CLOSE pk_cursordxReceptionDetail 
 DEALLOCATE pk_cursordxReceptionDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReceptionDetail.trAuditInsUpd] ON [dbo].[dxReceptionDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxReceptionDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReceptionDetail from inserted;
 set @tablename = 'dxReceptionDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxReceptionDetail
 FETCH NEXT FROM pk_cursordxReceptionDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReception', FK_dxReception from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPurchaseOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder', FK_dxPurchaseOrder from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPurchaseOrderDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrderDetail', FK_dxPurchaseOrderDetail from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BilledQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BilledQuantity', BilledQuantity from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', FK_dxScaleUnit__Quantity from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProductQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', ProductQuantity from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CurrencyRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CurrencyRate', CurrencyRate from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ConsiderAsBilled )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ConsiderAsBilled', ConsiderAsBilled from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LotDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'LotDate', LotDate from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExpirationDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpirationDate', ExpirationDate from dxReceptionDetail where PK_dxReceptionDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxReceptionDetail INTO @keyvalue
 END

 CLOSE pk_cursordxReceptionDetail 
 DEALLOCATE pk_cursordxReceptionDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReceptionDetail.trBuildList] ON [dbo].[dxReceptionDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;
   declare @DocList varchar(150);

   set @FKi  = ( SELECT Coalesce(max(FK_dxReception ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxReception ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   Set  @DocList = Null ;
   select  @DocList =
              case dbo.fdxIncluded( Coalesce(Convert(varchar(10),  FK_dxPurchaseOrder),'') , @DocList )  when 1 then  @DocList
              else  COALESCE(@DocList  + ',', '') + Coalesce(Convert(varchar(10),  FK_dxPurchaseOrder),'')
              end  from dxReceptionDetail where FK_dxReception = @FK and not FK_dxPurchaseOrder is null
   update dxReception set ListOfPO =  Coalesce(@DocList, '') where PK_dxReception = @FK

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReceptionDetail.trCheckBillQuantity] ON [dbo].[dxReceptionDetail]
AFTER  UPDATE
AS
BEGIN
   Declare @MSG varchar(100)
   if update(BilledQuantity)
     if ( Select Sum( abs(BilledQuantity) -abs(Quantity) ) from Inserted ) > 0.01
     begin
        Set @MSG = 'La surfacturation est interdite / Overbilling is not allowed. '
        --ROLLBACK TRANSACTION
        RAISERROR(@MSG , 16, 1)
        RETURN
     end
END
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [PK_dxReceptionDetail] PRIMARY KEY CLUSTERED  ([PK_dxReceptionDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReceptionDetail_FK_dxLocation] ON [dbo].[dxReceptionDetail] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReceptionDetail_FK_dxProduct] ON [dbo].[dxReceptionDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReceptionDetail_FK_dxPurchaseOrder] ON [dbo].[dxReceptionDetail] ([FK_dxPurchaseOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReceptionDetail_FK_dxPurchaseOrderDetail] ON [dbo].[dxReceptionDetail] ([FK_dxPurchaseOrderDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReceptionDetail_FK_dxReception] ON [dbo].[dxReceptionDetail] ([FK_dxReception]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReceptionDetail_FK_dxScaleUnit] ON [dbo].[dxReceptionDetail] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReceptionDetail_FK_dxScaleUnit__Quantity] ON [dbo].[dxReceptionDetail] ([FK_dxScaleUnit__Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReceptionDetail_FK_dxWarehouse] ON [dbo].[dxReceptionDetail] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxReceptionDetail] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxReceptionDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [dxConstraint_FK_dxPurchaseOrder_dxReceptionDetail] FOREIGN KEY ([FK_dxPurchaseOrder]) REFERENCES [dbo].[dxPurchaseOrder] ([PK_dxPurchaseOrder])
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [dxConstraint_FK_dxPurchaseOrderDetail_dxReceptionDetail] FOREIGN KEY ([FK_dxPurchaseOrderDetail]) REFERENCES [dbo].[dxPurchaseOrderDetail] ([PK_dxPurchaseOrderDetail])
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [dxConstraint_FK_dxReception_dxReceptionDetail] FOREIGN KEY ([FK_dxReception]) REFERENCES [dbo].[dxReception] ([PK_dxReception])
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxReceptionDetail] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Quantity_dxReceptionDetail] FOREIGN KEY ([FK_dxScaleUnit__Quantity]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxReceptionDetail] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxReceptionDetail] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
