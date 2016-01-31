CREATE TABLE [dbo].[dxQuery]
(
[PK_dxQuery] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[SQLScript] [varchar] (8000) COLLATE French_CI_AS NULL,
[SQLQuery] [varchar] (8000) COLLATE French_CI_AS NULL,
[EnglishDescription] [varchar] (500) COLLATE French_CI_AS NULL,
[SpanishDescription] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxReportCategory] [int] NULL,
[ExcelFileName] [varchar] (1000) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxQuery_ExcelFileName] DEFAULT (''),
[Active] [bit] NOT NULL CONSTRAINT [DF_dxQuery_Active] DEFAULT ((1)),
[ShowInPopupMenu] [bit] NOT NULL CONSTRAINT [DF_dxQuery_ShowInPopupMenu] DEFAULT ((0)),
[FormMainDataset] [varchar] (100) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxQuery.trAuditDelete] ON [dbo].[dxQuery]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxQuery'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxQuery CURSOR LOCAL FAST_FORWARD for SELECT PK_dxQuery, ID, Description, SQLScript, SQLQuery, EnglishDescription, SpanishDescription, FK_dxReportCategory, ExcelFileName, Active, ShowInPopupMenu, FormMainDataset from deleted
 Declare @PK_dxQuery int, @ID varchar(50), @Description varchar(255), @SQLScript varchar(8000), @SQLQuery varchar(8000), @EnglishDescription varchar(500), @SpanishDescription varchar(500), @FK_dxReportCategory int, @ExcelFileName varchar(1000), @Active Bit, @ShowInPopupMenu Bit, @FormMainDataset varchar(100)

 OPEN pk_cursordxQuery
 FETCH NEXT FROM pk_cursordxQuery INTO @PK_dxQuery, @ID, @Description, @SQLScript, @SQLQuery, @EnglishDescription, @SpanishDescription, @FK_dxReportCategory, @ExcelFileName, @Active, @ShowInPopupMenu, @FormMainDataset
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxQuery, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SQLScript', @SQLScript
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SQLQuery', @SQLQuery
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', @EnglishDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishDescription', @SpanishDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReportCategory', @FK_dxReportCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ExcelFileName', @ExcelFileName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShowInPopupMenu', @ShowInPopupMenu
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FormMainDataset', @FormMainDataset
FETCH NEXT FROM pk_cursordxQuery INTO @PK_dxQuery, @ID, @Description, @SQLScript, @SQLQuery, @EnglishDescription, @SpanishDescription, @FK_dxReportCategory, @ExcelFileName, @Active, @ShowInPopupMenu, @FormMainDataset
 END

 CLOSE pk_cursordxQuery 
 DEALLOCATE pk_cursordxQuery
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxQuery.trAuditInsUpd] ON [dbo].[dxQuery] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxQuery CURSOR LOCAL FAST_FORWARD for SELECT PK_dxQuery from inserted;
 set @tablename = 'dxQuery' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxQuery
 FETCH NEXT FROM pk_cursordxQuery INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SQLScript )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SQLScript', SQLScript from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SQLQuery )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SQLQuery', SQLQuery from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', EnglishDescription from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpanishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishDescription', SpanishDescription from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReportCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReportCategory', FK_dxReportCategory from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExcelFileName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ExcelFileName', ExcelFileName from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShowInPopupMenu )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShowInPopupMenu', ShowInPopupMenu from dxQuery where PK_dxQuery = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FormMainDataset )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FormMainDataset', FormMainDataset from dxQuery where PK_dxQuery = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxQuery INTO @keyvalue
 END

 CLOSE pk_cursordxQuery 
 DEALLOCATE pk_cursordxQuery
GO
ALTER TABLE [dbo].[dxQuery] ADD CONSTRAINT [PK_dxQuery] PRIMARY KEY CLUSTERED  ([PK_dxQuery]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxQuery_FK_dxReportCategory] ON [dbo].[dxQuery] ([FK_dxReportCategory]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxQuery] ON [dbo].[dxQuery] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxQuery] ADD CONSTRAINT [dxConstraint_FK_dxReportCategory_dxQuery] FOREIGN KEY ([FK_dxReportCategory]) REFERENCES [dbo].[dxReportCategory] ([PK_dxReportCategory])
GO
