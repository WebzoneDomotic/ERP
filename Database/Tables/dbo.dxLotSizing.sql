CREATE TABLE [dbo].[dxLotSizing]
(
[PK_dxLotSizing] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxLotSizing.trAuditDelete] ON [dbo].[dxLotSizing]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxLotSizing'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxLotSizing CURSOR LOCAL FAST_FORWARD for SELECT PK_dxLotSizing, ID, Description from deleted
 Declare @PK_dxLotSizing int, @ID varchar(50), @Description varchar(250)

 OPEN pk_cursordxLotSizing
 FETCH NEXT FROM pk_cursordxLotSizing INTO @PK_dxLotSizing, @ID, @Description
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxLotSizing, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
FETCH NEXT FROM pk_cursordxLotSizing INTO @PK_dxLotSizing, @ID, @Description
 END

 CLOSE pk_cursordxLotSizing 
 DEALLOCATE pk_cursordxLotSizing
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxLotSizing.trAuditInsUpd] ON [dbo].[dxLotSizing] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxLotSizing CURSOR LOCAL FAST_FORWARD for SELECT PK_dxLotSizing from inserted;
 set @tablename = 'dxLotSizing' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxLotSizing
 FETCH NEXT FROM pk_cursordxLotSizing INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxLotSizing where PK_dxLotSizing = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxLotSizing where PK_dxLotSizing = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxLotSizing INTO @keyvalue
 END

 CLOSE pk_cursordxLotSizing 
 DEALLOCATE pk_cursordxLotSizing
GO
ALTER TABLE [dbo].[dxLotSizing] ADD CONSTRAINT [PK_dxLotSizing] PRIMARY KEY CLUSTERED  ([PK_dxLotSizing]) ON [PRIMARY]
GO
