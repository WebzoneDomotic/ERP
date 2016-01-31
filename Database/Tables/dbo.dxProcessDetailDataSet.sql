CREATE TABLE [dbo].[dxProcessDetailDataSet]
(
[PK_dxProcessDetailDataSet] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProcessDetail] [int] NOT NULL,
[FK_dxDataSet] [int] NOT NULL,
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessDetailDataSet.trAuditDelete] ON [dbo].[dxProcessDetailDataSet]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProcessDetailDataSet'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProcessDetailDataSet CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessDetailDataSet, FK_dxProcessDetail, FK_dxDataSet from deleted
 Declare @PK_dxProcessDetailDataSet int, @FK_dxProcessDetail int, @FK_dxDataSet int

 OPEN pk_cursordxProcessDetailDataSet
 FETCH NEXT FROM pk_cursordxProcessDetailDataSet INTO @PK_dxProcessDetailDataSet, @FK_dxProcessDetail, @FK_dxDataSet
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProcessDetailDataSet, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetail', @FK_dxProcessDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDataSet', @FK_dxDataSet
FETCH NEXT FROM pk_cursordxProcessDetailDataSet INTO @PK_dxProcessDetailDataSet, @FK_dxProcessDetail, @FK_dxDataSet
 END

 CLOSE pk_cursordxProcessDetailDataSet 
 DEALLOCATE pk_cursordxProcessDetailDataSet
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessDetailDataSet.trAuditInsUpd] ON [dbo].[dxProcessDetailDataSet] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProcessDetailDataSet CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessDetailDataSet from inserted;
 set @tablename = 'dxProcessDetailDataSet' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProcessDetailDataSet
 FETCH NEXT FROM pk_cursordxProcessDetailDataSet INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcessDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetail', FK_dxProcessDetail from dxProcessDetailDataSet where PK_dxProcessDetailDataSet = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDataSet )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDataSet', FK_dxDataSet from dxProcessDetailDataSet where PK_dxProcessDetailDataSet = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProcessDetailDataSet INTO @keyvalue
 END

 CLOSE pk_cursordxProcessDetailDataSet 
 DEALLOCATE pk_cursordxProcessDetailDataSet
GO
ALTER TABLE [dbo].[dxProcessDetailDataSet] ADD CONSTRAINT [PK_dxProcessDetailDataSet] PRIMARY KEY CLUSTERED  ([PK_dxProcessDetailDataSet]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetailDataSet_FK_dxDataSet] ON [dbo].[dxProcessDetailDataSet] ([FK_dxDataSet]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetailDataSet_FK_dxProcessDetail] ON [dbo].[dxProcessDetailDataSet] ([FK_dxProcessDetail]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProcessDetailDataSet] ADD CONSTRAINT [dxConstraint_FK_dxDataSet_dxProcessDetailDataSet] FOREIGN KEY ([FK_dxDataSet]) REFERENCES [dbo].[dxDataSet] ([PK_dxDataSet])
GO
ALTER TABLE [dbo].[dxProcessDetailDataSet] ADD CONSTRAINT [dxConstraint_FK_dxProcessDetail_dxProcessDetailDataSet] FOREIGN KEY ([FK_dxProcessDetail]) REFERENCES [dbo].[dxProcessDetail] ([PK_dxProcessDetail])
GO
