CREATE TABLE [dbo].[dxEmployeeSalary]
(
[PK_dxEmployeeSalary] [int] NOT NULL IDENTITY(1, 1),
[FK_dxEmployee] [int] NOT NULL,
[HourlyRate] [float] NOT NULL CONSTRAINT [DF_dxEmployeeSalary_HourlyRate] DEFAULT ((0.0)),
[EffectiveDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxEmployeeSalary.trAuditDelete] ON [dbo].[dxEmployeeSalary]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxEmployeeSalary'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxEmployeeSalary CURSOR LOCAL FAST_FORWARD for SELECT PK_dxEmployeeSalary, FK_dxEmployee, HourlyRate, EffectiveDate from deleted
 Declare @PK_dxEmployeeSalary int, @FK_dxEmployee int, @HourlyRate Float, @EffectiveDate DateTime

 OPEN pk_cursordxEmployeeSalary
 FETCH NEXT FROM pk_cursordxEmployeeSalary INTO @PK_dxEmployeeSalary, @FK_dxEmployee, @HourlyRate, @EffectiveDate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxEmployeeSalary, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', @FK_dxEmployee
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'HourlyRate', @HourlyRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
FETCH NEXT FROM pk_cursordxEmployeeSalary INTO @PK_dxEmployeeSalary, @FK_dxEmployee, @HourlyRate, @EffectiveDate
 END

 CLOSE pk_cursordxEmployeeSalary 
 DEALLOCATE pk_cursordxEmployeeSalary
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxEmployeeSalary.trAuditInsUpd] ON [dbo].[dxEmployeeSalary] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxEmployeeSalary CURSOR LOCAL FAST_FORWARD for SELECT PK_dxEmployeeSalary from inserted;
 set @tablename = 'dxEmployeeSalary' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxEmployeeSalary
 FETCH NEXT FROM pk_cursordxEmployeeSalary INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', FK_dxEmployee from dxEmployeeSalary where PK_dxEmployeeSalary = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HourlyRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'HourlyRate', HourlyRate from dxEmployeeSalary where PK_dxEmployeeSalary = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxEmployeeSalary where PK_dxEmployeeSalary = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxEmployeeSalary INTO @keyvalue
 END

 CLOSE pk_cursordxEmployeeSalary 
 DEALLOCATE pk_cursordxEmployeeSalary
GO
ALTER TABLE [dbo].[dxEmployeeSalary] ADD CONSTRAINT [PK_dxEmployeeSalary] PRIMARY KEY CLUSTERED  ([PK_dxEmployeeSalary]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxEmployeeSalary_FK_dxEmployee] ON [dbo].[dxEmployeeSalary] ([FK_dxEmployee]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxEmployeeSalary] ADD CONSTRAINT [dxConstraint_FK_dxEmployee_dxEmployeeSalary] FOREIGN KEY ([FK_dxEmployee]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
