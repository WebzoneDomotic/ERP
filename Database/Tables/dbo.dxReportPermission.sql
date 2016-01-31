CREATE TABLE [dbo].[dxReportPermission]
(
[PK_dxReportPermission] [int] NOT NULL IDENTITY(1, 1),
[FK_dxReport] [int] NOT NULL,
[FK_dxUserGroup] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReportPermission.trAuditDelete] ON [dbo].[dxReportPermission]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxReportPermission'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxReportPermission CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReportPermission, FK_dxReport, FK_dxUserGroup from deleted
 Declare @PK_dxReportPermission int, @FK_dxReport int, @FK_dxUserGroup int

 OPEN pk_cursordxReportPermission
 FETCH NEXT FROM pk_cursordxReportPermission INTO @PK_dxReportPermission, @FK_dxReport, @FK_dxUserGroup
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxReportPermission, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', @FK_dxReport
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUserGroup', @FK_dxUserGroup
FETCH NEXT FROM pk_cursordxReportPermission INTO @PK_dxReportPermission, @FK_dxReport, @FK_dxUserGroup
 END

 CLOSE pk_cursordxReportPermission 
 DEALLOCATE pk_cursordxReportPermission
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReportPermission.trAuditInsUpd] ON [dbo].[dxReportPermission] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxReportPermission CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReportPermission from inserted;
 set @tablename = 'dxReportPermission' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxReportPermission
 FETCH NEXT FROM pk_cursordxReportPermission INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', FK_dxReport from dxReportPermission where PK_dxReportPermission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxUserGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUserGroup', FK_dxUserGroup from dxReportPermission where PK_dxReportPermission = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxReportPermission INTO @keyvalue
 END

 CLOSE pk_cursordxReportPermission 
 DEALLOCATE pk_cursordxReportPermission
GO
ALTER TABLE [dbo].[dxReportPermission] ADD CONSTRAINT [PK_dxReportPermission] PRIMARY KEY CLUSTERED  ([PK_dxReportPermission]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReportPermission_FK_dxReport] ON [dbo].[dxReportPermission] ([FK_dxReport]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReportPermission_FK_dxUserGroup] ON [dbo].[dxReportPermission] ([FK_dxUserGroup]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxReportPermission] ADD CONSTRAINT [dxConstraint_FK_dxReport_dxReportPermission] FOREIGN KEY ([FK_dxReport]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
ALTER TABLE [dbo].[dxReportPermission] ADD CONSTRAINT [dxConstraint_FK_dxUserGroup_dxReportPermission] FOREIGN KEY ([FK_dxUserGroup]) REFERENCES [dbo].[dxUserGroup] ([PK_dxUserGroup])
GO
