CREATE TABLE [dbo].[dxProductCategory]
(
[PK_dxProductCategory] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxAccount__MaterialCostVariance] [int] NULL,
[FK_dxAccount__AdjustmentCostRollup] [int] NULL,
[FK_dxAccount__LaborCostVariance] [int] NULL,
[FK_dxAccount__OverheadFixedCostVariance] [int] NULL,
[FK_dxAccount__OverheadVariableCostVariance] [int] NULL,
[FK_dxAccount__CostOfSalesMaterial] [int] NULL,
[FK_dxAccount__CostOfSalesLabor] [int] NULL,
[FK_dxAccount__CostOfSalesOverheadFixed] [int] NULL,
[FK_dxAccount__CostOfSalesOverheadVariable] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProductCategory.trAuditDelete] ON [dbo].[dxProductCategory]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProductCategory'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProductCategory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProductCategory, ID, Description, FK_dxAccount__MaterialCostVariance, FK_dxAccount__AdjustmentCostRollup, FK_dxAccount__LaborCostVariance, FK_dxAccount__OverheadFixedCostVariance, FK_dxAccount__OverheadVariableCostVariance, FK_dxAccount__CostOfSalesMaterial, FK_dxAccount__CostOfSalesLabor, FK_dxAccount__CostOfSalesOverheadFixed, FK_dxAccount__CostOfSalesOverheadVariable from deleted
 Declare @PK_dxProductCategory int, @ID varchar(50), @Description varchar(255), @FK_dxAccount__MaterialCostVariance int, @FK_dxAccount__AdjustmentCostRollup int, @FK_dxAccount__LaborCostVariance int, @FK_dxAccount__OverheadFixedCostVariance int, @FK_dxAccount__OverheadVariableCostVariance int, @FK_dxAccount__CostOfSalesMaterial int, @FK_dxAccount__CostOfSalesLabor int, @FK_dxAccount__CostOfSalesOverheadFixed int, @FK_dxAccount__CostOfSalesOverheadVariable int

 OPEN pk_cursordxProductCategory
 FETCH NEXT FROM pk_cursordxProductCategory INTO @PK_dxProductCategory, @ID, @Description, @FK_dxAccount__MaterialCostVariance, @FK_dxAccount__AdjustmentCostRollup, @FK_dxAccount__LaborCostVariance, @FK_dxAccount__OverheadFixedCostVariance, @FK_dxAccount__OverheadVariableCostVariance, @FK_dxAccount__CostOfSalesMaterial, @FK_dxAccount__CostOfSalesLabor, @FK_dxAccount__CostOfSalesOverheadFixed, @FK_dxAccount__CostOfSalesOverheadVariable
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProductCategory, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__MaterialCostVariance', @FK_dxAccount__MaterialCostVariance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AdjustmentCostRollup', @FK_dxAccount__AdjustmentCostRollup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__LaborCostVariance', @FK_dxAccount__LaborCostVariance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__OverheadFixedCostVariance', @FK_dxAccount__OverheadFixedCostVariance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__OverheadVariableCostVariance', @FK_dxAccount__OverheadVariableCostVariance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CostOfSalesMaterial', @FK_dxAccount__CostOfSalesMaterial
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CostOfSalesLabor', @FK_dxAccount__CostOfSalesLabor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CostOfSalesOverheadFixed', @FK_dxAccount__CostOfSalesOverheadFixed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CostOfSalesOverheadVariable', @FK_dxAccount__CostOfSalesOverheadVariable
FETCH NEXT FROM pk_cursordxProductCategory INTO @PK_dxProductCategory, @ID, @Description, @FK_dxAccount__MaterialCostVariance, @FK_dxAccount__AdjustmentCostRollup, @FK_dxAccount__LaborCostVariance, @FK_dxAccount__OverheadFixedCostVariance, @FK_dxAccount__OverheadVariableCostVariance, @FK_dxAccount__CostOfSalesMaterial, @FK_dxAccount__CostOfSalesLabor, @FK_dxAccount__CostOfSalesOverheadFixed, @FK_dxAccount__CostOfSalesOverheadVariable
 END

 CLOSE pk_cursordxProductCategory 
 DEALLOCATE pk_cursordxProductCategory
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProductCategory.trAuditInsUpd] ON [dbo].[dxProductCategory] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProductCategory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProductCategory from inserted;
 set @tablename = 'dxProductCategory' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProductCategory
 FETCH NEXT FROM pk_cursordxProductCategory INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__MaterialCostVariance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__MaterialCostVariance', FK_dxAccount__MaterialCostVariance from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AdjustmentCostRollup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AdjustmentCostRollup', FK_dxAccount__AdjustmentCostRollup from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__LaborCostVariance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__LaborCostVariance', FK_dxAccount__LaborCostVariance from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__OverheadFixedCostVariance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__OverheadFixedCostVariance', FK_dxAccount__OverheadFixedCostVariance from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__OverheadVariableCostVariance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__OverheadVariableCostVariance', FK_dxAccount__OverheadVariableCostVariance from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__CostOfSalesMaterial )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CostOfSalesMaterial', FK_dxAccount__CostOfSalesMaterial from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__CostOfSalesLabor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CostOfSalesLabor', FK_dxAccount__CostOfSalesLabor from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__CostOfSalesOverheadFixed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CostOfSalesOverheadFixed', FK_dxAccount__CostOfSalesOverheadFixed from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__CostOfSalesOverheadVariable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CostOfSalesOverheadVariable', FK_dxAccount__CostOfSalesOverheadVariable from dxProductCategory where PK_dxProductCategory = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProductCategory INTO @keyvalue
 END

 CLOSE pk_cursordxProductCategory 
 DEALLOCATE pk_cursordxProductCategory
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [PK_dxProductCategory] PRIMARY KEY CLUSTERED  ([PK_dxProductCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__AdjustmentCostRollup] ON [dbo].[dxProductCategory] ([FK_dxAccount__AdjustmentCostRollup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__CostOfSalesLabor] ON [dbo].[dxProductCategory] ([FK_dxAccount__CostOfSalesLabor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__CostOfSalesMaterial] ON [dbo].[dxProductCategory] ([FK_dxAccount__CostOfSalesMaterial]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__CostOfSalesOverheadFixed] ON [dbo].[dxProductCategory] ([FK_dxAccount__CostOfSalesOverheadFixed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__CostOfSalesOverheadVariable] ON [dbo].[dxProductCategory] ([FK_dxAccount__CostOfSalesOverheadVariable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__LaborCostVariance] ON [dbo].[dxProductCategory] ([FK_dxAccount__LaborCostVariance]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__MaterialCostVariance] ON [dbo].[dxProductCategory] ([FK_dxAccount__MaterialCostVariance]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__OverheadFixedCostVariance] ON [dbo].[dxProductCategory] ([FK_dxAccount__OverheadFixedCostVariance]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProductCategory_FK_dxAccount__OverheadVariableCostVariance] ON [dbo].[dxProductCategory] ([FK_dxAccount__OverheadVariableCostVariance]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AdjustmentCostRollup_dxProductCategory] FOREIGN KEY ([FK_dxAccount__AdjustmentCostRollup]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CostOfSalesLabor_dxProductCategory] FOREIGN KEY ([FK_dxAccount__CostOfSalesLabor]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CostOfSalesMaterial_dxProductCategory] FOREIGN KEY ([FK_dxAccount__CostOfSalesMaterial]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CostOfSalesOverheadFixed_dxProductCategory] FOREIGN KEY ([FK_dxAccount__CostOfSalesOverheadFixed]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CostOfSalesOverheadVariable_dxProductCategory] FOREIGN KEY ([FK_dxAccount__CostOfSalesOverheadVariable]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__LaborCostVariance_dxProductCategory] FOREIGN KEY ([FK_dxAccount__LaborCostVariance]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__MaterialCostVariance_dxProductCategory] FOREIGN KEY ([FK_dxAccount__MaterialCostVariance]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__OverheadFixedCostVariance_dxProductCategory] FOREIGN KEY ([FK_dxAccount__OverheadFixedCostVariance]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxProductCategory] ADD CONSTRAINT [dxConstraint_FK_dxAccount__OverheadVariableCostVariance_dxProductCategory] FOREIGN KEY ([FK_dxAccount__OverheadVariableCostVariance]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
