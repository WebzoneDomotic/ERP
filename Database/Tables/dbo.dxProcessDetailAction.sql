CREATE TABLE [dbo].[dxProcessDetailAction]
(
[PK_dxProcessDetailAction] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProcessDetail] [int] NOT NULL,
[FK_dxAction] [int] NOT NULL,
[ActionOrder] [int] NULL,
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessDetailAction.trAuditDelete] ON [dbo].[dxProcessDetailAction]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProcessDetailAction'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProcessDetailAction CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessDetailAction, FK_dxProcessDetail, FK_dxAction, ActionOrder from deleted
 Declare @PK_dxProcessDetailAction int, @FK_dxProcessDetail int, @FK_dxAction int, @ActionOrder int

 OPEN pk_cursordxProcessDetailAction
 FETCH NEXT FROM pk_cursordxProcessDetailAction INTO @PK_dxProcessDetailAction, @FK_dxProcessDetail, @FK_dxAction, @ActionOrder
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProcessDetailAction, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetail', @FK_dxProcessDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAction', @FK_dxAction
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ActionOrder', @ActionOrder
FETCH NEXT FROM pk_cursordxProcessDetailAction INTO @PK_dxProcessDetailAction, @FK_dxProcessDetail, @FK_dxAction, @ActionOrder
 END

 CLOSE pk_cursordxProcessDetailAction 
 DEALLOCATE pk_cursordxProcessDetailAction
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessDetailAction.trAuditInsUpd] ON [dbo].[dxProcessDetailAction] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProcessDetailAction CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessDetailAction from inserted;
 set @tablename = 'dxProcessDetailAction' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProcessDetailAction
 FETCH NEXT FROM pk_cursordxProcessDetailAction INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcessDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetail', FK_dxProcessDetail from dxProcessDetailAction where PK_dxProcessDetailAction = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAction )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAction', FK_dxAction from dxProcessDetailAction where PK_dxProcessDetailAction = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ActionOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ActionOrder', ActionOrder from dxProcessDetailAction where PK_dxProcessDetailAction = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProcessDetailAction INTO @keyvalue
 END

 CLOSE pk_cursordxProcessDetailAction 
 DEALLOCATE pk_cursordxProcessDetailAction
GO
ALTER TABLE [dbo].[dxProcessDetailAction] ADD CONSTRAINT [PK_dxProcessDetailAction] PRIMARY KEY CLUSTERED  ([PK_dxProcessDetailAction]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetailAction_FK_dxAction] ON [dbo].[dxProcessDetailAction] ([FK_dxAction]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetailAction_FK_dxProcessDetail] ON [dbo].[dxProcessDetailAction] ([FK_dxProcessDetail]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProcessDetailAction] ADD CONSTRAINT [dxConstraint_FK_dxAction_dxProcessDetailAction] FOREIGN KEY ([FK_dxAction]) REFERENCES [dbo].[dxAction] ([PK_dxAction])
GO
ALTER TABLE [dbo].[dxProcessDetailAction] ADD CONSTRAINT [dxConstraint_FK_dxProcessDetail_dxProcessDetailAction] FOREIGN KEY ([FK_dxProcessDetail]) REFERENCES [dbo].[dxProcessDetail] ([PK_dxProcessDetail])
GO
