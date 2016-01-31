CREATE TABLE [dbo].[dxCashReceipt]
(
[PK_dxCashReceipt] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxCashReceipt]),
[FK_dxClient] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[FK_dxCurrency] [int] NOT NULL,
[FK_dxPaymentType] [int] NOT NULL,
[FK_dxBankAccount] [int] NOT NULL,
[Reference] [varchar] (50) COLLATE French_CI_AS NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceipt_TotalAmount] DEFAULT ((0.0)),
[UnusedAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceipt_BalanceAmount] DEFAULT ((0.0)),
[FK_dxAccount] [int] NOT NULL,
[FK_dxDeposit] [int] NULL,
[InvoiceAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceipt_InvoiceAmount] DEFAULT ((0)),
[ImputationAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceipt_ImputationAmount] DEFAULT ((0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxCashReceipt_Posted] DEFAULT ((0)),
[PaymentCompleted] [bit] NOT NULL CONSTRAINT [DF_dxCashReceipt_PaymentCompleted] DEFAULT ((0)),
[NSF] [bit] NOT NULL CONSTRAINT [DF_dxCashReceipt_NSF] DEFAULT ((0)),
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxCashReceipt_DocumentStatus] DEFAULT ((0)),
[CashReceiptDiscountAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceipt_CashReceiptDiscountAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceipt.trAuditDelete] ON [dbo].[dxCashReceipt]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCashReceipt'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCashReceipt CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCashReceipt, ID, FK_dxClient, TransactionDate, FK_dxCurrency, FK_dxPaymentType, FK_dxBankAccount, Reference, Description, TotalAmount, UnusedAmount, FK_dxAccount, FK_dxDeposit, InvoiceAmount, ImputationAmount, Posted, PaymentCompleted, NSF, DocumentStatus, CashReceiptDiscountAmount from deleted
 Declare @PK_dxCashReceipt int, @ID int, @FK_dxClient int, @TransactionDate DateTime, @FK_dxCurrency int, @FK_dxPaymentType int, @FK_dxBankAccount int, @Reference varchar(50), @Description varchar(255), @TotalAmount Float, @UnusedAmount Float, @FK_dxAccount int, @FK_dxDeposit int, @InvoiceAmount Float, @ImputationAmount Float, @Posted Bit, @PaymentCompleted Bit, @NSF Bit, @DocumentStatus int, @CashReceiptDiscountAmount Float

 OPEN pk_cursordxCashReceipt
 FETCH NEXT FROM pk_cursordxCashReceipt INTO @PK_dxCashReceipt, @ID, @FK_dxClient, @TransactionDate, @FK_dxCurrency, @FK_dxPaymentType, @FK_dxBankAccount, @Reference, @Description, @TotalAmount, @UnusedAmount, @FK_dxAccount, @FK_dxDeposit, @InvoiceAmount, @ImputationAmount, @Posted, @PaymentCompleted, @NSF, @DocumentStatus, @CashReceiptDiscountAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCashReceipt, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', @FK_dxBankAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', @Reference
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', @TotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnusedAmount', @UnusedAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', @FK_dxAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeposit', @FK_dxDeposit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InvoiceAmount', @InvoiceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ImputationAmount', @ImputationAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PaymentCompleted', @PaymentCompleted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'NSF', @NSF
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CashReceiptDiscountAmount', @CashReceiptDiscountAmount
FETCH NEXT FROM pk_cursordxCashReceipt INTO @PK_dxCashReceipt, @ID, @FK_dxClient, @TransactionDate, @FK_dxCurrency, @FK_dxPaymentType, @FK_dxBankAccount, @Reference, @Description, @TotalAmount, @UnusedAmount, @FK_dxAccount, @FK_dxDeposit, @InvoiceAmount, @ImputationAmount, @Posted, @PaymentCompleted, @NSF, @DocumentStatus, @CashReceiptDiscountAmount
 END

 CLOSE pk_cursordxCashReceipt 
 DEALLOCATE pk_cursordxCashReceipt
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceipt.trAuditInsUpd] ON [dbo].[dxCashReceipt] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCashReceipt CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCashReceipt from inserted;
 set @tablename = 'dxCashReceipt' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCashReceipt
 FETCH NEXT FROM pk_cursordxCashReceipt INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBankAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', FK_dxBankAccount from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Reference )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', Reference from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnusedAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnusedAmount', UnusedAmount from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', FK_dxAccount from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDeposit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeposit', FK_dxDeposit from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InvoiceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InvoiceAmount', InvoiceAmount from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ImputationAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ImputationAmount', ImputationAmount from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PaymentCompleted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PaymentCompleted', PaymentCompleted from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NSF )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'NSF', NSF from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CashReceiptDiscountAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CashReceiptDiscountAmount', CashReceiptDiscountAmount from dxCashReceipt where PK_dxCashReceipt = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCashReceipt INTO @keyvalue
 END

 CLOSE pk_cursordxCashReceipt 
 DEALLOCATE pk_cursordxCashReceipt
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceipt.trCreateDeposit] ON [dbo].[dxCashReceipt]
AFTER UPDATE
AS
BEGIN
   Declare @FK_dxCashReceipt int
   if update(Posted)
   begin
     set @FK_dxCashReceipt = Coalesce((Select max(PK_dxCashReceipt) from inserted where Posted = 1),-1)
     if @FK_dxCashReceipt > 0 exec dbo.pdxCreateDeposit @PK_dxCashReceipt = @FK_dxCashReceipt
   end
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxCashReceipt.trUpdateSum] ON [dbo].[dxCashReceipt]
AFTER INSERT, UPDATE
AS
BEGIN
  if update (TotalAmount) or update (InvoiceAmount) or update (ImputationAmount)
  update dxCashReceipt set
     UnusedAmount = Round(Round(TotalAmount,2) - Round(InvoiceAmount,2) - Round(ImputationAmount,2),2)
  where PK_dxCashReceipt in ( Select PK_dxCashReceipt from inserted ) ;
END
GO
ALTER TABLE [dbo].[dxCashReceipt] ADD CONSTRAINT [PK_dxCashReceipt] PRIMARY KEY CLUSTERED  ([PK_dxCashReceipt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceipt_FK_dxAccount] ON [dbo].[dxCashReceipt] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceipt_FK_dxBankAccount] ON [dbo].[dxCashReceipt] ([FK_dxBankAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceipt_FK_dxClient] ON [dbo].[dxCashReceipt] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceipt_FK_dxCurrency] ON [dbo].[dxCashReceipt] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceipt_FK_dxDeposit] ON [dbo].[dxCashReceipt] ([FK_dxDeposit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceipt_FK_dxPaymentType] ON [dbo].[dxCashReceipt] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxCashReceiptDate] ON [dbo].[dxCashReceipt] ([TransactionDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCashReceipt] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxCashReceipt] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxCashReceipt] ADD CONSTRAINT [dxConstraint_FK_dxBankAccount_dxCashReceipt] FOREIGN KEY ([FK_dxBankAccount]) REFERENCES [dbo].[dxBankAccount] ([PK_dxBankAccount])
GO
ALTER TABLE [dbo].[dxCashReceipt] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxCashReceipt] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxCashReceipt] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxCashReceipt] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxCashReceipt] ADD CONSTRAINT [dxConstraint_FK_dxDeposit_dxCashReceipt] FOREIGN KEY ([FK_dxDeposit]) REFERENCES [dbo].[dxDeposit] ([PK_dxDeposit])
GO
ALTER TABLE [dbo].[dxCashReceipt] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxCashReceipt] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
