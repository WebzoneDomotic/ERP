CREATE TABLE [dbo].[dxInventoryAdjustmentDetail]
(
[PK_dxInventoryAdjustmentDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxInventoryAdjustment] [int] NOT NULL,
[FK_dxWarehouse] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_FK_dxProduct] DEFAULT ((1)),
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_Lot] DEFAULT ('0'),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_FK_dxLocation] DEFAULT ((1)),
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_AdjustmentQuantity] DEFAULT ((0)),
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_FK_dxScaleUnit] DEFAULT ((1)),
[AverageAmountPerUnit] [float] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_NewAverageAmountPerQuantity] DEFAULT ((0)),
[Amount] [float] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_AdjustmentAmount] DEFAULT ((0)),
[InStockQuantity] [float] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_InStockQuantity] DEFAULT ((0.0)),
[ScanQuantity] [float] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_ScanQuantity] DEFAULT ((0.0)),
[UnfoundProduct] [bit] NOT NULL CONSTRAINT [DF_dxInventoryAdjustmentDetail_UnfoundProduct] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryAdjustmentDetail.trAuditDelete] ON [dbo].[dxInventoryAdjustmentDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxInventoryAdjustmentDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxInventoryAdjustmentDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryAdjustmentDetail, FK_dxInventoryAdjustment, FK_dxWarehouse, FK_dxProduct, Lot, FK_dxLocation, Description, Quantity, FK_dxScaleUnit, AverageAmountPerUnit, Amount, InStockQuantity, ScanQuantity, UnfoundProduct from deleted
 Declare @PK_dxInventoryAdjustmentDetail int, @FK_dxInventoryAdjustment int, @FK_dxWarehouse int, @FK_dxProduct int, @Lot varchar(50), @FK_dxLocation int, @Description varchar(255), @Quantity Float, @FK_dxScaleUnit int, @AverageAmountPerUnit Float, @Amount Float, @InStockQuantity Float, @ScanQuantity Float, @UnfoundProduct Bit

 OPEN pk_cursordxInventoryAdjustmentDetail
 FETCH NEXT FROM pk_cursordxInventoryAdjustmentDetail INTO @PK_dxInventoryAdjustmentDetail, @FK_dxInventoryAdjustment, @FK_dxWarehouse, @FK_dxProduct, @Lot, @FK_dxLocation, @Description, @Quantity, @FK_dxScaleUnit, @AverageAmountPerUnit, @Amount, @InStockQuantity, @ScanQuantity, @UnfoundProduct
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxInventoryAdjustmentDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInventoryAdjustment', @FK_dxInventoryAdjustment
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', @FK_dxWarehouse
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', @Lot
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', @FK_dxLocation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', @Quantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', @FK_dxScaleUnit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AverageAmountPerUnit', @AverageAmountPerUnit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', @Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InStockQuantity', @InStockQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ScanQuantity', @ScanQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'UnfoundProduct', @UnfoundProduct
FETCH NEXT FROM pk_cursordxInventoryAdjustmentDetail INTO @PK_dxInventoryAdjustmentDetail, @FK_dxInventoryAdjustment, @FK_dxWarehouse, @FK_dxProduct, @Lot, @FK_dxLocation, @Description, @Quantity, @FK_dxScaleUnit, @AverageAmountPerUnit, @Amount, @InStockQuantity, @ScanQuantity, @UnfoundProduct
 END

 CLOSE pk_cursordxInventoryAdjustmentDetail 
 DEALLOCATE pk_cursordxInventoryAdjustmentDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryAdjustmentDetail.trAuditInsUpd] ON [dbo].[dxInventoryAdjustmentDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxInventoryAdjustmentDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryAdjustmentDetail from inserted;
 set @tablename = 'dxInventoryAdjustmentDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxInventoryAdjustmentDetail
 FETCH NEXT FROM pk_cursordxInventoryAdjustmentDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxInventoryAdjustment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInventoryAdjustment', FK_dxInventoryAdjustment from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AverageAmountPerUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AverageAmountPerUnit', AverageAmountPerUnit from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InStockQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InStockQuantity', InStockQuantity from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ScanQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ScanQuantity', ScanQuantity from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnfoundProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'UnfoundProduct', UnfoundProduct from dxInventoryAdjustmentDetail where PK_dxInventoryAdjustmentDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxInventoryAdjustmentDetail INTO @keyvalue
 END

 CLOSE pk_cursordxInventoryAdjustmentDetail 
 DEALLOCATE pk_cursordxInventoryAdjustmentDetail
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentDetail] ADD CONSTRAINT [CK_dxInventoryAdjustmentDetail_InStockQuantity] CHECK (([InStockQuantity]>=(0.0)))
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentDetail] ADD CONSTRAINT [CK_dxInventoryAdjustmentDetail_ScanQuantity] CHECK (([ScanQuantity]>=(0.0)))
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentDetail] ADD CONSTRAINT [PK_dxInventoryAdjustmentDetail] PRIMARY KEY CLUSTERED  ([PK_dxInventoryAdjustmentDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryAdjustmentDetail_FK_dxInventoryAdjustment] ON [dbo].[dxInventoryAdjustmentDetail] ([FK_dxInventoryAdjustment]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryAdjustmentDetail_FK_dxLocation] ON [dbo].[dxInventoryAdjustmentDetail] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryAdjustmentDetail_FK_dxProduct] ON [dbo].[dxInventoryAdjustmentDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryAdjustmentDetail_FK_dxScaleUnit] ON [dbo].[dxInventoryAdjustmentDetail] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryAdjustmentDetail_FK_dxWarehouse] ON [dbo].[dxInventoryAdjustmentDetail] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentDetail] ADD CONSTRAINT [dxConstraint_FK_dxInventoryAdjustment_dxInventoryAdjustmentDetail] FOREIGN KEY ([FK_dxInventoryAdjustment]) REFERENCES [dbo].[dxInventoryAdjustment] ([PK_dxInventoryAdjustment])
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentDetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxInventoryAdjustmentDetail] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxInventoryAdjustmentDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentDetail] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxInventoryAdjustmentDetail] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentDetail] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxInventoryAdjustmentDetail] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
