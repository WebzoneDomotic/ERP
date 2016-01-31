CREATE TABLE [dbo].[dxPurchasePlanning]
(
[PK_dxPurchasePlanning] [int] NOT NULL IDENTITY(90000, 1),
[FK_dxKanban] [int] NULL,
[RequestDate] [datetime] NULL,
[RequestQuantity] [float] NOT NULL CONSTRAINT [DF_dxPurchasePlanning_RequestQuantity] DEFAULT ((0.0)),
[FK_dxVendor] [int] NULL,
[PoNumber] [varchar] (50) COLLATE French_CI_AS NULL,
[OrderDate] [datetime] NULL,
[OrderedQuantity] [float] NOT NULL CONSTRAINT [DF_dxPurchasePlanning_OrderedQuantity] DEFAULT ((0.0)),
[ReceptionNumber] [varchar] (50) COLLATE French_CI_AS NULL,
[ReceptionDate] [datetime] NULL,
[ReceivedQuantity] [float] NOT NULL CONSTRAINT [DF_dxPurchasePlanning_ReceivedQuantity] DEFAULT ((0.0)),
[Note] [varchar] (500) COLLATE French_CI_AS NULL,
[ID] AS (CONVERT([varchar](50),[PK_dxPurchasePlanning],(0)))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPurchasePlanning.trAuditDelete] ON [dbo].[dxPurchasePlanning]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPurchasePlanning'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPurchasePlanning CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPurchasePlanning, FK_dxKanban, RequestDate, RequestQuantity, FK_dxVendor, PoNumber, OrderDate, OrderedQuantity, ReceptionNumber, ReceptionDate, ReceivedQuantity, Note, ID from deleted
 Declare @PK_dxPurchasePlanning int, @FK_dxKanban int, @RequestDate DateTime, @RequestQuantity Float, @FK_dxVendor int, @PoNumber varchar(50), @OrderDate DateTime, @OrderedQuantity Float, @ReceptionNumber varchar(50), @ReceptionDate DateTime, @ReceivedQuantity Float, @Note varchar(500), @ID varchar(50)

 OPEN pk_cursordxPurchasePlanning
 FETCH NEXT FROM pk_cursordxPurchasePlanning INTO @PK_dxPurchasePlanning, @FK_dxKanban, @RequestDate, @RequestQuantity, @FK_dxVendor, @PoNumber, @OrderDate, @OrderedQuantity, @ReceptionNumber, @ReceptionDate, @ReceivedQuantity, @Note, @ID
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPurchasePlanning, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxKanban', @FK_dxKanban
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'RequestDate', @RequestDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RequestQuantity', @RequestQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PoNumber', @PoNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'OrderDate', @OrderDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderedQuantity', @OrderedQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ReceptionNumber', @ReceptionNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ReceptionDate', @ReceptionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReceivedQuantity', @ReceivedQuantity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
FETCH NEXT FROM pk_cursordxPurchasePlanning INTO @PK_dxPurchasePlanning, @FK_dxKanban, @RequestDate, @RequestQuantity, @FK_dxVendor, @PoNumber, @OrderDate, @OrderedQuantity, @ReceptionNumber, @ReceptionDate, @ReceivedQuantity, @Note, @ID
 END

 CLOSE pk_cursordxPurchasePlanning 
 DEALLOCATE pk_cursordxPurchasePlanning
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPurchasePlanning.trAuditInsUpd] ON [dbo].[dxPurchasePlanning] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPurchasePlanning CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPurchasePlanning from inserted;
 set @tablename = 'dxPurchasePlanning' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPurchasePlanning
 FETCH NEXT FROM pk_cursordxPurchasePlanning INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxKanban )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxKanban', FK_dxKanban from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RequestDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'RequestDate', RequestDate from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RequestQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'RequestQuantity', RequestQuantity from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PoNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PoNumber', PoNumber from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OrderDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'OrderDate', OrderDate from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OrderedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderedQuantity', OrderedQuantity from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReceptionNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ReceptionNumber', ReceptionNumber from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReceptionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ReceptionDate', ReceptionDate from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReceivedQuantity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReceivedQuantity', ReceivedQuantity from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxPurchasePlanning where PK_dxPurchasePlanning = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPurchasePlanning INTO @keyvalue
 END

 CLOSE pk_cursordxPurchasePlanning 
 DEALLOCATE pk_cursordxPurchasePlanning
GO
ALTER TABLE [dbo].[dxPurchasePlanning] ADD CONSTRAINT [PK_dxPurchasePlanning] PRIMARY KEY CLUSTERED  ([PK_dxPurchasePlanning]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchasePlanning_FK_dxKanban] ON [dbo].[dxPurchasePlanning] ([FK_dxKanban]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPurchasePlanning_FK_dxVendor] ON [dbo].[dxPurchasePlanning] ([FK_dxVendor]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPurchasePlanning] ADD CONSTRAINT [dxConstraint_FK_dxKanban_dxPurchasePlanning] FOREIGN KEY ([FK_dxKanban]) REFERENCES [dbo].[dxKanban] ([PK_dxKanban])
GO
ALTER TABLE [dbo].[dxPurchasePlanning] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxPurchasePlanning] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
