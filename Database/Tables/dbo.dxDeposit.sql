CREATE TABLE [dbo].[dxDeposit]
(
[PK_dxDeposit] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxDeposit]),
[Reference] [varchar] (50) COLLATE French_CI_AS NULL,
[FK_dxBankAccount] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxDeposit_TotalAmount] DEFAULT ((0.0)),
[ReconciliationDate] [datetime] NULL CONSTRAINT [DF_dxDeposit_ReconciliationDate] DEFAULT (NULL),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxDeposit_Posted] DEFAULT ((0)),
[DepositCanceled] [bit] NOT NULL CONSTRAINT [DF_dxDeposit_DepositCanceled] DEFAULT ((0)),
[FK_dxCashReceipt] [int] NULL,
[FK_dxPaymentType] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeposit.trAuditDelete] ON [dbo].[dxDeposit]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxDeposit'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxDeposit CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDeposit, ID, Reference, FK_dxBankAccount, TransactionDate, TotalAmount, ReconciliationDate, Posted, DepositCanceled, FK_dxCashReceipt, FK_dxPaymentType from deleted
 Declare @PK_dxDeposit int, @ID int, @Reference varchar(50), @FK_dxBankAccount int, @TransactionDate DateTime, @TotalAmount Float, @ReconciliationDate DateTime, @Posted Bit, @DepositCanceled Bit, @FK_dxCashReceipt int, @FK_dxPaymentType int

 OPEN pk_cursordxDeposit
 FETCH NEXT FROM pk_cursordxDeposit INTO @PK_dxDeposit, @ID, @Reference, @FK_dxBankAccount, @TransactionDate, @TotalAmount, @ReconciliationDate, @Posted, @DepositCanceled, @FK_dxCashReceipt, @FK_dxPaymentType
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxDeposit, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', @Reference
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', @FK_dxBankAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', @TotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ReconciliationDate', @ReconciliationDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DepositCanceled', @DepositCanceled
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCashReceipt', @FK_dxCashReceipt
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
FETCH NEXT FROM pk_cursordxDeposit INTO @PK_dxDeposit, @ID, @Reference, @FK_dxBankAccount, @TransactionDate, @TotalAmount, @ReconciliationDate, @Posted, @DepositCanceled, @FK_dxCashReceipt, @FK_dxPaymentType
 END

 CLOSE pk_cursordxDeposit 
 DEALLOCATE pk_cursordxDeposit
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDeposit.trAuditInsUpd] ON [dbo].[dxDeposit] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxDeposit CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDeposit from inserted;
 set @tablename = 'dxDeposit' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxDeposit
 FETCH NEXT FROM pk_cursordxDeposit INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Reference )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', Reference from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBankAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', FK_dxBankAccount from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReconciliationDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ReconciliationDate', ReconciliationDate from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DepositCanceled )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DepositCanceled', DepositCanceled from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCashReceipt )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCashReceipt', FK_dxCashReceipt from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxDeposit where PK_dxDeposit = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxDeposit INTO @keyvalue
 END

 CLOSE pk_cursordxDeposit 
 DEALLOCATE pk_cursordxDeposit
GO
ALTER TABLE [dbo].[dxDeposit] ADD CONSTRAINT [PK_dxDeposit] PRIMARY KEY CLUSTERED  ([PK_dxDeposit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeposit_FK_dxBankAccount] ON [dbo].[dxDeposit] ([FK_dxBankAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeposit_FK_dxCashReceipt] ON [dbo].[dxDeposit] ([FK_dxCashReceipt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDeposit_FK_dxPaymentType] ON [dbo].[dxDeposit] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxDepositDate] ON [dbo].[dxDeposit] ([TransactionDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDeposit] ADD CONSTRAINT [dxConstraint_FK_dxBankAccount_dxDeposit] FOREIGN KEY ([FK_dxBankAccount]) REFERENCES [dbo].[dxBankAccount] ([PK_dxBankAccount])
GO
ALTER TABLE [dbo].[dxDeposit] ADD CONSTRAINT [dxConstraint_FK_dxCashReceipt_dxDeposit] FOREIGN KEY ([FK_dxCashReceipt]) REFERENCES [dbo].[dxCashReceipt] ([PK_dxCashReceipt])
GO
ALTER TABLE [dbo].[dxDeposit] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxDeposit] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
