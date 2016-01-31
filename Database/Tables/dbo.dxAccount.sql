CREATE TABLE [dbo].[dxAccount]
(
[PK_dxAccount] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxAccountType] [int] NOT NULL,
[FK_dxAccountUsage] [int] NULL,
[FK_dxCurrency] [int] NOT NULL,
[FK_dxAccountCategory] [int] NOT NULL CONSTRAINT [DF_dxAccount_FK_dxAccountCategory] DEFAULT ((1)),
[FK_dxAccount__ForeignExchangeReference] [int] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxAccount_Active] DEFAULT ((1)),
[RevaluationOfBalanceSheetAccount] [bit] NOT NULL CONSTRAINT [DF_dxAccount_RevaluationOfBalanceSheetAccount] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccount.trAuditDelete] ON [dbo].[dxAccount]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAccount'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAccount CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccount, ID, Description, FK_dxAccountType, FK_dxAccountUsage, FK_dxCurrency, FK_dxAccountCategory, FK_dxAccount__ForeignExchangeReference, Active, RevaluationOfBalanceSheetAccount from deleted
 Declare @PK_dxAccount int, @ID varchar(50), @Description varchar(255), @FK_dxAccountType int, @FK_dxAccountUsage int, @FK_dxCurrency int, @FK_dxAccountCategory int, @FK_dxAccount__ForeignExchangeReference int, @Active Bit, @RevaluationOfBalanceSheetAccount Bit

 OPEN pk_cursordxAccount
 FETCH NEXT FROM pk_cursordxAccount INTO @PK_dxAccount, @ID, @Description, @FK_dxAccountType, @FK_dxAccountUsage, @FK_dxCurrency, @FK_dxAccountCategory, @FK_dxAccount__ForeignExchangeReference, @Active, @RevaluationOfBalanceSheetAccount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAccount, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountType', @FK_dxAccountType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountUsage', @FK_dxAccountUsage
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountCategory', @FK_dxAccountCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ForeignExchangeReference', @FK_dxAccount__ForeignExchangeReference
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'RevaluationOfBalanceSheetAccount', @RevaluationOfBalanceSheetAccount
FETCH NEXT FROM pk_cursordxAccount INTO @PK_dxAccount, @ID, @Description, @FK_dxAccountType, @FK_dxAccountUsage, @FK_dxCurrency, @FK_dxAccountCategory, @FK_dxAccount__ForeignExchangeReference, @Active, @RevaluationOfBalanceSheetAccount
 END

 CLOSE pk_cursordxAccount 
 DEALLOCATE pk_cursordxAccount
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccount.trAuditInsUpd] ON [dbo].[dxAccount] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAccount CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccount from inserted;
 set @tablename = 'dxAccount' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAccount
 FETCH NEXT FROM pk_cursordxAccount INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxAccount where PK_dxAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxAccount where PK_dxAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccountType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountType', FK_dxAccountType from dxAccount where PK_dxAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccountUsage )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountUsage', FK_dxAccountUsage from dxAccount where PK_dxAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxAccount where PK_dxAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccountCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountCategory', FK_dxAccountCategory from dxAccount where PK_dxAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__ForeignExchangeReference )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__ForeignExchangeReference', FK_dxAccount__ForeignExchangeReference from dxAccount where PK_dxAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxAccount where PK_dxAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RevaluationOfBalanceSheetAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'RevaluationOfBalanceSheetAccount', RevaluationOfBalanceSheetAccount from dxAccount where PK_dxAccount = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAccount INTO @keyvalue
 END

 CLOSE pk_cursordxAccount 
 DEALLOCATE pk_cursordxAccount
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccount.trPeriodCurrency] ON [dbo].[dxAccount]
AFTER INSERT
AS
BEGIN
   SET NOCOUNT ON
   IF TRIGGER_NESTLEVEL() > 10 RETURN
   Execute [dbo].[pdxGLEntryPeriodCurrency]
   SET NOCOUNT OFF
END
GO
ALTER TABLE [dbo].[dxAccount] ADD CONSTRAINT [PK_dxAccount] PRIMARY KEY CLUSTERED  ([PK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccount_FK_dxAccount__ForeignExchangeReference] ON [dbo].[dxAccount] ([FK_dxAccount__ForeignExchangeReference]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccount_FK_dxAccountCategory] ON [dbo].[dxAccount] ([FK_dxAccountCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccount_FK_dxAccountType] ON [dbo].[dxAccount] ([FK_dxAccountType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccount_FK_dxAccountUsage] ON [dbo].[dxAccount] ([FK_dxAccountUsage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccount_FK_dxCurrency] ON [dbo].[dxAccount] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxAccountID] ON [dbo].[dxAccount] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAccount] ADD CONSTRAINT [dxConstraint_FK_dxAccount__ForeignExchangeReference_dxAccount] FOREIGN KEY ([FK_dxAccount__ForeignExchangeReference]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccount] ADD CONSTRAINT [dxConstraint_FK_dxAccountCategory_dxAccount] FOREIGN KEY ([FK_dxAccountCategory]) REFERENCES [dbo].[dxAccountCategory] ([PK_dxAccountCategory])
GO
ALTER TABLE [dbo].[dxAccount] ADD CONSTRAINT [dxConstraint_FK_dxAccountType_dxAccount] FOREIGN KEY ([FK_dxAccountType]) REFERENCES [dbo].[dxAccountType] ([PK_dxAccountType])
GO
ALTER TABLE [dbo].[dxAccount] ADD CONSTRAINT [dxConstraint_FK_dxAccountUsage_dxAccount] FOREIGN KEY ([FK_dxAccountUsage]) REFERENCES [dbo].[dxAccountUsage] ([PK_dxAccountUsage])
GO
ALTER TABLE [dbo].[dxAccount] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxAccount] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
