CREATE TABLE [dbo].[dxReportLocation]
(
[PK_dxReportLocation] [int] NOT NULL IDENTITY(1, 1),
[FK_dxReport] [int] NOT NULL,
[FK_dxTable] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReportLocation.trAuditDelete] ON [dbo].[dxReportLocation]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxReportLocation'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxReportLocation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReportLocation, FK_dxReport, FK_dxTable from deleted
 Declare @PK_dxReportLocation int, @FK_dxReport int, @FK_dxTable int

 OPEN pk_cursordxReportLocation
 FETCH NEXT FROM pk_cursordxReportLocation INTO @PK_dxReportLocation, @FK_dxReport, @FK_dxTable
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxReportLocation, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', @FK_dxReport
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTable', @FK_dxTable
FETCH NEXT FROM pk_cursordxReportLocation INTO @PK_dxReportLocation, @FK_dxReport, @FK_dxTable
 END

 CLOSE pk_cursordxReportLocation 
 DEALLOCATE pk_cursordxReportLocation
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReportLocation.trAuditInsUpd] ON [dbo].[dxReportLocation] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxReportLocation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReportLocation from inserted;
 set @tablename = 'dxReportLocation' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxReportLocation
 FETCH NEXT FROM pk_cursordxReportLocation INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', FK_dxReport from dxReportLocation where PK_dxReportLocation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTable', FK_dxTable from dxReportLocation where PK_dxReportLocation = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxReportLocation INTO @keyvalue
 END

 CLOSE pk_cursordxReportLocation 
 DEALLOCATE pk_cursordxReportLocation
GO
ALTER TABLE [dbo].[dxReportLocation] ADD CONSTRAINT [PK_dxReportLocation] PRIMARY KEY CLUSTERED  ([PK_dxReportLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReportLocation_FK_dxReport] ON [dbo].[dxReportLocation] ([FK_dxReport]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReportLocation_FK_dxTable] ON [dbo].[dxReportLocation] ([FK_dxTable]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxReportLocation] ADD CONSTRAINT [dxConstraint_FK_dxReport_dxReportLocation] FOREIGN KEY ([FK_dxReport]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
ALTER TABLE [dbo].[dxReportLocation] ADD CONSTRAINT [dxConstraint_FK_dxTable_dxReportLocation] FOREIGN KEY ([FK_dxTable]) REFERENCES [dbo].[dxTable] ([PK_dxTable])
GO
