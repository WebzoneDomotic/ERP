CREATE TABLE [dbo].[dxResource]
(
[PK_dxResource] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE French_CI_AS NULL,
[FK_dxResourceType] [int] NOT NULL CONSTRAINT [DF_dxResource_FK_dxResourceType] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxResource.trAuditDelete] ON [dbo].[dxResource]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxResource'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxResource CURSOR LOCAL FAST_FORWARD for SELECT PK_dxResource, ID, Name, FK_dxResourceType from deleted
 Declare @PK_dxResource int, @ID varchar(50), @Name varchar(100), @FK_dxResourceType int

 OPEN pk_cursordxResource
 FETCH NEXT FROM pk_cursordxResource INTO @PK_dxResource, @ID, @Name, @FK_dxResourceType
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxResource, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxResourceType', @FK_dxResourceType
FETCH NEXT FROM pk_cursordxResource INTO @PK_dxResource, @ID, @Name, @FK_dxResourceType
 END

 CLOSE pk_cursordxResource 
 DEALLOCATE pk_cursordxResource
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxResource.trAuditInsUpd] ON [dbo].[dxResource] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxResource CURSOR LOCAL FAST_FORWARD for SELECT PK_dxResource from inserted;
 set @tablename = 'dxResource' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxResource
 FETCH NEXT FROM pk_cursordxResource INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxResource where PK_dxResource = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxResource where PK_dxResource = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxResourceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxResourceType', FK_dxResourceType from dxResource where PK_dxResource = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxResource INTO @keyvalue
 END

 CLOSE pk_cursordxResource 
 DEALLOCATE pk_cursordxResource
GO
ALTER TABLE [dbo].[dxResource] ADD CONSTRAINT [PK_dxResource] PRIMARY KEY CLUSTERED  ([PK_dxResource]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxResource_FK_dxResourceType] ON [dbo].[dxResource] ([FK_dxResourceType]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxResource] ADD CONSTRAINT [dxConstraint_FK_dxResourceType_dxResource] FOREIGN KEY ([FK_dxResourceType]) REFERENCES [dbo].[dxResourceType] ([PK_dxResourceType])
GO
