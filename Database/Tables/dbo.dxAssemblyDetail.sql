CREATE TABLE [dbo].[dxAssemblyDetail]
(
[PK_dxAssemblyDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxAssembly] [int] NOT NULL,
[ID] AS ([PK_dxAssemblyDetail]),
[Rank] [float] NOT NULL CONSTRAINT [DF_dxAssemblyDetail_Rank] DEFAULT ((0.0)),
[PhaseNumber] [int] NOT NULL CONSTRAINT [DF_dxAssemblyDetail_PhaseNumber] DEFAULT ((10)),
[FK_dxProduct] [int] NOT NULL,
[NetQuantity] [float] NOT NULL CONSTRAINT [DF_dxAssemblyDetail_NetQuantity] DEFAULT ((0.0)),
[WasteQuantity] [float] NOT NULL CONSTRAINT [DF_dxAssemblyDetail_WasteQuantity] DEFAULT ((0.0)),
[PctOfWasteQuantity] [float] NOT NULL CONSTRAINT [DF_dxAssemblyDetail_PctWasteQuantity] DEFAULT ((0.0)),
[Instructions] [varchar] (8000) COLLATE French_CI_AS NULL,
[DismantlingPhaseNumber] [int] NOT NULL CONSTRAINT [DF_dxAssemblyDetail_DismantlingPhaseNumber] DEFAULT ((0)),
[ControledItem] [bit] NOT NULL CONSTRAINT [DF_dxAssemblyDetail_ControledItem] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAssemblyDetail.trAuditDelete] ON [dbo].[dxAssemblyDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAssemblyDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAssemblyDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAssemblyDetail, FK_dxAssembly, ID, Rank, PhaseNumber, FK_dxProduct, NetQuantity, WasteQuantity, PctOfWasteQuantity, Instructions, DismantlingPhaseNumber, ControledItem from deleted
 Declare @PK_dxAssemblyDetail int, @FK_dxAssembly int, @ID int, @Rank Float, @PhaseNumber int, @FK_dxProduct int, @NetQuantity Float, @WasteQuantity Float, @PctOfWasteQuantity Float, @Instructions varchar(8000), @DismantlingPhaseNumber int, @ControledItem Bit

 OPEN pk_cursordxAssemblyDetail
 FETCH NEXT FROM pk_cursordxAssemblyDetail INTO @PK_dxAssemblyDetail, @FK_dxAssembly, @ID, @Rank, @PhaseNumber, @FK_dxProduct, @NetQuantity, @WasteQuantity, @PctOfWasteQuantity, @Instructions, @DismantlingPhaseNumber, @ControledItem
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAssemblyDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAssembly', @FK_dxAssembly
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PhaseNumber', @PhaseNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NetQuantity', @NetQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'WasteQuantity', @WasteQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PctOfWasteQuantity', @PctOfWasteQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', @Instructions
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DismantlingPhaseNumber', @DismantlingPhaseNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ControledItem', @ControledItem
FETCH NEXT FROM pk_cursordxAssemblyDetail INTO @PK_dxAssemblyDetail, @FK_dxAssembly, @ID, @Rank, @PhaseNumber, @FK_dxProduct, @NetQuantity, @WasteQuantity, @PctOfWasteQuantity, @Instructions, @DismantlingPhaseNumber, @ControledItem
 END

 CLOSE pk_cursordxAssemblyDetail 
 DEALLOCATE pk_cursordxAssemblyDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAssemblyDetail.trAuditInsUpd] ON [dbo].[dxAssemblyDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAssemblyDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAssemblyDetail from inserted;
 set @tablename = 'dxAssemblyDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAssemblyDetail
 FETCH NEXT FROM pk_cursordxAssemblyDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAssembly )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAssembly', FK_dxAssembly from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PhaseNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PhaseNumber', PhaseNumber from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NetQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NetQuantity', NetQuantity from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( WasteQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'WasteQuantity', WasteQuantity from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PctOfWasteQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PctOfWasteQuantity', PctOfWasteQuantity from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Instructions )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', Instructions from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DismantlingPhaseNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DismantlingPhaseNumber', DismantlingPhaseNumber from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ControledItem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ControledItem', ControledItem from dxAssemblyDetail where PK_dxAssemblyDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAssemblyDetail INTO @keyvalue
 END

 CLOSE pk_cursordxAssemblyDetail 
 DEALLOCATE pk_cursordxAssemblyDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAssemblyDetail.trEffectiveDate] ON [dbo].[dxAssemblyDetail]
AFTER INSERT, UPDATE
AS
BEGIN
   SET NOCOUNT ON;
   declare  @FKi int, @EffectiveDate Datetime  ;
   set @FKi  = ( SELECT Coalesce(max(FK_dxProduct ),-1) from inserted )
   set @EffectiveDate = ( select Max(EffectiveDate) from dxAssembly a join Inserted i on ( i.FK_dxAssembly = a.PK_dxAssembly ) )
   if dbo.fdxAssemblyCircRef( @FKi , @EffectiveDate ) = 0 RaisError ('Circular',10,0)

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxAssemblyDetail.trValidateModification] ON [dbo].[dxAssemblyDetail]
AFTER UPDATE, DELETE
AS
BEGIN
  if not (update(Rank) or update(Instructions) or Update(ControledItem) )
  begin
    if Coalesce( (Select Max(PK_dxProductTransaction) From inserted ie
                   left join dxAssembly           aa on ( aa.PK_dxAssembly = ie.FK_dxAssembly )
                   left join dxProductTransaction pt on ( pt.FK_dxProduct = aa.FK_dxProduct and pt.TransactionDate >= aa.EffectiveDate )
                   where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
    begin
       ROLLBACK TRANSACTION
       RAISERROR('Modification de la nomenclature est refusée car il y a déjà des transactions postérieures ou égales à cette date. / Changing the assembly is prohibited because there are already transactions after that date.', 16, 1)
       RETURN
    end

    if Coalesce( (Select Max(PK_dxProductTransaction) From deleted ie
                   left join dxAssembly           aa on ( aa.PK_dxAssembly = ie.FK_dxAssembly )
                   left join dxProductTransaction pt on ( pt.FK_dxProduct = aa.FK_dxProduct and pt.TransactionDate >= aa.EffectiveDate )
                   where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
    begin
       ROLLBACK TRANSACTION
       RAISERROR('Modification de la nomenclature refusée car il y a déjà des transactions postérieures ou égales à  cette date. / Changing the assembly is prohibited because there are already transactions after that date.', 16, 1)
       RETURN
    end
  end
End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxAssemblyDetail.trValidateModificationInsert] ON [dbo].[dxAssemblyDetail]
AFTER INSERT
AS
BEGIN
  
    if Coalesce( (Select Max(PK_dxProductTransaction) From inserted ie
                   left join dxAssembly           aa on ( aa.PK_dxAssembly = ie.FK_dxAssembly )
                   left join dxProductTransaction pt on ( pt.FK_dxProduct = aa.FK_dxProduct and pt.TransactionDate >= aa.EffectiveDate )
                   where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
    begin
       ROLLBACK TRANSACTION
       RAISERROR('Modification de la nomenclature est refusée car il y a déjà des transactions postérieures ou égales à cette date. / Changing the assembly is prohibited because there are already transactions after that date.', 16, 1)
       RETURN
    end

    if Coalesce( (Select Max(PK_dxProductTransaction) From deleted ie
                   left join dxAssembly           aa on ( aa.PK_dxAssembly = ie.FK_dxAssembly )
                   left join dxProductTransaction pt on ( pt.FK_dxProduct = aa.FK_dxProduct and pt.TransactionDate >= aa.EffectiveDate )
                   where not PK_dxProductTransaction is null AND KindOfDocument <> 26), 0) > 0
    begin
       ROLLBACK TRANSACTION
       RAISERROR('Modification de la nomenclature refusée car il y a déjà des transactions postérieures ou égales à  cette date. / Changing the assembly is prohibited because there are already transactions after that date.', 16, 1)
       RETURN
    end

End
GO
ALTER TABLE [dbo].[dxAssemblyDetail] ADD CONSTRAINT [PK_dxAssemblyDetail] PRIMARY KEY CLUSTERED  ([PK_dxAssemblyDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAssemblyDetail_FK_dxAssembly] ON [dbo].[dxAssemblyDetail] ([FK_dxAssembly]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAssemblyDetail_FK_dxProduct] ON [dbo].[dxAssemblyDetail] ([FK_dxProduct]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAssemblyDetail] ADD CONSTRAINT [dxConstraint_FK_dxAssembly_dxAssemblyDetail] FOREIGN KEY ([FK_dxAssembly]) REFERENCES [dbo].[dxAssembly] ([PK_dxAssembly])
GO
ALTER TABLE [dbo].[dxAssemblyDetail] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxAssemblyDetail] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
