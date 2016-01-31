CREATE TABLE [dbo].[dxCurrency]
(
[PK_dxCurrency] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Symbol] [varchar] (10) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxAccount__Payable] [int] NULL,
[FK_dxAccount__PayableAccrual] [int] NULL,
[FK_dxAccount__Receivable] [int] NULL,
[RSSNoonRate] [varchar] (255) COLLATE French_CI_AS NULL,
[RSSClosingRate] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxAccount__ReceivableAccrual] [int] NULL,
[FK_dxAccount__CashReceiptDiscountAmount] [int] NULL,
[FK_dxAccount__PayableAdjustmentAmount] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCurrency.trAuditDelete] ON [dbo].[dxCurrency]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCurrency'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCurrency CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCurrency, ID, Symbol, Description, FK_dxAccount__Payable, FK_dxAccount__PayableAccrual, FK_dxAccount__Receivable, RSSNoonRate, RSSClosingRate, FK_dxAccount__ReceivableAccrual, FK_dxAccount__CashReceiptDiscountAmount, FK_dxAccount__PayableAdjustmentAmount from deleted
 Declare @PK_dxCurrency int, @ID varchar(50), @Symbol varchar(10), @Description varchar(255), @FK_dxAccount__Payable int, @FK_dxAccount__PayableAccrual int, @FK_dxAccount__Receivable int, @RSSNoonRate varchar(255), @RSSClosingRate varchar(255), @FK_dxAccount__ReceivableAccrual int, @FK_dxAccount__CashReceiptDiscountAmount int, @FK_dxAccount__PayableAdjustmentAmount int

 OPEN pk_cursordxCurrency
 FETCH NEXT FROM pk_cursordxCurrency INTO @PK_dxCurrency, @ID, @Symbol, @Description, @FK_dxAccount__Payable, @FK_dxAccount__PayableAccrual, @FK_dxAccount__Receivable, @RSSNoonRate, @RSSClosingRate, @FK_dxAccount__ReceivableAccrual, @FK_dxAccount__CashReceiptDiscountAmount, @FK_dxAccount__PayableAdjustmentAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCurrency, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Symbol', @Symbol
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Payable', @FK_dxAccount__Payable
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__PayableAccrual', @FK_dxAccount__PayableAccrual
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Receivable', @FK_dxAccount__Receivable
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'RSSNoonRate', @RSSNoonRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'RSSClosingRate', @RSSClosingRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ReceivableAccrual', @FK_dxAccount__ReceivableAccrual
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CashReceiptDiscountAmount', @FK_dxAccount__CashReceiptDiscountAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__PayableAdjustmentAmount', @FK_dxAccount__PayableAdjustmentAmount
FETCH NEXT FROM pk_cursordxCurrency INTO @PK_dxCurrency, @ID, @Symbol, @Description, @FK_dxAccount__Payable, @FK_dxAccount__PayableAccrual, @FK_dxAccount__Receivable, @RSSNoonRate, @RSSClosingRate, @FK_dxAccount__ReceivableAccrual, @FK_dxAccount__CashReceiptDiscountAmount, @FK_dxAccount__PayableAdjustmentAmount
 END

 CLOSE pk_cursordxCurrency 
 DEALLOCATE pk_cursordxCurrency
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCurrency.trAuditInsUpd] ON [dbo].[dxCurrency] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCurrency CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCurrency from inserted;
 set @tablename = 'dxCurrency' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCurrency
 FETCH NEXT FROM pk_cursordxCurrency INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Symbol )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Symbol', Symbol from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Payable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Payable', FK_dxAccount__Payable from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__PayableAccrual )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__PayableAccrual', FK_dxAccount__PayableAccrual from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Receivable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Receivable', FK_dxAccount__Receivable from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RSSNoonRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'RSSNoonRate', RSSNoonRate from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RSSClosingRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'RSSClosingRate', RSSClosingRate from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__ReceivableAccrual )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ReceivableAccrual', FK_dxAccount__ReceivableAccrual from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__CashReceiptDiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__CashReceiptDiscountAmount', FK_dxAccount__CashReceiptDiscountAmount from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__PayableAdjustmentAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__PayableAdjustmentAmount', FK_dxAccount__PayableAdjustmentAmount from dxCurrency where PK_dxCurrency = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCurrency INTO @keyvalue
 END

 CLOSE pk_cursordxCurrency 
 DEALLOCATE pk_cursordxCurrency
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCurrency.trPeriodCurrency] ON [dbo].[dxCurrency]
AFTER INSERT
AS
BEGIN
   SET NOCOUNT ON
   IF TRIGGER_NESTLEVEL() > 10 RETURN
   Execute [dbo].[pdxGLEntryPeriodCurrency]
   SET NOCOUNT OFF
END
GO
ALTER TABLE [dbo].[dxCurrency] ADD CONSTRAINT [PK_dxCurrency] PRIMARY KEY CLUSTERED  ([PK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrency_FK_dxAccount__CashReceiptDiscountAmount] ON [dbo].[dxCurrency] ([FK_dxAccount__CashReceiptDiscountAmount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrency_FK_dxAccount__Payable] ON [dbo].[dxCurrency] ([FK_dxAccount__Payable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrency_FK_dxAccount__PayableAccrual] ON [dbo].[dxCurrency] ([FK_dxAccount__PayableAccrual]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrency_FK_dxAccount__PayableAdjustmentAmount] ON [dbo].[dxCurrency] ([FK_dxAccount__PayableAdjustmentAmount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrency_FK_dxAccount__Receivable] ON [dbo].[dxCurrency] ([FK_dxAccount__Receivable]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrency_FK_dxAccount__ReceivableAccrual] ON [dbo].[dxCurrency] ([FK_dxAccount__ReceivableAccrual]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxCurrency] ON [dbo].[dxCurrency] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCurrency] ADD CONSTRAINT [dxConstraint_FK_dxAccount__CashReceiptDiscountAmount_dxCurrency] FOREIGN KEY ([FK_dxAccount__CashReceiptDiscountAmount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxCurrency] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Payable_dxCurrency] FOREIGN KEY ([FK_dxAccount__Payable]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxCurrency] ADD CONSTRAINT [dxConstraint_FK_dxAccount__PayableAccrual_dxCurrency] FOREIGN KEY ([FK_dxAccount__PayableAccrual]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxCurrency] ADD CONSTRAINT [dxConstraint_FK_dxAccount__PayableAdjustmentAmount_dxCurrency] FOREIGN KEY ([FK_dxAccount__PayableAdjustmentAmount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxCurrency] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Receivable_dxCurrency] FOREIGN KEY ([FK_dxAccount__Receivable]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxCurrency] ADD CONSTRAINT [dxConstraint_FK_dxAccount__ReceivableAccrual_dxCurrency] FOREIGN KEY ([FK_dxAccount__ReceivableAccrual]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
