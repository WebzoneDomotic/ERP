CREATE TABLE [dbo].[dxTerritory]
(
[PK_dxTerritory] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (250) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTerritory.trAuditDelete] ON [dbo].[dxTerritory]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxTerritory'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxTerritory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTerritory, ID, Name from deleted
 Declare @PK_dxTerritory int, @ID varchar(50), @Name varchar(250)

 OPEN pk_cursordxTerritory
 FETCH NEXT FROM pk_cursordxTerritory INTO @PK_dxTerritory, @ID, @Name
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxTerritory, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
FETCH NEXT FROM pk_cursordxTerritory INTO @PK_dxTerritory, @ID, @Name
 END

 CLOSE pk_cursordxTerritory 
 DEALLOCATE pk_cursordxTerritory
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTerritory.trAuditInsUpd] ON [dbo].[dxTerritory] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxTerritory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTerritory from inserted;
 set @tablename = 'dxTerritory' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxTerritory
 FETCH NEXT FROM pk_cursordxTerritory INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxTerritory where PK_dxTerritory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxTerritory where PK_dxTerritory = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxTerritory INTO @keyvalue
 END

 CLOSE pk_cursordxTerritory 
 DEALLOCATE pk_cursordxTerritory
GO
ALTER TABLE [dbo].[dxTerritory] ADD CONSTRAINT [PK_dxTerritory] PRIMARY KEY CLUSTERED  ([PK_dxTerritory]) ON [PRIMARY]
GO
