CREATE TABLE [dbo].[dxClientProductForecast]
(
[PK_dxClientProductForecast] [int] NOT NULL IDENTITY(1, 1),
[FK_dxClient] [int] NOT NULL,
[FK_dxAccountingYear] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[JanuaryQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_JanuaryQuantity] DEFAULT ((0.0)),
[FebruaryQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_FebruaryQuantity] DEFAULT ((0.0)),
[MarchQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_MarchQuantity] DEFAULT ((0.0)),
[AprilQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_AprilQuantity] DEFAULT ((0.0)),
[MayQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_MayQuantity] DEFAULT ((0.0)),
[JuneQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_JuneQuantity] DEFAULT ((0.0)),
[JulyQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_JulyQuantity] DEFAULT ((0.0)),
[AugustQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_AugustQuantity] DEFAULT ((0.0)),
[SeptemberQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_SeptemberQuantity] DEFAULT ((0.0)),
[OctoberQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_OctoberQuantity] DEFAULT ((0.0)),
[NovemberQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_NovemberQuantity] DEFAULT ((0.0)),
[DecemberQuantity] [float] NOT NULL CONSTRAINT [DF_dxClientProductForecast_DecemberQuantity] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientProductForecast.trAuditDelete] ON [dbo].[dxClientProductForecast]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientProductForecast'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientProductForecast CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientProductForecast, FK_dxClient, FK_dxAccountingYear, FK_dxProduct, JanuaryQuantity, FebruaryQuantity, MarchQuantity, AprilQuantity, MayQuantity, JuneQuantity, JulyQuantity, AugustQuantity, SeptemberQuantity, OctoberQuantity, NovemberQuantity, DecemberQuantity from deleted
 Declare @PK_dxClientProductForecast int, @FK_dxClient int, @FK_dxAccountingYear int, @FK_dxProduct int, @JanuaryQuantity Float, @FebruaryQuantity Float, @MarchQuantity Float, @AprilQuantity Float, @MayQuantity Float, @JuneQuantity Float, @JulyQuantity Float, @AugustQuantity Float, @SeptemberQuantity Float, @OctoberQuantity Float, @NovemberQuantity Float, @DecemberQuantity Float

 OPEN pk_cursordxClientProductForecast
 FETCH NEXT FROM pk_cursordxClientProductForecast INTO @PK_dxClientProductForecast, @FK_dxClient, @FK_dxAccountingYear, @FK_dxProduct, @JanuaryQuantity, @FebruaryQuantity, @MarchQuantity, @AprilQuantity, @MayQuantity, @JuneQuantity, @JulyQuantity, @AugustQuantity, @SeptemberQuantity, @OctoberQuantity, @NovemberQuantity, @DecemberQuantity
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientProductForecast, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountingYear', @FK_dxAccountingYear
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JanuaryQuantity', @JanuaryQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FebruaryQuantity', @FebruaryQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MarchQuantity', @MarchQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AprilQuantity', @AprilQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MayQuantity', @MayQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JuneQuantity', @JuneQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JulyQuantity', @JulyQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AugustQuantity', @AugustQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SeptemberQuantity', @SeptemberQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OctoberQuantity', @OctoberQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NovemberQuantity', @NovemberQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DecemberQuantity', @DecemberQuantity
FETCH NEXT FROM pk_cursordxClientProductForecast INTO @PK_dxClientProductForecast, @FK_dxClient, @FK_dxAccountingYear, @FK_dxProduct, @JanuaryQuantity, @FebruaryQuantity, @MarchQuantity, @AprilQuantity, @MayQuantity, @JuneQuantity, @JulyQuantity, @AugustQuantity, @SeptemberQuantity, @OctoberQuantity, @NovemberQuantity, @DecemberQuantity
 END

 CLOSE pk_cursordxClientProductForecast 
 DEALLOCATE pk_cursordxClientProductForecast
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientProductForecast.trAuditInsUpd] ON [dbo].[dxClientProductForecast] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientProductForecast CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientProductForecast from inserted;
 set @tablename = 'dxClientProductForecast' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientProductForecast
 FETCH NEXT FROM pk_cursordxClientProductForecast INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccountingYear )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountingYear', FK_dxAccountingYear from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( JanuaryQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JanuaryQuantity', JanuaryQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FebruaryQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FebruaryQuantity', FebruaryQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MarchQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MarchQuantity', MarchQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AprilQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AprilQuantity', AprilQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MayQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MayQuantity', MayQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( JuneQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JuneQuantity', JuneQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( JulyQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JulyQuantity', JulyQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AugustQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AugustQuantity', AugustQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SeptemberQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SeptemberQuantity', SeptemberQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OctoberQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OctoberQuantity', OctoberQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NovemberQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NovemberQuantity', NovemberQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DecemberQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DecemberQuantity', DecemberQuantity from dxClientProductForecast where PK_dxClientProductForecast = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientProductForecast INTO @keyvalue
 END

 CLOSE pk_cursordxClientProductForecast 
 DEALLOCATE pk_cursordxClientProductForecast
GO
ALTER TABLE [dbo].[dxClientProductForecast] ADD CONSTRAINT [PK_dxClientProductForecast] PRIMARY KEY CLUSTERED  ([PK_dxClientProductForecast]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientProductForecast_FK_dxAccountingYear] ON [dbo].[dxClientProductForecast] ([FK_dxAccountingYear]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientProductForecast_FK_dxClient] ON [dbo].[dxClientProductForecast] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientProductForecast_FK_dxProduct] ON [dbo].[dxClientProductForecast] ([FK_dxProduct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxClientProductForecast] ADD CONSTRAINT [dxConstraint_FK_dxAccountingYear_dxClientProductForecast] FOREIGN KEY ([FK_dxAccountingYear]) REFERENCES [dbo].[dxAccountingYear] ([PK_dxAccountingYear])
GO
ALTER TABLE [dbo].[dxClientProductForecast] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxClientProductForecast] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxClientProductForecast] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxClientProductForecast] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
