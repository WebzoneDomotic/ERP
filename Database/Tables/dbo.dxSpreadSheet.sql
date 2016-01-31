CREATE TABLE [dbo].[dxSpreadSheet]
(
[PK_dxSpreadsheet] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProject] [int] NULL,
[ID] AS ([PK_dxSpreadSheet]),
[Description] [varchar] (500) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxSpreadSheet.trAuditDelete] ON [dbo].[dxSpreadSheet]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxSpreadSheet'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxSpreadSheet CURSOR LOCAL FAST_FORWARD for SELECT PK_dxSpreadsheet, FK_dxProject, ID, Description from deleted
 Declare @PK_dxSpreadsheet int, @FK_dxProject int, @ID int, @Description varchar(500)

 OPEN pk_cursordxSpreadSheet
 FETCH NEXT FROM pk_cursordxSpreadSheet INTO @PK_dxSpreadsheet, @FK_dxProject, @ID, @Description
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxSpreadSheet, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', @FK_dxProject
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
FETCH NEXT FROM pk_cursordxSpreadSheet INTO @PK_dxSpreadsheet, @FK_dxProject, @ID, @Description
 END

 CLOSE pk_cursordxSpreadSheet 
 DEALLOCATE pk_cursordxSpreadSheet
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxSpreadSheet.trAuditInsUpd] ON [dbo].[dxSpreadSheet] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxSpreadSheet CURSOR LOCAL FAST_FORWARD for SELECT PK_dxSpreadSheet from inserted;
 set @tablename = 'dxSpreadSheet' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxSpreadSheet
 FETCH NEXT FROM pk_cursordxSpreadSheet INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxSpreadSheet where PK_dxSpreadSheet = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxSpreadSheet where PK_dxSpreadSheet = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxSpreadSheet INTO @keyvalue
 END

 CLOSE pk_cursordxSpreadSheet 
 DEALLOCATE pk_cursordxSpreadSheet
GO
ALTER TABLE [dbo].[dxSpreadSheet] ADD CONSTRAINT [PK_dxSpreadSheet] PRIMARY KEY CLUSTERED  ([PK_dxSpreadsheet]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSpreadSheet_FK_dxProject] ON [dbo].[dxSpreadSheet] ([FK_dxProject]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxSpreadSheet] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxSpreadSheet] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
