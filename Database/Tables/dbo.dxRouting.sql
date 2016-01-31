CREATE TABLE [dbo].[dxRouting]
(
[PK_dxRouting] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE French_CI_AS NOT NULL,
[Instructions] [varchar] (8000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRouting.trAuditDelete] ON [dbo].[dxRouting]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxRouting'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxRouting CURSOR LOCAL FAST_FORWARD for SELECT PK_dxRouting, ID, Name, Instructions from deleted
 Declare @PK_dxRouting int, @ID varchar(50), @Name varchar(100), @Instructions varchar(8000)

 OPEN pk_cursordxRouting
 FETCH NEXT FROM pk_cursordxRouting INTO @PK_dxRouting, @ID, @Name, @Instructions
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxRouting, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', @Instructions
FETCH NEXT FROM pk_cursordxRouting INTO @PK_dxRouting, @ID, @Name, @Instructions
 END

 CLOSE pk_cursordxRouting 
 DEALLOCATE pk_cursordxRouting
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRouting.trAuditInsUpd] ON [dbo].[dxRouting] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxRouting CURSOR LOCAL FAST_FORWARD for SELECT PK_dxRouting from inserted;
 set @tablename = 'dxRouting' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxRouting
 FETCH NEXT FROM pk_cursordxRouting INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxRouting where PK_dxRouting = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxRouting where PK_dxRouting = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Instructions )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', Instructions from dxRouting where PK_dxRouting = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxRouting INTO @keyvalue
 END

 CLOSE pk_cursordxRouting 
 DEALLOCATE pk_cursordxRouting
GO
ALTER TABLE [dbo].[dxRouting] ADD CONSTRAINT [PK_dxRouting] PRIMARY KEY CLUSTERED  ([PK_dxRouting]) ON [PRIMARY]
GO
