CREATE TABLE [dbo].[dxInventoryGroup]
(
[PK_dxInventoryGroup] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (2000) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryGroup.trAuditDelete] ON [dbo].[dxInventoryGroup]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxInventoryGroup'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxInventoryGroup CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryGroup, ID, Description from deleted
 Declare @PK_dxInventoryGroup int, @ID varchar(50), @Description varchar(2000)

 OPEN pk_cursordxInventoryGroup
 FETCH NEXT FROM pk_cursordxInventoryGroup INTO @PK_dxInventoryGroup, @ID, @Description
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxInventoryGroup, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
FETCH NEXT FROM pk_cursordxInventoryGroup INTO @PK_dxInventoryGroup, @ID, @Description
 END

 CLOSE pk_cursordxInventoryGroup 
 DEALLOCATE pk_cursordxInventoryGroup
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxInventoryGroup.trAuditInsUpd] ON [dbo].[dxInventoryGroup] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxInventoryGroup CURSOR LOCAL FAST_FORWARD for SELECT PK_dxInventoryGroup from inserted;
 set @tablename = 'dxInventoryGroup' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxInventoryGroup
 FETCH NEXT FROM pk_cursordxInventoryGroup INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxInventoryGroup where PK_dxInventoryGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxInventoryGroup where PK_dxInventoryGroup = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxInventoryGroup INTO @keyvalue
 END

 CLOSE pk_cursordxInventoryGroup 
 DEALLOCATE pk_cursordxInventoryGroup
GO
ALTER TABLE [dbo].[dxInventoryGroup] ADD CONSTRAINT [PK_dxInventoryGroup] PRIMARY KEY CLUSTERED  ([PK_dxInventoryGroup]) ON [PRIMARY]
GO
