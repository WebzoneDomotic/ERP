CREATE TABLE [dbo].[dxAssembly]
(
[PK_dxAssembly] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProduct] [int] NOT NULL,
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[FK_dxRouting] [int] NOT NULL,
[OptimalBatchSize] [float] NOT NULL CONSTRAINT [DF_dxAssembly_OptimalBatchSize] DEFAULT ((1)),
[Version] [float] NOT NULL CONSTRAINT [DF_dxAssembly1_Version] DEFAULT ((0.0)),
[EffectiveDate] [datetime] NOT NULL,
[InactiveDate] [datetime] NULL,
[Instructions] [varchar] (8000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAssembly.trAuditDelete] ON [dbo].[dxAssembly]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAssembly'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAssembly CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAssembly, FK_dxProduct, ID, FK_dxRouting, OptimalBatchSize, Version, EffectiveDate, InactiveDate, Instructions from deleted
 Declare @PK_dxAssembly int, @FK_dxProduct int, @ID varchar(50), @FK_dxRouting int, @OptimalBatchSize Float, @Version Float, @EffectiveDate DateTime, @InactiveDate DateTime, @Instructions varchar(8000)

 OPEN pk_cursordxAssembly
 FETCH NEXT FROM pk_cursordxAssembly INTO @PK_dxAssembly, @FK_dxProduct, @ID, @FK_dxRouting, @OptimalBatchSize, @Version, @EffectiveDate, @InactiveDate, @Instructions
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAssembly, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRouting', @FK_dxRouting
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OptimalBatchSize', @OptimalBatchSize
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Version', @Version
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InactiveDate', @InactiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', @Instructions
FETCH NEXT FROM pk_cursordxAssembly INTO @PK_dxAssembly, @FK_dxProduct, @ID, @FK_dxRouting, @OptimalBatchSize, @Version, @EffectiveDate, @InactiveDate, @Instructions
 END

 CLOSE pk_cursordxAssembly 
 DEALLOCATE pk_cursordxAssembly
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAssembly.trAuditInsUpd] ON [dbo].[dxAssembly] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAssembly CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAssembly from inserted;
 set @tablename = 'dxAssembly' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAssembly
 FETCH NEXT FROM pk_cursordxAssembly INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxAssembly where PK_dxAssembly = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxAssembly where PK_dxAssembly = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxRouting )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRouting', FK_dxRouting from dxAssembly where PK_dxAssembly = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OptimalBatchSize )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OptimalBatchSize', OptimalBatchSize from dxAssembly where PK_dxAssembly = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Version )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Version', Version from dxAssembly where PK_dxAssembly = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxAssembly where PK_dxAssembly = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InactiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InactiveDate', InactiveDate from dxAssembly where PK_dxAssembly = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Instructions )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', Instructions from dxAssembly where PK_dxAssembly = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAssembly INTO @keyvalue
 END

 CLOSE pk_cursordxAssembly 
 DEALLOCATE pk_cursordxAssembly
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxAssembly.trValidateModification] ON [dbo].[dxAssembly]
AFTER UPDATE, DELETE
AS
BEGIN
  if not (update(ID) or update(Version) or update(Instructions))
  begin
    if Coalesce( (Select Max(PK_dxProductTransaction) From inserted ie
                 left join dxProductTransaction pt on ( pt.FK_dxProduct = ie.FK_dxProduct and pt.TransactionDate >= ie.EffectiveDate )
                 where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
    begin
       ROLLBACK TRANSACTION
       RAISERROR('Modification de la nomenclature est refusée car il y a déjà des transactions postérieures ou égales à cette date. / Changing the assembly is prohibited because there are already transactions after that date.', 16, 1)
       RETURN
    end

    if Coalesce( (Select Max(PK_dxProductTransaction) From deleted ie
                   left join dxProductTransaction pt on ( pt.FK_dxProduct = ie.FK_dxProduct and pt.TransactionDate >= ie.EffectiveDate )
                   where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
    begin
       ROLLBACK TRANSACTION
       RAISERROR('Modification de la nomenclature refusée car il y a déjà des transactions postérieures ou égales à  cette date. / Changing the assembly is prohibited because there are already transactions after that date.', 16, 1)
       RETURN
    end
  end
End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxAssembly.trValidateModificationInsert] ON [dbo].[dxAssembly]
AFTER INSERT
AS
BEGIN

    if Coalesce( (Select Max(PK_dxProductTransaction) From inserted ie
                 left join dxProductTransaction pt on ( pt.FK_dxProduct = ie.FK_dxProduct and pt.TransactionDate >= ie.EffectiveDate )
                 where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
    begin
       ROLLBACK TRANSACTION
       RAISERROR('Modification de la nomenclature est refusée car il y a déjà des transactions postérieures ou égales à cette date. / Changing the assembly is prohibited because there are already transactions after that date.', 16, 1)
       RETURN
    end

    if Coalesce( (Select Max(PK_dxProductTransaction) From deleted ie
                   left join dxProductTransaction pt on ( pt.FK_dxProduct = ie.FK_dxProduct and pt.TransactionDate >= ie.EffectiveDate )
                   where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
    begin
       ROLLBACK TRANSACTION
       RAISERROR('Modification de la nomenclature refusée car il y a déjà des transactions postérieures ou égales à  cette date. / Changing the assembly is prohibited because there are already transactions after that date.', 16, 1)
       RETURN
    end

End
GO
ALTER TABLE [dbo].[dxAssembly] ADD CONSTRAINT [CK_dxAssembly] CHECK (([OptimalBatchSize]>=(1.0)))
GO
ALTER TABLE [dbo].[dxAssembly] ADD CONSTRAINT [PK_dxAssembly1] PRIMARY KEY CLUSTERED  ([PK_dxAssembly]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxAssemblyEffectiveDate] ON [dbo].[dxAssembly] ([EffectiveDate] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAssembly_FK_dxProduct] ON [dbo].[dxAssembly] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAssembly_FK_dxRouting] ON [dbo].[dxAssembly] ([FK_dxRouting]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAssembly] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxAssembly] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxAssembly] ADD CONSTRAINT [dxConstraint_FK_dxRouting_dxAssembly] FOREIGN KEY ([FK_dxRouting]) REFERENCES [dbo].[dxRouting] ([PK_dxRouting])
GO
