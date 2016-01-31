CREATE TABLE [dbo].[dxPayment]
(
[PK_dxPayment] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxPayment]),
[FK_dxVendor] [int] NOT NULL,
[PaidTo] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[Address] [varchar] (1000) COLLATE French_CI_AS NULL,
[TransactionDate] [datetime] NOT NULL,
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxPayament_FK_dxCurrency] DEFAULT ((1)),
[FK_dxPaymentType] [int] NOT NULL CONSTRAINT [DF_dxPayament_FK_dxPaymentType] DEFAULT ((1)),
[FK_dxBankAccount] [int] NOT NULL,
[ChequeNumber] [int] NULL CONSTRAINT [DF_dxPayment_ChequeNumber] DEFAULT ((0)),
[Reference] [varchar] (255) COLLATE French_CI_AS NULL,
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxPayament_TotalAmount] DEFAULT ((0.0)),
[TextAmount] [varchar] (1000) COLLATE French_CI_AS NULL,
[InvoiceAmount] [float] NOT NULL CONSTRAINT [DF_dxPayment_InvoiceAmount] DEFAULT ((0.0)),
[ImputationAmount] [float] NOT NULL CONSTRAINT [DF_dxPayment_ImputationAmount] DEFAULT ((0.0)),
[UnusedAmount] [float] NOT NULL CONSTRAINT [DF_dxPayment_UnusedAmount] DEFAULT ((0.0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxPayament_Posted] DEFAULT ((0)),
[PaymentCompleted] [bit] NOT NULL CONSTRAINT [DF_dxPayment_PaymentCompleted] DEFAULT ((0)),
[NumberOfPrint] [int] NOT NULL CONSTRAINT [DF_dxPayment_NumberOfPrint] DEFAULT ((0)),
[FK_dxAccount] [int] NOT NULL,
[FK_dxPaymentPlanning] [int] NULL,
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxPayment_DocumentStatus] DEFAULT ((0)),
[Canceled] [bit] NOT NULL CONSTRAINT [DF_dxPayment_Canceled] DEFAULT ((0)),
[FK_dxPayment__Canceled] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayment.trAmountToText] ON [dbo].[dxPayment]
AFTER INSERT, UPDATE
AS
BEGIN
  If Update(TotalAmount)
    Update dxPayment set TextAmount = Upper(dbo.fdxNumberToWord( Convert( int, TotalAmount),  Coalesce(( select FK_dxLanguage From dxVendor where PK_dxVendor = FK_dxVendor),1)  ))
    where PK_dxPayment in ( Select PK_dxPayment from inserted )
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayment.trAuditDelete] ON [dbo].[dxPayment]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPayment'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPayment CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayment, ID, FK_dxVendor, PaidTo, Address, TransactionDate, FK_dxCurrency, FK_dxPaymentType, FK_dxBankAccount, ChequeNumber, Reference, TotalAmount, TextAmount, InvoiceAmount, ImputationAmount, UnusedAmount, Posted, PaymentCompleted, NumberOfPrint, FK_dxAccount, FK_dxPaymentPlanning, DocumentStatus, Canceled, FK_dxPayment__Canceled from deleted
 Declare @PK_dxPayment int, @ID int, @FK_dxVendor int, @PaidTo varchar(255), @Address varchar(1000), @TransactionDate DateTime, @FK_dxCurrency int, @FK_dxPaymentType int, @FK_dxBankAccount int, @ChequeNumber int, @Reference varchar(255), @TotalAmount Float, @TextAmount varchar(1000), @InvoiceAmount Float, @ImputationAmount Float, @UnusedAmount Float, @Posted Bit, @PaymentCompleted Bit, @NumberOfPrint int, @FK_dxAccount int, @FK_dxPaymentPlanning int, @DocumentStatus int, @Canceled Bit, @FK_dxPayment__Canceled int

 OPEN pk_cursordxPayment
 FETCH NEXT FROM pk_cursordxPayment INTO @PK_dxPayment, @ID, @FK_dxVendor, @PaidTo, @Address, @TransactionDate, @FK_dxCurrency, @FK_dxPaymentType, @FK_dxBankAccount, @ChequeNumber, @Reference, @TotalAmount, @TextAmount, @InvoiceAmount, @ImputationAmount, @UnusedAmount, @Posted, @PaymentCompleted, @NumberOfPrint, @FK_dxAccount, @FK_dxPaymentPlanning, @DocumentStatus, @Canceled, @FK_dxPayment__Canceled
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPayment, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PaidTo', @PaidTo
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address', @Address
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ChequeNumber', @ChequeNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', @Reference
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', @TotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TextAmount', @TextAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InvoiceAmount', @InvoiceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ImputationAmount', @ImputationAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnusedAmount', @UnusedAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PaymentCompleted', @PaymentCompleted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfPrint', @NumberOfPrint
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', @FK_dxAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentPlanning', @FK_dxPaymentPlanning
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Canceled', @Canceled
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayment__Canceled', @FK_dxPayment__Canceled
FETCH NEXT FROM pk_cursordxPayment INTO @PK_dxPayment, @ID, @FK_dxVendor, @PaidTo, @Address, @TransactionDate, @FK_dxCurrency, @FK_dxPaymentType, @FK_dxBankAccount, @ChequeNumber, @Reference, @TotalAmount, @TextAmount, @InvoiceAmount, @ImputationAmount, @UnusedAmount, @Posted, @PaymentCompleted, @NumberOfPrint, @FK_dxAccount, @FK_dxPaymentPlanning, @DocumentStatus, @Canceled, @FK_dxPayment__Canceled
 END

 CLOSE pk_cursordxPayment 
 DEALLOCATE pk_cursordxPayment
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayment.trAuditInsUpd] ON [dbo].[dxPayment] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPayment CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayment from inserted;
 set @tablename = 'dxPayment' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPayment
 FETCH NEXT FROM pk_cursordxPayment INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PaidTo )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PaidTo', PaidTo from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Address )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address', Address from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBankAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', FK_dxBankAccount from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ChequeNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ChequeNumber', ChequeNumber from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Reference )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', Reference from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TextAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TextAmount', TextAmount from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InvoiceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InvoiceAmount', InvoiceAmount from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ImputationAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ImputationAmount', ImputationAmount from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UnusedAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UnusedAmount', UnusedAmount from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PaymentCompleted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PaymentCompleted', PaymentCompleted from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfPrint )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfPrint', NumberOfPrint from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', FK_dxAccount from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentPlanning )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentPlanning', FK_dxPaymentPlanning from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Canceled )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Canceled', Canceled from dxPayment where PK_dxPayment = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayment__Canceled )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayment__Canceled', FK_dxPayment__Canceled from dxPayment where PK_dxPayment = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPayment INTO @keyvalue
 END

 CLOSE pk_cursordxPayment 
 DEALLOCATE pk_cursordxPayment
GO
ALTER TABLE [dbo].[dxPayment] ADD CONSTRAINT [PK_dxPayment] PRIMARY KEY CLUSTERED  ([PK_dxPayment]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayment_FK_dxAccount] ON [dbo].[dxPayment] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayment_FK_dxBankAccount] ON [dbo].[dxPayment] ([FK_dxBankAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayment_FK_dxCurrency] ON [dbo].[dxPayment] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayment_FK_dxPayment__Canceled] ON [dbo].[dxPayment] ([FK_dxPayment__Canceled]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayment_FK_dxPaymentPlanning] ON [dbo].[dxPayment] ([FK_dxPaymentPlanning]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayment_FK_dxPaymentType] ON [dbo].[dxPayment] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayment_FK_dxVendor] ON [dbo].[dxPayment] ([FK_dxVendor]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPayment] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxPayment] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPayment] ADD CONSTRAINT [dxConstraint_FK_dxBankAccount_dxPayment] FOREIGN KEY ([FK_dxBankAccount]) REFERENCES [dbo].[dxBankAccount] ([PK_dxBankAccount])
GO
ALTER TABLE [dbo].[dxPayment] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxPayment] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxPayment] ADD CONSTRAINT [dxConstraint_FK_dxPayment__Canceled_dxPayment] FOREIGN KEY ([FK_dxPayment__Canceled]) REFERENCES [dbo].[dxPayment] ([PK_dxPayment])
GO
ALTER TABLE [dbo].[dxPayment] ADD CONSTRAINT [dxConstraint_FK_dxPaymentPlanning_dxPayment] FOREIGN KEY ([FK_dxPaymentPlanning]) REFERENCES [dbo].[dxPaymentPlanning] ([PK_dxPaymentPlanning])
GO
ALTER TABLE [dbo].[dxPayment] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxPayment] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
ALTER TABLE [dbo].[dxPayment] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxPayment] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
