CREATE TABLE [dbo].[dxStandardCostHistory]
(
[PK_dxStandardCostHistory] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProduct] [int] NOT NULL,
[EffectiveDate] [datetime] NOT NULL,
[StandardCost] AS ((([MaterialCost]+[LaborCost])+[OverheadFixedCost])+[OverheadVariableCost]),
[MaterialCost] [float] NOT NULL CONSTRAINT [DF_dxStandardCostHistory_LaborCost] DEFAULT ((0.0)),
[LaborCost] [float] NOT NULL CONSTRAINT [DF_dxStandardCostHistory_LaborCost_1] DEFAULT ((0.0)),
[OverheadFixedCost] [float] NOT NULL CONSTRAINT [DF_dxStandardCostHistory_OverheadFixedCost] DEFAULT ((0.0)),
[OverheadVariableCost] [float] NOT NULL CONSTRAINT [DF_dxStandardCostHistory_OverheadVariableCost] DEFAULT ((0.0)),
[CostRollup] [bit] NOT NULL CONSTRAINT [DF_dxStandardCostHistory_CostRollup] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxStandardCostHistory.trAuditDelete] ON [dbo].[dxStandardCostHistory]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxStandardCostHistory'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxStandardCostHistory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxStandardCostHistory, FK_dxProduct, EffectiveDate, StandardCost, MaterialCost, LaborCost, OverheadFixedCost, OverheadVariableCost, CostRollup from deleted
 Declare @PK_dxStandardCostHistory int, @FK_dxProduct int, @EffectiveDate DateTime, @StandardCost Float, @MaterialCost Float, @LaborCost Float, @OverheadFixedCost Float, @OverheadVariableCost Float, @CostRollup Bit

 OPEN pk_cursordxStandardCostHistory
 FETCH NEXT FROM pk_cursordxStandardCostHistory INTO @PK_dxStandardCostHistory, @FK_dxProduct, @EffectiveDate, @StandardCost, @MaterialCost, @LaborCost, @OverheadFixedCost, @OverheadVariableCost, @CostRollup
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxStandardCostHistory, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MaterialCost', @MaterialCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LaborCost', @LaborCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverheadFixedCost', @OverheadFixedCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverheadVariableCost', @OverheadVariableCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'CostRollup', @CostRollup
FETCH NEXT FROM pk_cursordxStandardCostHistory INTO @PK_dxStandardCostHistory, @FK_dxProduct, @EffectiveDate, @StandardCost, @MaterialCost, @LaborCost, @OverheadFixedCost, @OverheadVariableCost, @CostRollup
 END

 CLOSE pk_cursordxStandardCostHistory 
 DEALLOCATE pk_cursordxStandardCostHistory
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxStandardCostHistory.trAuditInsUpd] ON [dbo].[dxStandardCostHistory] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxStandardCostHistory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxStandardCostHistory from inserted;
 set @tablename = 'dxStandardCostHistory' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxStandardCostHistory
 FETCH NEXT FROM pk_cursordxStandardCostHistory INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxStandardCostHistory where PK_dxStandardCostHistory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxStandardCostHistory where PK_dxStandardCostHistory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MaterialCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MaterialCost', MaterialCost from dxStandardCostHistory where PK_dxStandardCostHistory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LaborCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LaborCost', LaborCost from dxStandardCostHistory where PK_dxStandardCostHistory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OverheadFixedCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverheadFixedCost', OverheadFixedCost from dxStandardCostHistory where PK_dxStandardCostHistory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OverheadVariableCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverheadVariableCost', OverheadVariableCost from dxStandardCostHistory where PK_dxStandardCostHistory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CostRollup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'CostRollup', CostRollup from dxStandardCostHistory where PK_dxStandardCostHistory = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxStandardCostHistory INTO @keyvalue
 END

 CLOSE pk_cursordxStandardCostHistory 
 DEALLOCATE pk_cursordxStandardCostHistory
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxStandardCostHistory.trValidateModification] ON [dbo].[dxStandardCostHistory]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  if Coalesce( (Select Max(PK_dxProductTransaction) From inserted ie
                 left join dxProductTransaction pt on ( pt.FK_dxProduct = ie.FK_dxProduct and pt.TransactionDate >= ie.EffectiveDate )
                 where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
  begin
     ROLLBACK TRANSACTION
     RAISERROR('Modification du coût standard est refusée car il y a déjà des transactions postérieurs cette date. / Changing the standard cost is prohibited because there are already transactions after that date.', 16, 1)
     RETURN
  end

  if Coalesce( (Select Max(PK_dxProductTransaction) From deleted ie
                 left join dxProductTransaction pt on ( pt.FK_dxProduct = ie.FK_dxProduct and pt.TransactionDate >= ie.EffectiveDate )
                 where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
  begin
     ROLLBACK TRANSACTION
     RAISERROR('Modification du coût standard est refusée car il y a déjà des transactions postérieurs cette date. / Changing the standard cost is prohibited because there are already transactions after that date.', 16, 1)
     RETURN
  end

END
GO
ALTER TABLE [dbo].[dxStandardCostHistory] ADD CONSTRAINT [PK_dxStandardCostHistory] PRIMARY KEY CLUSTERED  ([PK_dxStandardCostHistory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxStandardCostHistoryDate] ON [dbo].[dxStandardCostHistory] ([EffectiveDate] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxStandardCostHistory_FK_dxProduct] ON [dbo].[dxStandardCostHistory] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxStandardCostHistoryUnique] ON [dbo].[dxStandardCostHistory] ([FK_dxProduct], [EffectiveDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxStandardCostHistory] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxStandardCostHistory] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
