CREATE TABLE [dbo].[dxQueryPermission]
(
[PK_dxQueryPermission] [int] NOT NULL IDENTITY(1, 1),
[FK_dxUserGroup] [int] NOT NULL,
[FK_dxQuery] [int] NOT NULL,
[ViewQuery] [bit] NOT NULL CONSTRAINT [DF_dxQueryPermission_ViewQuery] DEFAULT ((0)),
[PrintQuery] [bit] NOT NULL CONSTRAINT [DF_dxQueryPermission_PrintQuery] DEFAULT ((0)),
[ExportQuery] [bit] NOT NULL CONSTRAINT [DF_dxQueryPermission_ExportQuery] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxQueryPermission.trAuditDelete] ON [dbo].[dxQueryPermission]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxQueryPermission'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxQueryPermission CURSOR LOCAL FAST_FORWARD for SELECT PK_dxQueryPermission, FK_dxUserGroup, FK_dxQuery, ViewQuery, PrintQuery, ExportQuery from deleted
 Declare @PK_dxQueryPermission int, @FK_dxUserGroup int, @FK_dxQuery int, @ViewQuery Bit, @PrintQuery Bit, @ExportQuery Bit

 OPEN pk_cursordxQueryPermission
 FETCH NEXT FROM pk_cursordxQueryPermission INTO @PK_dxQueryPermission, @FK_dxUserGroup, @FK_dxQuery, @ViewQuery, @PrintQuery, @ExportQuery
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxQueryPermission, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUserGroup', @FK_dxUserGroup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxQuery', @FK_dxQuery
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ViewQuery', @ViewQuery
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PrintQuery', @PrintQuery
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ExportQuery', @ExportQuery
FETCH NEXT FROM pk_cursordxQueryPermission INTO @PK_dxQueryPermission, @FK_dxUserGroup, @FK_dxQuery, @ViewQuery, @PrintQuery, @ExportQuery
 END

 CLOSE pk_cursordxQueryPermission 
 DEALLOCATE pk_cursordxQueryPermission
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxQueryPermission.trAuditInsUpd] ON [dbo].[dxQueryPermission] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxQueryPermission CURSOR LOCAL FAST_FORWARD for SELECT PK_dxQueryPermission from inserted;
 set @tablename = 'dxQueryPermission' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxQueryPermission
 FETCH NEXT FROM pk_cursordxQueryPermission INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxUserGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUserGroup', FK_dxUserGroup from dxQueryPermission where PK_dxQueryPermission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxQuery )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxQuery', FK_dxQuery from dxQueryPermission where PK_dxQueryPermission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ViewQuery )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ViewQuery', ViewQuery from dxQueryPermission where PK_dxQueryPermission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PrintQuery )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PrintQuery', PrintQuery from dxQueryPermission where PK_dxQueryPermission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExportQuery )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ExportQuery', ExportQuery from dxQueryPermission where PK_dxQueryPermission = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxQueryPermission INTO @keyvalue
 END

 CLOSE pk_cursordxQueryPermission 
 DEALLOCATE pk_cursordxQueryPermission
GO
ALTER TABLE [dbo].[dxQueryPermission] ADD CONSTRAINT [PK_dxQueryPermission] PRIMARY KEY CLUSTERED  ([PK_dxQueryPermission]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxQueryPermission_FK_dxQuery] ON [dbo].[dxQueryPermission] ([FK_dxQuery]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxQueryPermission_FK_dxUserGroup] ON [dbo].[dxQueryPermission] ([FK_dxUserGroup]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxQueryPermission] ADD CONSTRAINT [dxConstraint_FK_dxQuery_dxQueryPermission] FOREIGN KEY ([FK_dxQuery]) REFERENCES [dbo].[dxQuery] ([PK_dxQuery])
GO
ALTER TABLE [dbo].[dxQueryPermission] ADD CONSTRAINT [dxConstraint_FK_dxQuery_dxQueryPermission_CascadeDelete] FOREIGN KEY ([FK_dxQuery]) REFERENCES [dbo].[dxQuery] ([PK_dxQuery]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dxQueryPermission] ADD CONSTRAINT [dxConstraint_FK_dxUserGroup_dxQueryPermission] FOREIGN KEY ([FK_dxUserGroup]) REFERENCES [dbo].[dxUserGroup] ([PK_dxUserGroup])
GO
