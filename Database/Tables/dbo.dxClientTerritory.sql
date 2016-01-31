CREATE TABLE [dbo].[dxClientTerritory]
(
[PK_dxClientTerritory] [int] NOT NULL IDENTITY(1, 1),
[FK_dxClient] [int] NOT NULL,
[FK_dxTerritory] [int] NOT NULL,
[FK_dxEmployee] [int] NOT NULL,
[EffectiveDate] [datetime] NOT NULL,
[Commission] [float] NOT NULL CONSTRAINT [DF_dxClientTerritory_Commission] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientTerritory.trAuditDelete] ON [dbo].[dxClientTerritory]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientTerritory'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientTerritory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientTerritory, FK_dxClient, FK_dxTerritory, FK_dxEmployee, EffectiveDate, Commission from deleted
 Declare @PK_dxClientTerritory int, @FK_dxClient int, @FK_dxTerritory int, @FK_dxEmployee int, @EffectiveDate DateTime, @Commission Float

 OPEN pk_cursordxClientTerritory
 FETCH NEXT FROM pk_cursordxClientTerritory INTO @PK_dxClientTerritory, @FK_dxClient, @FK_dxTerritory, @FK_dxEmployee, @EffectiveDate, @Commission
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientTerritory, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerritory', @FK_dxTerritory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', @FK_dxEmployee
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Commission', @Commission
FETCH NEXT FROM pk_cursordxClientTerritory INTO @PK_dxClientTerritory, @FK_dxClient, @FK_dxTerritory, @FK_dxEmployee, @EffectiveDate, @Commission
 END

 CLOSE pk_cursordxClientTerritory 
 DEALLOCATE pk_cursordxClientTerritory
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientTerritory.trAuditInsUpd] ON [dbo].[dxClientTerritory] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientTerritory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientTerritory from inserted;
 set @tablename = 'dxClientTerritory' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientTerritory
 FETCH NEXT FROM pk_cursordxClientTerritory INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxClientTerritory where PK_dxClientTerritory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTerritory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerritory', FK_dxTerritory from dxClientTerritory where PK_dxClientTerritory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', FK_dxEmployee from dxClientTerritory where PK_dxClientTerritory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxClientTerritory where PK_dxClientTerritory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Commission )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Commission', Commission from dxClientTerritory where PK_dxClientTerritory = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientTerritory INTO @keyvalue
 END

 CLOSE pk_cursordxClientTerritory 
 DEALLOCATE pk_cursordxClientTerritory
GO
ALTER TABLE [dbo].[dxClientTerritory] ADD CONSTRAINT [PK_dxClientTerritory] PRIMARY KEY CLUSTERED  ([PK_dxClientTerritory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientTerritory_FK_dxClient] ON [dbo].[dxClientTerritory] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientTerritory_FK_dxEmployee] ON [dbo].[dxClientTerritory] ([FK_dxEmployee]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientTerritory_FK_dxTerritory] ON [dbo].[dxClientTerritory] ([FK_dxTerritory]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxClientTerritory] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxClientTerritory] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxClientTerritory] ADD CONSTRAINT [dxConstraint_FK_dxEmployee_dxClientTerritory] FOREIGN KEY ([FK_dxEmployee]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxClientTerritory] ADD CONSTRAINT [dxConstraint_FK_dxTerritory_dxClientTerritory] FOREIGN KEY ([FK_dxTerritory]) REFERENCES [dbo].[dxTerritory] ([PK_dxTerritory])
GO
