CREATE TABLE [dbo].[dxEntryRecurrenceType]
(
[PK_dxEntryRecurrenceType] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (120) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxEntryRecurrenceType.trAuditDelete] ON [dbo].[dxEntryRecurrenceType]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxEntryRecurrenceType'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxEntryRecurrenceType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxEntryRecurrenceType, Name from deleted
 Declare @PK_dxEntryRecurrenceType int, @Name varchar(120)

 OPEN pk_cursordxEntryRecurrenceType
 FETCH NEXT FROM pk_cursordxEntryRecurrenceType INTO @PK_dxEntryRecurrenceType, @Name
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxEntryRecurrenceType, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
FETCH NEXT FROM pk_cursordxEntryRecurrenceType INTO @PK_dxEntryRecurrenceType, @Name
 END

 CLOSE pk_cursordxEntryRecurrenceType 
 DEALLOCATE pk_cursordxEntryRecurrenceType
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxEntryRecurrenceType.trAuditInsUpd] ON [dbo].[dxEntryRecurrenceType] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxEntryRecurrenceType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxEntryRecurrenceType from inserted;
 set @tablename = 'dxEntryRecurrenceType' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxEntryRecurrenceType
 FETCH NEXT FROM pk_cursordxEntryRecurrenceType INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxEntryRecurrenceType where PK_dxEntryRecurrenceType = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxEntryRecurrenceType INTO @keyvalue
 END

 CLOSE pk_cursordxEntryRecurrenceType 
 DEALLOCATE pk_cursordxEntryRecurrenceType
GO
ALTER TABLE [dbo].[dxEntryRecurrenceType] ADD CONSTRAINT [PK_dxEntryRecurrenceType] PRIMARY KEY CLUSTERED  ([PK_dxEntryRecurrenceType]) ON [PRIMARY]
GO
