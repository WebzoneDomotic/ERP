CREATE TABLE [dbo].[dxFinancialColumnType]
(
[PK_dxFinancialColumnType] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialColumnType.trAuditDelete] ON [dbo].[dxFinancialColumnType]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxFinancialColumnType'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxFinancialColumnType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialColumnType, ID from deleted
 Declare @PK_dxFinancialColumnType int, @ID varchar(50)

 OPEN pk_cursordxFinancialColumnType
 FETCH NEXT FROM pk_cursordxFinancialColumnType INTO @PK_dxFinancialColumnType, @ID
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxFinancialColumnType, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
FETCH NEXT FROM pk_cursordxFinancialColumnType INTO @PK_dxFinancialColumnType, @ID
 END

 CLOSE pk_cursordxFinancialColumnType 
 DEALLOCATE pk_cursordxFinancialColumnType
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialColumnType.trAuditInsUpd] ON [dbo].[dxFinancialColumnType] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxFinancialColumnType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialColumnType from inserted;
 set @tablename = 'dxFinancialColumnType' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxFinancialColumnType
 FETCH NEXT FROM pk_cursordxFinancialColumnType INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxFinancialColumnType where PK_dxFinancialColumnType = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxFinancialColumnType INTO @keyvalue
 END

 CLOSE pk_cursordxFinancialColumnType 
 DEALLOCATE pk_cursordxFinancialColumnType
GO
ALTER TABLE [dbo].[dxFinancialColumnType] ADD CONSTRAINT [PK_dxFinancialColumnType] PRIMARY KEY CLUSTERED  ([PK_dxFinancialColumnType]) ON [PRIMARY]
GO
