CREATE TABLE [dbo].[dxInventoryTransferDetail]
(
[PK_dxInventoryTransferDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxInventoryTransfer] [int] NOT NULL,
[FK_dxWarehouse__Out] [int] NOT NULL,
[FK_dxLocation__Out] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxInventoryMovementDetail_Lot] DEFAULT ('0'),
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxInventoryMovementDetail_Quantity] DEFAULT ('0'),
[FK_dxWarehouse__In] [int] NOT NULL,
[FK_dxLocation__In] [int] NOT NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[NewLot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxInventoryTransferDetail_NewLot] DEFAULT ('')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryTransferDetail.trAuditDelete] ON [dbo].[dxInventoryTransferDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxInventoryTransferDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxInventoryTransferDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryTransferDetail, FK_dxInventoryTransfer, FK_dxWarehouse__Out, FK_dxLocation__Out, FK_dxProduct, Lot, Quantity, FK_dxWarehouse__In, FK_dxLocation__In, Note, NewLot from deleted
 Declare @PK_dxInventoryTransferDetail int, @FK_dxInventoryTransfer int, @FK_dxWarehouse__Out int, @FK_dxLocation__Out int, @FK_dxProduct int, @Lot varchar(50), @Quantity Float, @FK_dxWarehouse__In int, @FK_dxLocation__In int, @Note varchar(2000), @NewLot varchar(50)

 OPEN pk_cursordxInventoryTransferDetail
 FETCH NEXT FROM pk_cursordxInventoryTransferDetail INTO @PK_dxInventoryTransferDetail, @FK_dxInventoryTransfer, @FK_dxWarehouse__Out, @FK_dxLocation__Out, @FK_dxProduct, @Lot, @Quantity, @FK_dxWarehouse__In, @FK_dxLocation__In, @Note, @NewLot
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxInventoryTransferDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInventoryTransfer', @FK_dxInventoryTransfer
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse__Out', @FK_dxWarehouse__Out
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Out', @FK_dxLocation__Out
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
        select @pkdataaudit, 'FK_dxWarehouse__In', @FK_dxWarehouse__In
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__In', @FK_dxLocation__In
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'NewLot', @NewLot
FETCH NEXT FROM pk_cursordxInventoryTransferDetail INTO @PK_dxInventoryTransferDetail, @FK_dxInventoryTransfer, @FK_dxWarehouse__Out, @FK_dxLocation__Out, @FK_dxProduct, @Lot, @Quantity, @FK_dxWarehouse__In, @FK_dxLocation__In, @Note, @NewLot
 END

 CLOSE pk_cursordxInventoryTransferDetail 
 DEALLOCATE pk_cursordxInventoryTransferDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryTransferDetail.trAuditInsUpd] ON [dbo].[dxInventoryTransferDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxInventoryTransferDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryTransferDetail from inserted;
 set @tablename = 'dxInventoryTransferDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxInventoryTransferDetail
 FETCH NEXT FROM pk_cursordxInventoryTransferDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxInventoryTransfer )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInventoryTransfer', FK_dxInventoryTransfer from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse__Out )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse__Out', FK_dxWarehouse__Out from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation__Out )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Out', FK_dxLocation__Out from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse__In )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse__In', FK_dxWarehouse__In from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation__In )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__In', FK_dxLocation__In from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NewLot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'NewLot', NewLot from dxInventoryTransferDetail where PK_dxInventoryTransferDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxInventoryTransferDetail INTO @keyvalue
 END

 CLOSE pk_cursordxInventoryTransferDetail 
 DEALLOCATE pk_cursordxInventoryTransferDetail
GO
ALTER TABLE [dbo].[dxInventoryTransferDetail] ADD CONSTRAINT [CK_dxInventoryMovementDetail] CHECK (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[dxInventoryTransferDetail] ADD CONSTRAINT [PK_dxInventoryMovementDetail] PRIMARY KEY CLUSTERED  ([PK_dxInventoryTransferDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryTransferDetail_FK_dxInventoryTransfer] ON [dbo].[dxInventoryTransferDetail] ([FK_dxInventoryTransfer]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryTransferDetail_FK_dxLocation__In] ON [dbo].[dxInventoryTransferDetail] ([FK_dxLocation__In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryTransferDetail_FK_dxLocation__Out] ON [dbo].[dxInventoryTransferDetail] ([FK_dxLocation__Out]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryTransferDetail_FK_dxProduct] ON [dbo].[dxInventoryTransferDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryTransferDetail_FK_dxWarehouse__In] ON [dbo].[dxInventoryTransferDetail] ([FK_dxWarehouse__In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryTransferDetail_FK_dxWarehouse__Out] ON [dbo].[dxInventoryTransferDetail] ([FK_dxWarehouse__Out]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxInventoryTransferDetail] ADD CONSTRAINT [dxConstraint_FK_dxInventoryTransfer_dxInventoryTransferDetail] FOREIGN KEY ([FK_dxInventoryTransfer]) REFERENCES [dbo].[dxInventoryTransfer] ([PK_dxInventoryTransfer])
GO
ALTER TABLE [dbo].[dxInventoryTransferDetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation__In_dxInventoryTransferDetail] FOREIGN KEY ([FK_dxLocation__In]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxInventoryTransferDetail] ADD CONSTRAINT [dxConstraint_FK_dxLocation__Out_dxInventoryTransferDetail] FOREIGN KEY ([FK_dxLocation__Out]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxInventoryTransferDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxInventoryTransferDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxInventoryTransferDetail] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse__In_dxInventoryTransferDetail] FOREIGN KEY ([FK_dxWarehouse__In]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
ALTER TABLE [dbo].[dxInventoryTransferDetail] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse__Out_dxInventoryTransferDetail] FOREIGN KEY ([FK_dxWarehouse__Out]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
