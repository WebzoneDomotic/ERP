CREATE TABLE [dbo].[dxVendorProduct]
(
[PK_dxVendorProduct] [int] NOT NULL IDENTITY(1, 1),
[FK_dxVendor] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[VendorProductName] [varchar] (50) COLLATE French_CI_AS NULL,
[VendorProductDescription] [varchar] (255) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxVendorProduct.trAuditDelete] ON [dbo].[dxVendorProduct]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxVendorProduct'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxVendorProduct CURSOR LOCAL FAST_FORWARD for SELECT PK_dxVendorProduct, FK_dxVendor, FK_dxProduct, VendorProductName, VendorProductDescription from deleted
 Declare @PK_dxVendorProduct int, @FK_dxVendor int, @FK_dxProduct int, @VendorProductName varchar(50), @VendorProductDescription varchar(255)

 OPEN pk_cursordxVendorProduct
 FETCH NEXT FROM pk_cursordxVendorProduct INTO @PK_dxVendorProduct, @FK_dxVendor, @FK_dxProduct, @VendorProductName, @VendorProductDescription
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxVendorProduct, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorProductName', @VendorProductName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorProductDescription', @VendorProductDescription
FETCH NEXT FROM pk_cursordxVendorProduct INTO @PK_dxVendorProduct, @FK_dxVendor, @FK_dxProduct, @VendorProductName, @VendorProductDescription
 END

 CLOSE pk_cursordxVendorProduct 
 DEALLOCATE pk_cursordxVendorProduct
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxVendorProduct.trAuditInsUpd] ON [dbo].[dxVendorProduct] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxVendorProduct CURSOR LOCAL FAST_FORWARD for SELECT PK_dxVendorProduct from inserted;
 set @tablename = 'dxVendorProduct' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxVendorProduct
 FETCH NEXT FROM pk_cursordxVendorProduct INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxVendorProduct where PK_dxVendorProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxVendorProduct where PK_dxVendorProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( VendorProductName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorProductName', VendorProductName from dxVendorProduct where PK_dxVendorProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( VendorProductDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorProductDescription', VendorProductDescription from dxVendorProduct where PK_dxVendorProduct = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxVendorProduct INTO @keyvalue
 END

 CLOSE pk_cursordxVendorProduct 
 DEALLOCATE pk_cursordxVendorProduct
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendorProduct_FK_dxProduct] ON [dbo].[dxVendorProduct] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendorProduct_FK_dxVendor] ON [dbo].[dxVendorProduct] ([FK_dxVendor]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxVendorProduct] ON [dbo].[dxVendorProduct] ([FK_dxVendor], [FK_dxProduct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxVendorProduct] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxVendorProduct] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxVendorProduct] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxVendorProduct] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
