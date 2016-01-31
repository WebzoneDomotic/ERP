CREATE TABLE [dbo].[dxProcessLocation]
(
[PK_dxProcessLocation] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProcess] [int] NOT NULL,
[FK_dxTable] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessLocation.trAuditDelete] ON [dbo].[dxProcessLocation]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProcessLocation'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProcessLocation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessLocation, FK_dxProcess, FK_dxTable from deleted
 Declare @PK_dxProcessLocation int, @FK_dxProcess int, @FK_dxTable int

 OPEN pk_cursordxProcessLocation
 FETCH NEXT FROM pk_cursordxProcessLocation INTO @PK_dxProcessLocation, @FK_dxProcess, @FK_dxTable
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProcessLocation, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess', @FK_dxProcess
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTable', @FK_dxTable
FETCH NEXT FROM pk_cursordxProcessLocation INTO @PK_dxProcessLocation, @FK_dxProcess, @FK_dxTable
 END

 CLOSE pk_cursordxProcessLocation 
 DEALLOCATE pk_cursordxProcessLocation
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessLocation.trAuditInsUpd] ON [dbo].[dxProcessLocation] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProcessLocation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessLocation from inserted;
 set @tablename = 'dxProcessLocation' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProcessLocation
 FETCH NEXT FROM pk_cursordxProcessLocation INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcess )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess', FK_dxProcess from dxProcessLocation where PK_dxProcessLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTable', FK_dxTable from dxProcessLocation where PK_dxProcessLocation = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProcessLocation INTO @keyvalue
 END

 CLOSE pk_cursordxProcessLocation 
 DEALLOCATE pk_cursordxProcessLocation
GO
ALTER TABLE [dbo].[dxProcessLocation] ADD CONSTRAINT [PK_dxProcessLocation] PRIMARY KEY CLUSTERED  ([PK_dxProcessLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessLocation_FK_dxProcess] ON [dbo].[dxProcessLocation] ([FK_dxProcess]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessLocation_FK_dxTable] ON [dbo].[dxProcessLocation] ([FK_dxTable]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProcessLocation] ADD CONSTRAINT [dxConstraint_FK_dxProcess_dxProcessLocation] FOREIGN KEY ([FK_dxProcess]) REFERENCES [dbo].[dxProcess] ([PK_dxProcess])
GO
ALTER TABLE [dbo].[dxProcessLocation] ADD CONSTRAINT [dxConstraint_FK_dxTable_dxProcessLocation] FOREIGN KEY ([FK_dxTable]) REFERENCES [dbo].[dxTable] ([PK_dxTable])
GO
