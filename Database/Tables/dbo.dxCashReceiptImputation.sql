CREATE TABLE [dbo].[dxCashReceiptImputation]
(
[PK_dxCashReceiptImputation] [int] NOT NULL IDENTITY(1, 1),
[FK_dxCashReceipt] [int] NOT NULL,
[ID] AS ([PK_dxCashReceiptImputation]),
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxAccount] [int] NOT NULL,
[Amount] [float] NOT NULL CONSTRAINT [DF_dxCashReceiptImputation_Amount] DEFAULT ((0)),
[TransactionDate] [datetime] NOT NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxCashReceiptImputation_Posted] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceiptImputation.trAuditDelete] ON [dbo].[dxCashReceiptImputation]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCashReceiptImputation'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCashReceiptImputation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCashReceiptImputation, FK_dxCashReceipt, ID, Description, FK_dxAccount, Amount, TransactionDate, Posted from deleted
 Declare @PK_dxCashReceiptImputation int, @FK_dxCashReceipt int, @ID int, @Description varchar(255), @FK_dxAccount int, @Amount Float, @TransactionDate DateTime, @Posted Bit

 OPEN pk_cursordxCashReceiptImputation
 FETCH NEXT FROM pk_cursordxCashReceiptImputation INTO @PK_dxCashReceiptImputation, @FK_dxCashReceipt, @ID, @Description, @FK_dxAccount, @Amount, @TransactionDate, @Posted
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCashReceiptImputation, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCashReceipt', @FK_dxCashReceipt
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', @FK_dxAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', @Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
FETCH NEXT FROM pk_cursordxCashReceiptImputation INTO @PK_dxCashReceiptImputation, @FK_dxCashReceipt, @ID, @Description, @FK_dxAccount, @Amount, @TransactionDate, @Posted
 END

 CLOSE pk_cursordxCashReceiptImputation 
 DEALLOCATE pk_cursordxCashReceiptImputation
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceiptImputation.trAuditInsUpd] ON [dbo].[dxCashReceiptImputation] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCashReceiptImputation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCashReceiptImputation from inserted;
 set @tablename = 'dxCashReceiptImputation' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCashReceiptImputation
 FETCH NEXT FROM pk_cursordxCashReceiptImputation INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCashReceipt )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCashReceipt', FK_dxCashReceipt from dxCashReceiptImputation where PK_dxCashReceiptImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxCashReceiptImputation where PK_dxCashReceiptImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', FK_dxAccount from dxCashReceiptImputation where PK_dxCashReceiptImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxCashReceiptImputation where PK_dxCashReceiptImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxCashReceiptImputation where PK_dxCashReceiptImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxCashReceiptImputation where PK_dxCashReceiptImputation = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCashReceiptImputation INTO @keyvalue
 END

 CLOSE pk_cursordxCashReceiptImputation 
 DEALLOCATE pk_cursordxCashReceiptImputation
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCashReceiptImputation.trUpdateSum] ON [dbo].[dxCashReceiptImputation]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  declare @FK int, @FKi int , @FKd int, @InvoiceAmount float, @ImputationAmount float ;

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
ALTER TABLE [dbo].[dxCashReceiptImputation] ADD CONSTRAINT [PK_dxCashReceiptImputation] PRIMARY KEY CLUSTERED  ([PK_dxCashReceiptImputation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceiptImputation_FK_dxAccount] ON [dbo].[dxCashReceiptImputation] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCashReceiptImputation_FK_dxCashReceipt] ON [dbo].[dxCashReceiptImputation] ([FK_dxCashReceipt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCashReceiptImputation] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxCashReceiptImputation] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxCashReceiptImputation] ADD CONSTRAINT [dxConstraint_FK_dxCashReceipt_dxCashReceiptImputation] FOREIGN KEY ([FK_dxCashReceipt]) REFERENCES [dbo].[dxCashReceipt] ([PK_dxCashReceipt])
GO
