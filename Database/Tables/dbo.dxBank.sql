CREATE TABLE [dbo].[dxBank]
(
[PK_dxBank] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE French_CI_AS NULL,
[Address] [varchar] (500) COLLATE French_CI_AS NULL,
[Phone] [varchar] (50) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxBank.trAuditDelete] ON [dbo].[dxBank]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxBank'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxBank CURSOR LOCAL FAST_FORWARD for SELECT PK_dxBank, ID, Name, Address, Phone from deleted
 Declare @PK_dxBank int, @ID varchar(50), @Name varchar(255), @Address varchar(500), @Phone varchar(50)

 OPEN pk_cursordxBank
 FETCH NEXT FROM pk_cursordxBank INTO @PK_dxBank, @ID, @Name, @Address, @Phone
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxBank, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address', @Address
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Phone', @Phone
FETCH NEXT FROM pk_cursordxBank INTO @PK_dxBank, @ID, @Name, @Address, @Phone
 END

 CLOSE pk_cursordxBank 
 DEALLOCATE pk_cursordxBank
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxBank.trAuditInsUpd] ON [dbo].[dxBank] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxBank CURSOR LOCAL FAST_FORWARD for SELECT PK_dxBank from inserted;
 set @tablename = 'dxBank' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxBank
 FETCH NEXT FROM pk_cursordxBank INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxBank where PK_dxBank = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxBank where PK_dxBank = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Address )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address', Address from dxBank where PK_dxBank = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Phone )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Phone', Phone from dxBank where PK_dxBank = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxBank INTO @keyvalue
 END

 CLOSE pk_cursordxBank 
 DEALLOCATE pk_cursordxBank
GO
ALTER TABLE [dbo].[dxBank] ADD CONSTRAINT [PK_dxBank] PRIMARY KEY CLUSTERED  ([PK_dxBank]) ON [PRIMARY]
GO
