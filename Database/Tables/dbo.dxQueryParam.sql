CREATE TABLE [dbo].[dxQueryParam]
(
[PK_dxQueryParam] [int] NOT NULL IDENTITY(1, 1),
[FK_dxQuery] [int] NOT NULL,
[Name] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[ParamType] [int] NOT NULL,
[ParamValueString] [varchar] (8000) COLLATE French_CI_AS NULL,
[ParamValueInteger] [int] NULL,
[ParamValueDate] [datetime] NULL,
[ParamValueFloat] [float] NULL,
[ParamValueBoolean] [bit] NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxQueryParam.trAuditDelete] ON [dbo].[dxQueryParam]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxQueryParam'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxQueryParam CURSOR LOCAL FAST_FORWARD for SELECT PK_dxQueryParam, FK_dxQuery, Name, ParamType, ParamValueString, ParamValueInteger, ParamValueDate, ParamValueFloat, ParamValueBoolean, FrenchCaption, EnglishCaption, SpanishCaption from deleted
 Declare @PK_dxQueryParam int, @FK_dxQuery int, @Name varchar(255), @ParamType int, @ParamValueString varchar(8000), @ParamValueInteger int, @ParamValueDate DateTime, @ParamValueFloat Float, @ParamValueBoolean Bit, @FrenchCaption varchar(255), @EnglishCaption varchar(255), @SpanishCaption varchar(255)

 OPEN pk_cursordxQueryParam
 FETCH NEXT FROM pk_cursordxQueryParam INTO @PK_dxQueryParam, @FK_dxQuery, @Name, @ParamType, @ParamValueString, @ParamValueInteger, @ParamValueDate, @ParamValueFloat, @ParamValueBoolean, @FrenchCaption, @EnglishCaption, @SpanishCaption
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxQueryParam, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxQuery', @FK_dxQuery
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ParamType', @ParamType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ParamValueString', @ParamValueString
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ParamValueInteger', @ParamValueInteger
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ParamValueDate', @ParamValueDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ParamValueFloat', @ParamValueFloat
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ParamValueBoolean', @ParamValueBoolean
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FrenchCaption', @FrenchCaption
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishCaption', @EnglishCaption
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishCaption', @SpanishCaption
FETCH NEXT FROM pk_cursordxQueryParam INTO @PK_dxQueryParam, @FK_dxQuery, @Name, @ParamType, @ParamValueString, @ParamValueInteger, @ParamValueDate, @ParamValueFloat, @ParamValueBoolean, @FrenchCaption, @EnglishCaption, @SpanishCaption
 END

 CLOSE pk_cursordxQueryParam 
 DEALLOCATE pk_cursordxQueryParam
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxQueryParam.trAuditInsUpd] ON [dbo].[dxQueryParam] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxQueryParam CURSOR LOCAL FAST_FORWARD for SELECT PK_dxQueryParam from inserted;
 set @tablename = 'dxQueryParam' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxQueryParam
 FETCH NEXT FROM pk_cursordxQueryParam INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxQuery )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxQuery', FK_dxQuery from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ParamType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ParamType', ParamType from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ParamValueString )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ParamValueString', ParamValueString from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ParamValueInteger )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ParamValueInteger', ParamValueInteger from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ParamValueDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ParamValueDate', ParamValueDate from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ParamValueFloat )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ParamValueFloat', ParamValueFloat from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ParamValueBoolean )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ParamValueBoolean', ParamValueBoolean from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FrenchCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FrenchCaption', FrenchCaption from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishCaption', EnglishCaption from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpanishCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishCaption', SpanishCaption from dxQueryParam where PK_dxQueryParam = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxQueryParam INTO @keyvalue
 END

 CLOSE pk_cursordxQueryParam 
 DEALLOCATE pk_cursordxQueryParam
GO
ALTER TABLE [dbo].[dxQueryParam] ADD CONSTRAINT [PK_dxQueryParam] PRIMARY KEY CLUSTERED  ([PK_dxQueryParam]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxQueryParam_FK_dxQuery] ON [dbo].[dxQueryParam] ([FK_dxQuery]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxQueryParam] ADD CONSTRAINT [dxConstraint_FK_dxQuery_dxQueryParam] FOREIGN KEY ([FK_dxQuery]) REFERENCES [dbo].[dxQuery] ([PK_dxQuery])
GO
ALTER TABLE [dbo].[dxQueryParam] ADD CONSTRAINT [dxConstraint_FK_dxQuery_dxQueryParam_CascadeDelete] FOREIGN KEY ([FK_dxQuery]) REFERENCES [dbo].[dxQuery] ([PK_dxQuery]) ON DELETE CASCADE
GO
