CREATE TABLE [dbo].[dxRMADetail]
(
[PK_dxRMADetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxRMA] [int] NOT NULL,
[FK_dxShippingDetail] [int] NULL,
[FK_dxClientOrderDetail] [int] NULL,
[FK_dxWarehouse] [int] NULL,
[FK_dxLocation] [int] NULL,
[FK_dxProduct] [int] NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxRMADetail_Quantity] DEFAULT ((0.0)),
[ReturnedQuantity] [float] NOT NULL CONSTRAINT [DF_dxRMADetail_ReturnedQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit__Quantity] [int] NOT NULL CONSTRAINT [DF_dxRMADetail_FK_dxScaleUnit__Quantity] DEFAULT ((1)),
[ProductQuantity] [float] NOT NULL CONSTRAINT [DF_dxRMADetail_ProductQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxRMADetail_FK_dxScaleUnit] DEFAULT ((1)),
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxRMADetail_UnitAmount] DEFAULT ((0.0)),
[Rank] [float] NOT NULL CONSTRAINT [DF_dxRMADetail_Rank] DEFAULT ((0.0)),
[TrackingNumber] [varchar] (100) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxRMADetail_TrackingNumber] DEFAULT (''),
[FK_dxRMADetailReason] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[DeclaredQuantity] [float] NOT NULL CONSTRAINT [DF_dxRMADetail_DeclaredQuantity] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRMADetail.trAuditDelete] ON [dbo].[dxRMADetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxRMADetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxRMADetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxRMADetail, FK_dxRMA, FK_dxShippingDetail, FK_dxClientOrderDetail, FK_dxWarehouse, FK_dxLocation, FK_dxProduct, Lot, Description, Quantity, ReturnedQuantity, FK_dxScaleUnit__Quantity, ProductQuantity, FK_dxScaleUnit, UnitAmount, Rank, TrackingNumber, FK_dxRMADetailReason, Note, DeclaredQuantity from deleted
 Declare @PK_dxRMADetail int, @FK_dxRMA int, @FK_dxShippingDetail int, @FK_dxClientOrderDetail int, @FK_dxWarehouse int, @FK_dxLocation int, @FK_dxProduct int, @Lot varchar(50), @Description varchar(2000), @Quantity Float, @ReturnedQuantity Float, @FK_dxScaleUnit__Quantity int, @ProductQuantity Float, @FK_dxScaleUnit int, @UnitAmount Float, @Rank Float, @TrackingNumber varchar(100), @FK_dxRMADetailReason int, @Note varchar(2000), @DeclaredQuantity Float

 OPEN pk_cursordxRMADetail
 FETCH NEXT FROM pk_cursordxRMADetail INTO @PK_dxRMADetail, @FK_dxRMA, @FK_dxShippingDetail, @FK_dxClientOrderDetail, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Description, @Quantity, @ReturnedQuantity, @FK_dxScaleUnit__Quantity, @ProductQuantity, @FK_dxScaleUnit, @UnitAmount, @Rank, @TrackingNumber, @FK_dxRMADetailReason, @Note, @DeclaredQuantity
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxRMADetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRMA', @FK_dxRMA
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingDetail', @FK_dxShippingDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrderDetail', @FK_dxClientOrderDetail
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
        select @pkdataaudit, 'ReturnedQuantity', @ReturnedQuantity
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
        select @pkdataaudit, 'UnitAmount', @UnitAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TrackingNumber', @TrackingNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRMADetailReason', @FK_dxRMADetailReason
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DeclaredQuantity', @DeclaredQuantity
FETCH NEXT FROM pk_cursordxRMADetail INTO @PK_dxRMADetail, @FK_dxRMA, @FK_dxShippingDetail, @FK_dxClientOrderDetail, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Description, @Quantity, @ReturnedQuantity, @FK_dxScaleUnit__Quantity, @ProductQuantity, @FK_dxScaleUnit, @UnitAmount, @Rank, @TrackingNumber, @FK_dxRMADetailReason, @Note, @DeclaredQuantity
 END

 CLOSE pk_cursordxRMADetail 
 DEALLOCATE pk_cursordxRMADetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRMADetail.trAuditInsUpd] ON [dbo].[dxRMADetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxRMADetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxRMADetail from inserted;
 set @tablename = 'dxRMADetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxRMADetail
 FETCH NEXT FROM pk_cursordxRMADetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxRMA )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRMA', FK_dxRMA from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingDetail', FK_dxShippingDetail from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientOrderDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrderDetail', FK_dxClientOrderDetail from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReturnedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReturnedQuantity', ReturnedQuantity from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', FK_dxScaleUnit__Quantity from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProductQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', ProductQuantity from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TrackingNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TrackingNumber', TrackingNumber from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxRMADetailReason )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRMADetailReason', FK_dxRMADetailReason from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DeclaredQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DeclaredQuantity', DeclaredQuantity from dxRMADetail where PK_dxRMADetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxRMADetail INTO @keyvalue
 END

 CLOSE pk_cursordxRMADetail 
 DEALLOCATE pk_cursordxRMADetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRMADetail.trBuildList] ON [dbo].[dxRMADetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;
   declare @OrderList varchar(500);
   declare @ShippingList varchar(500);

   set @FKi  = ( SELECT Coalesce(max(FK_dxRMA ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxRMA ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   Set  @OrderList = Null ;
   Set  @ShippingList = Null ;

   select  @OrderList =
              case dbo.fdxIncluded(Coalesce( Convert(varchar(10),  cod.FK_dxClientOrder),'') , @OrderList )  when 1 then  @OrderList
              else  COALESCE(@OrderList  + ',', '') + Coalesce(Convert(varchar(10),  cod.FK_dxClientOrder),'')
              end,
           @ShippingList =
              case dbo.fdxIncluded( Coalesce(Convert(varchar(10),  sd.FK_dxShipping),'') , @ShippingList )  when 1 then  @ShippingList
              else  COALESCE(@ShippingList  + ',', '') + Coalesce(Convert(varchar(10),  sd.FK_dxShipping),'')
              end
   from dxRMADetail rd, dxClientOrderDetail cod, dxShippingDetail sd
   where rd.FK_dxRMA = @FK and
         cod.PK_dxClientOrderDetail = rd.FK_dxClientOrderDetail and
         sd.PK_dxShippingDetail = rd.FK_dxShippingDetail

   update dxRMA set ListOfOrder =  Coalesce(@OrderList, ''), ListOfShipping = Coalesce(@ShippingList, '')
      where PK_dxRMA = @FK ;
END
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [PK_dxRMADetail] PRIMARY KEY CLUSTERED  ([PK_dxRMADetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxClientOrderDetail] ON [dbo].[dxRMADetail] ([FK_dxClientOrderDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxLocation] ON [dbo].[dxRMADetail] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxProduct] ON [dbo].[dxRMADetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxRMA] ON [dbo].[dxRMADetail] ([FK_dxRMA]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxRMADetailReason] ON [dbo].[dxRMADetail] ([FK_dxRMADetailReason]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxScaleUnit] ON [dbo].[dxRMADetail] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxScaleUnit__Quantity] ON [dbo].[dxRMADetail] ([FK_dxScaleUnit__Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxShippingDetail] ON [dbo].[dxRMADetail] ([FK_dxShippingDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMADetail_FK_dxWarehouse] ON [dbo].[dxRMADetail] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxClientOrderDetail_dxRMADetail] FOREIGN KEY ([FK_dxClientOrderDetail]) REFERENCES [dbo].[dxClientOrderDetail] ([PK_dxClientOrderDetail])
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxRMADetail] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxRMADetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxRMA_dxRMADetail] FOREIGN KEY ([FK_dxRMA]) REFERENCES [dbo].[dxRMA] ([PK_dxRMA])
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxRMADetailReason_dxRMADetail] FOREIGN KEY ([FK_dxRMADetailReason]) REFERENCES [dbo].[dxRMADetailReason] ([PK_dxRMADetailReason])
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxRMADetail] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Quantity_dxRMADetail] FOREIGN KEY ([FK_dxScaleUnit__Quantity]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxShippingDetail_dxRMADetail] FOREIGN KEY ([FK_dxShippingDetail]) REFERENCES [dbo].[dxShippingDetail] ([PK_dxShippingDetail])
GO
ALTER TABLE [dbo].[dxRMADetail] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxRMADetail] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
