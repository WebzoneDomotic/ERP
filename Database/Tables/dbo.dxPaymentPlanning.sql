CREATE TABLE [dbo].[dxPaymentPlanning]
(
[PK_dxPaymentPlanning] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxPaymentPlanning]),
[Approuved] [bit] NOT NULL CONSTRAINT [DF_dxPaymentPlanning_Approuved] DEFAULT ((0)),
[FK_dxBankAccount] [int] NOT NULL,
[PaymentDate] [datetime] NOT NULL,
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxPaymentPlanning_TotalAmount] DEFAULT ((0.0)),
[ApprouvedTotalAmount] [float] NOT NULL CONSTRAINT [DF_dxPaymentPlanning_ApprouvedTotalAmount] DEFAULT ((0.0)),
[Note] [varchar] (1000) COLLATE French_CI_AS NULL,
[NumberOfChequeToDo] [int] NOT NULL CONSTRAINT [DF_dxPaymentPlanning_NumberOfChequeToDo] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentPlanning.trAuditDelete] ON [dbo].[dxPaymentPlanning]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPaymentPlanning'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPaymentPlanning CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentPlanning, ID, Approuved, FK_dxBankAccount, PaymentDate, TotalAmount, ApprouvedTotalAmount, Note, NumberOfChequeToDo from deleted
 Declare @PK_dxPaymentPlanning int, @ID int, @Approuved Bit, @FK_dxBankAccount int, @PaymentDate DateTime, @TotalAmount Float, @ApprouvedTotalAmount Float, @Note varchar(1000), @NumberOfChequeToDo int

 OPEN pk_cursordxPaymentPlanning
 FETCH NEXT FROM pk_cursordxPaymentPlanning INTO @PK_dxPaymentPlanning, @ID, @Approuved, @FK_dxBankAccount, @PaymentDate, @TotalAmount, @ApprouvedTotalAmount, @Note, @NumberOfChequeToDo
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPaymentPlanning, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Approuved', @Approuved
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', @FK_dxBankAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'PaymentDate', @PaymentDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', @TotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ApprouvedTotalAmount', @ApprouvedTotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfChequeToDo', @NumberOfChequeToDo
FETCH NEXT FROM pk_cursordxPaymentPlanning INTO @PK_dxPaymentPlanning, @ID, @Approuved, @FK_dxBankAccount, @PaymentDate, @TotalAmount, @ApprouvedTotalAmount, @Note, @NumberOfChequeToDo
 END

 CLOSE pk_cursordxPaymentPlanning 
 DEALLOCATE pk_cursordxPaymentPlanning
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentPlanning.trAuditInsUpd] ON [dbo].[dxPaymentPlanning] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPaymentPlanning CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentPlanning from inserted;
 set @tablename = 'dxPaymentPlanning' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPaymentPlanning
 FETCH NEXT FROM pk_cursordxPaymentPlanning INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Approuved )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Approuved', Approuved from dxPaymentPlanning where PK_dxPaymentPlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBankAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', FK_dxBankAccount from dxPaymentPlanning where PK_dxPaymentPlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PaymentDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'PaymentDate', PaymentDate from dxPaymentPlanning where PK_dxPaymentPlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxPaymentPlanning where PK_dxPaymentPlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApprouvedTotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ApprouvedTotalAmount', ApprouvedTotalAmount from dxPaymentPlanning where PK_dxPaymentPlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxPaymentPlanning where PK_dxPaymentPlanning = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfChequeToDo )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfChequeToDo', NumberOfChequeToDo from dxPaymentPlanning where PK_dxPaymentPlanning = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPaymentPlanning INTO @keyvalue
 END

 CLOSE pk_cursordxPaymentPlanning 
 DEALLOCATE pk_cursordxPaymentPlanning
GO
ALTER TABLE [dbo].[dxPaymentPlanning] ADD CONSTRAINT [PK_dxPaymentPlanning] PRIMARY KEY CLUSTERED  ([PK_dxPaymentPlanning]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentPlanning_FK_dxBankAccount] ON [dbo].[dxPaymentPlanning] ([FK_dxBankAccount]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPaymentPlanning] ADD CONSTRAINT [dxConstraint_FK_dxBankAccount_dxPaymentPlanning] FOREIGN KEY ([FK_dxBankAccount]) REFERENCES [dbo].[dxBankAccount] ([PK_dxBankAccount])
GO
