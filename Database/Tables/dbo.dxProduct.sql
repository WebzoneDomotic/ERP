CREATE TABLE [dbo].[dxProduct]
(
[PK_dxProduct] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[EnglishDescription] [varchar] (255) COLLATE French_CI_AS NULL,
[SpanishDescription] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxProductCategory] [int] NULL,
[FK_dxScaleUnit] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit] DEFAULT ((1)),
[StandardPrice] [float] NOT NULL CONSTRAINT [DF_dxProduct_StandardPrice] DEFAULT ((0.0)),
[FK_dxWarehouse] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxWarehouse] DEFAULT ((3)),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxLocation] DEFAULT ((1)),
[UPC] [varchar] (50) COLLATE French_CI_AS NULL,
[HS] [varchar] (50) COLLATE French_CI_AS NULL,
[FDA] [varchar] (50) COLLATE French_CI_AS NULL,
[DIN] [varchar] (50) COLLATE French_CI_AS NULL,
[SalesItem] [bit] NOT NULL CONSTRAINT [DF_dxProduct_SalesItem] DEFAULT ((1)),
[PurchasedItem] [bit] NOT NULL CONSTRAINT [DF_dxProduct_PurchasedItem] DEFAULT ((1)),
[InventoryItem] [bit] NOT NULL CONSTRAINT [DF_dxProduct_InventoryItem] DEFAULT ((1)),
[ApplyTax1] [bit] NOT NULL CONSTRAINT [DF_dxProduct_ApplyTax1] DEFAULT ((1)),
[ApplyTax2] [bit] NOT NULL CONSTRAINT [DF_dxProduct_ApplyTax2] DEFAULT ((1)),
[ApplyTax3] [bit] NOT NULL CONSTRAINT [DF_dxProduct_ApplyTax3] DEFAULT ((1)),
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxProduct_Active] DEFAULT ((1)),
[LifeSpanInDays] [int] NOT NULL CONSTRAINT [DF_dxProduct_LifeSpanInDays] DEFAULT ((0)),
[NumberOfDaysBeforeEndOfSales] [int] NOT NULL CONSTRAINT [DF_dxProduct_NumberOfDayBeforeEndOfSale] DEFAULT ((0)),
[FK_dxScaleUnit__PKG1] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__PKG1] DEFAULT ((1)),
[FK_dxScaleUnit__PKG2] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__PKG2] DEFAULT ((1)),
[FK_dxScaleUnit__PKG3] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__PKG3] DEFAULT ((1)),
[FK_dxScaleUnit__PKG4] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__PKG4] DEFAULT ((1)),
[FK_dxScaleUnit__PKG5] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__PKG5] DEFAULT ((1)),
[PackingQuantity1] [float] NOT NULL CONSTRAINT [DF_dxProduct_PackingQuantity1] DEFAULT ((0.0)),
[PackingQuantity2] [float] NOT NULL CONSTRAINT [DF_dxProduct_PackingQuantity2] DEFAULT ((0.0)),
[PackingQuantity3] [float] NOT NULL CONSTRAINT [DF_dxProduct_PackingQuantity3] DEFAULT ((0.0)),
[PackingQuantity4] [float] NOT NULL CONSTRAINT [DF_dxProduct_PackingQuantity4] DEFAULT ((0.0)),
[PackingQuantity5] [float] NOT NULL CONSTRAINT [DF_dxProduct_PackingQuantity5] DEFAULT ((0.0)),
[FK_dxVendor__Default] [int] NULL,
[OrderLevelQuantity] [float] NOT NULL CONSTRAINT [DF_dxProduct_DefaultQuantity] DEFAULT ((0)),
[FK_dxScaleUnit__Vendor] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__Vendor] DEFAULT ((1)),
[LeadTimeInDays] [int] NOT NULL CONSTRAINT [DF_dxProduct_LeadTimeInDays] DEFAULT ((0)),
[TriggerOrderedQuantity] [float] NOT NULL CONSTRAINT [DF_dxProduct_TriggerOrderedQuantity] DEFAULT ((0.0)),
[OtherDescription] [varchar] (255) COLLATE French_CI_AS NULL,
[Box_ID] [varchar] (50) COLLATE French_CI_AS NULL,
[Case_ID] [varchar] (50) COLLATE French_CI_AS NULL,
[Skid_ID] [varchar] (50) COLLATE French_CI_AS NULL,
[Bulk_ID] [varchar] (50) COLLATE French_CI_AS NULL,
[FixedLotSize] [float] NOT NULL CONSTRAINT [DF_dxProduct_FixedLotSize] DEFAULT ((1.0)),
[MinLotSize] [float] NOT NULL CONSTRAINT [DF_dxProduct_MinLotSize] DEFAULT ((1.0)),
[EconomicLotSize] [float] NOT NULL CONSTRAINT [DF_dxProduct_EconomicLotSize] DEFAULT ((1.0)),
[FK_dxLotSizing] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxLotSizing] DEFAULT ((1.0)),
[SafetyStock] [float] NOT NULL CONSTRAINT [DF_dxProduct_SafetyStock] DEFAULT ((0.0)),
[DailyForecast] [float] NOT NULL CONSTRAINT [DF_dxProduct_DailyForecast] DEFAULT ((0.0)),
[ManufacturedItem] [bit] NOT NULL CONSTRAINT [DF_dxProduct_ManufacturedItem] DEFAULT ((0)),
[ExcludeFromMRP] [bit] NOT NULL CONSTRAINT [DF_dxProduct_ExcludeFromMRP] DEFAULT ((0)),
[Weight] [float] NOT NULL CONSTRAINT [DF_dxProduct_Weight] DEFAULT ((0.0)),
[FK_dxScaleUnit__Weight] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__Weight] DEFAULT ((1)),
[Lenght] [float] NOT NULL CONSTRAINT [DF_dxProduct_Lenght] DEFAULT ((0.0)),
[FK_dxScaleUnit__Lenght] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__Lenght] DEFAULT ((1)),
[Width] [float] NOT NULL CONSTRAINT [DF_dxProduct_Width] DEFAULT ((0.0)),
[FK_dxScaleUnit__Width] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__Width] DEFAULT ((1)),
[Height] [float] NOT NULL CONSTRAINT [DF_dxProduct_Height] DEFAULT ((0.0)),
[FK_dxScaleUnit__Height] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__Height] DEFAULT ((1)),
[Volume] [float] NOT NULL CONSTRAINT [DF_dxProduct_Volume] DEFAULT ((0.0)),
[FK_dxScaleUnit__Volume] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__Volume] DEFAULT ((1)),
[Density] [float] NOT NULL CONSTRAINT [DF_dxProduct_Density] DEFAULT ((0.0)),
[FK_dxScaleUnit__Density] [int] NOT NULL CONSTRAINT [DF_dxProduct_FK_dxScaleUnit__Density] DEFAULT ((1)),
[Kit] [bit] NOT NULL CONSTRAINT [DF_dxProduct_Kit] DEFAULT ((0)),
[Picture] [image] NULL,
[DefaultSalesOrderedQuantity] [float] NOT NULL CONSTRAINT [DF_dxProduct_DefaultSalesOrderedQuantity] DEFAULT ((1.0)),
[FK_dxPropertyGroup] [int] NULL,
[ShortDescription] [varchar] (255) COLLATE French_CI_AS NULL,
[Freight] [bit] NOT NULL CONSTRAINT [DF_dxProduct_Freight] DEFAULT ((0)),
[DoNotProduce] [bit] NOT NULL CONSTRAINT [DF_dxProduct_DoNotProduce] DEFAULT ((0)),
[DoNotPurchase] [bit] NOT NULL CONSTRAINT [DF_dxProduct_DoNotPurchase] DEFAULT ((0)),
[FK_dxPropertyGroup__Compliance] [int] NULL,
[FK_dxWarehouse__Reception] [int] NULL,
[FK_dxLocation__Reception] [int] NULL,
[FK_dxScaleUnit__UnitAmount] [int] NULL,
[ManageReceptionPerUnit] [bit] NOT NULL CONSTRAINT [DF_dxProduct_ManageReceptionPerUnit] DEFAULT ((0)),
[MinimumLevelQuantity] [float] NOT NULL CONSTRAINT [DF_dxProduct_MinimumLevelQuantity] DEFAULT ((0.0)),
[MinimumBatchSize] [float] NOT NULL CONSTRAINT [DF_dxProduct_MinimumBatchSize] DEFAULT ((0.0)),
[MaximumBatchSize] [float] NOT NULL CONSTRAINT [DF_dxProduct_MaximumBatchSize] DEFAULT ((0.0)),
[ForecastType] [int] NOT NULL CONSTRAINT [DF_dxProduct_ForecastType] DEFAULT ((0)),
[OtherID] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxProduct_OtherID] DEFAULT (''),
[RefundPercentageOfTax1] [float] NOT NULL CONSTRAINT [DF_dxProduct_RefundPercentageOfTax1] DEFAULT ((0.0)),
[RefundPercentageOfTax2] [float] NOT NULL CONSTRAINT [DF_dxProduct_RefundPercentageOfTax2] DEFAULT ((0.0)),
[RefundPercentageOfTax3] [float] NOT NULL CONSTRAINT [DF_dxProduct_RefundPercentageOfTax3] DEFAULT ((0.0)),
[ForecastAdjustingFactor] [float] NOT NULL CONSTRAINT [DF_dxProduct_ForecastAdjustingFactor] DEFAULT ((0.0)),
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxProduct_DocumentStatus] DEFAULT ((0)),
[ClientProduct] [bit] NOT NULL CONSTRAINT [DF_dxProduct_ClientProduct] DEFAULT ((0)),
[TransitLeadTimeInDays] [int] NOT NULL CONSTRAINT [DF_dxProduct_TransitLeadTimeInDays] DEFAULT ((0)),
[LotNumberOfDaysForecast] [float] NOT NULL CONSTRAINT [DF_dxProduct_LotNumberOfDaysForecast] DEFAULT ((0)),
[FK_dxPropertyGroup__WO_Compliance] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProduct.trAuditDelete] ON [dbo].[dxProduct]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProduct'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProduct CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProduct, ID, Description, EnglishDescription, SpanishDescription, FK_dxProductCategory, FK_dxScaleUnit, StandardPrice, FK_dxWarehouse, FK_dxLocation, UPC, HS, FDA, DIN, SalesItem, PurchasedItem, InventoryItem, ApplyTax1, ApplyTax2, ApplyTax3, Note, Active, LifeSpanInDays, NumberOfDaysBeforeEndOfSales, FK_dxScaleUnit__PKG1, FK_dxScaleUnit__PKG2, FK_dxScaleUnit__PKG3, FK_dxScaleUnit__PKG4, FK_dxScaleUnit__PKG5, PackingQuantity1, PackingQuantity2, PackingQuantity3, PackingQuantity4, PackingQuantity5, FK_dxVendor__Default, OrderLevelQuantity, FK_dxScaleUnit__Vendor, LeadTimeInDays, TriggerOrderedQuantity, OtherDescription, Box_ID, Case_ID, Skid_ID, Bulk_ID, FixedLotSize, MinLotSize, EconomicLotSize, FK_dxLotSizing, SafetyStock, DailyForecast, ManufacturedItem, ExcludeFromMRP, Weight, FK_dxScaleUnit__Weight, Lenght, FK_dxScaleUnit__Lenght, Width, FK_dxScaleUnit__Width, Height, FK_dxScaleUnit__Height, Volume, FK_dxScaleUnit__Volume, Density, FK_dxScaleUnit__Density, Kit, DefaultSalesOrderedQuantity, FK_dxPropertyGroup, ShortDescription, Freight, DoNotProduce, DoNotPurchase, FK_dxPropertyGroup__Compliance, FK_dxWarehouse__Reception, FK_dxLocation__Reception, FK_dxScaleUnit__UnitAmount, ManageReceptionPerUnit, MinimumLevelQuantity, MinimumBatchSize, MaximumBatchSize, ForecastType, OtherID, RefundPercentageOfTax1, RefundPercentageOfTax2, RefundPercentageOfTax3, ForecastAdjustingFactor, DocumentStatus, ClientProduct, TransitLeadTimeInDays, LotNumberOfDaysForecast, FK_dxPropertyGroup__WO_Compliance from deleted
 Declare @PK_dxProduct int, @ID varchar(50), @Description varchar(255), @EnglishDescription varchar(255), @SpanishDescription varchar(255), @FK_dxProductCategory int, @FK_dxScaleUnit int, @StandardPrice Float, @FK_dxWarehouse int, @FK_dxLocation int, @UPC varchar(50), @HS varchar(50), @FDA varchar(50), @DIN varchar(50), @SalesItem Bit, @PurchasedItem Bit, @InventoryItem Bit, @ApplyTax1 Bit, @ApplyTax2 Bit, @ApplyTax3 Bit, @Note varchar(2000), @Active Bit, @LifeSpanInDays int, @NumberOfDaysBeforeEndOfSales int, @FK_dxScaleUnit__PKG1 int, @FK_dxScaleUnit__PKG2 int, @FK_dxScaleUnit__PKG3 int, @FK_dxScaleUnit__PKG4 int, @FK_dxScaleUnit__PKG5 int, @PackingQuantity1 Float, @PackingQuantity2 Float, @PackingQuantity3 Float, @PackingQuantity4 Float, @PackingQuantity5 Float, @FK_dxVendor__Default int, @OrderLevelQuantity Float, @FK_dxScaleUnit__Vendor int, @LeadTimeInDays int, @TriggerOrderedQuantity Float, @OtherDescription varchar(255), @Box_ID varchar(50), @Case_ID varchar(50), @Skid_ID varchar(50), @Bulk_ID varchar(50), @FixedLotSize Float, @MinLotSize Float, @EconomicLotSize Float, @FK_dxLotSizing int, @SafetyStock Float, @DailyForecast Float, @ManufacturedItem Bit, @ExcludeFromMRP Bit, @Weight Float, @FK_dxScaleUnit__Weight int, @Lenght Float, @FK_dxScaleUnit__Lenght int, @Width Float, @FK_dxScaleUnit__Width int, @Height Float, @FK_dxScaleUnit__Height int, @Volume Float, @FK_dxScaleUnit__Volume int, @Density Float, @FK_dxScaleUnit__Density int, @Kit Bit, @DefaultSalesOrderedQuantity Float, @FK_dxPropertyGroup int, @ShortDescription varchar(255), @Freight Bit, @DoNotProduce Bit, @DoNotPurchase Bit, @FK_dxPropertyGroup__Compliance int, @FK_dxWarehouse__Reception int, @FK_dxLocation__Reception int, @FK_dxScaleUnit__UnitAmount int, @ManageReceptionPerUnit Bit, @MinimumLevelQuantity Float, @MinimumBatchSize Float, @MaximumBatchSize Float, @ForecastType int, @OtherID varchar(50), @RefundPercentageOfTax1 Float, @RefundPercentageOfTax2 Float, @RefundPercentageOfTax3 Float, @ForecastAdjustingFactor Float, @DocumentStatus int, @ClientProduct Bit, @TransitLeadTimeInDays int, @LotNumberOfDaysForecast Float, @FK_dxPropertyGroup__WO_Compliance int

 OPEN pk_cursordxProduct
 FETCH NEXT FROM pk_cursordxProduct INTO @PK_dxProduct, @ID, @Description, @EnglishDescription, @SpanishDescription, @FK_dxProductCategory, @FK_dxScaleUnit, @StandardPrice, @FK_dxWarehouse, @FK_dxLocation, @UPC, @HS, @FDA, @DIN, @SalesItem, @PurchasedItem, @InventoryItem, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Note, @Active, @LifeSpanInDays, @NumberOfDaysBeforeEndOfSales, @FK_dxScaleUnit__PKG1, @FK_dxScaleUnit__PKG2, @FK_dxScaleUnit__PKG3, @FK_dxScaleUnit__PKG4, @FK_dxScaleUnit__PKG5, @PackingQuantity1, @PackingQuantity2, @PackingQuantity3, @PackingQuantity4, @PackingQuantity5, @FK_dxVendor__Default, @OrderLevelQuantity, @FK_dxScaleUnit__Vendor, @LeadTimeInDays, @TriggerOrderedQuantity, @OtherDescription, @Box_ID, @Case_ID, @Skid_ID, @Bulk_ID, @FixedLotSize, @MinLotSize, @EconomicLotSize, @FK_dxLotSizing, @SafetyStock, @DailyForecast, @ManufacturedItem, @ExcludeFromMRP, @Weight, @FK_dxScaleUnit__Weight, @Lenght, @FK_dxScaleUnit__Lenght, @Width, @FK_dxScaleUnit__Width, @Height, @FK_dxScaleUnit__Height, @Volume, @FK_dxScaleUnit__Volume, @Density, @FK_dxScaleUnit__Density, @Kit, @DefaultSalesOrderedQuantity, @FK_dxPropertyGroup, @ShortDescription, @Freight, @DoNotProduce, @DoNotPurchase, @FK_dxPropertyGroup__Compliance, @FK_dxWarehouse__Reception, @FK_dxLocation__Reception, @FK_dxScaleUnit__UnitAmount, @ManageReceptionPerUnit, @MinimumLevelQuantity, @MinimumBatchSize, @MaximumBatchSize, @ForecastType, @OtherID, @RefundPercentageOfTax1, @RefundPercentageOfTax2, @RefundPercentageOfTax3, @ForecastAdjustingFactor, @DocumentStatus, @ClientProduct, @TransitLeadTimeInDays, @LotNumberOfDaysForecast, @FK_dxPropertyGroup__WO_Compliance
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProduct, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', @EnglishDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishDescription', @SpanishDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProductCategory', @FK_dxProductCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', @FK_dxScaleUnit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'StandardPrice', @StandardPrice
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', @FK_dxWarehouse
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', @FK_dxLocation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'UPC', @UPC
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'HS', @HS
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FDA', @FDA
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DIN', @DIN
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'SalesItem', @SalesItem
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PurchasedItem', @PurchasedItem
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'InventoryItem', @InventoryItem
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax1', @ApplyTax1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax2', @ApplyTax2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax3', @ApplyTax3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'LifeSpanInDays', @LifeSpanInDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfDaysBeforeEndOfSales', @NumberOfDaysBeforeEndOfSales
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG1', @FK_dxScaleUnit__PKG1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG2', @FK_dxScaleUnit__PKG2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG3', @FK_dxScaleUnit__PKG3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG4', @FK_dxScaleUnit__PKG4
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG5', @FK_dxScaleUnit__PKG5
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity1', @PackingQuantity1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity2', @PackingQuantity2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity3', @PackingQuantity3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity4', @PackingQuantity4
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity5', @PackingQuantity5
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor__Default', @FK_dxVendor__Default
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderLevelQuantity', @OrderLevelQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Vendor', @FK_dxScaleUnit__Vendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'LeadTimeInDays', @LeadTimeInDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TriggerOrderedQuantity', @TriggerOrderedQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'OtherDescription', @OtherDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Box_ID', @Box_ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Case_ID', @Case_ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Skid_ID', @Skid_ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Bulk_ID', @Bulk_ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FixedLotSize', @FixedLotSize
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinLotSize', @MinLotSize
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EconomicLotSize', @EconomicLotSize
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLotSizing', @FK_dxLotSizing
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SafetyStock', @SafetyStock
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DailyForecast', @DailyForecast
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ManufacturedItem', @ManufacturedItem
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ExcludeFromMRP', @ExcludeFromMRP
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Weight', @Weight
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Weight', @FK_dxScaleUnit__Weight
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Lenght', @Lenght
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Lenght', @FK_dxScaleUnit__Lenght
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Width', @Width
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Width', @FK_dxScaleUnit__Width
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Height', @Height
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Height', @FK_dxScaleUnit__Height
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Volume', @Volume
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Volume', @FK_dxScaleUnit__Volume
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Density', @Density
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Density', @FK_dxScaleUnit__Density
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Kit', @Kit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DefaultSalesOrderedQuantity', @DefaultSalesOrderedQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', @FK_dxPropertyGroup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShortDescription', @ShortDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Freight', @Freight
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DoNotProduce', @DoNotProduce
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DoNotPurchase', @DoNotPurchase
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup__Compliance', @FK_dxPropertyGroup__Compliance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse__Reception', @FK_dxWarehouse__Reception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Reception', @FK_dxLocation__Reception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__UnitAmount', @FK_dxScaleUnit__UnitAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ManageReceptionPerUnit', @ManageReceptionPerUnit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinimumLevelQuantity', @MinimumLevelQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinimumBatchSize', @MinimumBatchSize
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MaximumBatchSize', @MaximumBatchSize
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ForecastType', @ForecastType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'OtherID', @OtherID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RefundPercentageOfTax1', @RefundPercentageOfTax1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RefundPercentageOfTax2', @RefundPercentageOfTax2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RefundPercentageOfTax3', @RefundPercentageOfTax3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ForecastAdjustingFactor', @ForecastAdjustingFactor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ClientProduct', @ClientProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'TransitLeadTimeInDays', @TransitLeadTimeInDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LotNumberOfDaysForecast', @LotNumberOfDaysForecast
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup__WO_Compliance', @FK_dxPropertyGroup__WO_Compliance
FETCH NEXT FROM pk_cursordxProduct INTO @PK_dxProduct, @ID, @Description, @EnglishDescription, @SpanishDescription, @FK_dxProductCategory, @FK_dxScaleUnit, @StandardPrice, @FK_dxWarehouse, @FK_dxLocation, @UPC, @HS, @FDA, @DIN, @SalesItem, @PurchasedItem, @InventoryItem, @ApplyTax1, @ApplyTax2, @ApplyTax3, @Note, @Active, @LifeSpanInDays, @NumberOfDaysBeforeEndOfSales, @FK_dxScaleUnit__PKG1, @FK_dxScaleUnit__PKG2, @FK_dxScaleUnit__PKG3, @FK_dxScaleUnit__PKG4, @FK_dxScaleUnit__PKG5, @PackingQuantity1, @PackingQuantity2, @PackingQuantity3, @PackingQuantity4, @PackingQuantity5, @FK_dxVendor__Default, @OrderLevelQuantity, @FK_dxScaleUnit__Vendor, @LeadTimeInDays, @TriggerOrderedQuantity, @OtherDescription, @Box_ID, @Case_ID, @Skid_ID, @Bulk_ID, @FixedLotSize, @MinLotSize, @EconomicLotSize, @FK_dxLotSizing, @SafetyStock, @DailyForecast, @ManufacturedItem, @ExcludeFromMRP, @Weight, @FK_dxScaleUnit__Weight, @Lenght, @FK_dxScaleUnit__Lenght, @Width, @FK_dxScaleUnit__Width, @Height, @FK_dxScaleUnit__Height, @Volume, @FK_dxScaleUnit__Volume, @Density, @FK_dxScaleUnit__Density, @Kit, @DefaultSalesOrderedQuantity, @FK_dxPropertyGroup, @ShortDescription, @Freight, @DoNotProduce, @DoNotPurchase, @FK_dxPropertyGroup__Compliance, @FK_dxWarehouse__Reception, @FK_dxLocation__Reception, @FK_dxScaleUnit__UnitAmount, @ManageReceptionPerUnit, @MinimumLevelQuantity, @MinimumBatchSize, @MaximumBatchSize, @ForecastType, @OtherID, @RefundPercentageOfTax1, @RefundPercentageOfTax2, @RefundPercentageOfTax3, @ForecastAdjustingFactor, @DocumentStatus, @ClientProduct, @TransitLeadTimeInDays, @LotNumberOfDaysForecast, @FK_dxPropertyGroup__WO_Compliance
 END

 CLOSE pk_cursordxProduct 
 DEALLOCATE pk_cursordxProduct
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProduct.trAuditInsUpd] ON [dbo].[dxProduct] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProduct CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProduct from inserted;
 set @tablename = 'dxProduct' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProduct
 FETCH NEXT FROM pk_cursordxProduct INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', EnglishDescription from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpanishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishDescription', SpanishDescription from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProductCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProductCategory', FK_dxProductCategory from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( StandardPrice )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'StandardPrice', StandardPrice from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UPC )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'UPC', UPC from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HS )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'HS', HS from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FDA )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FDA', FDA from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DIN )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DIN', DIN from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SalesItem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'SalesItem', SalesItem from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PurchasedItem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PurchasedItem', PurchasedItem from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InventoryItem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'InventoryItem', InventoryItem from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax1', ApplyTax1 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax2', ApplyTax2 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplyTax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplyTax3', ApplyTax3 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LifeSpanInDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'LifeSpanInDays', LifeSpanInDays from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfDaysBeforeEndOfSales )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfDaysBeforeEndOfSales', NumberOfDaysBeforeEndOfSales from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__PKG1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG1', FK_dxScaleUnit__PKG1 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__PKG2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG2', FK_dxScaleUnit__PKG2 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__PKG3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG3', FK_dxScaleUnit__PKG3 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__PKG4 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG4', FK_dxScaleUnit__PKG4 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__PKG5 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__PKG5', FK_dxScaleUnit__PKG5 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PackingQuantity1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity1', PackingQuantity1 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PackingQuantity2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity2', PackingQuantity2 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PackingQuantity3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity3', PackingQuantity3 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PackingQuantity4 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity4', PackingQuantity4 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PackingQuantity5 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PackingQuantity5', PackingQuantity5 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor__Default )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor__Default', FK_dxVendor__Default from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OrderLevelQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderLevelQuantity', OrderLevelQuantity from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Vendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Vendor', FK_dxScaleUnit__Vendor from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LeadTimeInDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'LeadTimeInDays', LeadTimeInDays from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TriggerOrderedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TriggerOrderedQuantity', TriggerOrderedQuantity from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OtherDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'OtherDescription', OtherDescription from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Box_ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Box_ID', Box_ID from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Case_ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Case_ID', Case_ID from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Skid_ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Skid_ID', Skid_ID from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Bulk_ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Bulk_ID', Bulk_ID from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FixedLotSize )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FixedLotSize', FixedLotSize from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MinLotSize )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinLotSize', MinLotSize from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EconomicLotSize )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EconomicLotSize', EconomicLotSize from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLotSizing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLotSizing', FK_dxLotSizing from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SafetyStock )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SafetyStock', SafetyStock from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DailyForecast )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DailyForecast', DailyForecast from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ManufacturedItem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ManufacturedItem', ManufacturedItem from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExcludeFromMRP )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ExcludeFromMRP', ExcludeFromMRP from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Weight )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Weight', Weight from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Weight )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Weight', FK_dxScaleUnit__Weight from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lenght )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Lenght', Lenght from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Lenght )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Lenght', FK_dxScaleUnit__Lenght from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Width )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Width', Width from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Width )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Width', FK_dxScaleUnit__Width from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Height )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Height', Height from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Height )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Height', FK_dxScaleUnit__Height from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Volume )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Volume', Volume from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Volume )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Volume', FK_dxScaleUnit__Volume from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Density )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Density', Density from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__Density )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__Density', FK_dxScaleUnit__Density from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Kit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Kit', Kit from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DefaultSalesOrderedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DefaultSalesOrderedQuantity', DefaultSalesOrderedQuantity from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPropertyGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', FK_dxPropertyGroup from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShortDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShortDescription', ShortDescription from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Freight )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Freight', Freight from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DoNotProduce )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DoNotProduce', DoNotProduce from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DoNotPurchase )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DoNotPurchase', DoNotPurchase from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPropertyGroup__Compliance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup__Compliance', FK_dxPropertyGroup__Compliance from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse__Reception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse__Reception', FK_dxWarehouse__Reception from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation__Reception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Reception', FK_dxLocation__Reception from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit__UnitAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit__UnitAmount', FK_dxScaleUnit__UnitAmount from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ManageReceptionPerUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ManageReceptionPerUnit', ManageReceptionPerUnit from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MinimumLevelQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinimumLevelQuantity', MinimumLevelQuantity from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MinimumBatchSize )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MinimumBatchSize', MinimumBatchSize from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MaximumBatchSize )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MaximumBatchSize', MaximumBatchSize from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ForecastType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ForecastType', ForecastType from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OtherID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'OtherID', OtherID from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RefundPercentageOfTax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RefundPercentageOfTax1', RefundPercentageOfTax1 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RefundPercentageOfTax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RefundPercentageOfTax2', RefundPercentageOfTax2 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RefundPercentageOfTax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RefundPercentageOfTax3', RefundPercentageOfTax3 from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ForecastAdjustingFactor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ForecastAdjustingFactor', ForecastAdjustingFactor from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ClientProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ClientProduct', ClientProduct from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransitLeadTimeInDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'TransitLeadTimeInDays', TransitLeadTimeInDays from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LotNumberOfDaysForecast )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LotNumberOfDaysForecast', LotNumberOfDaysForecast from dxProduct where PK_dxProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPropertyGroup__WO_Compliance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup__WO_Compliance', FK_dxPropertyGroup__WO_Compliance from dxProduct where PK_dxProduct = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProduct INTO @keyvalue
 END

 CLOSE pk_cursordxProduct 
 DEALLOCATE pk_cursordxProduct
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxProduct.trDeleteProduct] ON [dbo].[dxProduct]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  delete from dxProductForecastPerMonth where FK_dxProduct in (SELECT PK_dxProduct FROM deleted) ;
  delete from dxProductForecastPerWeek  where FK_dxProduct in (SELECT PK_dxProduct FROM deleted) ;
  delete from dxProduct                 where PK_dxProduct in (SELECT PK_dxProduct FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [PK_dxProduct] PRIMARY KEY CLUSTERED  ([PK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxLocation] ON [dbo].[dxProduct] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxLocation__Reception] ON [dbo].[dxProduct] ([FK_dxLocation__Reception]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxLotSizing] ON [dbo].[dxProduct] ([FK_dxLotSizing]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxProductCategory] ON [dbo].[dxProduct] ([FK_dxProductCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxPropertyGroup] ON [dbo].[dxProduct] ([FK_dxPropertyGroup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxPropertyGroup__Compliance] ON [dbo].[dxProduct] ([FK_dxPropertyGroup__Compliance]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxPropertyGroup__WO_Compliance] ON [dbo].[dxProduct] ([FK_dxPropertyGroup__WO_Compliance]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit] ON [dbo].[dxProduct] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__Density] ON [dbo].[dxProduct] ([FK_dxScaleUnit__Density]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__Height] ON [dbo].[dxProduct] ([FK_dxScaleUnit__Height]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__Lenght] ON [dbo].[dxProduct] ([FK_dxScaleUnit__Lenght]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__PKG1] ON [dbo].[dxProduct] ([FK_dxScaleUnit__PKG1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__PKG2] ON [dbo].[dxProduct] ([FK_dxScaleUnit__PKG2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__PKG3] ON [dbo].[dxProduct] ([FK_dxScaleUnit__PKG3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__PKG4] ON [dbo].[dxProduct] ([FK_dxScaleUnit__PKG4]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__PKG5] ON [dbo].[dxProduct] ([FK_dxScaleUnit__PKG5]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__UnitAmount] ON [dbo].[dxProduct] ([FK_dxScaleUnit__UnitAmount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__Vendor] ON [dbo].[dxProduct] ([FK_dxScaleUnit__Vendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__Volume] ON [dbo].[dxProduct] ([FK_dxScaleUnit__Volume]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__Weight] ON [dbo].[dxProduct] ([FK_dxScaleUnit__Weight]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxScaleUnit__Width] ON [dbo].[dxProduct] ([FK_dxScaleUnit__Width]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxVendor__Default] ON [dbo].[dxProduct] ([FK_dxVendor__Default]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxWarehouse] ON [dbo].[dxProduct] ([FK_dxWarehouse]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProduct_FK_dxWarehouse__Reception] ON [dbo].[dxProduct] ([FK_dxWarehouse__Reception]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxProduct] ON [dbo].[dxProduct] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxProduct] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxLocation__Reception_dxProduct] FOREIGN KEY ([FK_dxLocation__Reception]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxLotSizing_dxProduct] FOREIGN KEY ([FK_dxLotSizing]) REFERENCES [dbo].[dxLotSizing] ([PK_dxLotSizing])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxProductCategory_dxProduct] FOREIGN KEY ([FK_dxProductCategory]) REFERENCES [dbo].[dxProductCategory] ([PK_dxProductCategory])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxPropertyGroup_dxProduct] FOREIGN KEY ([FK_dxPropertyGroup]) REFERENCES [dbo].[dxPropertyGroup] ([PK_dxPropertyGroup])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxPropertyGroup__Compliance_dxProduct] FOREIGN KEY ([FK_dxPropertyGroup__Compliance]) REFERENCES [dbo].[dxPropertyGroup] ([PK_dxPropertyGroup])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxPropertyGroup__WO_Compliance_dxProduct] FOREIGN KEY ([FK_dxPropertyGroup__WO_Compliance]) REFERENCES [dbo].[dxPropertyGroup] ([PK_dxPropertyGroup])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxProduct] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Density_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__Density]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Height_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__Height]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Lenght_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__Lenght]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__PKG1_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__PKG1]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__PKG2_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__PKG2]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__PKG3_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__PKG3]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__PKG4_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__PKG4]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__PKG5_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__PKG5]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__UnitAmount_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__UnitAmount]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Vendor_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__Vendor]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Volume_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__Volume]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Weight_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__Weight]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit__Width_dxProduct] FOREIGN KEY ([FK_dxScaleUnit__Width]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxVendor__Default_dxProduct] FOREIGN KEY ([FK_dxVendor__Default]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxProduct] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
ALTER TABLE [dbo].[dxProduct] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse__Reception_dxProduct] FOREIGN KEY ([FK_dxWarehouse__Reception]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
