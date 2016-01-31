CREATE TABLE [dbo].[dxRoundMode]
(
[PK_dxRoundMode] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (10) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRoundMode.trAuditDelete] ON [dbo].[dxRoundMode]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxRoundMode'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxRoundMode CURSOR LOCAL FAST_FORWARD for SELECT PK_dxRoundMode, ID from deleted
 Declare @PK_dxRoundMode int, @ID varchar(10)

 OPEN pk_cursordxRoundMode
 FETCH NEXT FROM pk_cursordxRoundMode INTO @PK_dxRoundMode, @ID
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxRoundMode, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
FETCH NEXT FROM pk_cursordxRoundMode INTO @PK_dxRoundMode, @ID
 END

 CLOSE pk_cursordxRoundMode 
 DEALLOCATE pk_cursordxRoundMode
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxRoundMode.trAuditInsUpd] ON [dbo].[dxRoundMode] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxRoundMode CURSOR LOCAL FAST_FORWARD for SELECT PK_dxRoundMode from inserted;
 set @tablename = 'dxRoundMode' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxRoundMode
 FETCH NEXT FROM pk_cursordxRoundMode INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxRoundMode where PK_dxRoundMode = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxRoundMode INTO @keyvalue
 END

 CLOSE pk_cursordxRoundMode 
 DEALLOCATE pk_cursordxRoundMode
GO
ALTER TABLE [dbo].[dxRoundMode] ADD CONSTRAINT [PK_dxRoundMode] PRIMARY KEY CLUSTERED  ([PK_dxRoundMode]) ON [PRIMARY]
GO
