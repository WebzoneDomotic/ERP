CREATE TABLE [dbo].[dxTable]
(
[PK_dxTable] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Caption] [varchar] (255) COLLATE French_CI_AS NULL,
[FKCaptionFields] [varchar] (500) COLLATE French_CI_AS NULL,
[FKLookupListFields] [varchar] (500) COLLATE French_CI_AS NULL,
[FKSearchField] [varchar] (50) COLLATE French_CI_AS NULL,
[SQLFilter] [varchar] (8000) COLLATE French_CI_AS NULL,
[SQLWhere] [varchar] (8000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTable.trAuditDelete] ON [dbo].[dxTable]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxTable'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxTable CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTable, ID, Name, Caption, FKCaptionFields, FKLookupListFields, FKSearchField, SQLFilter, SQLWhere from deleted
 Declare @PK_dxTable int, @ID varchar(50), @Name varchar(50), @Caption varchar(255), @FKCaptionFields varchar(500), @FKLookupListFields varchar(500), @FKSearchField varchar(50), @SQLFilter varchar(8000), @SQLWhere varchar(8000)

 OPEN pk_cursordxTable
 FETCH NEXT FROM pk_cursordxTable INTO @PK_dxTable, @ID, @Name, @Caption, @FKCaptionFields, @FKLookupListFields, @FKSearchField, @SQLFilter, @SQLWhere
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxTable, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Caption', @Caption
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FKCaptionFields', @FKCaptionFields
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FKLookupListFields', @FKLookupListFields
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FKSearchField', @FKSearchField
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SQLFilter', @SQLFilter
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SQLWhere', @SQLWhere
FETCH NEXT FROM pk_cursordxTable INTO @PK_dxTable, @ID, @Name, @Caption, @FKCaptionFields, @FKLookupListFields, @FKSearchField, @SQLFilter, @SQLWhere
 END

 CLOSE pk_cursordxTable 
 DEALLOCATE pk_cursordxTable
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTable.trAuditInsUpd] ON [dbo].[dxTable] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxTable CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTable from inserted;
 set @tablename = 'dxTable' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxTable
 FETCH NEXT FROM pk_cursordxTable INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxTable where PK_dxTable = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxTable where PK_dxTable = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Caption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Caption', Caption from dxTable where PK_dxTable = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FKCaptionFields )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FKCaptionFields', FKCaptionFields from dxTable where PK_dxTable = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FKLookupListFields )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FKLookupListFields', FKLookupListFields from dxTable where PK_dxTable = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FKSearchField )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FKSearchField', FKSearchField from dxTable where PK_dxTable = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SQLFilter )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SQLFilter', SQLFilter from dxTable where PK_dxTable = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SQLWhere )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SQLWhere', SQLWhere from dxTable where PK_dxTable = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxTable INTO @keyvalue
 END

 CLOSE pk_cursordxTable 
 DEALLOCATE pk_cursordxTable
GO
ALTER TABLE [dbo].[dxTable] ADD CONSTRAINT [PK_dxTable] PRIMARY KEY CLUSTERED  ([PK_dxTable]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxTable] ON [dbo].[dxTable] ([ID]) ON [PRIMARY]
GO
