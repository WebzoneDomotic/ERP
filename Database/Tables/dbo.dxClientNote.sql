CREATE TABLE [dbo].[dxClientNote]
(
[PK_dxClientNote] [int] NOT NULL IDENTITY(1, 1),
[FK_dxClient] [int] NOT NULL,
[EffectiveDate] [datetime] NOT NULL,
[Note] [text] COLLATE French_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxClientNote_Active] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientNote.trAuditDelete] ON [dbo].[dxClientNote]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientNote'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientNote CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientNote, FK_dxClient, EffectiveDate, Active from deleted
 Declare @PK_dxClientNote int, @FK_dxClient int, @EffectiveDate DateTime, @Active Bit

 OPEN pk_cursordxClientNote
 FETCH NEXT FROM pk_cursordxClientNote INTO @PK_dxClientNote, @FK_dxClient, @EffectiveDate, @Active
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientNote, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
FETCH NEXT FROM pk_cursordxClientNote INTO @PK_dxClientNote, @FK_dxClient, @EffectiveDate, @Active
 END

 CLOSE pk_cursordxClientNote 
 DEALLOCATE pk_cursordxClientNote
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientNote.trAuditInsUpd] ON [dbo].[dxClientNote] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientNote CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientNote from inserted;
 set @tablename = 'dxClientNote' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientNote
 FETCH NEXT FROM pk_cursordxClientNote INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxClientNote where PK_dxClientNote = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxClientNote where PK_dxClientNote = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxClientNote where PK_dxClientNote = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientNote INTO @keyvalue
 END

 CLOSE pk_cursordxClientNote 
 DEALLOCATE pk_cursordxClientNote
GO
ALTER TABLE [dbo].[dxClientNote] ADD CONSTRAINT [PK_dxClientNote] PRIMARY KEY CLUSTERED  ([PK_dxClientNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientNote_FK_dxClient] ON [dbo].[dxClientNote] ([FK_dxClient]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxClientNote] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxClientNote] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
