CREATE TABLE [dbo].[dxReport]
(
[PK_dxReport] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxReport_Active] DEFAULT ((1)),
[PublishReportByTable] [bit] NOT NULL CONSTRAINT [DF_dxReport_PublishReportByTable] DEFAULT ((0)),
[UpdateGLBeforePrint] [bit] NOT NULL CONSTRAINT [DF_dxReport_UpdateGLBeforePrint] DEFAULT ((1)),
[FK_dxReportCategory] [int] NULL,
[ShowPrinterDialog] [bit] NOT NULL CONSTRAINT [DF_dxReport_ShowPrinterDialog] DEFAULT ((1)),
[BatchPrinting] [bit] NOT NULL CONSTRAINT [DF_dxReport_BatchPrinting] DEFAULT ((1)),
[PreviewReport] [bit] NOT NULL CONSTRAINT [DF_dxReport_PreviewReport] DEFAULT ((1)),
[SendByEmail] [bit] NOT NULL CONSTRAINT [DF_dxReport_SendByEmail] DEFAULT ((0)),
[EnglishDescription] [varchar] (500) COLLATE French_CI_AS NULL,
[SpanishDescription] [varchar] (500) COLLATE French_CI_AS NULL,
[ShellExecuteFirst] [bit] NOT NULL CONSTRAINT [DF_dxReport_ShellExecuteFirst] DEFAULT ((0)),
[PrintACopy] [bit] NOT NULL CONSTRAINT [DF_dxReport_PrintACopy] DEFAULT ((0)),
[DefaultPrintDocument] [bit] NOT NULL CONSTRAINT [DF_dxReport_DefaultPrintDocument] DEFAULT ((0)),
[TranslateComponent] [bit] NOT NULL CONSTRAINT [DF_dxReport_TranslateComponent] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReport.trAuditDelete] ON [dbo].[dxReport]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxReport'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxReport CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReport, ID, Description, Active, PublishReportByTable, UpdateGLBeforePrint, FK_dxReportCategory, ShowPrinterDialog, BatchPrinting, PreviewReport, SendByEmail, EnglishDescription, SpanishDescription, ShellExecuteFirst, PrintACopy, DefaultPrintDocument, TranslateComponent from deleted
 Declare @PK_dxReport int, @ID varchar(50), @Description varchar(500), @Active Bit, @PublishReportByTable Bit, @UpdateGLBeforePrint Bit, @FK_dxReportCategory int, @ShowPrinterDialog Bit, @BatchPrinting Bit, @PreviewReport Bit, @SendByEmail Bit, @EnglishDescription varchar(500), @SpanishDescription varchar(500), @ShellExecuteFirst Bit, @PrintACopy Bit, @DefaultPrintDocument Bit, @TranslateComponent Bit

 OPEN pk_cursordxReport
 FETCH NEXT FROM pk_cursordxReport INTO @PK_dxReport, @ID, @Description, @Active, @PublishReportByTable, @UpdateGLBeforePrint, @FK_dxReportCategory, @ShowPrinterDialog, @BatchPrinting, @PreviewReport, @SendByEmail, @EnglishDescription, @SpanishDescription, @ShellExecuteFirst, @PrintACopy, @DefaultPrintDocument, @TranslateComponent
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxReport, @tablename, @auditdate, @username, @fk_dxuser
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
        select @pkdataaudit, 'PublishReportByTable', @PublishReportByTable
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'UpdateGLBeforePrint', @UpdateGLBeforePrint
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReportCategory', @FK_dxReportCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShowPrinterDialog', @ShowPrinterDialog
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'BatchPrinting', @BatchPrinting
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PreviewReport', @PreviewReport
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'SendByEmail', @SendByEmail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', @EnglishDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishDescription', @SpanishDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShellExecuteFirst', @ShellExecuteFirst
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PrintACopy', @PrintACopy
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DefaultPrintDocument', @DefaultPrintDocument
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'TranslateComponent', @TranslateComponent
FETCH NEXT FROM pk_cursordxReport INTO @PK_dxReport, @ID, @Description, @Active, @PublishReportByTable, @UpdateGLBeforePrint, @FK_dxReportCategory, @ShowPrinterDialog, @BatchPrinting, @PreviewReport, @SendByEmail, @EnglishDescription, @SpanishDescription, @ShellExecuteFirst, @PrintACopy, @DefaultPrintDocument, @TranslateComponent
 END

 CLOSE pk_cursordxReport 
 DEALLOCATE pk_cursordxReport
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReport.trAuditInsUpd] ON [dbo].[dxReport] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxReport CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReport from inserted;
 set @tablename = 'dxReport' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxReport
 FETCH NEXT FROM pk_cursordxReport INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PublishReportByTable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PublishReportByTable', PublishReportByTable from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UpdateGLBeforePrint )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'UpdateGLBeforePrint', UpdateGLBeforePrint from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReportCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReportCategory', FK_dxReportCategory from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShowPrinterDialog )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShowPrinterDialog', ShowPrinterDialog from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BatchPrinting )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'BatchPrinting', BatchPrinting from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PreviewReport )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PreviewReport', PreviewReport from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SendByEmail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'SendByEmail', SendByEmail from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', EnglishDescription from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpanishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishDescription', SpanishDescription from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShellExecuteFirst )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShellExecuteFirst', ShellExecuteFirst from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PrintACopy )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PrintACopy', PrintACopy from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DefaultPrintDocument )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DefaultPrintDocument', DefaultPrintDocument from dxReport where PK_dxReport = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TranslateComponent )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'TranslateComponent', TranslateComponent from dxReport where PK_dxReport = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxReport INTO @keyvalue
 END

 CLOSE pk_cursordxReport 
 DEALLOCATE pk_cursordxReport
GO
ALTER TABLE [dbo].[dxReport] ADD CONSTRAINT [PK_dxReport] PRIMARY KEY CLUSTERED  ([PK_dxReport]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReport_FK_dxReportCategory] ON [dbo].[dxReport] ([FK_dxReportCategory]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxReport] ON [dbo].[dxReport] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxReport] ADD CONSTRAINT [dxConstraint_FK_dxReportCategory_dxReport] FOREIGN KEY ([FK_dxReportCategory]) REFERENCES [dbo].[dxReportCategory] ([PK_dxReportCategory])
GO
