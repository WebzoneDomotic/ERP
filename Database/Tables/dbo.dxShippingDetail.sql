CREATE TABLE [dbo].[dxShippingDetail]
(
[PK_dxShippingDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxShipping] [int] NOT NULL,
[FK_dxClientOrder] [int] NOT NULL,
[FK_dxClientOrderDetail] [int] NOT NULL,
[FK_dxWarehouse] [int] NULL,
[FK_dxLocation] [int] NULL,
[FK_dxProduct] [int] NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxShippingDetail_Quantity] DEFAULT ((0.0)),
[BilledQuantity] [float] NOT NULL CONSTRAINT [DF_dxShippingDetail_BilledQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit__Quantity] [int] NOT NULL CONSTRAINT [DF_dxShippingDetail_FK_dxScaleUnit__Quantity] DEFAULT ((1)),
[ProductQuantity] [float] NOT NULL CONSTRAINT [DF_dxShippingDetail_ProductQuantity] DEFAULT ((0.0)),
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxShippingDetail_FK_dxScaleUnit] DEFAULT ((1)),
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxShippingDetail_UnitAmount] DEFAULT ((0.0)),
[ConsiderAsBilled] [bit] NOT NULL CONSTRAINT [DF_dxShippingDetail_ConsiderAsBilled] DEFAULT ((0)),
[Rank] [float] NOT NULL CONSTRAINT [DF_dxShippingDetail_Rank] DEFAULT ((0.0)),
[TrackingNumber] [varchar] (100) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxShippingDetail_TrackingNumber] DEFAULT (''),
[SkidID] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxShippingDetail_SkidID] DEFAULT (''),
[CaseID] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxShippingDetail_CaseID] DEFAULT ('')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShippingDetail.trAuditDelete] ON [dbo].[dxShippingDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxShippingDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxShippingDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShippingDetail, FK_dxShipping, FK_dxClientOrder, FK_dxClientOrderDetail, FK_dxWarehouse, FK_dxLocation, FK_dxProduct, Lot, Description, Quantity, BilledQuantity, FK_dxScaleUnit__Quantity, ProductQuantity, FK_dxScaleUnit, UnitAmount, ConsiderAsBilled, Rank, TrackingNumber, SkidID, CaseID from deleted
 Declare @PK_dxShippingDetail int, @FK_dxShipping int, @FK_dxClientOrder int, @FK_dxClientOrderDetail int, @FK_dxWarehouse int, @FK_dxLocation int, @FK_dxProduct int, @Lot varchar(50), @Description varchar(2000), @Quantity Float, @BilledQuantity Float, @FK_dxScaleUnit__Quantity int, @ProductQuantity Float, @FK_dxScaleUnit int, @UnitAmount Float, @ConsiderAsBilled Bit, @Rank Float, @TrackingNumber varchar(100), @SkidID varchar(50), @CaseID varchar(50)

 OPEN pk_cursordxShippingDetail
 FETCH NEXT FROM pk_cursordxShippingDetail INTO @PK_dxShippingDetail, @FK_dxShipping, @FK_dxClientOrder, @FK_dxClientOrderDetail, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Description, @Quantity, @BilledQuantity, @FK_dxScaleUnit__Quantity, @ProductQuantity, @FK_dxScaleUnit, @UnitAmount, @ConsiderAsBilled, @Rank, @TrackingNumber, @SkidID, @CaseID
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxShippingDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipping', @FK_dxShipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', @FK_dxClientOrder
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
        select @pkdataaudit, 'UnitAmount', @UnitAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ConsiderAsBilled', @ConsiderAsBilled
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TrackingNumber', @TrackingNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SkidID', @SkidID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'CaseID', @CaseID
FETCH NEXT FROM pk_cursordxShippingDetail INTO @PK_dxShippingDetail, @FK_dxShipping, @FK_dxClientOrder, @FK_dxClientOrderDetail, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Description, @Quantity, @BilledQuantity, @FK_dxScaleUnit__Quantity, @ProductQuantity, @FK_dxScaleUnit, @UnitAmount, @ConsiderAsBilled, @Rank, @TrackingNumber, @SkidID, @CaseID
 END

 CLOSE pk_cursordxShippingDetail 
 DEALLOCATE pk_cursordxShippingDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShippingDetail.trAuditInsUpd] ON [dbo].[dxShippingDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxShippingDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShippingDetail from inserted;
 set @tablename = 'dxShippingDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxShippingDetail
 FETCH NEXT FROM pk_cursordxShippingDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipping', FK_dxShipping from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', FK_dxClientOrder from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientOrderDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrderDetail', FK_dxClientOrderDetail from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BilledQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BilledQuantity', BilledQuantity from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Quantity', FK_dxScaleUnit__Quantity from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProductQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductQuantity', ProductQuantity from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ConsiderAsBilled )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ConsiderAsBilled', ConsiderAsBilled from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TrackingNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TrackingNumber', TrackingNumber from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SkidID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SkidID', SkidID from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CaseID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'CaseID', CaseID from dxShippingDetail where PK_dxShippingDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxShippingDetail INTO @keyvalue
 END

 CLOSE pk_cursordxShippingDetail 
 DEALLOCATE pk_cursordxShippingDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShippingDetail.trBuildList] ON [dbo].[dxShippingDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;
   declare @DocList varchar(150);

   set @FKi  = ( SELECT Coalesce(max(FK_dxShipping ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxShipping ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   Set  @DocList = Null ;
   select  @DocList =
              case dbo.fdxIncluded( Coalesce(Convert(varchar(10),  FK_dxClientOrder),'') , @DocList )  when 1 then  @DocList
              else  COALESCE(@DocList  + ',', '') + Coalesce(Convert(varchar(10),  FK_dxClientOrder),'')
              end  from dxShippingDetail where FK_dxShipping = @FK and not FK_dxClientOrder is null
   update dxShipping set ListOfOrder =  Coalesce(@DocList, '')  where PK_dxShipping = @FK ;

END
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [PK_dxShippingDetail] PRIMARY KEY CLUSTERED  ([PK_dxShippingDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShippingDetail_FK_dxClientOrder] ON [dbo].[dxShippingDetail] ([FK_dxClientOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShippingDetail_FK_dxClientOrderDetail] ON [dbo].[dxShippingDetail] ([FK_dxClientOrderDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShippingDetail_FK_dxLocation] ON [dbo].[dxShippingDetail] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShippingDetail_FK_dxProduct] ON [dbo].[dxShippingDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxShippingDetailItem] ON [dbo].[dxShippingDetail] ([FK_dxProduct]) INCLUDE ([FK_dxShipping], [Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShippingDetail_FK_dxScaleUnit] ON [dbo].[dxShippingDetail] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShippingDetail_FK_dxScaleUnit__Quantity] ON [dbo].[dxShippingDetail] ([FK_dxScaleUnit__Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShippingDetail_FK_dxShipping] ON [dbo].[dxShippingDetail] ([FK_dxShipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShippingDetail_FK_dxWarehouse] ON [dbo].[dxShippingDetail] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [dxConstraint_FK_dxClientOrder_dxShippingDetail] FOREIGN KEY ([FK_dxClientOrder]) REFERENCES [dbo].[dxClientOrder] ([PK_dxClientOrder])
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [dxConstraint_FK_dxClientOrderDetail_dxShippingDetail] FOREIGN KEY ([FK_dxClientOrderDetail]) REFERENCES [dbo].[dxClientOrderDetail] ([PK_dxClientOrderDetail])
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxShippingDetail] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxShippingDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxShippingDetail] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Quantity_dxShippingDetail] FOREIGN KEY ([FK_dxScaleUnit__Quantity]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [dxConstraint_FK_dxShipping_dxShippingDetail] FOREIGN KEY ([FK_dxShipping]) REFERENCES [dbo].[dxShipping] ([PK_dxShipping])
GO
ALTER TABLE [dbo].[dxShippingDetail] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxShippingDetail] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
