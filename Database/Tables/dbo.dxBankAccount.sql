CREATE TABLE [dbo].[dxBankAccount]
(
[PK_dxBankAccount] [int] NOT NULL IDENTITY(1, 1),
[FK_dxBank] [int] NOT NULL,
[AccountNumber] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxBankAccount_AccountNumber] DEFAULT ('0'),
[BranchOfficeNumber] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxBankAccount_BranchOfficeNumber] DEFAULT ('0'),
[TransitNumber] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxBankAccount_TransitNumber] DEFAULT ('0'),
[FK_dxAccount__GL] [int] NOT NULL,
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxBankAccount_FK_dxCurrency] DEFAULT ((1)),
[FK_dxReport__Cheque] [int] NULL,
[FK_dxReport__Annex] [int] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxBankAccount_Active] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxBankAccount.trAuditDelete] ON [dbo].[dxBankAccount]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxBankAccount'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxBankAccount CURSOR LOCAL FAST_FORWARD for SELECT PK_dxBankAccount, FK_dxBank, AccountNumber, BranchOfficeNumber, TransitNumber, FK_dxAccount__GL, FK_dxCurrency, FK_dxReport__Cheque, FK_dxReport__Annex, Active from deleted
 Declare @PK_dxBankAccount int, @FK_dxBank int, @AccountNumber varchar(50), @BranchOfficeNumber varchar(50), @TransitNumber varchar(50), @FK_dxAccount__GL int, @FK_dxCurrency int, @FK_dxReport__Cheque int, @FK_dxReport__Annex int, @Active Bit

 OPEN pk_cursordxBankAccount
 FETCH NEXT FROM pk_cursordxBankAccount INTO @PK_dxBankAccount, @FK_dxBank, @AccountNumber, @BranchOfficeNumber, @TransitNumber, @FK_dxAccount__GL, @FK_dxCurrency, @FK_dxReport__Cheque, @FK_dxReport__Annex, @Active
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxBankAccount, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBank', @FK_dxBank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'AccountNumber', @AccountNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BranchOfficeNumber', @BranchOfficeNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TransitNumber', @TransitNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__GL', @FK_dxAccount__GL
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport__Cheque', @FK_dxReport__Cheque
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport__Annex', @FK_dxReport__Annex
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
FETCH NEXT FROM pk_cursordxBankAccount INTO @PK_dxBankAccount, @FK_dxBank, @AccountNumber, @BranchOfficeNumber, @TransitNumber, @FK_dxAccount__GL, @FK_dxCurrency, @FK_dxReport__Cheque, @FK_dxReport__Annex, @Active
 END

 CLOSE pk_cursordxBankAccount 
 DEALLOCATE pk_cursordxBankAccount
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxBankAccount.trAuditInsUpd] ON [dbo].[dxBankAccount] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxBankAccount CURSOR LOCAL FAST_FORWARD for SELECT PK_dxBankAccount from inserted;
 set @tablename = 'dxBankAccount' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxBankAccount
 FETCH NEXT FROM pk_cursordxBankAccount INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBank', FK_dxBank from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AccountNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'AccountNumber', AccountNumber from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BranchOfficeNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'BranchOfficeNumber', BranchOfficeNumber from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransitNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TransitNumber', TransitNumber from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__GL )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__GL', FK_dxAccount__GL from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport__Cheque )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport__Cheque', FK_dxReport__Cheque from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport__Annex )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport__Annex', FK_dxReport__Annex from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxBankAccount where PK_dxBankAccount = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxBankAccount INTO @keyvalue
 END

 CLOSE pk_cursordxBankAccount 
 DEALLOCATE pk_cursordxBankAccount
GO
ALTER TABLE [dbo].[dxBankAccount] ADD CONSTRAINT [PK_dxBankAccount] PRIMARY KEY CLUSTERED  ([PK_dxBankAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankAccount_FK_dxAccount__GL] ON [dbo].[dxBankAccount] ([FK_dxAccount__GL]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankAccount_FK_dxBank] ON [dbo].[dxBankAccount] ([FK_dxBank]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankAccount_FK_dxCurrency] ON [dbo].[dxBankAccount] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankAccount_FK_dxReport__Annex] ON [dbo].[dxBankAccount] ([FK_dxReport__Annex]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxBankAccount_FK_dxReport__Cheque] ON [dbo].[dxBankAccount] ([FK_dxReport__Cheque]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxBankAccount] ADD CONSTRAINT [dxConstraint_FK_dxAccount__GL_dxBankAccount] FOREIGN KEY ([FK_dxAccount__GL]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxBankAccount] ADD CONSTRAINT [dxConstraint_FK_dxBank_dxBankAccount] FOREIGN KEY ([FK_dxBank]) REFERENCES [dbo].[dxBank] ([PK_dxBank])
GO
ALTER TABLE [dbo].[dxBankAccount] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxBankAccount] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxBankAccount] ADD CONSTRAINT [dxConstraint_FK_dxReport__Annex_dxBankAccount] FOREIGN KEY ([FK_dxReport__Annex]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
ALTER TABLE [dbo].[dxBankAccount] ADD CONSTRAINT [dxConstraint_FK_dxReport__Cheque_dxBankAccount] FOREIGN KEY ([FK_dxReport__Cheque]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
