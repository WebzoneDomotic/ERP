CREATE TABLE [dbo].[dxProcess]
(
[PK_dxProcess] [int] NOT NULL IDENTITY(1, 1),
[ProcessName] [nvarchar] (255) COLLATE French_CI_AS NOT NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[FK_dxUser__Author] [int] NULL,
[IsSystem] [bit] NOT NULL CONSTRAINT [DF_dxProcess_IsSystem] DEFAULT ((0)),
[FK_dxProcess__CopiedFrom] [int] NULL,
[FK_dxProcess__Parent] [int] NULL,
[FlowChartInfo] [varbinary] (max) NULL,
[LastModified] [timestamp] NOT NULL,
[FK_dxReportCategory] [int] NULL,
[FlowChartImage] [image] NULL,
[FK_dxReport__Process] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcess.trAuditDelete] ON [dbo].[dxProcess]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProcess'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProcess CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcess, ProcessName, FrenchCaption, EnglishCaption, SpanishCaption, FK_dxUser__Author, IsSystem, FK_dxProcess__CopiedFrom, FK_dxProcess__Parent, FK_dxReportCategory, FK_dxReport__Process from deleted
 Declare @PK_dxProcess int, @ProcessName varchar(255), @FrenchCaption varchar(255), @EnglishCaption varchar(255), @SpanishCaption varchar(255), @FK_dxUser__Author int, @IsSystem Bit, @FK_dxProcess__CopiedFrom int, @FK_dxProcess__Parent int, @FK_dxReportCategory int, @FK_dxReport__Process int

 OPEN pk_cursordxProcess
 FETCH NEXT FROM pk_cursordxProcess INTO @PK_dxProcess, @ProcessName, @FrenchCaption, @EnglishCaption, @SpanishCaption, @FK_dxUser__Author, @IsSystem, @FK_dxProcess__CopiedFrom, @FK_dxProcess__Parent, @FK_dxReportCategory, @FK_dxReport__Process
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProcess, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ProcessName', @ProcessName
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
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUser__Author', @FK_dxUser__Author
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'IsSystem', @IsSystem
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess__CopiedFrom', @FK_dxProcess__CopiedFrom
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess__Parent', @FK_dxProcess__Parent
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReportCategory', @FK_dxReportCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport__Process', @FK_dxReport__Process
FETCH NEXT FROM pk_cursordxProcess INTO @PK_dxProcess, @ProcessName, @FrenchCaption, @EnglishCaption, @SpanishCaption, @FK_dxUser__Author, @IsSystem, @FK_dxProcess__CopiedFrom, @FK_dxProcess__Parent, @FK_dxReportCategory, @FK_dxReport__Process
 END

 CLOSE pk_cursordxProcess 
 DEALLOCATE pk_cursordxProcess
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcess.trAuditInsUpd] ON [dbo].[dxProcess] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProcess CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcess from inserted;
 set @tablename = 'dxProcess' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProcess
 FETCH NEXT FROM pk_cursordxProcess INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProcessName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ProcessName', ProcessName from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FrenchCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FrenchCaption', FrenchCaption from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishCaption', EnglishCaption from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpanishCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishCaption', SpanishCaption from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxUser__Author )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUser__Author', FK_dxUser__Author from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( IsSystem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'IsSystem', IsSystem from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcess__CopiedFrom )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess__CopiedFrom', FK_dxProcess__CopiedFrom from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcess__Parent )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess__Parent', FK_dxProcess__Parent from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReportCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReportCategory', FK_dxReportCategory from dxProcess where PK_dxProcess = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport__Process )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport__Process', FK_dxReport__Process from dxProcess where PK_dxProcess = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProcess INTO @keyvalue
 END

 CLOSE pk_cursordxProcess 
 DEALLOCATE pk_cursordxProcess
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcess.trInsertDefaultValues] ON [dbo].[dxProcess]
FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @FK_dxReport__Process int

	SET @FK_dxReport__Process = (SELECT TOP 1 FK_dxReport__ProcessDefault FROM dxSetup)

    IF @FK_dxReport__Process IS NOT NULL
    BEGIN
		UPDATE dxProcess SET FK_dxReport__Process = @FK_dxReport__Process
		   WHERE FK_dxReport__Process IS NULL AND PK_dxProcess IN (SELECT PK_dxProcess FROM inserted)
	END

    -- Insert Process permissions with default value (no permission)
	INSERT INTO dxProcessPermission ( FK_dxProcess, FK_dxUserGroup ) SELECT p.PK_dxProcess, g.PK_dxUserGroup FROM inserted p, dxUserGroup g
		WHERE NOT EXISTS ( SELECT 1 FROM dxProcessPermission WHERE FK_dxProcess = p.PK_dxProcess AND FK_dxUserGroup = g.PK_dxUserGroup) ;

	-- We make sure rights are accorded to administrators
	UPDATE dxProcessPermission SET ViewProcess = 1 WHERE FK_dxProcess IN (SELECT PK_dxProcess FROM inserted) AND FK_dxUserGroup = 1 AND Coalesce(ViewProcess, 0) = 0
END
GO
ALTER TABLE [dbo].[dxProcess] ADD CONSTRAINT [PK_dxProcess] PRIMARY KEY CLUSTERED  ([PK_dxProcess]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcess_FK_dxProcess__CopiedFrom] ON [dbo].[dxProcess] ([FK_dxProcess__CopiedFrom]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcess_FK_dxProcess__Parent] ON [dbo].[dxProcess] ([FK_dxProcess__Parent]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcess_FK_dxReport__Process] ON [dbo].[dxProcess] ([FK_dxReport__Process]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcess_FK_dxReportCategory] ON [dbo].[dxProcess] ([FK_dxReportCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcess_FK_dxUser__Author] ON [dbo].[dxProcess] ([FK_dxUser__Author]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProcess] ADD CONSTRAINT [dxConstraint_FK_dxProcess__CopiedFrom_dxProcess] FOREIGN KEY ([FK_dxProcess__CopiedFrom]) REFERENCES [dbo].[dxProcess] ([PK_dxProcess])
GO
ALTER TABLE [dbo].[dxProcess] ADD CONSTRAINT [dxConstraint_FK_dxProcess__Parent_dxProcess] FOREIGN KEY ([FK_dxProcess__Parent]) REFERENCES [dbo].[dxProcess] ([PK_dxProcess])
GO
ALTER TABLE [dbo].[dxProcess] ADD CONSTRAINT [dxConstraint_FK_dxReport__Process_dxProcess] FOREIGN KEY ([FK_dxReport__Process]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
ALTER TABLE [dbo].[dxProcess] ADD CONSTRAINT [dxConstraint_FK_dxReportCategory_dxProcess] FOREIGN KEY ([FK_dxReportCategory]) REFERENCES [dbo].[dxReportCategory] ([PK_dxReportCategory])
GO
ALTER TABLE [dbo].[dxProcess] ADD CONSTRAINT [dxConstraint_FK_dxUser__Author_dxProcess] FOREIGN KEY ([FK_dxUser__Author]) REFERENCES [dbo].[dxUser] ([PK_dxUser])
GO
