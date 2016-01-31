CREATE TABLE [dbo].[dxTax]
(
[PK_dxTax] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[Tax1Code] [varchar] (50) COLLATE French_CI_AS NULL,
[Tax2Code] [varchar] (50) COLLATE French_CI_AS NULL,
[Tax3Code] [varchar] (50) COLLATE French_CI_AS NULL,
[FK_dxAccount__AP_Tax1] [int] NOT NULL,
[FK_dxAccount__AP_Tax2] [int] NOT NULL,
[FK_dxAccount__AP_Tax3] [int] NOT NULL,
[FK_dxAccount__AR_Tax1] [int] NOT NULL,
[FK_dxAccount__AR_Tax2] [int] NOT NULL,
[FK_dxAccount__AR_Tax3] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTax.trAuditDelete] ON [dbo].[dxTax]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxTax'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxTax CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTax, ID, Description, Tax1Code, Tax2Code, Tax3Code, FK_dxAccount__AP_Tax1, FK_dxAccount__AP_Tax2, FK_dxAccount__AP_Tax3, FK_dxAccount__AR_Tax1, FK_dxAccount__AR_Tax2, FK_dxAccount__AR_Tax3 from deleted
 Declare @PK_dxTax int, @ID varchar(50), @Description varchar(255), @Tax1Code varchar(50), @Tax2Code varchar(50), @Tax3Code varchar(50), @FK_dxAccount__AP_Tax1 int, @FK_dxAccount__AP_Tax2 int, @FK_dxAccount__AP_Tax3 int, @FK_dxAccount__AR_Tax1 int, @FK_dxAccount__AR_Tax2 int, @FK_dxAccount__AR_Tax3 int

 OPEN pk_cursordxTax
 FETCH NEXT FROM pk_cursordxTax INTO @PK_dxTax, @ID, @Description, @Tax1Code, @Tax2Code, @Tax3Code, @FK_dxAccount__AP_Tax1, @FK_dxAccount__AP_Tax2, @FK_dxAccount__AP_Tax3, @FK_dxAccount__AR_Tax1, @FK_dxAccount__AR_Tax2, @FK_dxAccount__AR_Tax3
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxTax, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax1Code', @Tax1Code
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax2Code', @Tax2Code
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax3Code', @Tax3Code
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax1', @FK_dxAccount__AP_Tax1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax2', @FK_dxAccount__AP_Tax2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax3', @FK_dxAccount__AP_Tax3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax1', @FK_dxAccount__AR_Tax1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax2', @FK_dxAccount__AR_Tax2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax3', @FK_dxAccount__AR_Tax3
FETCH NEXT FROM pk_cursordxTax INTO @PK_dxTax, @ID, @Description, @Tax1Code, @Tax2Code, @Tax3Code, @FK_dxAccount__AP_Tax1, @FK_dxAccount__AP_Tax2, @FK_dxAccount__AP_Tax3, @FK_dxAccount__AR_Tax1, @FK_dxAccount__AR_Tax2, @FK_dxAccount__AR_Tax3
 END

 CLOSE pk_cursordxTax 
 DEALLOCATE pk_cursordxTax
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTax.trAuditInsUpd] ON [dbo].[dxTax] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxTax CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTax from inserted;
 set @tablename = 'dxTax' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxTax
 FETCH NEXT FROM pk_cursordxTax INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Code )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax1Code', Tax1Code from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Code )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax2Code', Tax2Code from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Code )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax3Code', Tax3Code from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AP_Tax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax1', FK_dxAccount__AP_Tax1 from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AP_Tax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax2', FK_dxAccount__AP_Tax2 from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AP_Tax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AP_Tax3', FK_dxAccount__AP_Tax3 from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AR_Tax1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax1', FK_dxAccount__AR_Tax1 from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AR_Tax2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax2', FK_dxAccount__AR_Tax2 from dxTax where PK_dxTax = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__AR_Tax3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__AR_Tax3', FK_dxAccount__AR_Tax3 from dxTax where PK_dxTax = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxTax INTO @keyvalue
 END

 CLOSE pk_cursordxTax 
 DEALLOCATE pk_cursordxTax
GO
ALTER TABLE [dbo].[dxTax] ADD CONSTRAINT [PK_dxTax] PRIMARY KEY CLUSTERED  ([PK_dxTax]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTax_FK_dxAccount__AP_Tax1] ON [dbo].[dxTax] ([FK_dxAccount__AP_Tax1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTax_FK_dxAccount__AP_Tax2] ON [dbo].[dxTax] ([FK_dxAccount__AP_Tax2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTax_FK_dxAccount__AP_Tax3] ON [dbo].[dxTax] ([FK_dxAccount__AP_Tax3]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTax_FK_dxAccount__AR_Tax1] ON [dbo].[dxTax] ([FK_dxAccount__AR_Tax1]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTax_FK_dxAccount__AR_Tax2] ON [dbo].[dxTax] ([FK_dxAccount__AR_Tax2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTax_FK_dxAccount__AR_Tax3] ON [dbo].[dxTax] ([FK_dxAccount__AR_Tax3]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxTax] ON [dbo].[dxTax] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxTax] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AP_Tax1_dxTax] FOREIGN KEY ([FK_dxAccount__AP_Tax1]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxTax] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AP_Tax2_dxTax] FOREIGN KEY ([FK_dxAccount__AP_Tax2]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxTax] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AP_Tax3_dxTax] FOREIGN KEY ([FK_dxAccount__AP_Tax3]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxTax] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AR_Tax1_dxTax] FOREIGN KEY ([FK_dxAccount__AR_Tax1]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxTax] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AR_Tax2_dxTax] FOREIGN KEY ([FK_dxAccount__AR_Tax2]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxTax] ADD CONSTRAINT [dxConstraint_FK_dxAccount__AR_Tax3_dxTax] FOREIGN KEY ([FK_dxAccount__AR_Tax3]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
