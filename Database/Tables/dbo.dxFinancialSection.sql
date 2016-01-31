CREATE TABLE [dbo].[dxFinancialSection]
(
[PK_dxFinancialSection] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NULL,
[FK_dxFinancialStatement] [int] NOT NULL,
[FK_dxFinancialSection__Master] [int] NULL,
[Hide] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_Hide] DEFAULT ((0)),
[nLevel] [float] NOT NULL CONSTRAINT [DF_dxFinancialSection_nLevel] DEFAULT ((0.0)),
[nIndex] [float] NOT NULL CONSTRAINT [DF_dxFinancialSection_nIndex] DEFAULT ((0.0)),
[nAbsoluteIndex] [float] NOT NULL CONSTRAINT [DF_dxFinancialSection_nAbsoluteIndex] DEFAULT ((0.0)),
[Header] [varchar] (255) COLLATE French_CI_AS NULL,
[HideHeader] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_HideHeader] DEFAULT ((0)),
[Footer] [varchar] (255) COLLATE French_CI_AS NULL,
[HideFooter] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_HideFooter] DEFAULT ((0)),
[Note] [varchar] (1000) COLLATE French_CI_AS NULL,
[HideNote] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_HideNote] DEFAULT ((0)),
[Font] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxFinancialSection_Font] DEFAULT ('Arial'),
[Underline] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_Underline] DEFAULT ((0)),
[Italic] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_Italic] DEFAULT ((0)),
[Bold] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_Bold] DEFAULT ((0)),
[Deleted] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_Deleted] DEFAULT ((0)),
[ShowAccount] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_ShowAccount] DEFAULT ((1)),
[ShowAccountDescription] [bit] NOT NULL CONSTRAINT [DF_dxFinancialSection_ShowAccountDescription] DEFAULT ((1)),
[Formula] [varchar] (500) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialSection.trAuditDelete] ON [dbo].[dxFinancialSection]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxFinancialSection'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxFinancialSection CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialSection, ID, FK_dxFinancialStatement, FK_dxFinancialSection__Master, Hide, nLevel, nIndex, nAbsoluteIndex, Header, HideHeader, Footer, HideFooter, Note, HideNote, Font, Underline, Italic, Bold, Deleted, ShowAccount, ShowAccountDescription, Formula from deleted
 Declare @PK_dxFinancialSection int, @ID varchar(50), @FK_dxFinancialStatement int, @FK_dxFinancialSection__Master int, @Hide Bit, @nLevel Float, @nIndex Float, @nAbsoluteIndex Float, @Header varchar(255), @HideHeader Bit, @Footer varchar(255), @HideFooter Bit, @Note varchar(1000), @HideNote Bit, @Font varchar(50), @Underline Bit, @Italic Bit, @Bold Bit, @Deleted Bit, @ShowAccount Bit, @ShowAccountDescription Bit, @Formula varchar(500)

 OPEN pk_cursordxFinancialSection
 FETCH NEXT FROM pk_cursordxFinancialSection INTO @PK_dxFinancialSection, @ID, @FK_dxFinancialStatement, @FK_dxFinancialSection__Master, @Hide, @nLevel, @nIndex, @nAbsoluteIndex, @Header, @HideHeader, @Footer, @HideFooter, @Note, @HideNote, @Font, @Underline, @Italic, @Bold, @Deleted, @ShowAccount, @ShowAccountDescription, @Formula
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxFinancialSection, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialStatement', @FK_dxFinancialStatement
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialSection__Master', @FK_dxFinancialSection__Master
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Hide', @Hide
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'nLevel', @nLevel
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'nIndex', @nIndex
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'nAbsoluteIndex', @nAbsoluteIndex
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Header', @Header
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HideHeader', @HideHeader
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Footer', @Footer
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HideFooter', @HideFooter
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HideNote', @HideNote
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Font', @Font
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Underline', @Underline
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Italic', @Italic
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Bold', @Bold
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Deleted', @Deleted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShowAccount', @ShowAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShowAccountDescription', @ShowAccountDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Formula', @Formula
FETCH NEXT FROM pk_cursordxFinancialSection INTO @PK_dxFinancialSection, @ID, @FK_dxFinancialStatement, @FK_dxFinancialSection__Master, @Hide, @nLevel, @nIndex, @nAbsoluteIndex, @Header, @HideHeader, @Footer, @HideFooter, @Note, @HideNote, @Font, @Underline, @Italic, @Bold, @Deleted, @ShowAccount, @ShowAccountDescription, @Formula
 END

 CLOSE pk_cursordxFinancialSection 
 DEALLOCATE pk_cursordxFinancialSection
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialSection.trAuditInsUpd] ON [dbo].[dxFinancialSection] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxFinancialSection CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialSection from inserted;
 set @tablename = 'dxFinancialSection' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxFinancialSection
 FETCH NEXT FROM pk_cursordxFinancialSection INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFinancialStatement )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialStatement', FK_dxFinancialStatement from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFinancialSection__Master )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialSection__Master', FK_dxFinancialSection__Master from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Hide )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Hide', Hide from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( nLevel )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'nLevel', nLevel from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( nIndex )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'nIndex', nIndex from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( nAbsoluteIndex )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'nAbsoluteIndex', nAbsoluteIndex from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Header )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Header', Header from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HideHeader )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HideHeader', HideHeader from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Footer )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Footer', Footer from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HideFooter )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HideFooter', HideFooter from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HideNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'HideNote', HideNote from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Font )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Font', Font from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Underline )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Underline', Underline from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Italic )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Italic', Italic from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Bold )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Bold', Bold from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Deleted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Deleted', Deleted from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShowAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShowAccount', ShowAccount from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShowAccountDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ShowAccountDescription', ShowAccountDescription from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Formula )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Formula', Formula from dxFinancialSection where PK_dxFinancialSection = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxFinancialSection INTO @keyvalue
 END

 CLOSE pk_cursordxFinancialSection 
 DEALLOCATE pk_cursordxFinancialSection
GO
ALTER TABLE [dbo].[dxFinancialSection] ADD CONSTRAINT [PK_dxFinancialSection] PRIMARY KEY CLUSTERED  ([PK_dxFinancialSection]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFinancialSection_FK_dxFinancialSection__Master] ON [dbo].[dxFinancialSection] ([FK_dxFinancialSection__Master]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFinancialSection_FK_dxFinancialStatement] ON [dbo].[dxFinancialSection] ([FK_dxFinancialStatement]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxFinancialSection] ADD CONSTRAINT [dxConstraint_FK_dxFinancialSection__Master_dxFinancialSection] FOREIGN KEY ([FK_dxFinancialSection__Master]) REFERENCES [dbo].[dxFinancialSection] ([PK_dxFinancialSection])
GO
ALTER TABLE [dbo].[dxFinancialSection] ADD CONSTRAINT [dxConstraint_FK_dxFinancialStatement_dxFinancialSection] FOREIGN KEY ([FK_dxFinancialStatement]) REFERENCES [dbo].[dxFinancialStatement] ([PK_dxFinancialStatement])
GO
