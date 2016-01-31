CREATE TABLE [dbo].[dxDeclarationDismantling]
(
[PK_dxDeclarationDismantling] [int] NOT NULL IDENTITY(1, 1),
[FK_dxDeclaration] [int] NOT NULL,
[Rank] [float] NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_Rank] DEFAULT ((0.0)),
[FK_dxWarehouse] [int] NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_FK_dxWarehouse] DEFAULT ((1)),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_FK_dxLocation] DEFAULT ((1)),
[FK_dxProduct] [int] NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_FK_dxProduct] DEFAULT ((1)),
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_Lot] DEFAULT ('0'),
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_Quantitty] DEFAULT ((0.0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_Posted] DEFAULT ((0)),
[ReworkRequired] [bit] NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_ReworkRequired] DEFAULT ((0)),
[PurchaseRequired] [bit] NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_PurchaseRequired] DEFAULT ((0)),
[Note] [varchar] (8000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeclarationDismantling.trAuditDelete] ON [dbo].[dxDeclarationDismantling]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxDeclarationDismantling'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxDeclarationDismantling CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDeclarationDismantling, FK_dxDeclaration, Rank, FK_dxWarehouse, FK_dxLocation, FK_dxProduct, Lot, Quantity, Posted, ReworkRequired, PurchaseRequired, Note from deleted
 Declare @PK_dxDeclarationDismantling int, @FK_dxDeclaration int, @Rank Float, @FK_dxWarehouse int, @FK_dxLocation int, @FK_dxProduct int, @Lot varchar(50), @Quantity Float, @Posted Bit, @ReworkRequired Bit, @PurchaseRequired Bit, @Note varchar(8000)

 OPEN pk_cursordxDeclarationDismantling
 FETCH NEXT FROM pk_cursordxDeclarationDismantling INTO @PK_dxDeclarationDismantling, @FK_dxDeclaration, @Rank, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Quantity, @Posted, @ReworkRequired, @PurchaseRequired, @Note
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxDeclarationDismantling, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeclaration', @FK_dxDeclaration
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', @FK_dxWarehouse
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', @FK_dxLocation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', @Lot
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', @Quantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ReworkRequired', @ReworkRequired
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PurchaseRequired', @PurchaseRequired
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
FETCH NEXT FROM pk_cursordxDeclarationDismantling INTO @PK_dxDeclarationDismantling, @FK_dxDeclaration, @Rank, @FK_dxWarehouse, @FK_dxLocation, @FK_dxProduct, @Lot, @Quantity, @Posted, @ReworkRequired, @PurchaseRequired, @Note
 END

 CLOSE pk_cursordxDeclarationDismantling 
 DEALLOCATE pk_cursordxDeclarationDismantling
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeclarationDismantling.trAuditInsUpd] ON [dbo].[dxDeclarationDismantling] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxDeclarationDismantling CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDeclarationDismantling from inserted;
 set @tablename = 'dxDeclarationDismantling' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxDeclarationDismantling
 FETCH NEXT FROM pk_cursordxDeclarationDismantling INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDeclaration )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeclaration', FK_dxDeclaration from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReworkRequired )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ReworkRequired', ReworkRequired from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PurchaseRequired )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PurchaseRequired', PurchaseRequired from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxDeclarationDismantling where PK_dxDeclarationDismantling = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxDeclarationDismantling INTO @keyvalue
 END

 CLOSE pk_cursordxDeclarationDismantling 
 DEALLOCATE pk_cursordxDeclarationDismantling
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeclarationDismantling.trCreatePOFromRework] ON [dbo].[dxDeclarationDismantling]
AFTER UPDATE
AS
BEGIN
   Declare @FK_dxDeclarationDismantling int
   if Update (Posted)
   begin
       -- Create PO if posted
       set @FK_dxDeclarationDismantling = Coalesce(( select max(PK_dxDeclarationDismantling) from inserted where Posted = 1 and PurchaseRequired =1 ), -1)
       if @FK_dxDeclarationDismantling > -1
         Execute [dbo].[pdxCreatePOFromRework] @FK_dxDeclarationDismantling

       -- Try to delete WO if unposted
       set @FK_dxDeclarationDismantling = Coalesce(( select max(PK_dxDeclarationDismantling) from inserted where Posted = 0 and PurchaseRequired =1), -1)
       if @FK_dxDeclarationDismantling > -1
         Delete from dxPurchaseOrder where FK_dxDeclarationDismantling = @FK_dxDeclarationDismantling and Posted = 0
   end;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxDeclarationDismantling.trCreateWOFromRework] ON [dbo].[dxDeclarationDismantling]
AFTER UPDATE
AS
BEGIN
   Declare @FK_dxDeclarationDismantling int
   if Update (Posted) 
   begin
       -- Create WO if posted
       set @FK_dxDeclarationDismantling = Coalesce(( select max(PK_dxDeclarationDismantling) from inserted where Posted = 1 and ReworkRequired =1), -1)
       if @FK_dxDeclarationDismantling > -1 
         Execute pdxCreateWOFromRework @FK_dxDeclarationDismantling
       
       -- Try to delete WO if unposted
       set @FK_dxDeclarationDismantling = Coalesce(( select max(PK_dxDeclarationDismantling) from inserted where Posted = 0 and ReworkRequired =1), -1)
       if @FK_dxDeclarationDismantling > -1 
         Delete from dxWorkOrder where FK_dxDeclarationDismantling = @FK_dxDeclarationDismantling
   end;
END
GO
ALTER TABLE [dbo].[dxDeclarationDismantling] ADD CONSTRAINT [PK_dxDeclarationDismantling] PRIMARY KEY CLUSTERED  ([PK_dxDeclarationDismantling]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationDismantling_FK_dxDeclaration] ON [dbo].[dxDeclarationDismantling] ([FK_dxDeclaration]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationDismantling_FK_dxLocation] ON [dbo].[dxDeclarationDismantling] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationDismantling_FK_dxProduct] ON [dbo].[dxDeclarationDismantling] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclarationDismantling_FK_dxWarehouse] ON [dbo].[dxDeclarationDismantling] ([FK_dxWarehouse]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDeclarationDismantling] ADD CONSTRAINT [dxConstraint_FK_dxDeclaration_dxDeclarationDismantling] FOREIGN KEY ([FK_dxDeclaration]) REFERENCES [dbo].[dxDeclaration] ([PK_dxDeclaration])
GO
ALTER TABLE [dbo].[dxDeclarationDismantling] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxDeclarationDismantling] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxDeclarationDismantling] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxDeclarationDismantling] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxDeclarationDismantling] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxDeclarationDismantling] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
