CREATE TABLE [dbo].[dxFactor]
(
[PK_dxFactor] [int] NOT NULL IDENTITY(1, 1),
[FK_dxScaleUnit__In] [int] NOT NULL,
[Factor] [float] NOT NULL,
[FK_dxScaleUnit__Out] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFactor.trAuditDelete] ON [dbo].[dxFactor]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxFactor'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxFactor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFactor, FK_dxScaleUnit__In, Factor, FK_dxScaleUnit__Out from deleted
 Declare @PK_dxFactor int, @FK_dxScaleUnit__In int, @Factor Float, @FK_dxScaleUnit__Out int

 OPEN pk_cursordxFactor
 FETCH NEXT FROM pk_cursordxFactor INTO @PK_dxFactor, @FK_dxScaleUnit__In, @Factor, @FK_dxScaleUnit__Out
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxFactor, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__In', @FK_dxScaleUnit__In
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Factor', @Factor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Out', @FK_dxScaleUnit__Out
FETCH NEXT FROM pk_cursordxFactor INTO @PK_dxFactor, @FK_dxScaleUnit__In, @Factor, @FK_dxScaleUnit__Out
 END

 CLOSE pk_cursordxFactor 
 DEALLOCATE pk_cursordxFactor
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFactor.trAuditInsUpd] ON [dbo].[dxFactor] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxFactor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFactor from inserted;
 set @tablename = 'dxFactor' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxFactor
 FETCH NEXT FROM pk_cursordxFactor INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__In )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__In', FK_dxScaleUnit__In from dxFactor where PK_dxFactor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Factor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Factor', Factor from dxFactor where PK_dxFactor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Out )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Out', FK_dxScaleUnit__Out from dxFactor where PK_dxFactor = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxFactor INTO @keyvalue
 END

 CLOSE pk_cursordxFactor 
 DEALLOCATE pk_cursordxFactor
GO
ALTER TABLE [dbo].[dxFactor] ADD CONSTRAINT [PK_dxFactor] PRIMARY KEY CLUSTERED  ([PK_dxFactor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFactor_FK_dxScaleUnit__In] ON [dbo].[dxFactor] ([FK_dxScaleUnit__In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFactor_FK_dxScaleUnit__Out] ON [dbo].[dxFactor] ([FK_dxScaleUnit__Out]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxFactor] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__In_dxFactor] FOREIGN KEY ([FK_dxScaleUnit__In]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxFactor] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Out_dxFactor] FOREIGN KEY ([FK_dxScaleUnit__Out]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
