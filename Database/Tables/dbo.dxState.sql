CREATE TABLE [dbo].[dxState]
(
[PK_dxState] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[FK_dxShippingZone] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxState.trAuditDelete] ON [dbo].[dxState]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxState'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxState CURSOR LOCAL FAST_FORWARD for SELECT PK_dxState, ID, Name, FK_dxShippingZone from deleted
 Declare @PK_dxState int, @ID varchar(50), @Name varchar(255), @FK_dxShippingZone int

 OPEN pk_cursordxState
 FETCH NEXT FROM pk_cursordxState INTO @PK_dxState, @ID, @Name, @FK_dxShippingZone
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxState, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingZone', @FK_dxShippingZone
FETCH NEXT FROM pk_cursordxState INTO @PK_dxState, @ID, @Name, @FK_dxShippingZone
 END

 CLOSE pk_cursordxState 
 DEALLOCATE pk_cursordxState
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxState.trAuditInsUpd] ON [dbo].[dxState] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxState CURSOR LOCAL FAST_FORWARD for SELECT PK_dxState from inserted;
 set @tablename = 'dxState' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxState
 FETCH NEXT FROM pk_cursordxState INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxState where PK_dxState = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxState where PK_dxState = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingZone )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingZone', FK_dxShippingZone from dxState where PK_dxState = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxState INTO @keyvalue
 END

 CLOSE pk_cursordxState 
 DEALLOCATE pk_cursordxState
GO
ALTER TABLE [dbo].[dxState] ADD CONSTRAINT [PK_dxState] PRIMARY KEY CLUSTERED  ([PK_dxState]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxState_FK_dxShippingZone] ON [dbo].[dxState] ([FK_dxShippingZone]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxState] ON [dbo].[dxState] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxState] ADD CONSTRAINT [dxConstraint_FK_dxShippingZone_dxState] FOREIGN KEY ([FK_dxShippingZone]) REFERENCES [dbo].[dxShippingZone] ([PK_dxShippingZone])
GO
