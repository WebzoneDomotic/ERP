CREATE TABLE [dbo].[dxInventoryAdjustmentType]
(
[PK_dxInventoryAdjustmentType] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[FK_dxAccount__InventoryAdjustment] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryAdjustmentType.trAuditDelete] ON [dbo].[dxInventoryAdjustmentType]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxInventoryAdjustmentType'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxInventoryAdjustmentType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryAdjustmentType, ID, Description, FK_dxAccount__InventoryAdjustment from deleted
 Declare @PK_dxInventoryAdjustmentType int, @ID varchar(50), @Description varchar(255), @FK_dxAccount__InventoryAdjustment int

 OPEN pk_cursordxInventoryAdjustmentType
 FETCH NEXT FROM pk_cursordxInventoryAdjustmentType INTO @PK_dxInventoryAdjustmentType, @ID, @Description, @FK_dxAccount__InventoryAdjustment
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxInventoryAdjustmentType, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__InventoryAdjustment', @FK_dxAccount__InventoryAdjustment
FETCH NEXT FROM pk_cursordxInventoryAdjustmentType INTO @PK_dxInventoryAdjustmentType, @ID, @Description, @FK_dxAccount__InventoryAdjustment
 END

 CLOSE pk_cursordxInventoryAdjustmentType 
 DEALLOCATE pk_cursordxInventoryAdjustmentType
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryAdjustmentType.trAuditInsUpd] ON [dbo].[dxInventoryAdjustmentType] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxInventoryAdjustmentType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryAdjustmentType from inserted;
 set @tablename = 'dxInventoryAdjustmentType' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxInventoryAdjustmentType
 FETCH NEXT FROM pk_cursordxInventoryAdjustmentType INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxInventoryAdjustmentType where PK_dxInventoryAdjustmentType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxInventoryAdjustmentType where PK_dxInventoryAdjustmentType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__InventoryAdjustment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__InventoryAdjustment', FK_dxAccount__InventoryAdjustment from dxInventoryAdjustmentType where PK_dxInventoryAdjustmentType = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxInventoryAdjustmentType INTO @keyvalue
 END

 CLOSE pk_cursordxInventoryAdjustmentType 
 DEALLOCATE pk_cursordxInventoryAdjustmentType
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentType] ADD CONSTRAINT [PK_dxInventoryAdjustmentType] PRIMARY KEY CLUSTERED  ([PK_dxInventoryAdjustmentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryAdjustmentType_FK_dxAccount__InventoryAdjustment] ON [dbo].[dxInventoryAdjustmentType] ([FK_dxAccount__InventoryAdjustment]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxInventoryAdjustmentType] ADD CONSTRAINT [dxConstraint_FK_dxAccount__InventoryAdjustment_dxInventoryAdjustmentType] FOREIGN KEY ([FK_dxAccount__InventoryAdjustment]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
