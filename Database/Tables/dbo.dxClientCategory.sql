CREATE TABLE [dbo].[dxClientCategory]
(
[PK_dxClientCategory] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientCategory.trAuditDelete] ON [dbo].[dxClientCategory]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientCategory'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientCategory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientCategory, ID, Description from deleted
 Declare @PK_dxClientCategory int, @ID varchar(50), @Description varchar(255)

 OPEN pk_cursordxClientCategory
 FETCH NEXT FROM pk_cursordxClientCategory INTO @PK_dxClientCategory, @ID, @Description
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientCategory, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
FETCH NEXT FROM pk_cursordxClientCategory INTO @PK_dxClientCategory, @ID, @Description
 END

 CLOSE pk_cursordxClientCategory 
 DEALLOCATE pk_cursordxClientCategory
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientCategory.trAuditInsUpd] ON [dbo].[dxClientCategory] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientCategory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientCategory from inserted;
 set @tablename = 'dxClientCategory' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientCategory
 FETCH NEXT FROM pk_cursordxClientCategory INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxClientCategory where PK_dxClientCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxClientCategory where PK_dxClientCategory = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientCategory INTO @keyvalue
 END

 CLOSE pk_cursordxClientCategory 
 DEALLOCATE pk_cursordxClientCategory
GO
ALTER TABLE [dbo].[dxClientCategory] ADD CONSTRAINT [PK_dxClientCategory] PRIMARY KEY CLUSTERED  ([PK_dxClientCategory]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxClientCategory] ON [dbo].[dxClientCategory] ([ID]) ON [PRIMARY]
GO
