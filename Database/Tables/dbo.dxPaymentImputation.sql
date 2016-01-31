CREATE TABLE [dbo].[dxPaymentImputation]
(
[PK_dxPaymentImputation] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPayment] [int] NOT NULL,
[ID] AS ([PK_dxPaymentImputation]),
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxAccount] [int] NOT NULL,
[Amount] [float] NOT NULL CONSTRAINT [DF_dxPaymentImputation_Amount] DEFAULT ((0.0)),
[TransactionDate] [datetime] NOT NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxPaymentImputation_Posted] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentImputation.trAuditDelete] ON [dbo].[dxPaymentImputation]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPaymentImputation'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPaymentImputation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentImputation, FK_dxPayment, ID, Description, FK_dxAccount, Amount, TransactionDate, Posted from deleted
 Declare @PK_dxPaymentImputation int, @FK_dxPayment int, @ID int, @Description varchar(255), @FK_dxAccount int, @Amount Float, @TransactionDate DateTime, @Posted Bit

 OPEN pk_cursordxPaymentImputation
 FETCH NEXT FROM pk_cursordxPaymentImputation INTO @PK_dxPaymentImputation, @FK_dxPayment, @ID, @Description, @FK_dxAccount, @Amount, @TransactionDate, @Posted
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPaymentImputation, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayment', @FK_dxPayment
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
FETCH NEXT FROM pk_cursordxPaymentImputation INTO @PK_dxPaymentImputation, @FK_dxPayment, @ID, @Description, @FK_dxAccount, @Amount, @TransactionDate, @Posted
 END

 CLOSE pk_cursordxPaymentImputation 
 DEALLOCATE pk_cursordxPaymentImputation
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentImputation.trAuditInsUpd] ON [dbo].[dxPaymentImputation] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPaymentImputation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentImputation from inserted;
 set @tablename = 'dxPaymentImputation' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPaymentImputation
 FETCH NEXT FROM pk_cursordxPaymentImputation INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayment', FK_dxPayment from dxPaymentImputation where PK_dxPaymentImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPaymentImputation where PK_dxPaymentImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', FK_dxAccount from dxPaymentImputation where PK_dxPaymentImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxPaymentImputation where PK_dxPaymentImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxPaymentImputation where PK_dxPaymentImputation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxPaymentImputation where PK_dxPaymentImputation = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPaymentImputation INTO @keyvalue
 END

 CLOSE pk_cursordxPaymentImputation 
 DEALLOCATE pk_cursordxPaymentImputation
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentImputation.trUpdateSum] ON [dbo].[dxPaymentImputation]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN

  update pa set
      ImputationAmount  = Coalesce(( select Coalesce(sum( ImputationAmount ), 0.0) from dxPaymentInvoice    where FK_dxPayment = pa.PK_dxPayment ),0.0) +
                          Coalesce(( select Coalesce(sum( Amount     ), 0.0)       from dxPaymentImputation where FK_dxPayment = pa.PK_dxPayment ),0.0)
  From dxPayment pa
  Where PK_dxPayment in ( Select FK_dxPayment from inserted union all Select FK_dxPayment from deleted )
     update dxPayment set
     UnusedAmount         = TotalAmount - InvoiceAmount - ImputationAmount
  where PK_dxPayment in ( Select FK_dxPayment from inserted union all Select FK_dxPayment from deleted ) ;

END
GO
ALTER TABLE [dbo].[dxPaymentImputation] ADD CONSTRAINT [PK_dxPaymentImputation] PRIMARY KEY CLUSTERED  ([PK_dxPaymentImputation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentImputation_FK_dxAccount] ON [dbo].[dxPaymentImputation] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentImputation_FK_dxPayment] ON [dbo].[dxPaymentImputation] ([FK_dxPayment]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPaymentImputation] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxPaymentImputation] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxPaymentImputation] ADD CONSTRAINT [dxConstraint_FK_dxPayment_dxPaymentImputation] FOREIGN KEY ([FK_dxPayment]) REFERENCES [dbo].[dxPayment] ([PK_dxPayment])
GO
