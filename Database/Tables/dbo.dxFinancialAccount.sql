CREATE TABLE [dbo].[dxFinancialAccount]
(
[PK_dxFinancialAccount] [int] NOT NULL IDENTITY(1, 1),
[FK_dxFinancialSection] [int] NOT NULL,
[ExcludeAccount] [bit] NOT NULL CONSTRAINT [DF_dxFinancialAccount_ExcludeAccount] DEFAULT ((0)),
[ChangeSign] [bit] NOT NULL CONSTRAINT [DF_dxFinancialAccount_ChangeSign] DEFAULT ((0)),
[FK_dxAccountCategory] [int] NULL,
[FromAccount] [varchar] (50) COLLATE French_CI_AS NULL,
[ToAccount] [varchar] (50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialAccount.trAuditDelete] ON [dbo].[dxFinancialAccount]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxFinancialAccount'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxFinancialAccount CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialAccount, FK_dxFinancialSection, ExcludeAccount, ChangeSign, FK_dxAccountCategory, FromAccount, ToAccount from deleted
 Declare @PK_dxFinancialAccount int, @FK_dxFinancialSection int, @ExcludeAccount Bit, @ChangeSign Bit, @FK_dxAccountCategory int, @FromAccount varchar(50), @ToAccount varchar(50)

 OPEN pk_cursordxFinancialAccount
 FETCH NEXT FROM pk_cursordxFinancialAccount INTO @PK_dxFinancialAccount, @FK_dxFinancialSection, @ExcludeAccount, @ChangeSign, @FK_dxAccountCategory, @FromAccount, @ToAccount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxFinancialAccount, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialSection', @FK_dxFinancialSection
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ExcludeAccount', @ExcludeAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ChangeSign', @ChangeSign
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountCategory', @FK_dxAccountCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FromAccount', @FromAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ToAccount', @ToAccount
FETCH NEXT FROM pk_cursordxFinancialAccount INTO @PK_dxFinancialAccount, @FK_dxFinancialSection, @ExcludeAccount, @ChangeSign, @FK_dxAccountCategory, @FromAccount, @ToAccount
 END

 CLOSE pk_cursordxFinancialAccount 
 DEALLOCATE pk_cursordxFinancialAccount
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialAccount.trAuditInsUpd] ON [dbo].[dxFinancialAccount] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxFinancialAccount CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialAccount from inserted;
 set @tablename = 'dxFinancialAccount' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxFinancialAccount
 FETCH NEXT FROM pk_cursordxFinancialAccount INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFinancialSection )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialSection', FK_dxFinancialSection from dxFinancialAccount where PK_dxFinancialAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExcludeAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ExcludeAccount', ExcludeAccount from dxFinancialAccount where PK_dxFinancialAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ChangeSign )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ChangeSign', ChangeSign from dxFinancialAccount where PK_dxFinancialAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccountCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountCategory', FK_dxAccountCategory from dxFinancialAccount where PK_dxFinancialAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FromAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FromAccount', FromAccount from dxFinancialAccount where PK_dxFinancialAccount = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ToAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ToAccount', ToAccount from dxFinancialAccount where PK_dxFinancialAccount = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxFinancialAccount INTO @keyvalue
 END

 CLOSE pk_cursordxFinancialAccount 
 DEALLOCATE pk_cursordxFinancialAccount
GO
ALTER TABLE [dbo].[dxFinancialAccount] ADD CONSTRAINT [PK_dxFinancialAccount] PRIMARY KEY CLUSTERED  ([PK_dxFinancialAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFinancialAccount_FK_dxAccountCategory] ON [dbo].[dxFinancialAccount] ([FK_dxAccountCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFinancialAccount_FK_dxFinancialSection] ON [dbo].[dxFinancialAccount] ([FK_dxFinancialSection]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxFinancialAccount] ADD CONSTRAINT [dxConstraint_FK_dxAccountCategory_dxFinancialAccount] FOREIGN KEY ([FK_dxAccountCategory]) REFERENCES [dbo].[dxAccountCategory] ([PK_dxAccountCategory])
GO
ALTER TABLE [dbo].[dxFinancialAccount] ADD CONSTRAINT [dxConstraint_FK_dxFinancialSection_dxFinancialAccount] FOREIGN KEY ([FK_dxFinancialSection]) REFERENCES [dbo].[dxFinancialSection] ([PK_dxFinancialSection])
GO
