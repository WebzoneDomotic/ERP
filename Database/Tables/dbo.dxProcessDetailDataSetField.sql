CREATE TABLE [dbo].[dxProcessDetailDataSetField]
(
[PK_dxProcessDetailDataSetField] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProcessDetail] [int] NOT NULL,
[FK_dxDataSetField] [int] NOT NULL,
[FieldOrder] [int] NULL,
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessDetailDataSetField.trAuditDelete] ON [dbo].[dxProcessDetailDataSetField]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProcessDetailDataSetField'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProcessDetailDataSetField CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessDetailDataSetField, FK_dxProcessDetail, FK_dxDataSetField, FieldOrder from deleted
 Declare @PK_dxProcessDetailDataSetField int, @FK_dxProcessDetail int, @FK_dxDataSetField int, @FieldOrder int

 OPEN pk_cursordxProcessDetailDataSetField
 FETCH NEXT FROM pk_cursordxProcessDetailDataSetField INTO @PK_dxProcessDetailDataSetField, @FK_dxProcessDetail, @FK_dxDataSetField, @FieldOrder
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProcessDetailDataSetField, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetail', @FK_dxProcessDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDataSetField', @FK_dxDataSetField
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FieldOrder', @FieldOrder
FETCH NEXT FROM pk_cursordxProcessDetailDataSetField INTO @PK_dxProcessDetailDataSetField, @FK_dxProcessDetail, @FK_dxDataSetField, @FieldOrder
 END

 CLOSE pk_cursordxProcessDetailDataSetField 
 DEALLOCATE pk_cursordxProcessDetailDataSetField
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessDetailDataSetField.trAuditInsUpd] ON [dbo].[dxProcessDetailDataSetField] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProcessDetailDataSetField CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessDetailDataSetField from inserted;
 set @tablename = 'dxProcessDetailDataSetField' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProcessDetailDataSetField
 FETCH NEXT FROM pk_cursordxProcessDetailDataSetField INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcessDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetail', FK_dxProcessDetail from dxProcessDetailDataSetField where PK_dxProcessDetailDataSetField = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDataSetField )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDataSetField', FK_dxDataSetField from dxProcessDetailDataSetField where PK_dxProcessDetailDataSetField = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FieldOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FieldOrder', FieldOrder from dxProcessDetailDataSetField where PK_dxProcessDetailDataSetField = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProcessDetailDataSetField INTO @keyvalue
 END

 CLOSE pk_cursordxProcessDetailDataSetField 
 DEALLOCATE pk_cursordxProcessDetailDataSetField
GO
ALTER TABLE [dbo].[dxProcessDetailDataSetField] ADD CONSTRAINT [PK_dxProcessDetailDataSetField] PRIMARY KEY CLUSTERED  ([PK_dxProcessDetailDataSetField]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetailDataSetField_FK_dxDataSetField] ON [dbo].[dxProcessDetailDataSetField] ([FK_dxDataSetField]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetailDataSetField_FK_dxProcessDetail] ON [dbo].[dxProcessDetailDataSetField] ([FK_dxProcessDetail]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProcessDetailDataSetField] ADD CONSTRAINT [dxConstraint_FK_dxDataSetField_dxProcessDetailDataSetField] FOREIGN KEY ([FK_dxDataSetField]) REFERENCES [dbo].[dxDataSetField] ([PK_dxDataSetField])
GO
ALTER TABLE [dbo].[dxProcessDetailDataSetField] ADD CONSTRAINT [dxConstraint_FK_dxProcessDetail_dxProcessDetailDataSetField] FOREIGN KEY ([FK_dxProcessDetail]) REFERENCES [dbo].[dxProcessDetail] ([PK_dxProcessDetail])
GO
