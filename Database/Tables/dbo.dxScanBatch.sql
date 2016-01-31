CREATE TABLE [dbo].[dxScanBatch]
(
[PK_dxScanBatch] [int] NOT NULL IDENTITY(1, 1),
[FK_dxWarehouse] [int] NOT NULL,
[FK_dxLocation] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Quantity] [float] NULL,
[FK_dxInventoryAdjustment] [int] NULL,
[SystemUser] [varchar] (100) COLLATE French_CI_AS NULL,
[RecountVersion] [int] NOT NULL CONSTRAINT [DF_dxScanBatch_RecountVersion] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxScanBatch.trAuditDelete] ON [dbo].[dxScanBatch]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxScanBatch'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxScanBatch CURSOR LOCAL FAST_FORWARD for SELECT PK_dxScanBatch, FK_dxWarehouse, FK_dxLocation, FK_dxProduct, Lot, Quantity, FK_dxInventoryAdjustment, SystemUser, RecountVersion from deleted
 Declare @PK_dxScanBatch int, @FK_dxWarehouse int, @FK_dxLocation int, @FK_dxProduct int, @Lot varchar(50), @Quantity Float, @FK_dxInventoryAdjustment int, @SystemUser varchar(100), @RecountVersion int

 OPEN pk_cursordxScanBatch
 FETCH NEXT FROM pk_cursordxScanBatch INTO @PK_dxScanBatch, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Quantity, @FK_dxInventoryAdjustment, @SystemUser, @RecountVersion
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxScanBatch, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', @Quantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInventoryAdjustment', @FK_dxInventoryAdjustment
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SystemUser', @SystemUser
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'RecountVersion', @RecountVersion
FETCH NEXT FROM pk_cursordxScanBatch INTO @PK_dxScanBatch, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Quantity, @FK_dxInventoryAdjustment, @SystemUser, @RecountVersion
 END

 CLOSE pk_cursordxScanBatch 
 DEALLOCATE pk_cursordxScanBatch
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxScanBatch.trAuditInsUpd] ON [dbo].[dxScanBatch] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxScanBatch CURSOR LOCAL FAST_FORWARD for SELECT PK_dxScanBatch from inserted;
 set @tablename = 'dxScanBatch' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxScanBatch
 FETCH NEXT FROM pk_cursordxScanBatch INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxScanBatch where PK_dxScanBatch = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxScanBatch where PK_dxScanBatch = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxScanBatch where PK_dxScanBatch = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxScanBatch where PK_dxScanBatch = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxScanBatch where PK_dxScanBatch = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxInventoryAdjustment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInventoryAdjustment', FK_dxInventoryAdjustment from dxScanBatch where PK_dxScanBatch = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SystemUser )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SystemUser', SystemUser from dxScanBatch where PK_dxScanBatch = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RecountVersion )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'RecountVersion', RecountVersion from dxScanBatch where PK_dxScanBatch = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxScanBatch INTO @keyvalue
 END

 CLOSE pk_cursordxScanBatch 
 DEALLOCATE pk_cursordxScanBatch
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxScanBatch.trSetUserName] ON [dbo].[dxScanBatch] 
FOR INSERT 
AS
 Declare @keyvalue int ;
 Declare pk_cursor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxScanBatch from inserted;

 OPEN pk_cursor
 FETCH NEXT FROM pk_cursor INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
   UPDATE dxScanBatch SET SystemUser = SYSTEM_USER WHERE PK_dxScanBatch = @keyvalue
   FETCH NEXT FROM pk_cursor INTO @keyvalue
 END

 CLOSE pk_cursor 
 DEALLOCATE pk_cursor
GO
ALTER TABLE [dbo].[dxScanBatch] ADD CONSTRAINT [QuantityGreaterThanZero] CHECK (([Quantity]>(0.0)))
GO
ALTER TABLE [dbo].[dxScanBatch] ADD CONSTRAINT [PK_dxScanBatch] PRIMARY KEY CLUSTERED  ([PK_dxScanBatch]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxScanBatch_FK_dxInventoryAdjustment] ON [dbo].[dxScanBatch] ([FK_dxInventoryAdjustment]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxScanBatch_FK_dxLocation] ON [dbo].[dxScanBatch] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxScanBatch_FK_dxProduct] ON [dbo].[dxScanBatch] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxScanBatch_FK_dxWarehouse] ON [dbo].[dxScanBatch] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxScanBatch] ADD CONSTRAINT [dxConstraint_FK_dxInventoryAdjustment_dxScanBatch] FOREIGN KEY ([FK_dxInventoryAdjustment]) REFERENCES [dbo].[dxInventoryAdjustment] ([PK_dxInventoryAdjustment])
GO
ALTER TABLE [dbo].[dxScanBatch] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxScanBatch] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxScanBatch] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxScanBatch] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxScanBatch] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxScanBatch] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
