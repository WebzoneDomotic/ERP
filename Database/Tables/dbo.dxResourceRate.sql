CREATE TABLE [dbo].[dxResourceRate]
(
[PK_dxResourceRate] [int] NOT NULL IDENTITY(1, 1),
[FK_dxResource] [int] NOT NULL,
[HourlyRate] [float] NOT NULL CONSTRAINT [DF_dxResourceRate_HourlyRate] DEFAULT ((0.0)),
[EffectiveDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxResourceRate.trAuditDelete] ON [dbo].[dxResourceRate]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxResourceRate'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxResourceRate CURSOR LOCAL FAST_FORWARD for SELECT PK_dxResourceRate, FK_dxResource, HourlyRate, EffectiveDate from deleted
 Declare @PK_dxResourceRate int, @FK_dxResource int, @HourlyRate Float, @EffectiveDate DateTime

 OPEN pk_cursordxResourceRate
 FETCH NEXT FROM pk_cursordxResourceRate INTO @PK_dxResourceRate, @FK_dxResource, @HourlyRate, @EffectiveDate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxResourceRate, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxResource', @FK_dxResource
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'HourlyRate', @HourlyRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
FETCH NEXT FROM pk_cursordxResourceRate INTO @PK_dxResourceRate, @FK_dxResource, @HourlyRate, @EffectiveDate
 END

 CLOSE pk_cursordxResourceRate 
 DEALLOCATE pk_cursordxResourceRate
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxResourceRate.trAuditInsUpd] ON [dbo].[dxResourceRate] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxResourceRate CURSOR LOCAL FAST_FORWARD for SELECT PK_dxResourceRate from inserted;
 set @tablename = 'dxResourceRate' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxResourceRate
 FETCH NEXT FROM pk_cursordxResourceRate INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxResource )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxResource', FK_dxResource from dxResourceRate where PK_dxResourceRate = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HourlyRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'HourlyRate', HourlyRate from dxResourceRate where PK_dxResourceRate = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxResourceRate where PK_dxResourceRate = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxResourceRate INTO @keyvalue
 END

 CLOSE pk_cursordxResourceRate 
 DEALLOCATE pk_cursordxResourceRate
GO
ALTER TABLE [dbo].[dxResourceRate] ADD CONSTRAINT [PK_dxResourceRate] PRIMARY KEY CLUSTERED  ([PK_dxResourceRate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxResourceRate_FK_dxResource] ON [dbo].[dxResourceRate] ([FK_dxResource]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxResourceRate] ADD CONSTRAINT [dxConstraint_FK_dxResource_dxResourceRate] FOREIGN KEY ([FK_dxResource]) REFERENCES [dbo].[dxResource] ([PK_dxResource])
GO
