CREATE TABLE [dbo].[dxReportComponent]
(
[PK_dxReportComponent] [int] NOT NULL IDENTITY(1, 1),
[FK_dxReport] [int] NULL,
[ComponentName] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[NewItem] [bit] NOT NULL CONSTRAINT [DF_dxReportComponent_NewItem] DEFAULT ((0)),
[Original] [bit] NOT NULL CONSTRAINT [DF_dxReportComponent_Original] DEFAULT ((0)),
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReportComponent.trAuditDelete] ON [dbo].[dxReportComponent]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxReportComponent'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxReportComponent CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReportComponent, FK_dxReport, ComponentName, FrenchCaption, EnglishCaption, SpanishCaption, NewItem, Original from deleted
 Declare @PK_dxReportComponent int, @FK_dxReport int, @ComponentName varchar(255), @FrenchCaption varchar(255), @EnglishCaption varchar(255), @SpanishCaption varchar(255), @NewItem Bit, @Original Bit

 OPEN pk_cursordxReportComponent
 FETCH NEXT FROM pk_cursordxReportComponent INTO @PK_dxReportComponent, @FK_dxReport, @ComponentName, @FrenchCaption, @EnglishCaption, @SpanishCaption, @NewItem, @Original
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxReportComponent, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', @FK_dxReport
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ComponentName', @ComponentName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FrenchCaption', @FrenchCaption
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishCaption', @EnglishCaption
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishCaption', @SpanishCaption
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'NewItem', @NewItem
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Original', @Original
FETCH NEXT FROM pk_cursordxReportComponent INTO @PK_dxReportComponent, @FK_dxReport, @ComponentName, @FrenchCaption, @EnglishCaption, @SpanishCaption, @NewItem, @Original
 END

 CLOSE pk_cursordxReportComponent 
 DEALLOCATE pk_cursordxReportComponent
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReportComponent.trAuditInsUpd] ON [dbo].[dxReportComponent] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxReportComponent CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReportComponent from inserted;
 set @tablename = 'dxReportComponent' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxReportComponent
 FETCH NEXT FROM pk_cursordxReportComponent INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', FK_dxReport from dxReportComponent where PK_dxReportComponent = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ComponentName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ComponentName', ComponentName from dxReportComponent where PK_dxReportComponent = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FrenchCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FrenchCaption', FrenchCaption from dxReportComponent where PK_dxReportComponent = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishCaption', EnglishCaption from dxReportComponent where PK_dxReportComponent = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpanishCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishCaption', SpanishCaption from dxReportComponent where PK_dxReportComponent = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NewItem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'NewItem', NewItem from dxReportComponent where PK_dxReportComponent = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Original )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Original', Original from dxReportComponent where PK_dxReportComponent = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxReportComponent INTO @keyvalue
 END

 CLOSE pk_cursordxReportComponent 
 DEALLOCATE pk_cursordxReportComponent
GO
ALTER TABLE [dbo].[dxReportComponent] ADD CONSTRAINT [PK_dxReportComponent] PRIMARY KEY CLUSTERED  ([PK_dxReportComponent]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReportComponent_FK_dxReport] ON [dbo].[dxReportComponent] ([FK_dxReport]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxReportComponent] ADD CONSTRAINT [dxConstraint_FK_dxReport_dxReportComponent] FOREIGN KEY ([FK_dxReport]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
