CREATE TABLE [dbo].[dxShipping]
(
[PK_dxShipping] [int] NOT NULL IDENTITY(40000, 1),
[ID] AS ([PK_dxShipping]),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxShipping_Posted] DEFAULT ((0)),
[FK_dxClient] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxAddress__Billing] [int] NULL,
[BillingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxAddress__Shipping] [int] NULL,
[ShippingAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxFOB] [int] NULL,
[FOB] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxShipVia] [int] NULL,
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[ListOfOrder] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxShipping_ListOfOrder] DEFAULT (''),
[FK_dxClientOrder] [int] NULL,
[NumberOfBoxes] [int] NOT NULL CONSTRAINT [DF_dxShipping_NumberOfBoxes] DEFAULT ((0)),
[NumberOfCases] [int] NOT NULL CONSTRAINT [DF_dxShipping_NumberOfCases] DEFAULT ((0)),
[NumberOfSkids] [int] NOT NULL CONSTRAINT [DF_dxShipping_NumberOfSkids] DEFAULT ((0)),
[ReleaseNumber] [int] NOT NULL CONSTRAINT [DF_dxShipping_ReleaseNumber] DEFAULT ((1)),
[FK_dxShippingServiceType] [int] NULL,
[FK_dxEmployee__ApprovedBy] [int] NULL,
[Priority] [float] NOT NULL CONSTRAINT [DF_dxShipping_Priority] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShipping.trAuditDelete] ON [dbo].[dxShipping]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxShipping'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxShipping CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShipping, ID, Posted, FK_dxClient, TransactionDate, Description, FK_dxAddress__Billing, BillingAddress, FK_dxAddress__Shipping, ShippingAddress, FK_dxNote, Note, FK_dxFOB, FOB, FK_dxShipVia, ShipVia, ListOfOrder, FK_dxClientOrder, NumberOfBoxes, NumberOfCases, NumberOfSkids, ReleaseNumber, FK_dxShippingServiceType, FK_dxEmployee__ApprovedBy, Priority from deleted
 Declare @PK_dxShipping int, @ID int, @Posted Bit, @FK_dxClient int, @TransactionDate DateTime, @Description varchar(500), @FK_dxAddress__Billing int, @BillingAddress varchar(1000), @FK_dxAddress__Shipping int, @ShippingAddress varchar(1000), @FK_dxNote int, @Note varchar(2000), @FK_dxFOB int, @FOB varchar(500), @FK_dxShipVia int, @ShipVia varchar(500), @ListOfOrder varchar(500), @FK_dxClientOrder int, @NumberOfBoxes int, @NumberOfCases int, @NumberOfSkids int, @ReleaseNumber int, @FK_dxShippingServiceType int, @FK_dxEmployee__ApprovedBy int, @Priority Float

 OPEN pk_cursordxShipping
 FETCH NEXT FROM pk_cursordxShipping INTO @PK_dxShipping, @ID, @Posted, @FK_dxClient, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @FK_dxNote, @Note, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @ListOfOrder, @FK_dxClientOrder, @NumberOfBoxes, @NumberOfCases, @NumberOfSkids, @ReleaseNumber, @FK_dxShippingServiceType, @FK_dxEmployee__ApprovedBy, @Priority
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxShipping, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Billing', @FK_dxAddress__Billing
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillingAddress', @BillingAddress
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Shipping', @FK_dxAddress__Shipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShippingAddress', @ShippingAddress
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', @FK_dxNote
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', @FK_dxFOB
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', @FOB
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', @FK_dxShipVia
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', @ShipVia
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfOrder', @ListOfOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', @FK_dxClientOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfBoxes', @NumberOfBoxes
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfCases', @NumberOfCases
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfSkids', @NumberOfSkids
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ReleaseNumber', @ReleaseNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', @FK_dxShippingServiceType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__ApprovedBy', @FK_dxEmployee__ApprovedBy
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Priority', @Priority
FETCH NEXT FROM pk_cursordxShipping INTO @PK_dxShipping, @ID, @Posted, @FK_dxClient, @TransactionDate, @Description, @FK_dxAddress__Billing, @BillingAddress, @FK_dxAddress__Shipping, @ShippingAddress, @FK_dxNote, @Note, @FK_dxFOB, @FOB, @FK_dxShipVia, @ShipVia, @ListOfOrder, @FK_dxClientOrder, @NumberOfBoxes, @NumberOfCases, @NumberOfSkids, @ReleaseNumber, @FK_dxShippingServiceType, @FK_dxEmployee__ApprovedBy, @Priority
 END

 CLOSE pk_cursordxShipping 
 DEALLOCATE pk_cursordxShipping
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShipping.trAuditInsUpd] ON [dbo].[dxShipping] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxShipping CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShipping from inserted;
 set @tablename = 'dxShipping' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxShipping
 FETCH NEXT FROM pk_cursordxShipping INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Billing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Billing', FK_dxAddress__Billing from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BillingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BillingAddress', BillingAddress from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Shipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Shipping', FK_dxAddress__Shipping from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShippingAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShippingAddress', ShippingAddress from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', FK_dxFOB from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', FOB from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', FK_dxShipVia from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ListOfOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfOrder', ListOfOrder from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientOrder', FK_dxClientOrder from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfBoxes )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfBoxes', NumberOfBoxes from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfCases )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfCases', NumberOfCases from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfSkids )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfSkids', NumberOfSkids from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReleaseNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ReleaseNumber', ReleaseNumber from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingServiceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', FK_dxShippingServiceType from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__ApprovedBy )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__ApprovedBy', FK_dxEmployee__ApprovedBy from dxShipping where PK_dxShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Priority )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Priority', Priority from dxShipping where PK_dxShipping = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxShipping INTO @keyvalue
 END

 CLOSE pk_cursordxShipping 
 DEALLOCATE pk_cursordxShipping
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShipping.trDelete] ON [dbo].[dxShipping]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  delete from dxShippingDetail where FK_dxShipping in (SELECT PK_dxShipping FROM deleted) ;
  delete from dxShipping       where PK_dxShipping in (SELECT PK_dxShipping FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [PK_dxShipping] PRIMARY KEY CLUSTERED  ([PK_dxShipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxAddress__Billing] ON [dbo].[dxShipping] ([FK_dxAddress__Billing]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxAddress__Shipping] ON [dbo].[dxShipping] ([FK_dxAddress__Shipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxClient] ON [dbo].[dxShipping] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxClientOrder] ON [dbo].[dxShipping] ([FK_dxClientOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxEmployee__ApprovedBy] ON [dbo].[dxShipping] ([FK_dxEmployee__ApprovedBy]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxFOB] ON [dbo].[dxShipping] ([FK_dxFOB]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxNote] ON [dbo].[dxShipping] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxShippingServiceType] ON [dbo].[dxShipping] ([FK_dxShippingServiceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShipping_FK_dxShipVia] ON [dbo].[dxShipping] ([FK_dxShipVia]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxShippingDate] ON [dbo].[dxShipping] ([TransactionDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Billing_dxShipping] FOREIGN KEY ([FK_dxAddress__Billing]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Shipping_dxShipping] FOREIGN KEY ([FK_dxAddress__Shipping]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxShipping] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxClientOrder_dxShipping] FOREIGN KEY ([FK_dxClientOrder]) REFERENCES [dbo].[dxClientOrder] ([PK_dxClientOrder])
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__ApprovedBy_dxShipping] FOREIGN KEY ([FK_dxEmployee__ApprovedBy]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxFOB_dxShipping] FOREIGN KEY ([FK_dxFOB]) REFERENCES [dbo].[dxFOB] ([PK_dxFOB])
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxShipping] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxShippingServiceType_dxShipping] FOREIGN KEY ([FK_dxShippingServiceType]) REFERENCES [dbo].[dxShippingServiceType] ([PK_dxShippingServiceType])
GO
ALTER TABLE [dbo].[dxShipping] ADD CONSTRAINT [dxConstraint_FK_dxShipVia_dxShipping] FOREIGN KEY ([FK_dxShipVia]) REFERENCES [dbo].[dxShipVia] ([PK_dxShipVia])
GO
