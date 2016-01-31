CREATE TABLE [dbo].[dxDomainValue]
(
[PK_dxDomainValue] [int] NOT NULL IDENTITY(1, 1),
[FK_dxDomain] [int] NOT NULL,
[DomainValue] [varchar] (8000) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDomainValue.trAuditDelete] ON [dbo].[dxDomainValue]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxDomainValue'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxDomainValue CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDomainValue, FK_dxDomain, DomainValue from deleted
 Declare @PK_dxDomainValue int, @FK_dxDomain int, @DomainValue varchar(8000)

 OPEN pk_cursordxDomainValue
 FETCH NEXT FROM pk_cursordxDomainValue INTO @PK_dxDomainValue, @FK_dxDomain, @DomainValue
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxDomainValue, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDomain', @FK_dxDomain
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DomainValue', @DomainValue
FETCH NEXT FROM pk_cursordxDomainValue INTO @PK_dxDomainValue, @FK_dxDomain, @DomainValue
 END

 CLOSE pk_cursordxDomainValue 
 DEALLOCATE pk_cursordxDomainValue
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDomainValue.trAuditInsUpd] ON [dbo].[dxDomainValue] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxDomainValue CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDomainValue from inserted;
 set @tablename = 'dxDomainValue' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxDomainValue
 FETCH NEXT FROM pk_cursordxDomainValue INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDomain )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDomain', FK_dxDomain from dxDomainValue where PK_dxDomainValue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DomainValue )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DomainValue', DomainValue from dxDomainValue where PK_dxDomainValue = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxDomainValue INTO @keyvalue
 END

 CLOSE pk_cursordxDomainValue 
 DEALLOCATE pk_cursordxDomainValue
GO
ALTER TABLE [dbo].[dxDomainValue] ADD CONSTRAINT [PK_dxDomainValue] PRIMARY KEY CLUSTERED  ([PK_dxDomainValue]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDomainValue_FK_dxDomain] ON [dbo].[dxDomainValue] ([FK_dxDomain]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDomainValue] ADD CONSTRAINT [dxConstraint_FK_dxDomain_dxDomainValue] FOREIGN KEY ([FK_dxDomain]) REFERENCES [dbo].[dxDomain] ([PK_dxDomain])
GO
