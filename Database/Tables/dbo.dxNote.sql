CREATE TABLE [dbo].[dxNote]
(
[PK_dxNote] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxNote.trAuditDelete] ON [dbo].[dxNote]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxNote'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxNote CURSOR LOCAL FAST_FORWARD for SELECT PK_dxNote, ID, Note from deleted
 Declare @PK_dxNote int, @ID varchar(50), @Note varchar(2000)

 OPEN pk_cursordxNote
 FETCH NEXT FROM pk_cursordxNote INTO @PK_dxNote, @ID, @Note
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxNote, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
FETCH NEXT FROM pk_cursordxNote INTO @PK_dxNote, @ID, @Note
 END

 CLOSE pk_cursordxNote 
 DEALLOCATE pk_cursordxNote
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxNote.trAuditInsUpd] ON [dbo].[dxNote] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxNote CURSOR LOCAL FAST_FORWARD for SELECT PK_dxNote from inserted;
 set @tablename = 'dxNote' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxNote
 FETCH NEXT FROM pk_cursordxNote INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxNote where PK_dxNote = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxNote where PK_dxNote = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxNote INTO @keyvalue
 END

 CLOSE pk_cursordxNote 
 DEALLOCATE pk_cursordxNote
GO
ALTER TABLE [dbo].[dxNote] ADD CONSTRAINT [PK_dxNote] PRIMARY KEY CLUSTERED  ([PK_dxNote]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxNote] ON [dbo].[dxNote] ([ID]) ON [PRIMARY]
GO
