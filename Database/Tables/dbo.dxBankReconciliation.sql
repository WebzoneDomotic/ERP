CREATE TABLE [dbo].[dxBankReconciliation]
(
[PK_dxBankReconciliation] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxBankReconciliation]),
[FK_dxBankAccount] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[GLStartingBalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_GLStartingBalanceAmount] DEFAULT ((0.0)),
[GLChequeAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_GLChequeAmount] DEFAULT ((0.0)),
[GLDepositAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_GLDepositAmount] DEFAULT ((0.0)),
[GLTransactionAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_GLTransactionAmount] DEFAULT ((0.0)),
[GLEndingBalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_GLEndingBalanceAmount] DEFAULT ((0.0)),
[AdjustedGLBalance] [float] NOT NULL CONSTRAINT [DF_dxBankReconciliation_AjustedGLBalance] DEFAULT ((0.0)),
[StartingBalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_SartingBalanceAmount] DEFAULT ((0.0)),
[InitializationAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconciliation_InitializationAmount] DEFAULT ((0.0)),
[ReconcilatedChequeAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_ReconcilatedChequeAmount] DEFAULT ((0)),
[ReconciliatedDepositAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_ReconciliatedDepositAmount] DEFAULT ((0)),
[ReconciliatedTransactionAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_ReconciliatedTransactionAmount] DEFAULT ((0.0)),
[ReconciliatedFee] [float] NOT NULL CONSTRAINT [DF_dxBankReconciliation_ReconciliatedFee] DEFAULT ((0.0)),
[EndingBalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_EndingBalanceAmount] DEFAULT ((0)),
[OutstandingChequeAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_OutstandingChequeAmount] DEFAULT ((0.0)),
[OutstandingDepositAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_OutstandingDepositAmount] DEFAULT ((0.0)),
[OutstandingCashReceiptAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconcilation_OutstandingCashReceiptAmount] DEFAULT ((0.0)),
[CalculatedGLEndingBalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconciliation_CalculatedGLEndingBalanceAmount] DEFAULT ((0.0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxBankReconcilation_Posted] DEFAULT ((0)),
[DeltaAmount] [float] NOT NULL CONSTRAINT [DF_dxBankReconciliation_DeltaAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxBankReconciliation.trAuditDelete] ON [dbo].[dxBankReconciliation]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxBankReconciliation'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxBankReconciliation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxBankReconciliation, ID, FK_dxBankAccount, StartDate, EndDate, GLStartingBalanceAmount, GLChequeAmount, GLDepositAmount, GLTransactionAmount, GLEndingBalanceAmount, AdjustedGLBalance, StartingBalanceAmount, InitializationAmount, ReconcilatedChequeAmount, ReconciliatedDepositAmount, ReconciliatedTransactionAmount, ReconciliatedFee, EndingBalanceAmount, OutstandingChequeAmount, OutstandingDepositAmount, OutstandingCashReceiptAmount, CalculatedGLEndingBalanceAmount, Posted, DeltaAmount from deleted
 Declare @PK_dxBankReconciliation int, @ID int, @FK_dxBankAccount int, @StartDate DateTime, @EndDate DateTime, @GLStartingBalanceAmount Float, @GLChequeAmount Float, @GLDepositAmount Float, @GLTransactionAmount Float, @GLEndingBalanceAmount Float, @AdjustedGLBalance Float, @StartingBalanceAmount Float, @InitializationAmount Float, @ReconcilatedChequeAmount Float, @ReconciliatedDepositAmount Float, @ReconciliatedTransactionAmount Float, @ReconciliatedFee Float, @EndingBalanceAmount Float, @OutstandingChequeAmount Float, @OutstandingDepositAmount Float, @OutstandingCashReceiptAmount Float, @CalculatedGLEndingBalanceAmount Float, @Posted Bit, @DeltaAmount Float

 OPEN pk_cursordxBankReconciliation
 FETCH NEXT FROM pk_cursordxBankReconciliation INTO @PK_dxBankReconciliation, @ID, @FK_dxBankAccount, @StartDate, @EndDate, @GLStartingBalanceAmount, @GLChequeAmount, @GLDepositAmount, @GLTransactionAmount, @GLEndingBalanceAmount, @AdjustedGLBalance, @StartingBalanceAmount, @InitializationAmount, @ReconcilatedChequeAmount, @ReconciliatedDepositAmount, @ReconciliatedTransactionAmount, @ReconciliatedFee, @EndingBalanceAmount, @OutstandingChequeAmount, @OutstandingDepositAmount, @OutstandingCashReceiptAmount, @CalculatedGLEndingBalanceAmount, @Posted, @DeltaAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxBankReconciliation, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', @FK_dxBankAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'StartDate', @StartDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EndDate', @EndDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLStartingBalanceAmount', @GLStartingBalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLChequeAmount', @GLChequeAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLDepositAmount', @GLDepositAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLTransactionAmount', @GLTransactionAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLEndingBalanceAmount', @GLEndingBalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AdjustedGLBalance', @AdjustedGLBalance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'StartingBalanceAmount', @StartingBalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InitializationAmount', @InitializationAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReconcilatedChequeAmount', @ReconcilatedChequeAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReconciliatedDepositAmount', @ReconciliatedDepositAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReconciliatedTransactionAmount', @ReconciliatedTransactionAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReconciliatedFee', @ReconciliatedFee
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EndingBalanceAmount', @EndingBalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OutstandingChequeAmount', @OutstandingChequeAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OutstandingDepositAmount', @OutstandingDepositAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OutstandingCashReceiptAmount', @OutstandingCashReceiptAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CalculatedGLEndingBalanceAmount', @CalculatedGLEndingBalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DeltaAmount', @DeltaAmount
FETCH NEXT FROM pk_cursordxBankReconciliation INTO @PK_dxBankReconciliation, @ID, @FK_dxBankAccount, @StartDate, @EndDate, @GLStartingBalanceAmount, @GLChequeAmount, @GLDepositAmount, @GLTransactionAmount, @GLEndingBalanceAmount, @AdjustedGLBalance, @StartingBalanceAmount, @InitializationAmount, @ReconcilatedChequeAmount, @ReconciliatedDepositAmount, @ReconciliatedTransactionAmount, @ReconciliatedFee, @EndingBalanceAmount, @OutstandingChequeAmount, @OutstandingDepositAmount, @OutstandingCashReceiptAmount, @CalculatedGLEndingBalanceAmount, @Posted, @DeltaAmount
 END

 CLOSE pk_cursordxBankReconciliation 
 DEALLOCATE pk_cursordxBankReconciliation
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxBankReconciliation.trAuditInsUpd] ON [dbo].[dxBankReconciliation] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxBankReconciliation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxBankReconciliation from inserted;
 set @tablename = 'dxBankReconciliation' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxBankReconciliation
 FETCH NEXT FROM pk_cursordxBankReconciliation INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBankAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', FK_dxBankAccount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( StartDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'StartDate', StartDate from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EndDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EndDate', EndDate from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( GLStartingBalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLStartingBalanceAmount', GLStartingBalanceAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( GLChequeAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLChequeAmount', GLChequeAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( GLDepositAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLDepositAmount', GLDepositAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( GLTransactionAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLTransactionAmount', GLTransactionAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( GLEndingBalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GLEndingBalanceAmount', GLEndingBalanceAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AdjustedGLBalance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AdjustedGLBalance', AdjustedGLBalance from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( StartingBalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'StartingBalanceAmount', StartingBalanceAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InitializationAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'InitializationAmount', InitializationAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReconcilatedChequeAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReconcilatedChequeAmount', ReconcilatedChequeAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReconciliatedDepositAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReconciliatedDepositAmount', ReconciliatedDepositAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReconciliatedTransactionAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReconciliatedTransactionAmount', ReconciliatedTransactionAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ReconciliatedFee )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ReconciliatedFee', ReconciliatedFee from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EndingBalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EndingBalanceAmount', EndingBalanceAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OutstandingChequeAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OutstandingChequeAmount', OutstandingChequeAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OutstandingDepositAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OutstandingDepositAmount', OutstandingDepositAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OutstandingCashReceiptAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OutstandingCashReceiptAmount', OutstandingCashReceiptAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CalculatedGLEndingBalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CalculatedGLEndingBalanceAmount', CalculatedGLEndingBalanceAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DeltaAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DeltaAmount', DeltaAmount from dxBankReconciliation where PK_dxBankReconciliation = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxBankReconciliation INTO @keyvalue
 END

 CLOSE pk_cursordxBankReconciliation 
 DEALLOCATE pk_cursordxBankReconciliation
GO
ALTER TABLE [dbo].[dxBankReconciliation] ADD CONSTRAINT [PK_dxBankReconcilation] PRIMARY KEY CLUSTERED  ([PK_dxBankReconciliation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxBankReconciliationEndDate] ON [dbo].[dxBankReconciliation] ([EndDate] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankReconciliation_FK_dxBankAccount] ON [dbo].[dxBankReconciliation] ([FK_dxBankAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxBankReconciliationStartDate] ON [dbo].[dxBankReconciliation] ([StartDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxBankReconciliation] ADD CONSTRAINT [dxConstraint_FK_dxBankAccount_dxBankReconciliation] FOREIGN KEY ([FK_dxBankAccount]) REFERENCES [dbo].[dxBankAccount] ([PK_dxBankAccount])
GO
