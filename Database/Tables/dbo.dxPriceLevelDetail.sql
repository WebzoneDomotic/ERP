CREATE TABLE [dbo].[dxPriceLevelDetail]
(
[PK_dxPriceLevelDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPriceLevel] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[UnitAmount] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelDetail_FK_dxScaleUnit] DEFAULT ((0.0)),
[EffectiveDate] [datetime] NOT NULL CONSTRAINT [DF_dxPriceLevelDetail_EffectiveDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[MinimumQuantity] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelDetail_MinimumQuantity] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPriceLevelDetail.trAuditDelete] ON [dbo].[dxPriceLevelDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPriceLevelDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPriceLevelDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPriceLevelDetail, FK_dxPriceLevel, FK_dxProduct, UnitAmount, EffectiveDate, MinimumQuantity from deleted
 Declare @PK_dxPriceLevelDetail int, @FK_dxPriceLevel int, @FK_dxProduct int, @UnitAmount Float, @EffectiveDate DateTime, @MinimumQuantity Float

 OPEN pk_cursordxPriceLevelDetail
 FETCH NEXT FROM pk_cursordxPriceLevelDetail INTO @PK_dxPriceLevelDetail, @FK_dxPriceLevel, @FK_dxProduct, @UnitAmount, @EffectiveDate, @MinimumQuantity
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPriceLevelDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevel', @FK_dxPriceLevel
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
FETCH NEXT FROM pk_cursordxPriceLevelDetail INTO @PK_dxPriceLevelDetail, @FK_dxPriceLevel, @FK_dxProduct, @UnitAmount, @EffectiveDate, @MinimumQuantity
 END

 CLOSE pk_cursordxPriceLevelDetail 
 DEALLOCATE pk_cursordxPriceLevelDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPriceLevelDetail.trAuditInsUpd] ON [dbo].[dxPriceLevelDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPriceLevelDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPriceLevelDetail from inserted;
 set @tablename = 'dxPriceLevelDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPriceLevelDetail
 FETCH NEXT FROM pk_cursordxPriceLevelDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPriceLevel )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevel', FK_dxPriceLevel from dxPriceLevelDetail where PK_dxPriceLevelDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxPriceLevelDetail where PK_dxPriceLevelDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnitAmount', UnitAmount from dxPriceLevelDetail where PK_dxPriceLevelDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxPriceLevelDetail where PK_dxPriceLevelDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MinimumQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinimumQuantity', MinimumQuantity from dxPriceLevelDetail where PK_dxPriceLevelDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPriceLevelDetail INTO @keyvalue
 END

 CLOSE pk_cursordxPriceLevelDetail 
 DEALLOCATE pk_cursordxPriceLevelDetail
GO
ALTER TABLE [dbo].[dxPriceLevelDetail] ADD CONSTRAINT [PK_dxPriceLevelDetail] PRIMARY KEY CLUSTERED  ([PK_dxPriceLevelDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPriceLevelDetail_FK_dxPriceLevel] ON [dbo].[dxPriceLevelDetail] ([FK_dxPriceLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPriceLevelDetail_FK_dxProduct] ON [dbo].[dxPriceLevelDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPriceLevelDetail] ADD CONSTRAINT [dxConstraint_FK_dxPriceLevel_dxPriceLevelDetail] FOREIGN KEY ([FK_dxPriceLevel]) REFERENCES [dbo].[dxPriceLevel] ([PK_dxPriceLevel])
GO
ALTER TABLE [dbo].[dxPriceLevelDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxPriceLevelDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
