CREATE TABLE [dbo].[dxKanban]
(
[PK_dxKanban] [int] NOT NULL IDENTITY(90000, 1),
[FK_dxWarehouse] [int] NOT NULL CONSTRAINT [DF_dxKanban_FK_dxWarehouse] DEFAULT ((1)),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxKanban_FK_dxLocation] DEFAULT ((1)),
[FK_dxProduct] [int] NOT NULL CONSTRAINT [DF_dxKanban_FK_dxProduct] DEFAULT ((1)),
[FK_dxVendor__Default] [int] NOT NULL,
[FK_dxScaleUnit__Vendor] [int] NOT NULL CONSTRAINT [DF_dxKanban_FK_dxScaleUnit] DEFAULT ((1)),
[OrderLevelQuantity] [float] NOT NULL CONSTRAINT [DF_dxKanban_OrderLevelQuantity] DEFAULT ((0)),
[LeadTimeInDays] [int] NOT NULL CONSTRAINT [DF_dxKanban_LeadTimeInDays] DEFAULT ((0)),
[TriggerOrderedQuantity] [float] NOT NULL CONSTRAINT [DF_dxKanban_TriggerOrderedQuantity] DEFAULT ((0.0)),
[ID] AS (CONVERT([varchar](50),[PK_dxKanban],(0)))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxKanban.trAuditDelete] ON [dbo].[dxKanban]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxKanban'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxKanban CURSOR LOCAL FAST_FORWARD for SELECT PK_dxKanban, FK_dxWarehouse, FK_dxLocation, FK_dxProduct, FK_dxVendor__Default, FK_dxScaleUnit__Vendor, OrderLevelQuantity, LeadTimeInDays, TriggerOrderedQuantity, ID from deleted
 Declare @PK_dxKanban int, @FK_dxWarehouse int, @FK_dxLocation int, @FK_dxProduct int, @FK_dxVendor__Default int, @FK_dxScaleUnit__Vendor int, @OrderLevelQuantity Float, @LeadTimeInDays int, @TriggerOrderedQuantity Float, @ID varchar(50)

 OPEN pk_cursordxKanban
 FETCH NEXT FROM pk_cursordxKanban INTO @PK_dxKanban, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @FK_dxVendor__Default, @FK_dxScaleUnit__Vendor, @OrderLevelQuantity, @LeadTimeInDays, @TriggerOrderedQuantity, @ID
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxKanban, @tablename, @auditdate, @username, @fk_dxuser
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor__Default', @FK_dxVendor__Default
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Vendor', @FK_dxScaleUnit__Vendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderLevelQuantity', @OrderLevelQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'LeadTimeInDays', @LeadTimeInDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TriggerOrderedQuantity', @TriggerOrderedQuantity
FETCH NEXT FROM pk_cursordxKanban INTO @PK_dxKanban, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @FK_dxVendor__Default, @FK_dxScaleUnit__Vendor, @OrderLevelQuantity, @LeadTimeInDays, @TriggerOrderedQuantity, @ID
 END

 CLOSE pk_cursordxKanban 
 DEALLOCATE pk_cursordxKanban
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxKanban.trAuditInsUpd] ON [dbo].[dxKanban] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxKanban CURSOR LOCAL FAST_FORWARD for SELECT PK_dxKanban from inserted;
 set @tablename = 'dxKanban' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxKanban
 FETCH NEXT FROM pk_cursordxKanban INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxKanban where PK_dxKanban = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxKanban where PK_dxKanban = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxKanban where PK_dxKanban = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor__Default )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor__Default', FK_dxVendor__Default from dxKanban where PK_dxKanban = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Vendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Vendor', FK_dxScaleUnit__Vendor from dxKanban where PK_dxKanban = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OrderLevelQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderLevelQuantity', OrderLevelQuantity from dxKanban where PK_dxKanban = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LeadTimeInDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'LeadTimeInDays', LeadTimeInDays from dxKanban where PK_dxKanban = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TriggerOrderedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TriggerOrderedQuantity', TriggerOrderedQuantity from dxKanban where PK_dxKanban = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxKanban INTO @keyvalue
 END

 CLOSE pk_cursordxKanban 
 DEALLOCATE pk_cursordxKanban
GO
ALTER TABLE [dbo].[dxKanban] ADD CONSTRAINT [PK_dxKanban] PRIMARY KEY CLUSTERED  ([PK_dxKanban]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxKanban_FK_dxLocation] ON [dbo].[dxKanban] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxKanban_FK_dxProduct] ON [dbo].[dxKanban] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxKanban_FK_dxScaleUnit__Vendor] ON [dbo].[dxKanban] ([FK_dxScaleUnit__Vendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxKanban_FK_dxVendor__Default] ON [dbo].[dxKanban] ([FK_dxVendor__Default]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxKanban_FK_dxWarehouse] ON [dbo].[dxKanban] ([FK_dxWarehouse]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxKanban] ON [dbo].[dxKanban] ([FK_dxWarehouse], [FK_dxLocation], [FK_dxProduct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxKanban] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxKanban] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxKanban] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxKanban] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxKanban] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Vendor_dxKanban] FOREIGN KEY ([FK_dxScaleUnit__Vendor]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxKanban] ADD CONSTRAINT [dxConstraint_FK_dxVendor__Default_dxKanban] FOREIGN KEY ([FK_dxVendor__Default]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
ALTER TABLE [dbo].[dxKanban] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxKanban] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
