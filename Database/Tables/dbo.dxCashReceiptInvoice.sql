CREATE TABLE [dbo].[dxCashReceiptInvoice]
(
[PK_dxCashReceiptInvoice] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxCashReceiptInvoice]),
[FK_dxCashReceipt] [int] NOT NULL,
[FK_dxInvoice] [int] NOT NULL,
[PaidAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceiptInvoice_PaidAmount] DEFAULT ((0.0)),
[ImputationAmount] [float] NULL CONSTRAINT [DF_dxCashReceiptInvoice_ImputationAmount] DEFAULT ((0.0)),
[FK_dxAccount__InvoiceImputation] [int] NULL,
[TransactionDate] [datetime] NOT NULL,
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceiptInvoice_Amount] DEFAULT ((0.0)),
[BalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceiptInvoice_BalanceAmount] DEFAULT ((0.0)),
[NewBalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxCashReceiptInvoice_NewBalanceAmount] DEFAULT ((0.0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxCashReceiptInvoice_Posted] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceiptInvoice.trAuditDelete] ON [dbo].[dxCashReceiptInvoice]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCashReceiptInvoice'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCashReceiptInvoice CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCashReceiptInvoice, ID, FK_dxCashReceipt, FK_dxInvoice, PaidAmount, ImputationAmount, FK_dxAccount__InvoiceImputation, TransactionDate, TotalAmount, BalanceAmount, NewBalanceAmount, Posted from deleted
 Declare @PK_dxCashReceiptInvoice int, @ID int, @FK_dxCashReceipt int, @FK_dxInvoice int, @PaidAmount Float, @ImputationAmount Float, @FK_dxAccount__InvoiceImputation int, @TransactionDate DateTime, @TotalAmount Float, @BalanceAmount Float, @NewBalanceAmount Float, @Posted Bit

 OPEN pk_cursordxCashReceiptInvoice
 FETCH NEXT FROM pk_cursordxCashReceiptInvoice INTO @PK_dxCashReceiptInvoice, @ID, @FK_dxCashReceipt, @FK_dxInvoice, @PaidAmount, @ImputationAmount, @FK_dxAccount__InvoiceImputation, @TransactionDate, @TotalAmount, @BalanceAmount, @NewBalanceAmount, @Posted
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCashReceiptInvoice, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCashReceipt', @FK_dxCashReceipt
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInvoice', @FK_dxInvoice
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PaidAmount', @PaidAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ImputationAmount', @ImputationAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__InvoiceImputation', @FK_dxAccount__InvoiceImputation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', @TotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BalanceAmount', @BalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NewBalanceAmount', @NewBalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
FETCH NEXT FROM pk_cursordxCashReceiptInvoice INTO @PK_dxCashReceiptInvoice, @ID, @FK_dxCashReceipt, @FK_dxInvoice, @PaidAmount, @ImputationAmount, @FK_dxAccount__InvoiceImputation, @TransactionDate, @TotalAmount, @BalanceAmount, @NewBalanceAmount, @Posted
 END

 CLOSE pk_cursordxCashReceiptInvoice 
 DEALLOCATE pk_cursordxCashReceiptInvoice
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceiptInvoice.trAuditInsUpd] ON [dbo].[dxCashReceiptInvoice] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCashReceiptInvoice CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCashReceiptInvoice from inserted;
 set @tablename = 'dxCashReceiptInvoice' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCashReceiptInvoice
 FETCH NEXT FROM pk_cursordxCashReceiptInvoice INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCashReceipt )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCashReceipt', FK_dxCashReceipt from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxInvoice )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxInvoice', FK_dxInvoice from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PaidAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PaidAmount', PaidAmount from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ImputationAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ImputationAmount', ImputationAmount from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__InvoiceImputation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__InvoiceImputation', FK_dxAccount__InvoiceImputation from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BalanceAmount', BalanceAmount from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NewBalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NewBalanceAmount', NewBalanceAmount from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxCashReceiptInvoice where PK_dxCashReceiptInvoice = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCashReceiptInvoice INTO @keyvalue
 END

 CLOSE pk_cursordxCashReceiptInvoice 
 DEALLOCATE pk_cursordxCashReceiptInvoice
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceiptInvoice.trUpdateBalance] ON [dbo].[dxCashReceiptInvoice]
AFTER INSERT, UPDATE
AS
BEGIN
  If Update(Posted)
  begin
   Update dxInvoice set
       BalanceAmount = TotalAmount
                       - Coalesce ((select sum(PaidAmount)
                                    from dxCashReceiptInvoice
                                    where FK_dxInvoice = dxInvoice.PK_dxInvoice and Posted = 1 ), 0,0)
   Where PK_dxInvoice in ( Select FK_dxInvoice from inserted) ;
  end
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceiptInvoice.trUpdateSum] ON [dbo].[dxCashReceiptInvoice]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  declare @Ok int ,@FK int, @FKi int , @FKd int, @InvoiceAmount float, @ImputationAmount float ;

  set @FKi  = ( SELECT Coalesce(max(FK_dxCashReceipt ),-1) from inserted )
  set @FKd  = ( SELECT Coalesce(max(FK_dxCashReceipt ),-1) from deleted  )
  if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

  set @InvoiceAmount    = ( select Coalesce(sum( PaidAmount ), 0.0)       from dxCashReceiptInvoice    where FK_dxCashReceipt = @FK )
  set @ImputationAmount = ( select Coalesce(sum( ImputationAmount ), 0.0) from dxCashReceiptInvoice    where FK_dxCashReceipt = @FK ) +
                          ( select Coalesce(sum( Amount     ), 0.0)       from dxCashReceiptImputation where FK_dxCashReceipt = @FK )
  update dxCashReceipt set
     InvoiceAmount        = @InvoiceAmount,
     ImputationAmount     = @ImputationAmount,
     UnusedAmount         = TotalAmount - @InvoiceAmount - @ImputationAmount
  where PK_dxCashReceipt = @FK ;

END
GO
ALTER TABLE [dbo].[dxCashReceiptInvoice] ADD CONSTRAINT [PK_dxCashReceiptInvoice] PRIMARY KEY CLUSTERED  ([PK_dxCashReceiptInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceiptInvoice_FK_dxAccount__InvoiceImputation] ON [dbo].[dxCashReceiptInvoice] ([FK_dxAccount__InvoiceImputation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceiptInvoice_FK_dxCashReceipt] ON [dbo].[dxCashReceiptInvoice] ([FK_dxCashReceipt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceiptInvoice_FK_dxInvoice] ON [dbo].[dxCashReceiptInvoice] ([FK_dxInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxCashReceiptInvoiceDate] ON [dbo].[dxCashReceiptInvoice] ([TransactionDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCashReceiptInvoice] ADD CONSTRAINT [dxConstraint_FK_dxAccount__InvoiceImputation_dxCashReceiptInvoice] FOREIGN KEY ([FK_dxAccount__InvoiceImputation]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxCashReceiptInvoice] ADD CONSTRAINT [dxConstraint_FK_dxCashReceipt_dxCashReceiptInvoice] FOREIGN KEY ([FK_dxCashReceipt]) REFERENCES [dbo].[dxCashReceipt] ([PK_dxCashReceipt])
GO
ALTER TABLE [dbo].[dxCashReceiptInvoice] ADD CONSTRAINT [dxConstraint_FK_dxInvoice_dxCashReceiptInvoice] FOREIGN KEY ([FK_dxInvoice]) REFERENCES [dbo].[dxInvoice] ([PK_dxInvoice])
GO
