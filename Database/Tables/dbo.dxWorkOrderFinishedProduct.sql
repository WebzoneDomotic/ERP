CREATE TABLE [dbo].[dxWorkOrderFinishedProduct]
(
[PK_dxWorkOrderFinishedProduct] [int] NOT NULL IDENTITY(1, 1),
[FK_dxWorkOrder] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[Lot] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxWorkOrderFinishedProduct_Lot] DEFAULT ('0'),
[Sequence] [int] NOT NULL CONSTRAINT [DF_dxWorkOrderFinishedProduct_Sequence] DEFAULT ((0)),
[Quantity] [float] NOT NULL CONSTRAINT [DF_dxWorkOrderFinishedProduct_Quantity] DEFAULT ((0.0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxWorkOrderFinishedProduct_Posted] DEFAULT ((0)),
[Note] [varchar] (8000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxWorkOrderFinishedProduct.trAuditDelete] ON [dbo].[dxWorkOrderFinishedProduct]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxWorkOrderFinishedProduct'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxWorkOrderFinishedProduct CURSOR LOCAL FAST_FORWARD for SELECT PK_dxWorkOrderFinishedProduct, FK_dxWorkOrder, TransactionDate, Lot, Sequence, Quantity, Posted, Note from deleted
 Declare @PK_dxWorkOrderFinishedProduct int, @FK_dxWorkOrder int, @TransactionDate DateTime, @Lot varchar(50), @Sequence int, @Quantity Float, @Posted Bit, @Note varchar(8000)

 OPEN pk_cursordxWorkOrderFinishedProduct
 FETCH NEXT FROM pk_cursordxWorkOrderFinishedProduct INTO @PK_dxWorkOrderFinishedProduct, @FK_dxWorkOrder, @TransactionDate, @Lot, @Sequence, @Quantity, @Posted, @Note
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxWorkOrderFinishedProduct, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWorkOrder', @FK_dxWorkOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', @Lot
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'Sequence', @Sequence
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', @Quantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
FETCH NEXT FROM pk_cursordxWorkOrderFinishedProduct INTO @PK_dxWorkOrderFinishedProduct, @FK_dxWorkOrder, @TransactionDate, @Lot, @Sequence, @Quantity, @Posted, @Note
 END

 CLOSE pk_cursordxWorkOrderFinishedProduct 
 DEALLOCATE pk_cursordxWorkOrderFinishedProduct
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxWorkOrderFinishedProduct.trAuditInsUpd] ON [dbo].[dxWorkOrderFinishedProduct] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxWorkOrderFinishedProduct CURSOR LOCAL FAST_FORWARD for SELECT PK_dxWorkOrderFinishedProduct from inserted;
 set @tablename = 'dxWorkOrderFinishedProduct' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxWorkOrderFinishedProduct
 FETCH NEXT FROM pk_cursordxWorkOrderFinishedProduct INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWorkOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWorkOrder', FK_dxWorkOrder from dxWorkOrderFinishedProduct where PK_dxWorkOrderFinishedProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxWorkOrderFinishedProduct where PK_dxWorkOrderFinishedProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Lot )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Lot', Lot from dxWorkOrderFinishedProduct where PK_dxWorkOrderFinishedProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Sequence )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'Sequence', Sequence from dxWorkOrderFinishedProduct where PK_dxWorkOrderFinishedProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Quantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Quantity', Quantity from dxWorkOrderFinishedProduct where PK_dxWorkOrderFinishedProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxWorkOrderFinishedProduct where PK_dxWorkOrderFinishedProduct = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxWorkOrderFinishedProduct where PK_dxWorkOrderFinishedProduct = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxWorkOrderFinishedProduct INTO @keyvalue
 END

 CLOSE pk_cursordxWorkOrderFinishedProduct 
 DEALLOCATE pk_cursordxWorkOrderFinishedProduct
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxWorkOrderFinishedProduct.trBuildList] ON [dbo].[dxWorkOrderFinishedProduct]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;
   declare @DocList varchar(150);

   set @FKi = ( SELECT Coalesce(max(FK_dxWorkOrder ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxWorkOrder ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   Set  @DocList = Null ;
   select  @DocList =
              case dbo.fdxIncluded( Coalesce(Convert(varchar(50),  Lot),'') , @DocList )  when 1 then  @DocList
              else  COALESCE(@DocList  + ',', '') + Coalesce(Convert(varchar(50),  Lot),'')
              end  from dxWorkOrderFinishedProduct where FK_dxWorkOrder = @FK and not FK_dxWorkOrder is null
   update dxWorkOrder set LotNumberList =  Coalesce(@DocList, '')  where PK_dxWorkOrder = @FK ;

END
GO
ALTER TABLE [dbo].[dxWorkOrderFinishedProduct] ADD CONSTRAINT [CK_dxWorkOrderFinishedProduct_Quantity] CHECK (([Quantity]>(0.0)))
GO
ALTER TABLE [dbo].[dxWorkOrderFinishedProduct] ADD CONSTRAINT [PK_dxWorkOrderFinishedProduct] PRIMARY KEY CLUSTERED  ([PK_dxWorkOrderFinishedProduct]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxWorkOrderFinishedProduct_FK_dxWorkOrder] ON [dbo].[dxWorkOrderFinishedProduct] ([FK_dxWorkOrder]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxWorkOrderFinishedProduct] ADD CONSTRAINT [dxConstraint_FK_dxWorkOrder_dxWorkOrderFinishedProduct] FOREIGN KEY ([FK_dxWorkOrder]) REFERENCES [dbo].[dxWorkOrder] ([PK_dxWorkOrder])
GO
