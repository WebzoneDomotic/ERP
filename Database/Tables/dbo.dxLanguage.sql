CREATE TABLE [dbo].[dxLanguage]
(
[PK_dxLanguage] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Caption] [varchar] (255) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxLanguage.trAuditDelete] ON [dbo].[dxLanguage]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxLanguage'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxLanguage CURSOR LOCAL FAST_FORWARD for SELECT PK_dxLanguage, ID, Caption from deleted
 Declare @PK_dxLanguage int, @ID varchar(50), @Caption varchar(255)

 OPEN pk_cursordxLanguage
 FETCH NEXT FROM pk_cursordxLanguage INTO @PK_dxLanguage, @ID, @Caption
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxLanguage, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Caption', @Caption
FETCH NEXT FROM pk_cursordxLanguage INTO @PK_dxLanguage, @ID, @Caption
 END

 CLOSE pk_cursordxLanguage 
 DEALLOCATE pk_cursordxLanguage
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxLanguage.trAuditInsUpd] ON [dbo].[dxLanguage] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxLanguage CURSOR LOCAL FAST_FORWARD for SELECT PK_dxLanguage from inserted;
 set @tablename = 'dxLanguage' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxLanguage
 FETCH NEXT FROM pk_cursordxLanguage INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxLanguage where PK_dxLanguage = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Caption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Caption', Caption from dxLanguage where PK_dxLanguage = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxLanguage INTO @keyvalue
 END

 CLOSE pk_cursordxLanguage 
 DEALLOCATE pk_cursordxLanguage
GO
ALTER TABLE [dbo].[dxLanguage] ADD CONSTRAINT [PK_dxLanguage] PRIMARY KEY CLUSTERED  ([PK_dxLanguage]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxLanguage] ON [dbo].[dxLanguage] ([ID]) ON [PRIMARY]
GO
