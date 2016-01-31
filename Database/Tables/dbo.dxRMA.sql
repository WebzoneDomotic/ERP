CREATE TABLE [dbo].[dxRMA]
(
[PK_dxRMA] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxRMA]),
[FK_dxClient] [int] NOT NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxRMA_Posted] DEFAULT ((0)),
[TransactionDate] [datetime] NOT NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxShipVia] [int] NULL,
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[ListOfOrder] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF__dxRMA__ListOfOrd__0B129727] DEFAULT (''),
[ListOfShipping] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF__dxRMA__ListOfShi__0C06BB60] DEFAULT (''),
[NumberOfBoxes] [int] NOT NULL CONSTRAINT [DF_dxRMA_NumberOfBoxes] DEFAULT ((0)),
[NumberOfCases] [int] NOT NULL CONSTRAINT [DF_dxRMA_NumberOfCases] DEFAULT ((0)),
[NumberOfSkids] [int] NOT NULL CONSTRAINT [DF_dxRMA_NumberOfSkids] DEFAULT ((0)),
[ComplaintDate] [datetime] NOT NULL CONSTRAINT [DF_dxRMA_ComplaintDate] DEFAULT (getdate()),
[FK_dxPropertyGroup] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRMA.trAuditDelete] ON [dbo].[dxRMA]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxRMA'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxRMA CURSOR LOCAL FAST_FORWARD for SELECT PK_dxRMA, ID, FK_dxClient, Posted, TransactionDate, Description, FK_dxNote, Note, FK_dxShipVia, ShipVia, ListOfOrder, ListOfShipping, NumberOfBoxes, NumberOfCases, NumberOfSkids, ComplaintDate, FK_dxPropertyGroup from deleted
 Declare @PK_dxRMA int, @ID int, @FK_dxClient int, @Posted Bit, @TransactionDate DateTime, @Description varchar(500), @FK_dxNote int, @Note varchar(2000), @FK_dxShipVia int, @ShipVia varchar(500), @ListOfOrder varchar(500), @ListOfShipping varchar(500), @NumberOfBoxes int, @NumberOfCases int, @NumberOfSkids int, @ComplaintDate DateTime, @FK_dxPropertyGroup int

 OPEN pk_cursordxRMA
 FETCH NEXT FROM pk_cursordxRMA INTO @PK_dxRMA, @ID, @FK_dxClient, @Posted, @TransactionDate, @Description, @FK_dxNote, @Note, @FK_dxShipVia, @ShipVia, @ListOfOrder, @ListOfShipping, @NumberOfBoxes, @NumberOfCases, @NumberOfSkids, @ComplaintDate, @FK_dxPropertyGroup
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxRMA, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', @FK_dxNote
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfShipping', @ListOfShipping
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ComplaintDate', @ComplaintDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', @FK_dxPropertyGroup
FETCH NEXT FROM pk_cursordxRMA INTO @PK_dxRMA, @ID, @FK_dxClient, @Posted, @TransactionDate, @Description, @FK_dxNote, @Note, @FK_dxShipVia, @ShipVia, @ListOfOrder, @ListOfShipping, @NumberOfBoxes, @NumberOfCases, @NumberOfSkids, @ComplaintDate, @FK_dxPropertyGroup
 END

 CLOSE pk_cursordxRMA 
 DEALLOCATE pk_cursordxRMA
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRMA.trAuditInsUpd] ON [dbo].[dxRMA] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxRMA CURSOR LOCAL FAST_FORWARD for SELECT PK_dxRMA from inserted;
 set @tablename = 'dxRMA' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxRMA
 FETCH NEXT FROM pk_cursordxRMA INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', FK_dxShipVia from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ListOfOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfOrder', ListOfOrder from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ListOfShipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfShipping', ListOfShipping from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfBoxes )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfBoxes', NumberOfBoxes from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfCases )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfCases', NumberOfCases from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfSkids )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfSkids', NumberOfSkids from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ComplaintDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ComplaintDate', ComplaintDate from dxRMA where PK_dxRMA = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPropertyGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', FK_dxPropertyGroup from dxRMA where PK_dxRMA = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxRMA INTO @keyvalue
 END

 CLOSE pk_cursordxRMA 
 DEALLOCATE pk_cursordxRMA
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRMA.trDelete] ON [dbo].[dxRMA]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  delete from dxRMADetail where FK_dxRMA in (SELECT PK_dxRMA FROM deleted) ;
  delete from dxRMA       where PK_dxRMA in (SELECT PK_dxRMA FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
ALTER TABLE [dbo].[dxRMA] ADD CONSTRAINT [PK_dxRMA] PRIMARY KEY CLUSTERED  ([PK_dxRMA]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMA_FK_dxClient] ON [dbo].[dxRMA] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMA_FK_dxNote] ON [dbo].[dxRMA] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMA_FK_dxPropertyGroup] ON [dbo].[dxRMA] ([FK_dxPropertyGroup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxRMA_FK_dxShipVia] ON [dbo].[dxRMA] ([FK_dxShipVia]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxRMA] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxRMA] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxRMA] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxRMA] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxRMA] ADD CONSTRAINT [dxConstraint_FK_dxPropertyGroup_dxRMA] FOREIGN KEY ([FK_dxPropertyGroup]) REFERENCES [dbo].[dxPropertyGroup] ([PK_dxPropertyGroup])
GO
ALTER TABLE [dbo].[dxRMA] ADD CONSTRAINT [dxConstraint_FK_dxShipVia_dxRMA] FOREIGN KEY ([FK_dxShipVia]) REFERENCES [dbo].[dxShipVia] ([PK_dxShipVia])
GO
