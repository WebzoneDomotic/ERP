CREATE TABLE [dbo].[dxDomain]
(
[PK_dxDomain] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (2000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDomain.trAuditDelete] ON [dbo].[dxDomain]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxDomain'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxDomain CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDomain, Name, Description from deleted
 Declare @PK_dxDomain int, @Name varchar(250), @Description varchar(2000)

 OPEN pk_cursordxDomain
 FETCH NEXT FROM pk_cursordxDomain INTO @PK_dxDomain, @Name, @Description
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxDomain, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
FETCH NEXT FROM pk_cursordxDomain INTO @PK_dxDomain, @Name, @Description
 END

 CLOSE pk_cursordxDomain 
 DEALLOCATE pk_cursordxDomain
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDomain.trAuditInsUpd] ON [dbo].[dxDomain] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxDomain CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDomain from inserted;
 set @tablename = 'dxDomain' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxDomain
 FETCH NEXT FROM pk_cursordxDomain INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxDomain where PK_dxDomain = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxDomain where PK_dxDomain = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxDomain INTO @keyvalue
 END

 CLOSE pk_cursordxDomain 
 DEALLOCATE pk_cursordxDomain
GO
ALTER TABLE [dbo].[dxDomain] ADD CONSTRAINT [PK_dxDomain] PRIMARY KEY CLUSTERED  ([PK_dxDomain]) ON [PRIMARY]
GO
