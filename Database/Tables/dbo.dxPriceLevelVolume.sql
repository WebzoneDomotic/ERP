CREATE TABLE [dbo].[dxPriceLevelVolume]
(
[PK_dxPriceLevelVolume] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPriceLevelDetail] [int] NOT NULL,
[LowerBoundQuantity] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolume_LowerBoundQuantity] DEFAULT ((0.0)),
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolume_UnitAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPriceLevelVolume.trAuditDelete] ON [dbo].[dxPriceLevelVolume]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPriceLevelVolume'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPriceLevelVolume CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPriceLevelVolume, FK_dxPriceLevelDetail, LowerBoundQuantity, UnitAmount from deleted
 Declare @PK_dxPriceLevelVolume int, @FK_dxPriceLevelDetail int, @LowerBoundQuantity Float, @UnitAmount Float

 OPEN pk_cursordxPriceLevelVolume
 FETCH NEXT FROM pk_cursordxPriceLevelVolume INTO @PK_dxPriceLevelVolume, @FK_dxPriceLevelDetail, @LowerBoundQuantity, @UnitAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPriceLevelVolume, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevelDetail', @FK_dxPriceLevelDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LowerBoundQuantity', @LowerBoundQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', @UnitAmount
FETCH NEXT FROM pk_cursordxPriceLevelVolume INTO @PK_dxPriceLevelVolume, @FK_dxPriceLevelDetail, @LowerBoundQuantity, @UnitAmount
 END

 CLOSE pk_cursordxPriceLevelVolume 
 DEALLOCATE pk_cursordxPriceLevelVolume
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPriceLevelVolume.trAuditInsUpd] ON [dbo].[dxPriceLevelVolume] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPriceLevelVolume CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPriceLevelVolume from inserted;
 set @tablename = 'dxPriceLevelVolume' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPriceLevelVolume
 FETCH NEXT FROM pk_cursordxPriceLevelVolume INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPriceLevelDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevelDetail', FK_dxPriceLevelDetail from dxPriceLevelVolume where PK_dxPriceLevelVolume = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LowerBoundQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LowerBoundQuantity', LowerBoundQuantity from dxPriceLevelVolume where PK_dxPriceLevelVolume = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxPriceLevelVolume where PK_dxPriceLevelVolume = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPriceLevelVolume INTO @keyvalue
 END

 CLOSE pk_cursordxPriceLevelVolume 
 DEALLOCATE pk_cursordxPriceLevelVolume
GO
ALTER TABLE [dbo].[dxPriceLevelVolume] ADD CONSTRAINT [PK_dxPriceLevelVolume] PRIMARY KEY CLUSTERED  ([PK_dxPriceLevelVolume]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPriceLevelVolume_FK_dxPriceLevelDetail] ON [dbo].[dxPriceLevelVolume] ([FK_dxPriceLevelDetail]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPriceLevelVolume] ADD CONSTRAINT [dxConstraint_FK_dxPriceLevelDetail_dxPriceLevelVolume] FOREIGN KEY ([FK_dxPriceLevelDetail]) REFERENCES [dbo].[dxPriceLevelDetail] ([PK_dxPriceLevelDetail])
GO
