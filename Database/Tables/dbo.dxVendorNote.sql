CREATE TABLE [dbo].[dxVendorNote]
(
[PK_dxVendorNote] [int] NOT NULL IDENTITY(1, 1),
[FK_dxVendor] [int] NOT NULL,
[EffectiveDate] [datetime] NOT NULL,
[Note] [text] COLLATE French_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxVendorNote_Active] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxVendorNote.trAuditDelete] ON [dbo].[dxVendorNote]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxVendorNote'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxVendorNote CURSOR LOCAL FAST_FORWARD for SELECT PK_dxVendorNote, FK_dxVendor, EffectiveDate, Active from deleted
 Declare @PK_dxVendorNote int, @FK_dxVendor int, @EffectiveDate DateTime, @Active Bit

 OPEN pk_cursordxVendorNote
 FETCH NEXT FROM pk_cursordxVendorNote INTO @PK_dxVendorNote, @FK_dxVendor, @EffectiveDate, @Active
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxVendorNote, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
FETCH NEXT FROM pk_cursordxVendorNote INTO @PK_dxVendorNote, @FK_dxVendor, @EffectiveDate, @Active
 END

 CLOSE pk_cursordxVendorNote 
 DEALLOCATE pk_cursordxVendorNote
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxVendorNote.trAuditInsUpd] ON [dbo].[dxVendorNote] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxVendorNote CURSOR LOCAL FAST_FORWARD for SELECT PK_dxVendorNote from inserted;
 set @tablename = 'dxVendorNote' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxVendorNote
 FETCH NEXT FROM pk_cursordxVendorNote INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxVendorNote where PK_dxVendorNote = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxVendorNote where PK_dxVendorNote = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxVendorNote where PK_dxVendorNote = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxVendorNote INTO @keyvalue
 END

 CLOSE pk_cursordxVendorNote 
 DEALLOCATE pk_cursordxVendorNote
GO
ALTER TABLE [dbo].[dxVendorNote] ADD CONSTRAINT [PK_dxVendorNote] PRIMARY KEY CLUSTERED  ([PK_dxVendorNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendorNote_FK_dxVendor] ON [dbo].[dxVendorNote] ([FK_dxVendor]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxVendorNote] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxVendorNote] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
