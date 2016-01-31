CREATE TABLE [dbo].[dxAccountExpense]
(
[PK_dxAccountExpense] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxAccountExpense]),
[FK_dxCurrency] [int] NULL,
[FK_dxTax] [int] NULL,
[FK_dxProjectCategory] [int] NULL,
[FK_dxProject] [int] NULL,
[FK_dxCostLevel] [int] NULL,
[FK_dxVendorCategory] [int] NULL,
[FK_dxVendor] [int] NULL,
[FK_dxProductCategory] [int] NULL,
[FK_dxProduct] [int] NULL,
[FK_dxAccount__Expense] [int] NULL,
[FK_dxAccount__Discount] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountExpense.trAuditDelete] ON [dbo].[dxAccountExpense]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAccountExpense'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAccountExpense CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccountExpense, ID, FK_dxCurrency, FK_dxTax, FK_dxProjectCategory, FK_dxProject, FK_dxCostLevel, FK_dxVendorCategory, FK_dxVendor, FK_dxProductCategory, FK_dxProduct, FK_dxAccount__Expense, FK_dxAccount__Discount from deleted
 Declare @PK_dxAccountExpense int, @ID int, @FK_dxCurrency int, @FK_dxTax int, @FK_dxProjectCategory int, @FK_dxProject int, @FK_dxCostLevel int, @FK_dxVendorCategory int, @FK_dxVendor int, @FK_dxProductCategory int, @FK_dxProduct int, @FK_dxAccount__Expense int, @FK_dxAccount__Discount int

 OPEN pk_cursordxAccountExpense
 FETCH NEXT FROM pk_cursordxAccountExpense INTO @PK_dxAccountExpense, @ID, @FK_dxCurrency, @FK_dxTax, @FK_dxProjectCategory, @FK_dxProject, @FK_dxCostLevel, @FK_dxVendorCategory, @FK_dxVendor, @FK_dxProductCategory, @FK_dxProduct, @FK_dxAccount__Expense, @FK_dxAccount__Discount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAccountExpense, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', @FK_dxTax
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProjectCategory', @FK_dxProjectCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', @FK_dxProject
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCostLevel', @FK_dxCostLevel
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendorCategory', @FK_dxVendorCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProductCategory', @FK_dxProductCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Expense', @FK_dxAccount__Expense
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Discount', @FK_dxAccount__Discount
FETCH NEXT FROM pk_cursordxAccountExpense INTO @PK_dxAccountExpense, @ID, @FK_dxCurrency, @FK_dxTax, @FK_dxProjectCategory, @FK_dxProject, @FK_dxCostLevel, @FK_dxVendorCategory, @FK_dxVendor, @FK_dxProductCategory, @FK_dxProduct, @FK_dxAccount__Expense, @FK_dxAccount__Discount
 END

 CLOSE pk_cursordxAccountExpense 
 DEALLOCATE pk_cursordxAccountExpense
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountExpense.trAuditInsUpd] ON [dbo].[dxAccountExpense] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAccountExpense CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccountExpense from inserted;
 set @tablename = 'dxAccountExpense' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAccountExpense
 FETCH NEXT FROM pk_cursordxAccountExpense INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', FK_dxTax from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProjectCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProjectCategory', FK_dxProjectCategory from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCostLevel )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCostLevel', FK_dxCostLevel from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendorCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendorCategory', FK_dxVendorCategory from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProductCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProductCategory', FK_dxProductCategory from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Expense )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Expense', FK_dxAccount__Expense from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Discount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Discount', FK_dxAccount__Discount from dxAccountExpense where PK_dxAccountExpense = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAccountExpense INTO @keyvalue
 END

 CLOSE pk_cursordxAccountExpense 
 DEALLOCATE pk_cursordxAccountExpense
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [PK_dxAccountExpense] PRIMARY KEY CLUSTERED  ([PK_dxAccountExpense]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxAccount__Discount] ON [dbo].[dxAccountExpense] ([FK_dxAccount__Discount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxAccount__Expense] ON [dbo].[dxAccountExpense] ([FK_dxAccount__Expense]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxCostLevel] ON [dbo].[dxAccountExpense] ([FK_dxCostLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxCurrency] ON [dbo].[dxAccountExpense] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxProduct] ON [dbo].[dxAccountExpense] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxProductCategory] ON [dbo].[dxAccountExpense] ([FK_dxProductCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxProject] ON [dbo].[dxAccountExpense] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxProjectCategory] ON [dbo].[dxAccountExpense] ([FK_dxProjectCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxTax] ON [dbo].[dxAccountExpense] ([FK_dxTax]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxVendor] ON [dbo].[dxAccountExpense] ([FK_dxVendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountExpense_FK_dxVendorCategory] ON [dbo].[dxAccountExpense] ([FK_dxVendorCategory]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Discount_dxAccountExpense] FOREIGN KEY ([FK_dxAccount__Discount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Expense_dxAccountExpense] FOREIGN KEY ([FK_dxAccount__Expense]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxCostLevel_dxAccountExpense] FOREIGN KEY ([FK_dxCostLevel]) REFERENCES [dbo].[dxCostLevel] ([PK_dxCostLevel])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxAccountExpense] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxAccountExpense] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxProductCategory_dxAccountExpense] FOREIGN KEY ([FK_dxProductCategory]) REFERENCES [dbo].[dxProductCategory] ([PK_dxProductCategory])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxAccountExpense] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxProjectCategory_dxAccountExpense] FOREIGN KEY ([FK_dxProjectCategory]) REFERENCES [dbo].[dxProjectCategory] ([PK_dxProjectCategory])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxAccountExpense] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxAccountExpense] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
ALTER TABLE [dbo].[dxAccountExpense] ADD CONSTRAINT [dxConstraint_FK_dxVendorCategory_dxAccountExpense] FOREIGN KEY ([FK_dxVendorCategory]) REFERENCES [dbo].[dxVendorCategory] ([PK_dxVendorCategory])
GO
