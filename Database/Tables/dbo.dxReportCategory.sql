CREATE TABLE [dbo].[dxReportCategory]
(
[PK_dxReportCategory] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[Image32x32] [int] NULL,
[EnglishDescription] [varchar] (500) COLLATE French_CI_AS NULL,
[SpanishDescription] [varchar] (500) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReportCategory.trAuditDelete] ON [dbo].[dxReportCategory]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxReportCategory'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxReportCategory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReportCategory, ID, Description, Image32x32, EnglishDescription, SpanishDescription from deleted
 Declare @PK_dxReportCategory int, @ID varchar(50), @Description varchar(255), @Image32x32 int, @EnglishDescription varchar(500), @SpanishDescription varchar(500)

 OPEN pk_cursordxReportCategory
 FETCH NEXT FROM pk_cursordxReportCategory INTO @PK_dxReportCategory, @ID, @Description, @Image32x32, @EnglishDescription, @SpanishDescription
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxReportCategory, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'Image32x32', @Image32x32
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', @EnglishDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishDescription', @SpanishDescription
FETCH NEXT FROM pk_cursordxReportCategory INTO @PK_dxReportCategory, @ID, @Description, @Image32x32, @EnglishDescription, @SpanishDescription
 END

 CLOSE pk_cursordxReportCategory 
 DEALLOCATE pk_cursordxReportCategory
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReportCategory.trAuditInsUpd] ON [dbo].[dxReportCategory] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxReportCategory CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReportCategory from inserted;
 set @tablename = 'dxReportCategory' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxReportCategory
 FETCH NEXT FROM pk_cursordxReportCategory INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxReportCategory where PK_dxReportCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxReportCategory where PK_dxReportCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Image32x32 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'Image32x32', Image32x32 from dxReportCategory where PK_dxReportCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', EnglishDescription from dxReportCategory where PK_dxReportCategory = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpanishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishDescription', SpanishDescription from dxReportCategory where PK_dxReportCategory = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxReportCategory INTO @keyvalue
 END

 CLOSE pk_cursordxReportCategory 
 DEALLOCATE pk_cursordxReportCategory
GO
ALTER TABLE [dbo].[dxReportCategory] ADD CONSTRAINT [PK_dxReportCategory] PRIMARY KEY CLUSTERED  ([PK_dxReportCategory]) ON [PRIMARY]
GO
