CREATE TABLE [dbo].[dxInventoryTransfer]
(
[PK_dxInventoryTransfer] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxInventoryTransfer]),
[TransactionDate] [datetime] NOT NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxInventoryMovement_Posted] DEFAULT ((0)),
[FK_dxEmployee__RequestBy] [int] NULL,
[RequiredDate] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryTransfer.trAuditDelete] ON [dbo].[dxInventoryTransfer]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxInventoryTransfer'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxInventoryTransfer CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryTransfer, ID, TransactionDate, Note, Posted, FK_dxEmployee__RequestBy, RequiredDate from deleted
 Declare @PK_dxInventoryTransfer int, @ID int, @TransactionDate DateTime, @Note varchar(2000), @Posted Bit, @FK_dxEmployee__RequestBy int, @RequiredDate DateTime

 OPEN pk_cursordxInventoryTransfer
 FETCH NEXT FROM pk_cursordxInventoryTransfer INTO @PK_dxInventoryTransfer, @ID, @TransactionDate, @Note, @Posted, @FK_dxEmployee__RequestBy, @RequiredDate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxInventoryTransfer, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__RequestBy', @FK_dxEmployee__RequestBy
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'RequiredDate', @RequiredDate
FETCH NEXT FROM pk_cursordxInventoryTransfer INTO @PK_dxInventoryTransfer, @ID, @TransactionDate, @Note, @Posted, @FK_dxEmployee__RequestBy, @RequiredDate
 END

 CLOSE pk_cursordxInventoryTransfer 
 DEALLOCATE pk_cursordxInventoryTransfer
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryTransfer.trAuditInsUpd] ON [dbo].[dxInventoryTransfer] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxInventoryTransfer CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryTransfer from inserted;
 set @tablename = 'dxInventoryTransfer' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxInventoryTransfer
 FETCH NEXT FROM pk_cursordxInventoryTransfer INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxInventoryTransfer where PK_dxInventoryTransfer = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxInventoryTransfer where PK_dxInventoryTransfer = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxInventoryTransfer where PK_dxInventoryTransfer = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__RequestBy )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__RequestBy', FK_dxEmployee__RequestBy from dxInventoryTransfer where PK_dxInventoryTransfer = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RequiredDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'RequiredDate', RequiredDate from dxInventoryTransfer where PK_dxInventoryTransfer = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxInventoryTransfer INTO @keyvalue
 END

 CLOSE pk_cursordxInventoryTransfer 
 DEALLOCATE pk_cursordxInventoryTransfer
GO
ALTER TABLE [dbo].[dxInventoryTransfer] ADD CONSTRAINT [PK_dxInventoryMovement] PRIMARY KEY CLUSTERED  ([PK_dxInventoryTransfer]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxInventoryTransfer_FK_dxEmployee__RequestBy] ON [dbo].[dxInventoryTransfer] ([FK_dxEmployee__RequestBy]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxInventoryTransfer] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__RequestBy_dxInventoryTransfer] FOREIGN KEY ([FK_dxEmployee__RequestBy]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
