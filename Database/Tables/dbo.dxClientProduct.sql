CREATE TABLE [dbo].[dxClientProduct]
(
[PK_dxClientProduct] [int] NOT NULL IDENTITY(1, 1),
[FK_dxClient] [int] NOT NULL,
[FK_dxProduct] [int] NOT NULL,
[NumberOfDaysBeforeEndOfSales] [int] NOT NULL CONSTRAINT [DF_dxClientProduct_NumberOfDayBeforeEndOfSale] DEFAULT ((0)),
[ClientProductName] [varchar] (50) COLLATE French_CI_AS NULL,
[ClientProductDescription] [varchar] (255) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientProduct.trAuditDelete] ON [dbo].[dxClientProduct]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientProduct'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientProduct CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientProduct, FK_dxClient, FK_dxProduct, NumberOfDaysBeforeEndOfSales, ClientProductName, ClientProductDescription from deleted
 Declare @PK_dxClientProduct int, @FK_dxClient int, @FK_dxProduct int, @NumberOfDaysBeforeEndOfSales int, @ClientProductName varchar(50), @ClientProductDescription varchar(255)

 OPEN pk_cursordxClientProduct
 FETCH NEXT FROM pk_cursordxClientProduct INTO @PK_dxClientProduct, @FK_dxClient, @FK_dxProduct, @NumberOfDaysBeforeEndOfSales, @ClientProductName, @ClientProductDescription
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientProduct, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfDaysBeforeEndOfSales', @NumberOfDaysBeforeEndOfSales
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ClientProductName', @ClientProductName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ClientProductDescription', @ClientProductDescription
FETCH NEXT FROM pk_cursordxClientProduct INTO @PK_dxClientProduct, @FK_dxClient, @FK_dxProduct, @NumberOfDaysBeforeEndOfSales, @ClientProductName, @ClientProductDescription
 END

 CLOSE pk_cursordxClientProduct 
 DEALLOCATE pk_cursordxClientProduct
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientProduct.trAuditInsUpd] ON [dbo].[dxClientProduct] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientProduct CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientProduct from inserted;
 set @tablename = 'dxClientProduct' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientProduct
 FETCH NEXT FROM pk_cursordxClientProduct INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxClientProduct where PK_dxClientProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxClientProduct where PK_dxClientProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfDaysBeforeEndOfSales )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfDaysBeforeEndOfSales', NumberOfDaysBeforeEndOfSales from dxClientProduct where PK_dxClientProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ClientProductName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ClientProductName', ClientProductName from dxClientProduct where PK_dxClientProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ClientProductDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ClientProductDescription', ClientProductDescription from dxClientProduct where PK_dxClientProduct = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientProduct INTO @keyvalue
 END

 CLOSE pk_cursordxClientProduct 
 DEALLOCATE pk_cursordxClientProduct
GO
ALTER TABLE [dbo].[dxClientProduct] ADD CONSTRAINT [PK_dxClientProduct] PRIMARY KEY CLUSTERED  ([PK_dxClientProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientProduct_FK_dxClient] ON [dbo].[dxClientProduct] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxClientProduct] ON [dbo].[dxClientProduct] ([FK_dxClient], [FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientProduct_FK_dxProduct] ON [dbo].[dxClientProduct] ([FK_dxProduct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxClientProduct] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxClientProduct] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxClientProduct] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxClientProduct] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
