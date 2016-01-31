CREATE TABLE [dbo].[dxPaymentInvoice]
(
[PK_dxPaymentInvoice] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxPaymentInvoice]),
[FK_dxPayment] [int] NOT NULL,
[FK_dxPayableInvoice] [int] NOT NULL,
[PaidAmount] [float] NOT NULL CONSTRAINT [DF_dxPaymentInvoice_PaidAmount] DEFAULT ((0.0)),
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxPaymentInvoice_TotalAmount] DEFAULT ((0.0)),
[BalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxPaymentInvoice_BalanceAmount] DEFAULT ((0.0)),
[NewBalanceAmount] [float] NOT NULL CONSTRAINT [DF_dxPaymentInvoice_NewBalanceAmount] DEFAULT ((0.0)),
[TransactionDate] [datetime] NOT NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxPaymentInvoice_Posted] DEFAULT ((0)),
[ImputationAmount] [float] NULL CONSTRAINT [DF_dxPaymentInvoice_ImputationAmount] DEFAULT ((0.0)),
[FK_dxAccount__InvoiceImputation] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentInvoice.trAuditDelete] ON [dbo].[dxPaymentInvoice]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPaymentInvoice'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPaymentInvoice CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentInvoice, ID, FK_dxPayment, FK_dxPayableInvoice, PaidAmount, TotalAmount, BalanceAmount, NewBalanceAmount, TransactionDate, Posted, ImputationAmount, FK_dxAccount__InvoiceImputation from deleted
 Declare @PK_dxPaymentInvoice int, @ID int, @FK_dxPayment int, @FK_dxPayableInvoice int, @PaidAmount Float, @TotalAmount Float, @BalanceAmount Float, @NewBalanceAmount Float, @TransactionDate DateTime, @Posted Bit, @ImputationAmount Float, @FK_dxAccount__InvoiceImputation int

 OPEN pk_cursordxPaymentInvoice
 FETCH NEXT FROM pk_cursordxPaymentInvoice INTO @PK_dxPaymentInvoice, @ID, @FK_dxPayment, @FK_dxPayableInvoice, @PaidAmount, @TotalAmount, @BalanceAmount, @NewBalanceAmount, @TransactionDate, @Posted, @ImputationAmount, @FK_dxAccount__InvoiceImputation
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPaymentInvoice, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayment', @FK_dxPayment
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoice', @FK_dxPayableInvoice
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PaidAmount', @PaidAmount
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ImputationAmount', @ImputationAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__InvoiceImputation', @FK_dxAccount__InvoiceImputation
FETCH NEXT FROM pk_cursordxPaymentInvoice INTO @PK_dxPaymentInvoice, @ID, @FK_dxPayment, @FK_dxPayableInvoice, @PaidAmount, @TotalAmount, @BalanceAmount, @NewBalanceAmount, @TransactionDate, @Posted, @ImputationAmount, @FK_dxAccount__InvoiceImputation
 END

 CLOSE pk_cursordxPaymentInvoice 
 DEALLOCATE pk_cursordxPaymentInvoice
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentInvoice.trAuditInsUpd] ON [dbo].[dxPaymentInvoice] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPaymentInvoice CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentInvoice from inserted;
 set @tablename = 'dxPaymentInvoice' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPaymentInvoice
 FETCH NEXT FROM pk_cursordxPaymentInvoice INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayment', FK_dxPayment from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayableInvoice )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoice', FK_dxPayableInvoice from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PaidAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'PaidAmount', PaidAmount from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BalanceAmount', BalanceAmount from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NewBalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NewBalanceAmount', NewBalanceAmount from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ImputationAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ImputationAmount', ImputationAmount from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__InvoiceImputation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__InvoiceImputation', FK_dxAccount__InvoiceImputation from dxPaymentInvoice where PK_dxPaymentInvoice = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPaymentInvoice INTO @keyvalue
 END

 CLOSE pk_cursordxPaymentInvoice 
 DEALLOCATE pk_cursordxPaymentInvoice
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxPaymentInvoice.trUpdateBalanceAmount] ON [dbo].[dxPaymentInvoice]
AFTER INSERT, UPDATE
AS
BEGIN
  -- Update Balance Amount on Payable Invoice
  If Update(Posted)
  begin
    Update dxPayableInvoice
       set BalanceAmount =  TotalAmount
                          - Coalesce(( Select sum(PaidAmount) From dxPaymentInvoice
                                        where FK_dxPayableInvoice = PK_dxPayableInvoice and Posted =1) , 0.0)
     where PK_dxPayableInvoice in ( Select ie.FK_dxPayableInvoice from inserted ie )
  end
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentInvoice.trUpdateSum] ON [dbo].[dxPaymentInvoice]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

   update pa set
      InvoiceAmount        = Coalesce(( select Coalesce(sum( PaidAmount ), 0.0)       from dxPaymentInvoice    where FK_dxPayment = pa.PK_dxPayment ),0.0) ,
      ImputationAmount     = Coalesce(( select Coalesce(sum( ImputationAmount ), 0.0) from dxPaymentInvoice    where FK_dxPayment = pa.PK_dxPayment ),0.0) +
                             Coalesce(( select Coalesce(sum( Amount     ), 0.0)       from dxPaymentImputation where FK_dxPayment = pa.PK_dxPayment ),0.0)
   From dxPayment pa
   Where pa.PK_dxPayment in ( Select FK_dxPayment from inserted union all Select FK_dxPayment from deleted )
   -- Update Unused Amount
   update dxPayment set
      UnusedAmount         = TotalAmount - InvoiceAmount - ImputationAmount
   where PK_dxPayment in ( Select FK_dxPayment from inserted union all Select FK_dxPayment from deleted ) ;

END
GO
ALTER TABLE [dbo].[dxPaymentInvoice] ADD CONSTRAINT [PK_dxPaymentInvoice] PRIMARY KEY CLUSTERED  ([PK_dxPaymentInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentInvoice_FK_dxAccount__InvoiceImputation] ON [dbo].[dxPaymentInvoice] ([FK_dxAccount__InvoiceImputation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentInvoice_FK_dxPayableInvoice] ON [dbo].[dxPaymentInvoice] ([FK_dxPayableInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentInvoice_FK_dxPayment] ON [dbo].[dxPaymentInvoice] ([FK_dxPayment]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPaymentInvoice] ADD CONSTRAINT [dxConstraint_FK_dxAccount__InvoiceImputation_dxPaymentInvoice] FOREIGN KEY ([FK_dxAccount__InvoiceImputation]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPaymentInvoice] ADD CONSTRAINT [dxConstraint_FK_dxPayableInvoice_dxPaymentInvoice] FOREIGN KEY ([FK_dxPayableInvoice]) REFERENCES [dbo].[dxPayableInvoice] ([PK_dxPayableInvoice])
GO
ALTER TABLE [dbo].[dxPaymentInvoice] ADD CONSTRAINT [dxConstraint_FK_dxPayment_dxPaymentInvoice] FOREIGN KEY ([FK_dxPayment]) REFERENCES [dbo].[dxPayment] ([PK_dxPayment])
GO
