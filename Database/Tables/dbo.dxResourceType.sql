CREATE TABLE [dbo].[dxResourceType]
(
[PK_dxResourceType] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (500) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxResourceType.trAuditDelete] ON [dbo].[dxResourceType]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxResourceType'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxResourceType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxResourceType, ID, Name from deleted
 Declare @PK_dxResourceType int, @ID varchar(50), @Name varchar(500)

 OPEN pk_cursordxResourceType
 FETCH NEXT FROM pk_cursordxResourceType INTO @PK_dxResourceType, @ID, @Name
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxResourceType, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
FETCH NEXT FROM pk_cursordxResourceType INTO @PK_dxResourceType, @ID, @Name
 END

 CLOSE pk_cursordxResourceType 
 DEALLOCATE pk_cursordxResourceType
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxResourceType.trAuditInsUpd] ON [dbo].[dxResourceType] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxResourceType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxResourceType from inserted;
 set @tablename = 'dxResourceType' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxResourceType
 FETCH NEXT FROM pk_cursordxResourceType INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxResourceType where PK_dxResourceType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxResourceType where PK_dxResourceType = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxResourceType INTO @keyvalue
 END

 CLOSE pk_cursordxResourceType 
 DEALLOCATE pk_cursordxResourceType
GO
ALTER TABLE [dbo].[dxResourceType] ADD CONSTRAINT [PK_dxResourceType] PRIMARY KEY CLUSTERED  ([PK_dxResourceType]) ON [PRIMARY]
GO
