CREATE TABLE [dbo].[dxAccountConfiguration]
(
[PK_dxAccountConfiguration] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxCurrency__System] [int] NULL,
[FK_dxAccount__ProfitAndLoss] [int] NULL,
[FK_dxAccount__ForeignExchangeExpense] [int] NULL,
[FK_dxAccount__ExchangeCalculation] [int] NULL,
[FK_dxAccount__LaborAbsorbed] [int] NULL,
[FK_dxAccount__OverheadFixedAbsorbed] [int] NULL,
[FK_dxAccount__OverheadVariableAbsorbed] [int] NULL,
[FK_dxAccount__ProductionMaterialUsage] [int] NULL,
[FK_dxAccount__ProductionLaborUsage] [int] NULL,
[FK_dxAccount__RoundingDifference] [int] NULL,
[RoundingDifferenceAmount] [float] NOT NULL CONSTRAINT [DF_dxAccountConfiguration_RoundingDifferenceAmount] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountConfiguration.trAuditDelete] ON [dbo].[dxAccountConfiguration]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAccountConfiguration'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAccountConfiguration CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccountConfiguration, ID, Description, FK_dxCurrency__System, FK_dxAccount__ProfitAndLoss, FK_dxAccount__ForeignExchangeExpense, FK_dxAccount__ExchangeCalculation, FK_dxAccount__LaborAbsorbed, FK_dxAccount__OverheadFixedAbsorbed, FK_dxAccount__OverheadVariableAbsorbed, FK_dxAccount__ProductionMaterialUsage, FK_dxAccount__ProductionLaborUsage, FK_dxAccount__RoundingDifference, RoundingDifferenceAmount from deleted
 Declare @PK_dxAccountConfiguration int, @ID varchar(50), @Description varchar(255), @FK_dxCurrency__System int, @FK_dxAccount__ProfitAndLoss int, @FK_dxAccount__ForeignExchangeExpense int, @FK_dxAccount__ExchangeCalculation int, @FK_dxAccount__LaborAbsorbed int, @FK_dxAccount__OverheadFixedAbsorbed int, @FK_dxAccount__OverheadVariableAbsorbed int, @FK_dxAccount__ProductionMaterialUsage int, @FK_dxAccount__ProductionLaborUsage int, @FK_dxAccount__RoundingDifference int, @RoundingDifferenceAmount Float

 OPEN pk_cursordxAccountConfiguration
 FETCH NEXT FROM pk_cursordxAccountConfiguration INTO @PK_dxAccountConfiguration, @ID, @Description, @FK_dxCurrency__System, @FK_dxAccount__ProfitAndLoss, @FK_dxAccount__ForeignExchangeExpense, @FK_dxAccount__ExchangeCalculation, @FK_dxAccount__LaborAbsorbed, @FK_dxAccount__OverheadFixedAbsorbed, @FK_dxAccount__OverheadVariableAbsorbed, @FK_dxAccount__ProductionMaterialUsage, @FK_dxAccount__ProductionLaborUsage, @FK_dxAccount__RoundingDifference, @RoundingDifferenceAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAccountConfiguration, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency__System', @FK_dxCurrency__System
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ProfitAndLoss', @FK_dxAccount__ProfitAndLoss
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ForeignExchangeExpense', @FK_dxAccount__ForeignExchangeExpense
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ExchangeCalculation', @FK_dxAccount__ExchangeCalculation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__LaborAbsorbed', @FK_dxAccount__LaborAbsorbed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__OverheadFixedAbsorbed', @FK_dxAccount__OverheadFixedAbsorbed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__OverheadVariableAbsorbed', @FK_dxAccount__OverheadVariableAbsorbed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ProductionMaterialUsage', @FK_dxAccount__ProductionMaterialUsage
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ProductionLaborUsage', @FK_dxAccount__ProductionLaborUsage
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__RoundingDifference', @FK_dxAccount__RoundingDifference
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RoundingDifferenceAmount', @RoundingDifferenceAmount
FETCH NEXT FROM pk_cursordxAccountConfiguration INTO @PK_dxAccountConfiguration, @ID, @Description, @FK_dxCurrency__System, @FK_dxAccount__ProfitAndLoss, @FK_dxAccount__ForeignExchangeExpense, @FK_dxAccount__ExchangeCalculation, @FK_dxAccount__LaborAbsorbed, @FK_dxAccount__OverheadFixedAbsorbed, @FK_dxAccount__OverheadVariableAbsorbed, @FK_dxAccount__ProductionMaterialUsage, @FK_dxAccount__ProductionLaborUsage, @FK_dxAccount__RoundingDifference, @RoundingDifferenceAmount
 END

 CLOSE pk_cursordxAccountConfiguration 
 DEALLOCATE pk_cursordxAccountConfiguration
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountConfiguration.trAuditInsUpd] ON [dbo].[dxAccountConfiguration] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAccountConfiguration CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccountConfiguration from inserted;
 set @tablename = 'dxAccountConfiguration' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAccountConfiguration
 FETCH NEXT FROM pk_cursordxAccountConfiguration INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency__System )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency__System', FK_dxCurrency__System from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__ProfitAndLoss )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ProfitAndLoss', FK_dxAccount__ProfitAndLoss from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__ForeignExchangeExpense )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ForeignExchangeExpense', FK_dxAccount__ForeignExchangeExpense from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__ExchangeCalculation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ExchangeCalculation', FK_dxAccount__ExchangeCalculation from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__LaborAbsorbed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__LaborAbsorbed', FK_dxAccount__LaborAbsorbed from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__OverheadFixedAbsorbed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__OverheadFixedAbsorbed', FK_dxAccount__OverheadFixedAbsorbed from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__OverheadVariableAbsorbed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__OverheadVariableAbsorbed', FK_dxAccount__OverheadVariableAbsorbed from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__ProductionMaterialUsage )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ProductionMaterialUsage', FK_dxAccount__ProductionMaterialUsage from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__ProductionLaborUsage )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ProductionLaborUsage', FK_dxAccount__ProductionLaborUsage from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__RoundingDifference )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__RoundingDifference', FK_dxAccount__RoundingDifference from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RoundingDifferenceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RoundingDifferenceAmount', RoundingDifferenceAmount from dxAccountConfiguration where PK_dxAccountConfiguration = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAccountConfiguration INTO @keyvalue
 END

 CLOSE pk_cursordxAccountConfiguration 
 DEALLOCATE pk_cursordxAccountConfiguration
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [PK_dxAccountConfiguration] PRIMARY KEY CLUSTERED  ([PK_dxAccountConfiguration]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__ExchangeCalculation] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__ExchangeCalculation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__ForeignExchangeExpense] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__ForeignExchangeExpense]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__LaborAbsorbed] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__LaborAbsorbed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__OverheadFixedAbsorbed] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__OverheadFixedAbsorbed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__OverheadVariableAbsorbed] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__OverheadVariableAbsorbed]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__ProductionLaborUsage] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__ProductionLaborUsage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__ProductionMaterialUsage] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__ProductionMaterialUsage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__ProfitAndLoss] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__ProfitAndLoss]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxAccount__RoundingDifference] ON [dbo].[dxAccountConfiguration] ([FK_dxAccount__RoundingDifference]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccountConfiguration_FK_dxCurrency__System] ON [dbo].[dxAccountConfiguration] ([FK_dxCurrency__System]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__ExchangeCalculation_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__ExchangeCalculation]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__ForeignExchangeExpense_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__ForeignExchangeExpense]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__LaborAbsorbed_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__LaborAbsorbed]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__OverheadFixedAbsorbed_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__OverheadFixedAbsorbed]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__OverheadVariableAbsorbed_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__OverheadVariableAbsorbed]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__ProductionLaborUsage_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__ProductionLaborUsage]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__ProductionMaterialUsage_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__ProductionMaterialUsage]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__ProfitAndLoss_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__ProfitAndLoss]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxAccount__RoundingDifference_dxAccountConfiguration] FOREIGN KEY ([FK_dxAccount__RoundingDifference]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccountConfiguration] ADD CONSTRAINT [dxConstraint_FK_dxCurrency__System_dxAccountConfiguration] FOREIGN KEY ([FK_dxCurrency__System]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
