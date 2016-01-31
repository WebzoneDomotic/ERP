CREATE TABLE [dbo].[dxUserGroup]
(
[PK_dxUserGroup] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxUserGroup_Active] DEFAULT ((1)),
[AccesDocumentGLEntry] [bit] NOT NULL CONSTRAINT [DF_dxUserGroup_AccesDocumentGLEntry] DEFAULT ((0)),
[AllowedToApproveClientOrder] [bit] NOT NULL CONSTRAINT [DF_dxUserGroup_AllowedToApproveClientOrder] DEFAULT ((0)),
[AllowedToApprovePurchaseOrder] [bit] NOT NULL CONSTRAINT [DF_dxUserGroup_AllowedToApprovePurchaseOrder] DEFAULT ((0)),
[AllowedToReprintCheque] [bit] NOT NULL CONSTRAINT [DF_dxUserGroup_AllowedToReprintCheque] DEFAULT ((0)),
[AllowedToEditFormula] [bit] NOT NULL CONSTRAINT [DF_dxUserGroup_AllowedToEditFormula] DEFAULT ((0)),
[AllowedToAccessAssembly] [bit] NOT NULL CONSTRAINT [DF_dxUserGroup_AllowedToAccessAssembly] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxUserGroup.trAuditDelete] ON [dbo].[dxUserGroup]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxUserGroup'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxUserGroup CURSOR LOCAL FAST_FORWARD for SELECT PK_dxUserGroup, ID, Description, Active, AccesDocumentGLEntry, AllowedToApproveClientOrder, AllowedToApprovePurchaseOrder, AllowedToReprintCheque, AllowedToEditFormula, AllowedToAccessAssembly from deleted
 Declare @PK_dxUserGroup int, @ID varchar(50), @Description varchar(255), @Active Bit, @AccesDocumentGLEntry Bit, @AllowedToApproveClientOrder Bit, @AllowedToApprovePurchaseOrder Bit, @AllowedToReprintCheque Bit, @AllowedToEditFormula Bit, @AllowedToAccessAssembly Bit

 OPEN pk_cursordxUserGroup
 FETCH NEXT FROM pk_cursordxUserGroup INTO @PK_dxUserGroup, @ID, @Description, @Active, @AccesDocumentGLEntry, @AllowedToApproveClientOrder, @AllowedToApprovePurchaseOrder, @AllowedToReprintCheque, @AllowedToEditFormula, @AllowedToAccessAssembly
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxUserGroup, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AccesDocumentGLEntry', @AccesDocumentGLEntry
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToApproveClientOrder', @AllowedToApproveClientOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToApprovePurchaseOrder', @AllowedToApprovePurchaseOrder
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToReprintCheque', @AllowedToReprintCheque
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToEditFormula', @AllowedToEditFormula
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToAccessAssembly', @AllowedToAccessAssembly
FETCH NEXT FROM pk_cursordxUserGroup INTO @PK_dxUserGroup, @ID, @Description, @Active, @AccesDocumentGLEntry, @AllowedToApproveClientOrder, @AllowedToApprovePurchaseOrder, @AllowedToReprintCheque, @AllowedToEditFormula, @AllowedToAccessAssembly
 END

 CLOSE pk_cursordxUserGroup 
 DEALLOCATE pk_cursordxUserGroup
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxUserGroup.trAuditInsUpd] ON [dbo].[dxUserGroup] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxUserGroup CURSOR LOCAL FAST_FORWARD for SELECT PK_dxUserGroup from inserted;
 set @tablename = 'dxUserGroup' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxUserGroup
 FETCH NEXT FROM pk_cursordxUserGroup INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AccesDocumentGLEntry )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AccesDocumentGLEntry', AccesDocumentGLEntry from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AllowedToApproveClientOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToApproveClientOrder', AllowedToApproveClientOrder from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AllowedToApprovePurchaseOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToApprovePurchaseOrder', AllowedToApprovePurchaseOrder from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AllowedToReprintCheque )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToReprintCheque', AllowedToReprintCheque from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AllowedToEditFormula )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToEditFormula', AllowedToEditFormula from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AllowedToAccessAssembly )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AllowedToAccessAssembly', AllowedToAccessAssembly from dxUserGroup where PK_dxUserGroup = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxUserGroup INTO @keyvalue
 END

 CLOSE pk_cursordxUserGroup 
 DEALLOCATE pk_cursordxUserGroup
GO
ALTER TABLE [dbo].[dxUserGroup] ADD CONSTRAINT [PK_dxUseGroup] PRIMARY KEY CLUSTERED  ([PK_dxUserGroup]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxUserGroup] ON [dbo].[dxUserGroup] ([ID]) ON [PRIMARY]
GO
