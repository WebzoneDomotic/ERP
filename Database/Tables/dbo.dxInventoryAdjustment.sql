CREATE TABLE [dbo].[dxInventoryAdjustment]
(
[PK_dxInventoryAdjustment] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxInventoryAdjustment]),
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[TransactionDate] [datetime] NOT NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxInventoryAdjustment_Posted] DEFAULT ((0)),
[FK_dxInventoryAdjustmentType] [int] NOT NULL CONSTRAINT [DF_dxInventoryAdjustment_FK_dxInventoryAdjustmentType] DEFAULT ((1)),
[RecountVersion] [int] NOT NULL CONSTRAINT [DF_dxInventoryAdjustment_RecountVersion] DEFAULT ((1)),
[DoNotGenerateGLEntry] [bit] NOT NULL CONSTRAINT [DF_dxInventoryAdjustment_DoNotGenerateGLEntry] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryAdjustment.trAuditDelete] ON [dbo].[dxInventoryAdjustment]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxInventoryAdjustment'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxInventoryAdjustment CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryAdjustment, ID, Description, TransactionDate, Posted, FK_dxInventoryAdjustmentType, RecountVersion, DoNotGenerateGLEntry from deleted
 Declare @PK_dxInventoryAdjustment int, @ID int, @Description varchar(255), @TransactionDate DateTime, @Posted Bit, @FK_dxInventoryAdjustmentType int, @RecountVersion int, @DoNotGenerateGLEntry Bit

 OPEN pk_cursordxInventoryAdjustment
 FETCH NEXT FROM pk_cursordxInventoryAdjustment INTO @PK_dxInventoryAdjustment, @ID, @Description, @TransactionDate, @Posted, @FK_dxInventoryAdjustmentType, @RecountVersion, @DoNotGenerateGLEntry
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxInventoryAdjustment, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInventoryAdjustmentType', @FK_dxInventoryAdjustmentType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'RecountVersion', @RecountVersion
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DoNotGenerateGLEntry', @DoNotGenerateGLEntry
FETCH NEXT FROM pk_cursordxInventoryAdjustment INTO @PK_dxInventoryAdjustment, @ID, @Description, @TransactionDate, @Posted, @FK_dxInventoryAdjustmentType, @RecountVersion, @DoNotGenerateGLEntry
 END

 CLOSE pk_cursordxInventoryAdjustment 
 DEALLOCATE pk_cursordxInventoryAdjustment
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryAdjustment.trAuditInsUpd] ON [dbo].[dxInventoryAdjustment] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxInventoryAdjustment CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryAdjustment from inserted;
 set @tablename = 'dxInventoryAdjustment' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxInventoryAdjustment
 FETCH NEXT FROM pk_cursordxInventoryAdjustment INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxInventoryAdjustment where PK_dxInventoryAdjustment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxInventoryAdjustment where PK_dxInventoryAdjustment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxInventoryAdjustment where PK_dxInventoryAdjustment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxInventoryAdjustmentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInventoryAdjustmentType', FK_dxInventoryAdjustmentType from dxInventoryAdjustment where PK_dxInventoryAdjustment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RecountVersion )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'RecountVersion', RecountVersion from dxInventoryAdjustment where PK_dxInventoryAdjustment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DoNotGenerateGLEntry )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DoNotGenerateGLEntry', DoNotGenerateGLEntry from dxInventoryAdjustment where PK_dxInventoryAdjustment = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxInventoryAdjustment INTO @keyvalue
 END

 CLOSE pk_cursordxInventoryAdjustment 
 DEALLOCATE pk_cursordxInventoryAdjustment
GO
ALTER TABLE [dbo].[dxInventoryAdjustment] ADD CONSTRAINT [PK_dxInventoryAdjustment] PRIMARY KEY CLUSTERED  ([PK_dxInventoryAdjustment]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryAdjustment_FK_dxInventoryAdjustmentType] ON [dbo].[dxInventoryAdjustment] ([FK_dxInventoryAdjustmentType]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxInventoryAdjustment] ADD CONSTRAINT [dxConstraint_FK_dxInventoryAdjustmentType_dxInventoryAdjustment] FOREIGN KEY ([FK_dxInventoryAdjustmentType]) REFERENCES [dbo].[dxInventoryAdjustmentType] ([PK_dxInventoryAdjustmentType])
GO
