CREATE TABLE [dbo].[dxConversionFactor]
(
[PK_dxConversionFactor] [int] NOT NULL IDENTITY(1, 1),
[FK_dxScaleUnit__In] [int] NOT NULL,
[Factor] [float] NOT NULL,
[FK_dxScaleUnit__Out] [int] NOT NULL,
[UniqueRecord] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxConversionFactor.trAuditDelete] ON [dbo].[dxConversionFactor]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxConversionFactor'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxConversionFactor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxConversionFactor, FK_dxScaleUnit__In, Factor, FK_dxScaleUnit__Out, UniqueRecord from deleted
 Declare @PK_dxConversionFactor int, @FK_dxScaleUnit__In int, @Factor Float, @FK_dxScaleUnit__Out int, @UniqueRecord int

 OPEN pk_cursordxConversionFactor
 FETCH NEXT FROM pk_cursordxConversionFactor INTO @PK_dxConversionFactor, @FK_dxScaleUnit__In, @Factor, @FK_dxScaleUnit__Out, @UniqueRecord
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxConversionFactor, @tablename, @auditdate, @username, @fk_dxuser
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
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'UniqueRecord', @UniqueRecord
FETCH NEXT FROM pk_cursordxConversionFactor INTO @PK_dxConversionFactor, @FK_dxScaleUnit__In, @Factor, @FK_dxScaleUnit__Out, @UniqueRecord
 END

 CLOSE pk_cursordxConversionFactor 
 DEALLOCATE pk_cursordxConversionFactor
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxConversionFactor.trAuditInsUpd] ON [dbo].[dxConversionFactor] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxConversionFactor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxConversionFactor from inserted;
 set @tablename = 'dxConversionFactor' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxConversionFactor
 FETCH NEXT FROM pk_cursordxConversionFactor INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__In )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__In', FK_dxScaleUnit__In from dxConversionFactor where PK_dxConversionFactor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Factor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Factor', Factor from dxConversionFactor where PK_dxConversionFactor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Out )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Out', FK_dxScaleUnit__Out from dxConversionFactor where PK_dxConversionFactor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UniqueRecord )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'UniqueRecord', UniqueRecord from dxConversionFactor where PK_dxConversionFactor = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxConversionFactor INTO @keyvalue
 END

 CLOSE pk_cursordxConversionFactor 
 DEALLOCATE pk_cursordxConversionFactor
GO
CREATE NONCLUSTERED INDEX [IxFK_dxConversionFactor_FK_dxScaleUnit__In] ON [dbo].[dxConversionFactor] ([FK_dxScaleUnit__In]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxConversionFactor_FK_dxScaleUnit__Out] ON [dbo].[dxConversionFactor] ([FK_dxScaleUnit__Out]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxConversionFactor] ON [dbo].[dxConversionFactor] ([UniqueRecord] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxConversionFactor] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__In_dxConversionFactor] FOREIGN KEY ([FK_dxScaleUnit__In]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxConversionFactor] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Out_dxConversionFactor] FOREIGN KEY ([FK_dxScaleUnit__Out]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
