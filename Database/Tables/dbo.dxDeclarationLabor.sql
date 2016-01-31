CREATE TABLE [dbo].[dxDeclarationLabor]
(
[PK_dxDeclarationLabor] [int] NOT NULL IDENTITY(1, 1),
[FK_dxDeclaration] [int] NULL,
[FK_dxResource] [int] NULL,
[OperationTime] [datetime] NOT NULL CONSTRAINT [DF_dxDeclarationLabour_OperationTime] DEFAULT ((0.0)),
[Note] [varchar] (8000) COLLATE French_CI_AS NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxDeclarationLabour_Posted] DEFAULT ((0)),
[FK_dxPurchaseOrder] [int] NULL,
[FK_dxPayableInvoice] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeclarationLabor.trAuditDelete] ON [dbo].[dxDeclarationLabor]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxDeclarationLabor'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxDeclarationLabor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDeclarationLabor, FK_dxDeclaration, FK_dxResource, OperationTime, Note, Posted, FK_dxPurchaseOrder, FK_dxPayableInvoice from deleted
 Declare @PK_dxDeclarationLabor int, @FK_dxDeclaration int, @FK_dxResource int, @OperationTime DateTime, @Note varchar(8000), @Posted Bit, @FK_dxPurchaseOrder int, @FK_dxPayableInvoice int

 OPEN pk_cursordxDeclarationLabor
 FETCH NEXT FROM pk_cursordxDeclarationLabor INTO @PK_dxDeclarationLabor, @FK_dxDeclaration, @FK_dxResource, @OperationTime, @Note, @Posted, @FK_dxPurchaseOrder, @FK_dxPayableInvoice
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxDeclarationLabor, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeclaration', @FK_dxDeclaration
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxResource', @FK_dxResource
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'OperationTime', @OperationTime
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder', @FK_dxPurchaseOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoice', @FK_dxPayableInvoice
FETCH NEXT FROM pk_cursordxDeclarationLabor INTO @PK_dxDeclarationLabor, @FK_dxDeclaration, @FK_dxResource, @OperationTime, @Note, @Posted, @FK_dxPurchaseOrder, @FK_dxPayableInvoice
 END

 CLOSE pk_cursordxDeclarationLabor 
 DEALLOCATE pk_cursordxDeclarationLabor
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeclarationLabor.trAuditInsUpd] ON [dbo].[dxDeclarationLabor] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxDeclarationLabor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDeclarationLabor from inserted;
 set @tablename = 'dxDeclarationLabor' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxDeclarationLabor
 FETCH NEXT FROM pk_cursordxDeclarationLabor INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDeclaration )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeclaration', FK_dxDeclaration from dxDeclarationLabor where PK_dxDeclarationLabor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxResource )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxResource', FK_dxResource from dxDeclarationLabor where PK_dxDeclarationLabor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OperationTime )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'OperationTime', OperationTime from dxDeclarationLabor where PK_dxDeclarationLabor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxDeclarationLabor where PK_dxDeclarationLabor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxDeclarationLabor where PK_dxDeclarationLabor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPurchaseOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPurchaseOrder', FK_dxPurchaseOrder from dxDeclarationLabor where PK_dxDeclarationLabor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayableInvoice )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoice', FK_dxPayableInvoice from dxDeclarationLabor where PK_dxDeclarationLabor = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxDeclarationLabor INTO @keyvalue
 END

 CLOSE pk_cursordxDeclarationLabor 
 DEALLOCATE pk_cursordxDeclarationLabor
GO
ALTER TABLE [dbo].[dxDeclarationLabor] ADD CONSTRAINT [PK_dxDeclarationLabour] PRIMARY KEY CLUSTERED  ([PK_dxDeclarationLabor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationLabor_FK_dxDeclaration] ON [dbo].[dxDeclarationLabor] ([FK_dxDeclaration]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationLabor_FK_dxPayableInvoice] ON [dbo].[dxDeclarationLabor] ([FK_dxPayableInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationLabor_FK_dxPurchaseOrder] ON [dbo].[dxDeclarationLabor] ([FK_dxPurchaseOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationLabor_FK_dxResource] ON [dbo].[dxDeclarationLabor] ([FK_dxResource]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDeclarationLabor] ADD CONSTRAINT [dxConstraint_FK_dxDeclaration_dxDeclarationLabor] FOREIGN KEY ([FK_dxDeclaration]) REFERENCES [dbo].[dxDeclaration] ([PK_dxDeclaration])
GO
ALTER TABLE [dbo].[dxDeclarationLabor] ADD CONSTRAINT [dxConstraint_FK_dxPayableInvoice_dxDeclarationLabor] FOREIGN KEY ([FK_dxPayableInvoice]) REFERENCES [dbo].[dxPayableInvoice] ([PK_dxPayableInvoice])
GO
ALTER TABLE [dbo].[dxDeclarationLabor] ADD CONSTRAINT [dxConstraint_FK_dxPurchaseOrder_dxDeclarationLabor] FOREIGN KEY ([FK_dxPurchaseOrder]) REFERENCES [dbo].[dxPurchaseOrder] ([PK_dxPurchaseOrder])
GO
ALTER TABLE [dbo].[dxDeclarationLabor] ADD CONSTRAINT [dxConstraint_FK_dxResource_dxDeclarationLabor] FOREIGN KEY ([FK_dxResource]) REFERENCES [dbo].[dxResource] ([PK_dxResource])
GO
