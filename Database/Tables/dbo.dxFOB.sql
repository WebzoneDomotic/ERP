CREATE TABLE [dbo].[dxFOB]
(
[PK_dxFOB] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[FOB] [varchar] (500) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFOB.trAuditDelete] ON [dbo].[dxFOB]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxFOB'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxFOB CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFOB, ID, FOB from deleted
 Declare @PK_dxFOB int, @ID varchar(50), @FOB varchar(500)

 OPEN pk_cursordxFOB
 FETCH NEXT FROM pk_cursordxFOB INTO @PK_dxFOB, @ID, @FOB
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxFOB, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', @FOB
FETCH NEXT FROM pk_cursordxFOB INTO @PK_dxFOB, @ID, @FOB
 END

 CLOSE pk_cursordxFOB 
 DEALLOCATE pk_cursordxFOB
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFOB.trAuditInsUpd] ON [dbo].[dxFOB] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxFOB CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFOB from inserted;
 set @tablename = 'dxFOB' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxFOB
 FETCH NEXT FROM pk_cursordxFOB INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxFOB where PK_dxFOB = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', FOB from dxFOB where PK_dxFOB = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxFOB INTO @keyvalue
 END

 CLOSE pk_cursordxFOB 
 DEALLOCATE pk_cursordxFOB
GO
ALTER TABLE [dbo].[dxFOB] ADD CONSTRAINT [PK_dxFOB] PRIMARY KEY CLUSTERED  ([PK_dxFOB]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxFOB] ON [dbo].[dxFOB] ([ID]) ON [PRIMARY]
GO
