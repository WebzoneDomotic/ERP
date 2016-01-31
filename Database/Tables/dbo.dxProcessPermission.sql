CREATE TABLE [dbo].[dxProcessPermission]
(
[PK_dxProcessPermission] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProcess] [int] NOT NULL,
[FK_dxUserGroup] [int] NOT NULL,
[ViewProcess] [bit] NOT NULL CONSTRAINT [DF_dxProcessPermission_ViewProcess] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessPermission.trAuditDelete] ON [dbo].[dxProcessPermission]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProcessPermission'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProcessPermission CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessPermission, FK_dxProcess, FK_dxUserGroup, ViewProcess from deleted
 Declare @PK_dxProcessPermission int, @FK_dxProcess int, @FK_dxUserGroup int, @ViewProcess Bit

 OPEN pk_cursordxProcessPermission
 FETCH NEXT FROM pk_cursordxProcessPermission INTO @PK_dxProcessPermission, @FK_dxProcess, @FK_dxUserGroup, @ViewProcess
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProcessPermission, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess', @FK_dxProcess
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUserGroup', @FK_dxUserGroup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ViewProcess', @ViewProcess
FETCH NEXT FROM pk_cursordxProcessPermission INTO @PK_dxProcessPermission, @FK_dxProcess, @FK_dxUserGroup, @ViewProcess
 END

 CLOSE pk_cursordxProcessPermission 
 DEALLOCATE pk_cursordxProcessPermission
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessPermission.trAuditInsUpd] ON [dbo].[dxProcessPermission] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProcessPermission CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessPermission from inserted;
 set @tablename = 'dxProcessPermission' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProcessPermission
 FETCH NEXT FROM pk_cursordxProcessPermission INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcess )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess', FK_dxProcess from dxProcessPermission where PK_dxProcessPermission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxUserGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUserGroup', FK_dxUserGroup from dxProcessPermission where PK_dxProcessPermission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ViewProcess )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ViewProcess', ViewProcess from dxProcessPermission where PK_dxProcessPermission = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProcessPermission INTO @keyvalue
 END

 CLOSE pk_cursordxProcessPermission 
 DEALLOCATE pk_cursordxProcessPermission
GO
ALTER TABLE [dbo].[dxProcessPermission] ADD CONSTRAINT [PK_dxProcessPermission] PRIMARY KEY CLUSTERED  ([PK_dxProcessPermission]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessPermission_FK_dxProcess] ON [dbo].[dxProcessPermission] ([FK_dxProcess]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessPermission_FK_dxUserGroup] ON [dbo].[dxProcessPermission] ([FK_dxUserGroup]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProcessPermission] ADD CONSTRAINT [dxConstraint_FK_dxProcess_dxProcessPermission] FOREIGN KEY ([FK_dxProcess]) REFERENCES [dbo].[dxProcess] ([PK_dxProcess])
GO
ALTER TABLE [dbo].[dxProcessPermission] ADD CONSTRAINT [dxConstraint_FK_dxProcess_dxProcessPermission_CascadeDelete] FOREIGN KEY ([FK_dxProcess]) REFERENCES [dbo].[dxProcess] ([PK_dxProcess]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dxProcessPermission] ADD CONSTRAINT [dxConstraint_FK_dxUserGroup_dxProcessPermission] FOREIGN KEY ([FK_dxUserGroup]) REFERENCES [dbo].[dxUserGroup] ([PK_dxUserGroup])
GO
