CREATE TABLE [dbo].[dxAccountRevenue]
(
[PK_dxAccountRevenue] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxAccountRevenue]),
[FK_dxCurrency] [int] NULL,
[FK_dxTax] [int] NULL,
[FK_dxPriceLevel] [int] NULL,
[FK_dxProjectCategory] [int] NULL,
[FK_dxProject] [int] NULL,
[FK_dxClientCategory] [int] NULL,
[FK_dxClient] [int] NULL,
[FK_dxProductCategory] [int] NULL,
[FK_dxProduct] [int] NULL,
[FK_dxAccount__Revenue] [int] NULL,
[FK_dxAccount__Discount] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountRevenue.trAuditDelete] ON [dbo].[dxAccountRevenue]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAccountRevenue'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAccountRevenue CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccountRevenue, ID, FK_dxCurrency, FK_dxTax, FK_dxPriceLevel, FK_dxProjectCategory, FK_dxProject, FK_dxClientCategory, FK_dxClient, FK_dxProductCategory, FK_dxProduct, FK_dxAccount__Revenue, FK_dxAccount__Discount from deleted
 Declare @PK_dxAccountRevenue int, @ID int, @FK_dxCurrency int, @FK_dxTax int, @FK_dxPriceLevel int, @FK_dxProjectCategory int, @FK_dxProject int, @FK_dxClientCategory int, @FK_dxClient int, @FK_dxProductCategory int, @FK_dxProduct int, @FK_dxAccount__Revenue int, @FK_dxAccount__Discount int

 OPEN pk_cursordxAccountRevenue
 FETCH NEXT FROM pk_cursordxAccountRevenue INTO @PK_dxAccountRevenue, @ID, @FK_dxCurrency, @FK_dxTax, @FK_dxPriceLevel, @FK_dxProjectCategory, @FK_dxProject, @FK_dxClientCategory, @FK_dxClient, @FK_dxProductCategory, @FK_dxProduct, @FK_dxAccount__Revenue, @FK_dxAccount__Discount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAccountRevenue, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', @FK_dxTax
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevel', @FK_dxPriceLevel
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProjectCategory', @FK_dxProjectCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', @FK_dxProject
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientCategory', @FK_dxClientCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProductCategory', @FK_dxProductCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Revenue', @FK_dxAccount__Revenue
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Discount', @FK_dxAccount__Discount
FETCH NEXT FROM pk_cursordxAccountRevenue INTO @PK_dxAccountRevenue, @ID, @FK_dxCurrency, @FK_dxTax, @FK_dxPriceLevel, @FK_dxProjectCategory, @FK_dxProject, @FK_dxClientCategory, @FK_dxClient, @FK_dxProductCategory, @FK_dxProduct, @FK_dxAccount__Revenue, @FK_dxAccount__Discount
 END

 CLOSE pk_cursordxAccountRevenue 
 DEALLOCATE pk_cursordxAccountRevenue
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountRevenue.trAuditInsUpd] ON [dbo].[dxAccountRevenue] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAccountRevenue CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccountRevenue from inserted;
 set @tablename = 'dxAccountRevenue' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAccountRevenue
 FETCH NEXT FROM pk_cursordxAccountRevenue INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', FK_dxTax from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPriceLevel )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevel', FK_dxPriceLevel from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProjectCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProjectCategory', FK_dxProjectCategory from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientCategory', FK_dxClientCategory from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProductCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProductCategory', FK_dxProductCategory from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Revenue )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Revenue', FK_dxAccount__Revenue from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Discount', FK_dxAccount__Discount from dxAccountRevenue where PK_dxAccountRevenue = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAccountRevenue INTO @keyvalue
 END

 CLOSE pk_cursordxAccountRevenue 
 DEALLOCATE pk_cursordxAccountRevenue
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [PK_AccountRevenue] PRIMARY KEY CLUSTERED  ([PK_dxAccountRevenue]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxAccount__Discount] ON [dbo].[dxAccountRevenue] ([FK_dxAccount__Discount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxAccount__Revenue] ON [dbo].[dxAccountRevenue] ([FK_dxAccount__Revenue]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxClient] ON [dbo].[dxAccountRevenue] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxClientCategory] ON [dbo].[dxAccountRevenue] ([FK_dxClientCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxCurrency] ON [dbo].[dxAccountRevenue] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxPriceLevel] ON [dbo].[dxAccountRevenue] ([FK_dxPriceLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxProduct] ON [dbo].[dxAccountRevenue] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxProductCategory] ON [dbo].[dxAccountRevenue] ([FK_dxProductCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxProject] ON [dbo].[dxAccountRevenue] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxProjectCategory] ON [dbo].[dxAccountRevenue] ([FK_dxProjectCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountRevenue_FK_dxTax] ON [dbo].[dxAccountRevenue] ([FK_dxTax]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Discount_dxAccountRevenue] FOREIGN KEY ([FK_dxAccount__Discount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Revenue_dxAccountRevenue] FOREIGN KEY ([FK_dxAccount__Revenue]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxAccountRevenue] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxClientCategory_dxAccountRevenue] FOREIGN KEY ([FK_dxClientCategory]) REFERENCES [dbo].[dxClientCategory] ([PK_dxClientCategory])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxAccountRevenue] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxPriceLevel_dxAccountRevenue] FOREIGN KEY ([FK_dxPriceLevel]) REFERENCES [dbo].[dxPriceLevel] ([PK_dxPriceLevel])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxAccountRevenue] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxProductCategory_dxAccountRevenue] FOREIGN KEY ([FK_dxProductCategory]) REFERENCES [dbo].[dxProductCategory] ([PK_dxProductCategory])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxAccountRevenue] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxProjectCategory_dxAccountRevenue] FOREIGN KEY ([FK_dxProjectCategory]) REFERENCES [dbo].[dxProjectCategory] ([PK_dxProjectCategory])
GO
ALTER TABLE [dbo].[dxAccountRevenue] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxAccountRevenue] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
