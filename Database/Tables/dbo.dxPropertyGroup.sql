CREATE TABLE [dbo].[dxPropertyGroup]
(
[PK_dxPropertyGroup] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[LinkedTableName] [varchar] (100) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPropertyGroup.trAuditDelete] ON [dbo].[dxPropertyGroup]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPropertyGroup'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPropertyGroup CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPropertyGroup, Name, Description, LinkedTableName from deleted
 Declare @PK_dxPropertyGroup int, @Name varchar(250), @Description varchar(2000), @LinkedTableName varchar(100)

 OPEN pk_cursordxPropertyGroup
 FETCH NEXT FROM pk_cursordxPropertyGroup INTO @PK_dxPropertyGroup, @Name, @Description, @LinkedTableName
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPropertyGroup, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LinkedTableName', @LinkedTableName
FETCH NEXT FROM pk_cursordxPropertyGroup INTO @PK_dxPropertyGroup, @Name, @Description, @LinkedTableName
 END

 CLOSE pk_cursordxPropertyGroup 
 DEALLOCATE pk_cursordxPropertyGroup
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPropertyGroup.trAuditInsUpd] ON [dbo].[dxPropertyGroup] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPropertyGroup CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPropertyGroup from inserted;
 set @tablename = 'dxPropertyGroup' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPropertyGroup
 FETCH NEXT FROM pk_cursordxPropertyGroup INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxPropertyGroup where PK_dxPropertyGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPropertyGroup where PK_dxPropertyGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LinkedTableName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LinkedTableName', LinkedTableName from dxPropertyGroup where PK_dxPropertyGroup = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPropertyGroup INTO @keyvalue
 END

 CLOSE pk_cursordxPropertyGroup 
 DEALLOCATE pk_cursordxPropertyGroup
GO
ALTER TABLE [dbo].[dxPropertyGroup] ADD CONSTRAINT [PK_dxPropertyGroup] PRIMARY KEY CLUSTERED  ([PK_dxPropertyGroup]) ON [PRIMARY]
GO
