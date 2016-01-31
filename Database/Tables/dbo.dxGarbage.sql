CREATE TABLE [dbo].[dxGarbage]
(
[PK_dxGarbage] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxGarbage.trAuditDelete] ON [dbo].[dxGarbage]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxGarbage'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxGarbage CURSOR LOCAL FAST_FORWARD for SELECT PK_dxGarbage from deleted
 Declare @PK_dxGarbage int

 OPEN pk_cursordxGarbage
 FETCH NEXT FROM pk_cursordxGarbage INTO @PK_dxGarbage
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxGarbage, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
FETCH NEXT FROM pk_cursordxGarbage INTO @PK_dxGarbage
 END

 CLOSE pk_cursordxGarbage 
 DEALLOCATE pk_cursordxGarbage
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxGarbage.trAuditInsUpd] ON [dbo].[dxGarbage] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxGarbage CURSOR LOCAL FAST_FORWARD for SELECT PK_dxGarbage from inserted;
 set @tablename = 'dxGarbage' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxGarbage
 FETCH NEXT FROM pk_cursordxGarbage INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
FETCH NEXT FROM pk_cursordxGarbage INTO @keyvalue
 END

 CLOSE pk_cursordxGarbage 
 DEALLOCATE pk_cursordxGarbage
GO
