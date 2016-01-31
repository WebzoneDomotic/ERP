CREATE TABLE [dbo].[dxDeclaration]
(
[PK_dxDeclaration] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxDeclaration]),
[FK_dxWorkOrder] [int] NOT NULL,
[PhaseNumber] [int] NOT NULL CONSTRAINT [DF_dxDeclaration_PhaseNumber] DEFAULT ((10)),
[TransactionDate] [datetime] NOT NULL,
[DeclaredQuantity] [float] NOT NULL CONSTRAINT [DF_dxDeclaration_DeclaredQuantity] DEFAULT ((0.0)),
[RejectedQuantity] [float] NOT NULL CONSTRAINT [DF_dxDeclaration_RejectedQuantity] DEFAULT ((0.0)),
[TotalQuantity] AS ([DeclaredQuantity]+[RejectedQuantity]),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxDeclaration_Posted] DEFAULT ((0)),
[Note] [varchar] (8000) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxDeclaration_Note] DEFAULT ((0)),
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxDeclaration_DocumentStatus] DEFAULT ((0)),
[Closed] [bit] NOT NULL CONSTRAINT [DF_dxDeclaration_Closed] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeclaration.trAuditDelete] ON [dbo].[dxDeclaration]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxDeclaration'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxDeclaration CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDeclaration, ID, FK_dxWorkOrder, PhaseNumber, TransactionDate, DeclaredQuantity, RejectedQuantity, TotalQuantity, Posted, Note, DocumentStatus, Closed from deleted
 Declare @PK_dxDeclaration int, @ID int, @FK_dxWorkOrder int, @PhaseNumber int, @TransactionDate DateTime, @DeclaredQuantity Float, @RejectedQuantity Float, @TotalQuantity Float, @Posted Bit, @Note varchar(8000), @DocumentStatus int, @Closed Bit

 OPEN pk_cursordxDeclaration
 FETCH NEXT FROM pk_cursordxDeclaration INTO @PK_dxDeclaration, @ID, @FK_dxWorkOrder, @PhaseNumber, @TransactionDate, @DeclaredQuantity, @RejectedQuantity, @TotalQuantity, @Posted, @Note, @DocumentStatus, @Closed
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxDeclaration, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWorkOrder', @FK_dxWorkOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PhaseNumber', @PhaseNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DeclaredQuantity', @DeclaredQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RejectedQuantity', @RejectedQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', @Closed
FETCH NEXT FROM pk_cursordxDeclaration INTO @PK_dxDeclaration, @ID, @FK_dxWorkOrder, @PhaseNumber, @TransactionDate, @DeclaredQuantity, @RejectedQuantity, @TotalQuantity, @Posted, @Note, @DocumentStatus, @Closed
 END

 CLOSE pk_cursordxDeclaration 
 DEALLOCATE pk_cursordxDeclaration
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeclaration.trAuditInsUpd] ON [dbo].[dxDeclaration] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxDeclaration CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDeclaration from inserted;
 set @tablename = 'dxDeclaration' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxDeclaration
 FETCH NEXT FROM pk_cursordxDeclaration INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWorkOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWorkOrder', FK_dxWorkOrder from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PhaseNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PhaseNumber', PhaseNumber from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DeclaredQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DeclaredQuantity', DeclaredQuantity from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RejectedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RejectedQuantity', RejectedQuantity from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Closed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Closed', Closed from dxDeclaration where PK_dxDeclaration = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxDeclaration INTO @keyvalue
 END

 CLOSE pk_cursordxDeclaration 
 DEALLOCATE pk_cursordxDeclaration
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create TRIGGER [dbo].[dxDeclaration.trDeclared] ON [dbo].[dxDeclaration]
FOR INSERT, UPDATE
AS
  -- W.O. Status
  -- 0 Planned
  -- 1 Accepted
  -- 2 Started
  -- 3 Stoped
  -- 4 Closed

  Declare @Status int
  set @Status = ( Select Max(WorkOrderStatus) From dxWorkOrder where  PK_dxWorkOrder in ( Select FK_dxWorkOrder from inserted ))
  if @Status = 0
  begin
    ROLLBACK TRANSACTION
    RAISERROR('La production n''a pas été autorisée (confirmée). Impossible de débuter la production', 16, 1)
    RETURN
  end else
  if @Status = 3
  begin
    ROLLBACK TRANSACTION
    RAISERROR('La production est arrêtée pour cet O.F.', 16, 1)
    RETURN
  end else
  if @Status = 4
  begin
    ROLLBACK TRANSACTION
    RAISERROR('La production est terminée pour cet O.F.', 16, 1)
    RETURN
  end else
  --Change work order status
  if Update(Posted)
    update dxWorkOrder set WorkOrderStatus =  2
    where PK_dxWorkOrder in ( Select FK_dxWorkOrder from inserted )
      and WorkOrderStatus <= 1
GO
ALTER TABLE [dbo].[dxDeclaration] ADD CONSTRAINT [CK_dxDeclaration] CHECK (([DeclaredQuantity]>=(0.0) AND [RejectedQuantity]>=(0.0)))
GO
ALTER TABLE [dbo].[dxDeclaration] ADD CONSTRAINT [PK_dxDeclaration] PRIMARY KEY CLUSTERED  ([PK_dxDeclaration]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeclaration_FK_dxWorkOrder] ON [dbo].[dxDeclaration] ([FK_dxWorkOrder]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDeclaration] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrder_dxDeclaration] FOREIGN KEY ([FK_dxWorkOrder]) REFERENCES [dbo].[dxWorkOrder] ([PK_dxWorkOrder])
GO
