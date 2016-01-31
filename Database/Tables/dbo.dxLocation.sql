CREATE TABLE [dbo].[dxLocation]
(
[PK_dxLocation] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[PickingOrder] [int] NOT NULL CONSTRAINT [DF_dxLocation_PickingOrder] DEFAULT ((0)),
[FK_dxWorkOrder] [int] NULL,
[PhaseNumber] [int] NULL,
[FK_dxClientOrder] [int] NULL,
[ReservedArea] [bit] NOT NULL CONSTRAINT [DF_dxLocation_ReservedArea] DEFAULT ((0)),
[FK_dxWarehouse] [int] NULL,
[CommonWIPLocation] [bit] NOT NULL CONSTRAINT [DF_dxLocation_CommonWIPLocation] DEFAULT ((0)),
[FK_dxLocation__Sector] [int] NULL,
[ScanBatchInProcess] [bit] NOT NULL CONSTRAINT [DF_dxLocation_ScanBatchInProcess] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxLocation.trAuditDelete] ON [dbo].[dxLocation]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxLocation'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxLocation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxLocation, ID, Description, PickingOrder, FK_dxWorkOrder, PhaseNumber, FK_dxClientOrder, ReservedArea, FK_dxWarehouse, CommonWIPLocation, FK_dxLocation__Sector, ScanBatchInProcess from deleted
 Declare @PK_dxLocation int, @ID varchar(50), @Description varchar(255), @PickingOrder int, @FK_dxWorkOrder int, @PhaseNumber int, @FK_dxClientOrder int, @ReservedArea Bit, @FK_dxWarehouse int, @CommonWIPLocation Bit, @FK_dxLocation__Sector int, @ScanBatchInProcess Bit

 OPEN pk_cursordxLocation
 FETCH NEXT FROM pk_cursordxLocation INTO @PK_dxLocation, @ID, @Description, @PickingOrder, @FK_dxWorkOrder, @PhaseNumber, @FK_dxClientOrder, @ReservedArea, @FK_dxWarehouse, @CommonWIPLocation, @FK_dxLocation__Sector, @ScanBatchInProcess
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxLocation, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PickingOrder', @PickingOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWorkOrder', @FK_dxWorkOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PhaseNumber', @PhaseNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', @FK_dxClientOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ReservedArea', @ReservedArea
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', @FK_dxWarehouse
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'CommonWIPLocation', @CommonWIPLocation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Sector', @FK_dxLocation__Sector
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ScanBatchInProcess', @ScanBatchInProcess
FETCH NEXT FROM pk_cursordxLocation INTO @PK_dxLocation, @ID, @Description, @PickingOrder, @FK_dxWorkOrder, @PhaseNumber, @FK_dxClientOrder, @ReservedArea, @FK_dxWarehouse, @CommonWIPLocation, @FK_dxLocation__Sector, @ScanBatchInProcess
 END

 CLOSE pk_cursordxLocation 
 DEALLOCATE pk_cursordxLocation
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxLocation.trAuditInsUpd] ON [dbo].[dxLocation] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxLocation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxLocation from inserted;
 set @tablename = 'dxLocation' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxLocation
 FETCH NEXT FROM pk_cursordxLocation INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PickingOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PickingOrder', PickingOrder from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWorkOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWorkOrder', FK_dxWorkOrder from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PhaseNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PhaseNumber', PhaseNumber from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', FK_dxClientOrder from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReservedArea )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ReservedArea', ReservedArea from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CommonWIPLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'CommonWIPLocation', CommonWIPLocation from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation__Sector )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Sector', FK_dxLocation__Sector from dxLocation where PK_dxLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ScanBatchInProcess )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ScanBatchInProcess', ScanBatchInProcess from dxLocation where PK_dxLocation = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxLocation INTO @keyvalue
 END

 CLOSE pk_cursordxLocation 
 DEALLOCATE pk_cursordxLocation
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxLocation.trCheckWarehouse] ON [dbo].[dxLocation]
AFTER INSERT, UPDATE
AS
BEGIN
 update dxLocation set FK_dxWarehouse = null
  where PK_dxLocation in ( Select PK_dxLocation from inserted where PK_dxLocation = 1 ) and not FK_dxWarehouse is null

 update dxLocation set FK_dxWarehouse = 4
  where PK_dxLocation in ( Select PK_dxLocation from inserted where (PK_dxLocation <> 1)
                             and  (FK_dxWorkOrder > 0) )
   and ((FK_dxWarehouse <> 4) or (FK_dxWarehouse is null))
 
END
GO
ALTER TABLE [dbo].[dxLocation] ADD CONSTRAINT [PK_dxLocation] PRIMARY KEY CLUSTERED  ([PK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxLocation_FK_dxClientOrder] ON [dbo].[dxLocation] ([FK_dxClientOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxLocation_FK_dxLocation__Sector] ON [dbo].[dxLocation] ([FK_dxLocation__Sector]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxLocation_FK_dxWarehouse] ON [dbo].[dxLocation] ([FK_dxWarehouse]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxLocation_FK_dxWorkOrder] ON [dbo].[dxLocation] ([FK_dxWorkOrder]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxLocation] ON [dbo].[dxLocation] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxLocation] ADD CONSTRAINT [dxConstraint_FK_dxClientOrder_dxLocation] FOREIGN KEY ([FK_dxClientOrder]) REFERENCES [dbo].[dxClientOrder] ([PK_dxClientOrder])
GO
ALTER TABLE [dbo].[dxLocation] ADD CONSTRAINT [dxConstraint_FK_dxLocation__Sector_dxLocation] FOREIGN KEY ([FK_dxLocation__Sector]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxLocation] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxLocation] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
ALTER TABLE [dbo].[dxLocation] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrder_dxLocation] FOREIGN KEY ([FK_dxWorkOrder]) REFERENCES [dbo].[dxWorkOrder] ([PK_dxWorkOrder])
GO
