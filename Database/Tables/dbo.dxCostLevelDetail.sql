CREATE TABLE [dbo].[dxCostLevelDetail]
(
[PK_dxCostLevelDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxCostLevel] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxCostLevelDetail_UnitAmount] DEFAULT ((0.0)),
[EffectiveDate] [datetime] NOT NULL CONSTRAINT [DF_dxCostLevelDetail_EffectiveDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[MinimumQuantity] [float] NOT NULL CONSTRAINT [DF_dxCostLevelDetail_MinimumQuantity] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCostLevelDetail.trAuditDelete] ON [dbo].[dxCostLevelDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCostLevelDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCostLevelDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCostLevelDetail, FK_dxCostLevel, FK_dxProduct, UnitAmount, EffectiveDate, MinimumQuantity from deleted
 Declare @PK_dxCostLevelDetail int, @FK_dxCostLevel int, @FK_dxProduct int, @UnitAmount Float, @EffectiveDate DateTime, @MinimumQuantity Float

 OPEN pk_cursordxCostLevelDetail
 FETCH NEXT FROM pk_cursordxCostLevelDetail INTO @PK_dxCostLevelDetail, @FK_dxCostLevel, @FK_dxProduct, @UnitAmount, @EffectiveDate, @MinimumQuantity
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCostLevelDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCostLevel', @FK_dxCostLevel
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', @UnitAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinimumQuantity', @MinimumQuantity
FETCH NEXT FROM pk_cursordxCostLevelDetail INTO @PK_dxCostLevelDetail, @FK_dxCostLevel, @FK_dxProduct, @UnitAmount, @EffectiveDate, @MinimumQuantity
 END

 CLOSE pk_cursordxCostLevelDetail 
 DEALLOCATE pk_cursordxCostLevelDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCostLevelDetail.trAuditInsUpd] ON [dbo].[dxCostLevelDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCostLevelDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCostLevelDetail from inserted;
 set @tablename = 'dxCostLevelDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCostLevelDetail
 FETCH NEXT FROM pk_cursordxCostLevelDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCostLevel )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCostLevel', FK_dxCostLevel from dxCostLevelDetail where PK_dxCostLevelDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxCostLevelDetail where PK_dxCostLevelDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxCostLevelDetail where PK_dxCostLevelDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxCostLevelDetail where PK_dxCostLevelDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MinimumQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinimumQuantity', MinimumQuantity from dxCostLevelDetail where PK_dxCostLevelDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCostLevelDetail INTO @keyvalue
 END

 CLOSE pk_cursordxCostLevelDetail 
 DEALLOCATE pk_cursordxCostLevelDetail
GO
ALTER TABLE [dbo].[dxCostLevelDetail] ADD CONSTRAINT [PK_dxCostLevelDetail] PRIMARY KEY CLUSTERED  ([PK_dxCostLevelDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCostLevelDetail_FK_dxCostLevel] ON [dbo].[dxCostLevelDetail] ([FK_dxCostLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCostLevelDetail_FK_dxProduct] ON [dbo].[dxCostLevelDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCostLevelDetail] ADD CONSTRAINT [dxConstraint_FK_dxCostLevel_dxCostLevelDetail] FOREIGN KEY ([FK_dxCostLevel]) REFERENCES [dbo].[dxCostLevel] ([PK_dxCostLevel])
GO
ALTER TABLE [dbo].[dxCostLevelDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxCostLevelDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
