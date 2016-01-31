CREATE TABLE [dbo].[dxPriceLevelVolumeDiscount]
(
[PK_dxPriceLevelVolumeDiscount] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPriceLevel] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxScaleUnit] [int] NOT NULL,
[Quantity1] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_Quantity1] DEFAULT ((0.0)),
[DiscountQuantity1] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_DiscountQuantity1] DEFAULT ((0.0)),
[Quantity2] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_Quantity2] DEFAULT ((0.0)),
[DiscountQuantity2] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_DiscountQuantity2] DEFAULT ((0.0)),
[Quantity3] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_Quantity3] DEFAULT ((0.0)),
[DiscountQuantity3] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_DiscountQuantity3] DEFAULT ((0.0)),
[Quantity4] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_Quantity4] DEFAULT ((0.0)),
[DiscountQuantity4] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_DiscountQuantity4] DEFAULT ((0.0)),
[Quantity5] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_Quantity5] DEFAULT ((0.0)),
[DiscountQuantity5] [float] NOT NULL CONSTRAINT [DF_dxPriceLevelVolumeDiscount_DiscountQuantity5] DEFAULT ((0.0)),
[EffectiveEndDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPriceLevelVolumeDiscount.trAuditDelete] ON [dbo].[dxPriceLevelVolumeDiscount]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPriceLevelVolumeDiscount'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPriceLevelVolumeDiscount CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPriceLevelVolumeDiscount, FK_dxPriceLevel, FK_dxProduct, Description, FK_dxScaleUnit, Quantity1, DiscountQuantity1, Quantity2, DiscountQuantity2, Quantity3, DiscountQuantity3, Quantity4, DiscountQuantity4, Quantity5, DiscountQuantity5, EffectiveEndDate from deleted
 Declare @PK_dxPriceLevelVolumeDiscount int, @FK_dxPriceLevel int, @FK_dxProduct int, @Description varchar(255), @FK_dxScaleUnit int, @Quantity1 Float, @DiscountQuantity1 Float, @Quantity2 Float, @DiscountQuantity2 Float, @Quantity3 Float, @DiscountQuantity3 Float, @Quantity4 Float, @DiscountQuantity4 Float, @Quantity5 Float, @DiscountQuantity5 Float, @EffectiveEndDate DateTime

 OPEN pk_cursordxPriceLevelVolumeDiscount
 FETCH NEXT FROM pk_cursordxPriceLevelVolumeDiscount INTO @PK_dxPriceLevelVolumeDiscount, @FK_dxPriceLevel, @FK_dxProduct, @Description, @FK_dxScaleUnit, @Quantity1, @DiscountQuantity1, @Quantity2, @DiscountQuantity2, @Quantity3, @DiscountQuantity3, @Quantity4, @DiscountQuantity4, @Quantity5, @DiscountQuantity5, @EffectiveEndDate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPriceLevelVolumeDiscount, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevel', @FK_dxPriceLevel
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', @FK_dxScaleUnit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity1', @Quantity1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity1', @DiscountQuantity1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity2', @Quantity2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity2', @DiscountQuantity2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity3', @Quantity3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity3', @DiscountQuantity3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity4', @Quantity4
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity4', @DiscountQuantity4
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity5', @Quantity5
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity5', @DiscountQuantity5
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveEndDate', @EffectiveEndDate
FETCH NEXT FROM pk_cursordxPriceLevelVolumeDiscount INTO @PK_dxPriceLevelVolumeDiscount, @FK_dxPriceLevel, @FK_dxProduct, @Description, @FK_dxScaleUnit, @Quantity1, @DiscountQuantity1, @Quantity2, @DiscountQuantity2, @Quantity3, @DiscountQuantity3, @Quantity4, @DiscountQuantity4, @Quantity5, @DiscountQuantity5, @EffectiveEndDate
 END

 CLOSE pk_cursordxPriceLevelVolumeDiscount 
 DEALLOCATE pk_cursordxPriceLevelVolumeDiscount
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPriceLevelVolumeDiscount.trAuditInsUpd] ON [dbo].[dxPriceLevelVolumeDiscount] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPriceLevelVolumeDiscount CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPriceLevelVolumeDiscount from inserted;
 set @tablename = 'dxPriceLevelVolumeDiscount' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPriceLevelVolumeDiscount
 FETCH NEXT FROM pk_cursordxPriceLevelVolumeDiscount INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPriceLevel )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevel', FK_dxPriceLevel from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity1', Quantity1 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountQuantity1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity1', DiscountQuantity1 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity2', Quantity2 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountQuantity2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity2', DiscountQuantity2 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity3', Quantity3 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountQuantity3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity3', DiscountQuantity3 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity4 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity4', Quantity4 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountQuantity4 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity4', DiscountQuantity4 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity5 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity5', Quantity5 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountQuantity5 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DiscountQuantity5', DiscountQuantity5 from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveEndDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveEndDate', EffectiveEndDate from dxPriceLevelVolumeDiscount where PK_dxPriceLevelVolumeDiscount = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPriceLevelVolumeDiscount INTO @keyvalue
 END

 CLOSE pk_cursordxPriceLevelVolumeDiscount 
 DEALLOCATE pk_cursordxPriceLevelVolumeDiscount
GO
ALTER TABLE [dbo].[dxPriceLevelVolumeDiscount] ADD CONSTRAINT [PK_dxPriceLevelVolumeDiscount] PRIMARY KEY CLUSTERED  ([PK_dxPriceLevelVolumeDiscount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPriceLevelVolumeDiscount_FK_dxPriceLevel] ON [dbo].[dxPriceLevelVolumeDiscount] ([FK_dxPriceLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPriceLevelVolumeDiscount_FK_dxProduct] ON [dbo].[dxPriceLevelVolumeDiscount] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPriceLevelVolumeDiscount_FK_dxScaleUnit] ON [dbo].[dxPriceLevelVolumeDiscount] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPriceLevelVolumeDiscount] ADD CONSTRAINT [dxConstraint_FK_dxPriceLevel_dxPriceLevelVolumeDiscount] FOREIGN KEY ([FK_dxPriceLevel]) REFERENCES [dbo].[dxPriceLevel] ([PK_dxPriceLevel])
GO
ALTER TABLE [dbo].[dxPriceLevelVolumeDiscount] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxPriceLevelVolumeDiscount] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxPriceLevelVolumeDiscount] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxPriceLevelVolumeDiscount] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
