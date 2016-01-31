CREATE TABLE [dbo].[dxWorkOrder]
(
[PK_dxWorkOrder] [int] NOT NULL IDENTITY(100000, 1),
[ID] AS ([PK_dxWorkOrder]),
[FK_dxProduct] [int] NOT NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxWorkOrder_Lot] DEFAULT ('0'),
[WorkOrderStatus] [int] NOT NULL CONSTRAINT [DF_dxWorkOrder_WorkOrderStatus] DEFAULT ((1)),
[AskedQuantity] [float] NOT NULL CONSTRAINT [DF_dxWorkOrder_AskedQuantity] DEFAULT ((1)),
[QuantityToProduce] [float] NOT NULL CONSTRAINT [DF_dxWorkOrder_QuantityToProduce] DEFAULT ((1)),
[WorkOrderDate] [datetime] NOT NULL,
[ProducedQuantity] [float] NOT NULL CONSTRAINT [DF_dxWorkOrder_ProducedQuantity] DEFAULT ((0.0)),
[Instructions] [varchar] (8000) COLLATE French_CI_AS NULL,
[FK_dxRouting] [int] NULL,
[SequentialProcess] [bit] NOT NULL CONSTRAINT [DF_dxWorkOrder_SequentialProcess] DEFAULT ((0)),
[FK_dxClientOrderDetail] [int] NULL,
[FK_dxDeclarationDismantling] [int] NULL,
[FK_dxWarehouse] [int] NOT NULL CONSTRAINT [DF_dxWorkOrder_FK_dxWarehouse] DEFAULT ((4)),
[FK_dxLocation] [int] NOT NULL CONSTRAINT [DF_dxWorkOrder_FK_dxLocation] DEFAULT ((1)),
[ExpirationDate] [datetime] NULL,
[FK_dxWorkOrder__Master] [int] NULL,
[OverridePriority] [float] NOT NULL CONSTRAINT [DF_dxWorkOrder_OverridePriority] DEFAULT ((0.0)),
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxWorkOrder_DocumentStatus] DEFAULT ((0)),
[Priority] [float] NOT NULL CONSTRAINT [DF_dxWorkOrder_Priority] DEFAULT ((0.0)),
[LotNumberList] [varchar] (1000) COLLATE French_CI_AS NULL,
[PlannedReserved] [bit] NOT NULL CONSTRAINT [DF_dxWorkOrder_PlannedReserved] DEFAULT ((0)),
[FK_dxProductionLine] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxWorkOrder.trAuditDelete] ON [dbo].[dxWorkOrder]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxWorkOrder'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxWorkOrder CURSOR LOCAL FAST_FORWARD for SELECT PK_dxWorkOrder, ID, FK_dxProduct, Lot, WorkOrderStatus, AskedQuantity, QuantityToProduce, WorkOrderDate, ProducedQuantity, Instructions, FK_dxRouting, SequentialProcess, FK_dxClientOrderDetail, FK_dxDeclarationDismantling, FK_dxWarehouse, FK_dxLocation, ExpirationDate, FK_dxWorkOrder__Master, OverridePriority, DocumentStatus, Priority, LotNumberList, PlannedReserved, FK_dxProductionLine from deleted
 Declare @PK_dxWorkOrder int, @ID int, @FK_dxProduct int, @Lot varchar(50), @WorkOrderStatus int, @AskedQuantity Float, @QuantityToProduce Float, @WorkOrderDate DateTime, @ProducedQuantity Float, @Instructions varchar(8000), @FK_dxRouting int, @SequentialProcess Bit, @FK_dxClientOrderDetail int, @FK_dxDeclarationDismantling int, @FK_dxWarehouse int, @FK_dxLocation int, @ExpirationDate DateTime, @FK_dxWorkOrder__Master int, @OverridePriority Float, @DocumentStatus int, @Priority Float, @LotNumberList varchar(1000), @PlannedReserved Bit, @FK_dxProductionLine int

 OPEN pk_cursordxWorkOrder
 FETCH NEXT FROM pk_cursordxWorkOrder INTO @PK_dxWorkOrder, @ID, @FK_dxProduct, @Lot, @WorkOrderStatus, @AskedQuantity, @QuantityToProduce, @WorkOrderDate, @ProducedQuantity, @Instructions, @FK_dxRouting, @SequentialProcess, @FK_dxClientOrderDetail, @FK_dxDeclarationDismantling, @FK_dxWarehouse, @FK_dxLocation, @ExpirationDate, @FK_dxWorkOrder__Master, @OverridePriority, @DocumentStatus, @Priority, @LotNumberList, @PlannedReserved, @FK_dxProductionLine
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxWorkOrder, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', @FK_dxProduct
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', @Lot
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'WorkOrderStatus', @WorkOrderStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AskedQuantity', @AskedQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'QuantityToProduce', @QuantityToProduce
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'WorkOrderDate', @WorkOrderDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProducedQuantity', @ProducedQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', @Instructions
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRouting', @FK_dxRouting
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'SequentialProcess', @SequentialProcess
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrderDetail', @FK_dxClientOrderDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeclarationDismantling', @FK_dxDeclarationDismantling
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', @FK_dxWarehouse
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', @FK_dxLocation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpirationDate', @ExpirationDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWorkOrder__Master', @FK_dxWorkOrder__Master
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverridePriority', @OverridePriority
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Priority', @Priority
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LotNumberList', @LotNumberList
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PlannedReserved', @PlannedReserved
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProductionLine', @FK_dxProductionLine
FETCH NEXT FROM pk_cursordxWorkOrder INTO @PK_dxWorkOrder, @ID, @FK_dxProduct, @Lot, @WorkOrderStatus, @AskedQuantity, @QuantityToProduce, @WorkOrderDate, @ProducedQuantity, @Instructions, @FK_dxRouting, @SequentialProcess, @FK_dxClientOrderDetail, @FK_dxDeclarationDismantling, @FK_dxWarehouse, @FK_dxLocation, @ExpirationDate, @FK_dxWorkOrder__Master, @OverridePriority, @DocumentStatus, @Priority, @LotNumberList, @PlannedReserved, @FK_dxProductionLine
 END

 CLOSE pk_cursordxWorkOrder 
 DEALLOCATE pk_cursordxWorkOrder
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxWorkOrder.trAuditInsUpd] ON [dbo].[dxWorkOrder] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxWorkOrder CURSOR LOCAL FAST_FORWARD for SELECT PK_dxWorkOrder from inserted;
 set @tablename = 'dxWorkOrder' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxWorkOrder
 FETCH NEXT FROM pk_cursordxWorkOrder INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProduct )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProduct', FK_dxProduct from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( WorkOrderStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'WorkOrderStatus', WorkOrderStatus from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AskedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AskedQuantity', AskedQuantity from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( QuantityToProduce )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'QuantityToProduce', QuantityToProduce from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( WorkOrderDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'WorkOrderDate', WorkOrderDate from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProducedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProducedQuantity', ProducedQuantity from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Instructions )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', Instructions from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxRouting )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRouting', FK_dxRouting from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SequentialProcess )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'SequentialProcess', SequentialProcess from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientOrderDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrderDetail', FK_dxClientOrderDetail from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDeclarationDismantling )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeclarationDismantling', FK_dxDeclarationDismantling from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse', FK_dxWarehouse from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation', FK_dxLocation from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExpirationDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExpirationDate', ExpirationDate from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWorkOrder__Master )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWorkOrder__Master', FK_dxWorkOrder__Master from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OverridePriority )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverridePriority', OverridePriority from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Priority )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Priority', Priority from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LotNumberList )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LotNumberList', LotNumberList from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PlannedReserved )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PlannedReserved', PlannedReserved from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProductionLine )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProductionLine', FK_dxProductionLine from dxWorkOrder where PK_dxWorkOrder = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxWorkOrder INTO @keyvalue
 END

 CLOSE pk_cursordxWorkOrder 
 DEALLOCATE pk_cursordxWorkOrder
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxWorkOrder.trWorkOrderChange] ON [dbo].[dxWorkOrder]
FOR INSERT
AS
  Declare @PK_dxWorkOrder int
         , @RecNo int, @EOF int

  Declare @WOList Table (
       [RecNo]       [int] IDENTITY(1,1) NOT NULL
      ,[FK_dxWorkOrder] int )

  Exec [dbo].[pdxCreateWorkOrderPhase] @FK_dxWorkOrder = -1

  -- Recalculate phase date for all inserted Work Order
  Insert into @WOList
  SELECT [PK_dxWorkOrder] FROM Inserted

  -- Recalculate All Work Order Phase Date
  Set @RecNo = 1
  Set @EOF = ( Select Max([RecNo]) from @WOList )
  While @RecNo <= @EOF
  begin
    Select @PK_dxWorkOrder = [FK_dxWorkOrder] From @WOList where RecNo = @RecNo
    Exec dbo.pdxRecalculatePhaseForwardPass  @FK_dxWorkOrder = @PK_dxWorkOrder
    Exec dbo.pdxRecalculatePhaseBackwardPass @FK_dxWorkOrder = @PK_dxWorkOrder
    set @RecNo = @RecNo+ 1
  end
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxWorkOrder.trWorkOrderDateChange] ON [dbo].[dxWorkOrder]
FOR UPDATE
AS
Begin
   If update(WorkOrderDate)
   Begin
     Update co
        Set ExpectedDeliveryDate = [dbo].[fdxGetPrevNextWorkDay]
                                             ( DateAdd(dd, Coalesce(( Select Max(pr.LeadTimeInDays) From dxProduct pr
                                                   where pr.PK_dxProduct in ( Select FK_dxProduct From dxClientOrderDetail
                                                                               where FK_dxClientOrder = co.PK_dxClientOrder)),0)
                                              , WorkOrderDate )-1.0 ,1)
     From dxClientOrder co
     left join dxClientOrderDetail cd on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
     left join inserted ie on ( ie.FK_dxClientOrderDetail = cd.PK_dxClientOrderDetail)
     Where not ie.FK_dxClientOrderDetail is null
   End
End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxWorkOrder.trWorkOrderDateChangeMaster] ON [dbo].[dxWorkOrder]
FOR UPDATE
AS
Begin
   If update(WorkOrderDate)
   Begin
     Update wo
        Set WorkOrderDate = DateAdd( dd
             , (Select datediff(dd, de.WorkOrderDate,wi.WorkOrderDate ) from inserted wi left join deleted de on de.PK_dxWorkOrder = wi.PK_dxWorkOrder)
             , wo.WorkOrderDate )
     From dxWorkOrder wo
     Where wo.FK_dxWorkOrder__Master in ( Select PK_dxWorkOrder from inserted )

   End
End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxWorkOrder.trWorkOrderDateChangeSub] ON [dbo].[dxWorkOrder]
FOR UPDATE
AS
Begin
   Declare @MSG varchar(100)
   If update(WorkOrderDate)
   Begin
     If Coalesce(( Select Max(wi.WorkOrderDate - wo.WorkOrderDate) from Inserted wi
          left join dxWorkOrder wo on ( wo.PK_dxWorkOrder = wi.FK_dxWorkOrder__Master )),0.0) > 0.0
     begin
        Set @MSG = 'Date de l''OF est invalide car elle est postérieur à celle de l''OF maître / The WO Date is invalid because it is greater than the Master WO Date. '
        --ROLLBACK TRANSACTION
        RAISERROR(@MSG , 16, 1)
        RETURN
     end
   End
End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create TRIGGER [dbo].[dxWorkOrder.trWorkOrderDelete] ON [dbo].[dxWorkOrder]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  -- Update MRP to Clear constraint
  Update dxMRP set FK_dxWorkOrder = null where FK_dxWorkOrder in (SELECT PK_dxWorkOrder FROM deleted)
  --Delete the SchedulerEvent
  Delete from dxSchedulerEvent  where FK_dxWorkOrder in (SELECT PK_dxWorkOrder From dxWorkOrder where FK_dxWorkOrder__Master in (SELECT PK_dxWorkOrder FROM deleted)) ;
  Delete from dxSchedulerEvent  where FK_dxWorkOrder in (SELECT PK_dxWorkOrder FROM deleted) ;
  Delete From dxWorkOrderPhase  Where FK_dxWorkOrder in (SELECT PK_dxWorkOrder FROM deleted) ;
  -- Delete the children if it is the case
  Delete from dxWorkOrder       where FK_dxWorkOrder__Master in (SELECT PK_dxWorkOrder FROM deleted) ;
  Delete from dxWorkOrder       where PK_dxWorkOrder in (SELECT PK_dxWorkOrder FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create TRIGGER [dbo].[dxWorkOrder.trWorkOrderLocation] ON [dbo].[dxWorkOrder]
FOR INSERT , UPDATE
AS
BEGIN
  Declare @FK_dxWorkOrder int , @ManageWOWithReservedArea bit
  -- Check if we mangage reserved area on the WO
  Set @ManageWOWithReservedArea = ( Select ManageWOWithReservedArea from dxSetup )

  If Update(WorkOrderStatus)
  begin

    if (@ManageWOWithReservedArea = 1)
       INSERT INTO dxLocation ( ID, Description, FK_dxWorkOrder, PhaseNumber, ReservedArea )
       Select   'WO'+Convert(varchar(20) , ie.PK_dxWorkOrder)
              , 'Emplacement de travail réservé pour l''OF '+ Convert(varchar(20) , ie.PK_dxWorkOrder)
              , PK_dxWorkOrder
              , Null
              , 1
       from inserted ie
       where ( not exists ( Select 1 from dxLocation lo
                             where lo.FK_dxWorkOrder = ie.PK_dxWorkOrder and lo.PhaseNumber is null ) )
         and ie.WorkOrderStatus > 0

    -- Update default Warehouse
    Update dxWorkOrder
      set FK_dxWarehouse = Coalesce( Case when @ManageWOWithReservedArea = 1 then 4
                                       Else ( Select FK_dxWarehouse from dxProduct where PK_dxProduct = dxWorkOrder.FK_dxProduct )
                                     End
                                   , 1)
    where PK_dxWorkOrder in ( Select PK_dxWorkOrder from inserted where WorkOrderStatus between 1 and 3 )

     -- Update default location
    Update dxWorkOrder
      set FK_dxLocation = Coalesce(
                                    ( Select Max(PK_dxLocation) from dxLocation where FK_dxWorkOrder = dxWorkOrder.PK_dxWorkOrder and PhaseNumber is null )
                                   ,( Select FK_dxLocation from dxProduct  where PK_dxProduct   = dxWorkOrder.FK_dxProduct   )
                                   , 1)
    where PK_dxWorkOrder in ( Select PK_dxWorkOrder from inserted where WorkOrderStatus between 1 and 3 )

  end
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxWorkOrder.trWorkOrderQuantityChange] ON [dbo].[dxWorkOrder]
FOR UPDATE
AS
Begin
   If update(QuantityToProduce)
   Begin
     Update wo
        Set QuantityToProduce = Round( wi.QuantityToProduce *ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0,0)
     from dxAssemblyDetail ad
     Left join dxWorkOrder wo on ( wo.FK_dxProduct = ad.FK_dxProduct) 
     left join dxAssembly aa on (aa.PK_dxAssembly = ad.FK_dxAssembly)
     left join inserted wi on ( wi.PK_dxWorkOrder = wo.FK_dxWorkOrder__Master and wi.WorkOrderStatus <= 1)
      where aa.FK_dxProduct = wi.FK_dxProduct
        and aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  wi.FK_dxProduct , wi.WorkOrderDate )
        and wi.WorkOrderStatus <= 1
        and wo.FK_dxWorkOrder__Master = wi.PK_dxWorkOrder
        and wo.FK_dxProduct = ad.FK_dxProduct
   End
End
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxWorkOrder.trWorkOrderStatusChange] ON [dbo].[dxWorkOrder]
FOR UPDATE
AS
Begin
   If update(WorkOrderStatus)
   Begin
     Update wo
        Set WorkOrderStatus = wi.WorkOrderStatus

     From dxWorkOrder wo
     left join inserted wi on ( wi.PK_dxWorkOrder = wo.FK_dxWorkOrder__Master and wi.WorkOrderStatus <= 1)
     Where wi.WorkOrderStatus <= 1
       and wo.WorkOrderStatus <= 1

   End
End
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [CK_dxWorkOrder_AskedQuantity] CHECK (([AskedQuantity]>(0.0) AND [QuantityToProduce]>(0.0)))
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [CK_dxWorkOrder_WorkOrderStatus] CHECK (([WorkOrderStatus]=(4) OR [WorkOrderStatus]=(3) OR [WorkOrderStatus]=(2) OR [WorkOrderStatus]=(1) OR [WorkOrderStatus]=(0)))
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [PK_dxWorkOrder] PRIMARY KEY CLUSTERED  ([PK_dxWorkOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrder_FK_dxClientOrderDetail] ON [dbo].[dxWorkOrder] ([FK_dxClientOrderDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrder_FK_dxDeclarationDismantling] ON [dbo].[dxWorkOrder] ([FK_dxDeclarationDismantling]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrder_FK_dxLocation] ON [dbo].[dxWorkOrder] ([FK_dxLocation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrder_FK_dxProduct] ON [dbo].[dxWorkOrder] ([FK_dxProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrder_FK_dxProductionLine] ON [dbo].[dxWorkOrder] ([FK_dxProductionLine]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrder_FK_dxRouting] ON [dbo].[dxWorkOrder] ([FK_dxRouting]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrder_FK_dxWarehouse] ON [dbo].[dxWorkOrder] ([FK_dxWarehouse]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrder_FK_dxWorkOrder__Master] ON [dbo].[dxWorkOrder] ([FK_dxWorkOrder__Master]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxWorkOrderDate] ON [dbo].[dxWorkOrder] ([WorkOrderDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxWorkOrderStatus] ON [dbo].[dxWorkOrder] ([WorkOrderStatus]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [dxConstraint_FK_dxClientOrderDetail_dxWorkOrder] FOREIGN KEY ([FK_dxClientOrderDetail]) REFERENCES [dbo].[dxClientOrderDetail] ([PK_dxClientOrderDetail])
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [dxConstraint_FK_dxDeclarationDismantling_dxWorkOrder] FOREIGN KEY ([FK_dxDeclarationDismantling]) REFERENCES [dbo].[dxDeclarationDismantling] ([PK_dxDeclarationDismantling])
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [dxConstraint_FK_dxLocation_dxWorkOrder] FOREIGN KEY ([FK_dxLocation]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [dxConstraint_FK_dxProduct_dxWorkOrder] FOREIGN KEY ([FK_dxProduct]) REFERENCES [dbo].[dxProduct] ([PK_dxProduct])
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [dxConstraint_FK_dxProductionLine_dxWorkOrder] FOREIGN KEY ([FK_dxProductionLine]) REFERENCES [dbo].[dxProductionLine] ([PK_dxProductionLine])
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [dxConstraint_FK_dxRouting_dxWorkOrder] FOREIGN KEY ([FK_dxRouting]) REFERENCES [dbo].[dxRouting] ([PK_dxRouting])
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse_dxWorkOrder] FOREIGN KEY ([FK_dxWarehouse]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
ALTER TABLE [dbo].[dxWorkOrder] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrder__Master_dxWorkOrder] FOREIGN KEY ([FK_dxWorkOrder__Master]) REFERENCES [dbo].[dxWorkOrder] ([PK_dxWorkOrder])
GO
