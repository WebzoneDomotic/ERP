CREATE TABLE [dbo].[dxVendorCategory]
(
[PK_dxVendorCategory] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxVendorCategory.trAuditDelete] ON [dbo].[dxVendorCategory]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxVendorCategory'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxVendorCategory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxVendorCategory, ID, Description from deleted
 Declare @PK_dxVendorCategory int, @ID varchar(50), @Description varchar(255)

 OPEN pk_cursordxVendorCategory
 FETCH NEXT FROM pk_cursordxVendorCategory INTO @PK_dxVendorCategory, @ID, @Description
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxVendorCategory, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
FETCH NEXT FROM pk_cursordxVendorCategory INTO @PK_dxVendorCategory, @ID, @Description
 END

 CLOSE pk_cursordxVendorCategory 
 DEALLOCATE pk_cursordxVendorCategory
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxVendorCategory.trAuditInsUpd] ON [dbo].[dxVendorCategory] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxVendorCategory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxVendorCategory from inserted;
 set @tablename = 'dxVendorCategory' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxVendorCategory
 FETCH NEXT FROM pk_cursordxVendorCategory INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxVendorCategory where PK_dxVendorCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxVendorCategory where PK_dxVendorCategory = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxVendorCategory INTO @keyvalue
 END

 CLOSE pk_cursordxVendorCategory 
 DEALLOCATE pk_cursordxVendorCategory
GO
ALTER TABLE [dbo].[dxVendorCategory] ADD CONSTRAINT [PK_dxVendorCategory] PRIMARY KEY CLUSTERED  ([PK_dxVendorCategory]) ON [PRIMARY]
GO
