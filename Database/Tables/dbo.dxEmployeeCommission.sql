CREATE TABLE [dbo].[dxEmployeeCommission]
(
[PK_dxEmployeeCommission] [int] NOT NULL IDENTITY(1, 1),
[FK_dxEmployee] [int] NOT NULL,
[Commission] [float] NOT NULL CONSTRAINT [DF_dxEmployeeCommission_Commission] DEFAULT ((0.0)),
[EffectiveDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxEmployeeCommission.trAuditDelete] ON [dbo].[dxEmployeeCommission]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxEmployeeCommission'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxEmployeeCommission CURSOR LOCAL FAST_FORWARD for SELECT PK_dxEmployeeCommission, FK_dxEmployee, Commission, EffectiveDate from deleted
 Declare @PK_dxEmployeeCommission int, @FK_dxEmployee int, @Commission Float, @EffectiveDate DateTime

 OPEN pk_cursordxEmployeeCommission
 FETCH NEXT FROM pk_cursordxEmployeeCommission INTO @PK_dxEmployeeCommission, @FK_dxEmployee, @Commission, @EffectiveDate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxEmployeeCommission, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', @FK_dxEmployee
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Commission', @Commission
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
FETCH NEXT FROM pk_cursordxEmployeeCommission INTO @PK_dxEmployeeCommission, @FK_dxEmployee, @Commission, @EffectiveDate
 END

 CLOSE pk_cursordxEmployeeCommission 
 DEALLOCATE pk_cursordxEmployeeCommission
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxEmployeeCommission.trAuditInsUpd] ON [dbo].[dxEmployeeCommission] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxEmployeeCommission CURSOR LOCAL FAST_FORWARD for SELECT PK_dxEmployeeCommission from inserted;
 set @tablename = 'dxEmployeeCommission' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxEmployeeCommission
 FETCH NEXT FROM pk_cursordxEmployeeCommission INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', FK_dxEmployee from dxEmployeeCommission where PK_dxEmployeeCommission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Commission )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Commission', Commission from dxEmployeeCommission where PK_dxEmployeeCommission = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxEmployeeCommission where PK_dxEmployeeCommission = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxEmployeeCommission INTO @keyvalue
 END

 CLOSE pk_cursordxEmployeeCommission 
 DEALLOCATE pk_cursordxEmployeeCommission
GO
ALTER TABLE [dbo].[dxEmployeeCommission] ADD CONSTRAINT [PK_dxEmployeeCommission] PRIMARY KEY CLUSTERED  ([PK_dxEmployeeCommission]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxEmployeeCommission_FK_dxEmployee] ON [dbo].[dxEmployeeCommission] ([FK_dxEmployee]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxEmployeeCommission] ADD CONSTRAINT [dxConstraint_FK_dxEmployee_dxEmployeeCommission] FOREIGN KEY ([FK_dxEmployee]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
