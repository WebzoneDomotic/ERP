CREATE TABLE [dbo].[dxPropertyValue]
(
[PK_dxPropertyValue] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProperty] [int] NOT NULL,
[PrimaryKeyValue] [int] NOT NULL,
[Value] [varchar] (8000) COLLATE French_CI_AS NOT NULL,
[LinkedTableName] [varchar] (100) COLLATE French_CI_AS NOT NULL,
[FK_dxDomainValue] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPropertyValue.trAuditDelete] ON [dbo].[dxPropertyValue]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPropertyValue'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPropertyValue CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPropertyValue, FK_dxProperty, PrimaryKeyValue, Value, LinkedTableName, FK_dxDomainValue from deleted
 Declare @PK_dxPropertyValue int, @FK_dxProperty int, @PrimaryKeyValue int, @Value varchar(8000), @LinkedTableName varchar(100), @FK_dxDomainValue int

 OPEN pk_cursordxPropertyValue
 FETCH NEXT FROM pk_cursordxPropertyValue INTO @PK_dxPropertyValue, @FK_dxProperty, @PrimaryKeyValue, @Value, @LinkedTableName, @FK_dxDomainValue
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPropertyValue, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProperty', @FK_dxProperty
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PrimaryKeyValue', @PrimaryKeyValue
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Value', @Value
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LinkedTableName', @LinkedTableName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDomainValue', @FK_dxDomainValue
FETCH NEXT FROM pk_cursordxPropertyValue INTO @PK_dxPropertyValue, @FK_dxProperty, @PrimaryKeyValue, @Value, @LinkedTableName, @FK_dxDomainValue
 END

 CLOSE pk_cursordxPropertyValue 
 DEALLOCATE pk_cursordxPropertyValue
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPropertyValue.trAuditInsUpd] ON [dbo].[dxPropertyValue] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPropertyValue CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPropertyValue from inserted;
 set @tablename = 'dxPropertyValue' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPropertyValue
 FETCH NEXT FROM pk_cursordxPropertyValue INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProperty )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProperty', FK_dxProperty from dxPropertyValue where PK_dxPropertyValue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PrimaryKeyValue )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PrimaryKeyValue', PrimaryKeyValue from dxPropertyValue where PK_dxPropertyValue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Value )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Value', Value from dxPropertyValue where PK_dxPropertyValue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LinkedTableName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LinkedTableName', LinkedTableName from dxPropertyValue where PK_dxPropertyValue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDomainValue )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDomainValue', FK_dxDomainValue from dxPropertyValue where PK_dxPropertyValue = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPropertyValue INTO @keyvalue
 END

 CLOSE pk_cursordxPropertyValue 
 DEALLOCATE pk_cursordxPropertyValue
GO
ALTER TABLE [dbo].[dxPropertyValue] ADD CONSTRAINT [PK_dxPropertyValue] PRIMARY KEY CLUSTERED  ([PK_dxPropertyValue]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPropertyValue_FK_dxDomainValue] ON [dbo].[dxPropertyValue] ([FK_dxDomainValue]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPropertyValue_FK_dxProperty] ON [dbo].[dxPropertyValue] ([FK_dxProperty]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPropertyValue] ADD CONSTRAINT [dxConstraint_FK_dxDomainValue_dxPropertyValue] FOREIGN KEY ([FK_dxDomainValue]) REFERENCES [dbo].[dxDomainValue] ([PK_dxDomainValue])
GO
ALTER TABLE [dbo].[dxPropertyValue] ADD CONSTRAINT [dxConstraint_FK_dxProperty_dxPropertyValue] FOREIGN KEY ([FK_dxProperty]) REFERENCES [dbo].[dxProperty] ([PK_dxProperty])
GO
