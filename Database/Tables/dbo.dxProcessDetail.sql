CREATE TABLE [dbo].[dxProcessDetail]
(
[PK_dxProcessDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProcess] [int] NOT NULL,
[FK_dxProcessDetail__Parent] [int] NULL,
[FK_dxProcessDetailType] [int] NULL CONSTRAINT [DF_dxProcessDetail_FK_dxProcessDetailType] DEFAULT ((0)),
[Name] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[FrenchHint] [ntext] COLLATE French_CI_AS NULL,
[FrenchDescription] [ntext] COLLATE French_CI_AS NULL,
[EnglishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[EnglishHint] [ntext] COLLATE French_CI_AS NULL,
[EnglishDescription] [ntext] COLLATE French_CI_AS NULL,
[SpanishCaption] [nvarchar] (255) COLLATE French_CI_AS NULL,
[SpanishHint] [ntext] COLLATE French_CI_AS NULL,
[SpanishDescription] [ntext] COLLATE French_CI_AS NULL,
[ImageIndex] [int] NOT NULL CONSTRAINT [DF_dxProcessDetail_ImageIndex] DEFAULT ((-1)),
[ProcessDetailOrder] [int] NULL,
[FlowChartInfo] [varbinary] (max) NULL,
[LastModified] [timestamp] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessDetail.trAuditDelete] ON [dbo].[dxProcessDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProcessDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProcessDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessDetail, FK_dxProcess, FK_dxProcessDetail__Parent, FK_dxProcessDetailType, Name, FrenchCaption, EnglishCaption, SpanishCaption, ImageIndex, ProcessDetailOrder from deleted
 Declare @PK_dxProcessDetail int, @FK_dxProcess int, @FK_dxProcessDetail__Parent int, @FK_dxProcessDetailType int, @Name varchar(255), @FrenchCaption varchar(255), @EnglishCaption varchar(255), @SpanishCaption varchar(255), @ImageIndex int, @ProcessDetailOrder int

 OPEN pk_cursordxProcessDetail
 FETCH NEXT FROM pk_cursordxProcessDetail INTO @PK_dxProcessDetail, @FK_dxProcess, @FK_dxProcessDetail__Parent, @FK_dxProcessDetailType, @Name, @FrenchCaption, @EnglishCaption, @SpanishCaption, @ImageIndex, @ProcessDetailOrder
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProcessDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess', @FK_dxProcess
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetail__Parent', @FK_dxProcessDetail__Parent
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetailType', @FK_dxProcessDetailType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
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
        select @pkdataaudit, 'ImageIndex', @ImageIndex
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ProcessDetailOrder', @ProcessDetailOrder
FETCH NEXT FROM pk_cursordxProcessDetail INTO @PK_dxProcessDetail, @FK_dxProcess, @FK_dxProcessDetail__Parent, @FK_dxProcessDetailType, @Name, @FrenchCaption, @EnglishCaption, @SpanishCaption, @ImageIndex, @ProcessDetailOrder
 END

 CLOSE pk_cursordxProcessDetail 
 DEALLOCATE pk_cursordxProcessDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProcessDetail.trAuditInsUpd] ON [dbo].[dxProcessDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProcessDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProcessDetail from inserted;
 set @tablename = 'dxProcessDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProcessDetail
 FETCH NEXT FROM pk_cursordxProcessDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcess )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcess', FK_dxProcess from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcessDetail__Parent )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetail__Parent', FK_dxProcessDetail__Parent from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProcessDetailType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProcessDetailType', FK_dxProcessDetailType from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FrenchCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FrenchCaption', FrenchCaption from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishCaption', EnglishCaption from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpanishCaption )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SpanishCaption', SpanishCaption from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ImageIndex )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ImageIndex', ImageIndex from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProcessDetailOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ProcessDetailOrder', ProcessDetailOrder from dxProcessDetail where PK_dxProcessDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProcessDetail INTO @keyvalue
 END

 CLOSE pk_cursordxProcessDetail 
 DEALLOCATE pk_cursordxProcessDetail
GO
ALTER TABLE [dbo].[dxProcessDetail] ADD CONSTRAINT [PK_dxProcessDetail] PRIMARY KEY CLUSTERED  ([PK_dxProcessDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetail_FK_dxProcess] ON [dbo].[dxProcessDetail] ([FK_dxProcess]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetail_FK_dxProcessDetail__Parent] ON [dbo].[dxProcessDetail] ([FK_dxProcessDetail__Parent]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProcessDetail_FK_dxProcessDetailType] ON [dbo].[dxProcessDetail] ([FK_dxProcessDetailType]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProcessDetail] ADD CONSTRAINT [dxConstraint_FK_dxProcess_dxProcessDetail] FOREIGN KEY ([FK_dxProcess]) REFERENCES [dbo].[dxProcess] ([PK_dxProcess])
GO
ALTER TABLE [dbo].[dxProcessDetail] ADD CONSTRAINT [dxConstraint_FK_dxProcess_dxProcessDetail_CascadeDelete] FOREIGN KEY ([FK_dxProcess]) REFERENCES [dbo].[dxProcess] ([PK_dxProcess]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[dxProcessDetail] ADD CONSTRAINT [dxConstraint_FK_dxProcessDetail__Parent_dxProcessDetail] FOREIGN KEY ([FK_dxProcessDetail__Parent]) REFERENCES [dbo].[dxProcessDetail] ([PK_dxProcessDetail])
GO
ALTER TABLE [dbo].[dxProcessDetail] ADD CONSTRAINT [dxConstraint_FK_dxProcessDetailType_dxProcessDetail] FOREIGN KEY ([FK_dxProcessDetailType]) REFERENCES [dbo].[dxProcessDetailType] ([PK_dxProcessDetailType])
GO
