CREATE TABLE [dbo].[dxBankReconciliationDetail]
(
[PK_dxBankReconciliationDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxBankReconciliation] [int] NOT NULL,
[FK_dxReconciliationTransactionType] [int] NULL,
[FK_dxPayment] [int] NULL,
[FK_dxDeposit] [int] NULL,
[FK_dxJournalEntryDetail] [int] NULL,
[TransactionDate] [datetime] NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[Amount] [float] NOT NULL CONSTRAINT [DF_dxBankReconciliationDetail_Amount] DEFAULT ((0.0)),
[FK_dxAccount] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxBankReconciliationDetail.trAuditDelete] ON [dbo].[dxBankReconciliationDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxBankReconciliationDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxBankReconciliationDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxBankReconciliationDetail, FK_dxBankReconciliation, FK_dxReconciliationTransactionType, FK_dxPayment, FK_dxDeposit, FK_dxJournalEntryDetail, TransactionDate, Description, Amount, FK_dxAccount from deleted
 Declare @PK_dxBankReconciliationDetail int, @FK_dxBankReconciliation int, @FK_dxReconciliationTransactionType int, @FK_dxPayment int, @FK_dxDeposit int, @FK_dxJournalEntryDetail int, @TransactionDate DateTime, @Description varchar(255), @Amount Float, @FK_dxAccount int

 OPEN pk_cursordxBankReconciliationDetail
 FETCH NEXT FROM pk_cursordxBankReconciliationDetail INTO @PK_dxBankReconciliationDetail, @FK_dxBankReconciliation, @FK_dxReconciliationTransactionType, @FK_dxPayment, @FK_dxDeposit, @FK_dxJournalEntryDetail, @TransactionDate, @Description, @Amount, @FK_dxAccount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxBankReconciliationDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankReconciliation', @FK_dxBankReconciliation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReconciliationTransactionType', @FK_dxReconciliationTransactionType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayment', @FK_dxPayment
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeposit', @FK_dxDeposit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxJournalEntryDetail', @FK_dxJournalEntryDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', @Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', @FK_dxAccount
FETCH NEXT FROM pk_cursordxBankReconciliationDetail INTO @PK_dxBankReconciliationDetail, @FK_dxBankReconciliation, @FK_dxReconciliationTransactionType, @FK_dxPayment, @FK_dxDeposit, @FK_dxJournalEntryDetail, @TransactionDate, @Description, @Amount, @FK_dxAccount
 END

 CLOSE pk_cursordxBankReconciliationDetail 
 DEALLOCATE pk_cursordxBankReconciliationDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxBankReconciliationDetail.trAuditInsUpd] ON [dbo].[dxBankReconciliationDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxBankReconciliationDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxBankReconciliationDetail from inserted;
 set @tablename = 'dxBankReconciliationDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxBankReconciliationDetail
 FETCH NEXT FROM pk_cursordxBankReconciliationDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBankReconciliation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankReconciliation', FK_dxBankReconciliation from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReconciliationTransactionType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReconciliationTransactionType', FK_dxReconciliationTransactionType from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayment', FK_dxPayment from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDeposit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeposit', FK_dxDeposit from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxJournalEntryDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxJournalEntryDetail', FK_dxJournalEntryDetail from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', FK_dxAccount from dxBankReconciliationDetail where PK_dxBankReconciliationDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxBankReconciliationDetail INTO @keyvalue
 END

 CLOSE pk_cursordxBankReconciliationDetail 
 DEALLOCATE pk_cursordxBankReconciliationDetail
GO
ALTER TABLE [dbo].[dxBankReconciliationDetail] ADD CONSTRAINT [PK_dxBankReconciliationDetail] PRIMARY KEY CLUSTERED  ([PK_dxBankReconciliationDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankReconciliationDetail_FK_dxAccount] ON [dbo].[dxBankReconciliationDetail] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankReconciliationDetail_FK_dxBankReconciliation] ON [dbo].[dxBankReconciliationDetail] ([FK_dxBankReconciliation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankReconciliationDetail_FK_dxDeposit] ON [dbo].[dxBankReconciliationDetail] ([FK_dxDeposit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankReconciliationDetail_FK_dxJournalEntryDetail] ON [dbo].[dxBankReconciliationDetail] ([FK_dxJournalEntryDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankReconciliationDetail_FK_dxPayment] ON [dbo].[dxBankReconciliationDetail] ([FK_dxPayment]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankReconciliationDetail_FK_dxReconciliationTransactionType] ON [dbo].[dxBankReconciliationDetail] ([FK_dxReconciliationTransactionType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxBankReconciliationDetailDate] ON [dbo].[dxBankReconciliationDetail] ([TransactionDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxBankReconciliationDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxBankReconciliationDetail] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxBankReconciliationDetail] ADD CONSTRAINT [dxConstraint_FK_dxBankReconciliation_dxBankReconciliationDetail] FOREIGN KEY ([FK_dxBankReconciliation]) REFERENCES [dbo].[dxBankReconciliation] ([PK_dxBankReconciliation])
GO
ALTER TABLE [dbo].[dxBankReconciliationDetail] ADD CONSTRAINT [dxConstraint_FK_dxDeposit_dxBankReconciliationDetail] FOREIGN KEY ([FK_dxDeposit]) REFERENCES [dbo].[dxDeposit] ([PK_dxDeposit])
GO
ALTER TABLE [dbo].[dxBankReconciliationDetail] ADD CONSTRAINT [dxConstraint_FK_dxJournalEntryDetail_dxBankReconciliationDetail] FOREIGN KEY ([FK_dxJournalEntryDetail]) REFERENCES [dbo].[dxJournalEntryDetail] ([PK_dxJournalEntryDetail])
GO
ALTER TABLE [dbo].[dxBankReconciliationDetail] ADD CONSTRAINT [dxConstraint_FK_dxPayment_dxBankReconciliationDetail] FOREIGN KEY ([FK_dxPayment]) REFERENCES [dbo].[dxPayment] ([PK_dxPayment])
GO
ALTER TABLE [dbo].[dxBankReconciliationDetail] ADD CONSTRAINT [dxConstraint_FK_dxReconciliationTransactionType_dxBankReconciliationDetail] FOREIGN KEY ([FK_dxReconciliationTransactionType]) REFERENCES [dbo].[dxReconciliationTransactionType] ([PK_dxReconciliationTransactionType])
GO
