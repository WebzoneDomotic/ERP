CREATE TABLE [dbo].[dxCostLevelVolume]
(
[PK_dxCostLevelVolume] [int] NOT NULL IDENTITY(1, 1),
[FK_dxCostLevelDetail] [int] NOT NULL,
[LowerBoundQuantity] [float] NOT NULL CONSTRAINT [DF_dxCostLevelVolume_LowerBoundQuantity] DEFAULT ((0.0)),
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxCostLevelVolume_UnitAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCostLevelVolume.trAuditDelete] ON [dbo].[dxCostLevelVolume]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCostLevelVolume'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCostLevelVolume CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCostLevelVolume, FK_dxCostLevelDetail, LowerBoundQuantity, UnitAmount from deleted
 Declare @PK_dxCostLevelVolume int, @FK_dxCostLevelDetail int, @LowerBoundQuantity Float, @UnitAmount Float

 OPEN pk_cursordxCostLevelVolume
 FETCH NEXT FROM pk_cursordxCostLevelVolume INTO @PK_dxCostLevelVolume, @FK_dxCostLevelDetail, @LowerBoundQuantity, @UnitAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCostLevelVolume, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCostLevelDetail', @FK_dxCostLevelDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LowerBoundQuantity', @LowerBoundQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', @UnitAmount
FETCH NEXT FROM pk_cursordxCostLevelVolume INTO @PK_dxCostLevelVolume, @FK_dxCostLevelDetail, @LowerBoundQuantity, @UnitAmount
 END

 CLOSE pk_cursordxCostLevelVolume 
 DEALLOCATE pk_cursordxCostLevelVolume
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCostLevelVolume.trAuditInsUpd] ON [dbo].[dxCostLevelVolume] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCostLevelVolume CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCostLevelVolume from inserted;
 set @tablename = 'dxCostLevelVolume' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCostLevelVolume
 FETCH NEXT FROM pk_cursordxCostLevelVolume INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCostLevelDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCostLevelDetail', FK_dxCostLevelDetail from dxCostLevelVolume where PK_dxCostLevelVolume = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LowerBoundQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LowerBoundQuantity', LowerBoundQuantity from dxCostLevelVolume where PK_dxCostLevelVolume = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxCostLevelVolume where PK_dxCostLevelVolume = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCostLevelVolume INTO @keyvalue
 END

 CLOSE pk_cursordxCostLevelVolume 
 DEALLOCATE pk_cursordxCostLevelVolume
GO
ALTER TABLE [dbo].[dxCostLevelVolume] ADD CONSTRAINT [PK_dxCostLevelVolume] PRIMARY KEY CLUSTERED  ([PK_dxCostLevelVolume]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCostLevelVolume_FK_dxCostLevelDetail] ON [dbo].[dxCostLevelVolume] ([FK_dxCostLevelDetail]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCostLevelVolume] ADD CONSTRAINT [dxConstraint_FK_dxCostLevelDetail_dxCostLevelVolume] FOREIGN KEY ([FK_dxCostLevelDetail]) REFERENCES [dbo].[dxCostLevelDetail] ([PK_dxCostLevelDetail])
GO
