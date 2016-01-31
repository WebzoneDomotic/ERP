CREATE TABLE [dbo].[dxProperty]
(
[PK_dxProperty] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProperty__Parent] [int] NULL,
[FK_dxPropertyGroup] [int] NOT NULL,
[ImageIndex] [int] NOT NULL CONSTRAINT [DF_dxProperty_ImageIndex] DEFAULT ((1)),
[Name] [varchar] (250) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (2000) COLLATE French_CI_AS NOT NULL,
[DataType] [varchar] (20) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxProperty_DataType] DEFAULT ('String'),
[FK_dxDomain] [int] NULL,
[DefaultValue] [varchar] (8000) COLLATE French_CI_AS NULL,
[FK_dxDomainValue__Default] [int] NULL,
[FK_dxScaleUnit] [int] NULL,
[Rank] [float] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProperty.trAuditDelete] ON [dbo].[dxProperty]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProperty'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProperty CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProperty, FK_dxProperty__Parent, FK_dxPropertyGroup, ImageIndex, Name, Description, DataType, FK_dxDomain, DefaultValue, FK_dxDomainValue__Default, FK_dxScaleUnit, Rank from deleted
 Declare @PK_dxProperty int, @FK_dxProperty__Parent int, @FK_dxPropertyGroup int, @ImageIndex int, @Name varchar(250), @Description varchar(2000), @DataType varchar(20), @FK_dxDomain int, @DefaultValue varchar(8000), @FK_dxDomainValue__Default int, @FK_dxScaleUnit int, @Rank Float

 OPEN pk_cursordxProperty
 FETCH NEXT FROM pk_cursordxProperty INTO @PK_dxProperty, @FK_dxProperty__Parent, @FK_dxPropertyGroup, @ImageIndex, @Name, @Description, @DataType, @FK_dxDomain, @DefaultValue, @FK_dxDomainValue__Default, @FK_dxScaleUnit, @Rank
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProperty, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProperty__Parent', @FK_dxProperty__Parent
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', @FK_dxPropertyGroup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ImageIndex', @ImageIndex
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DataType', @DataType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDomain', @FK_dxDomain
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DefaultValue', @DefaultValue
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDomainValue__Default', @FK_dxDomainValue__Default
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', @FK_dxScaleUnit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
FETCH NEXT FROM pk_cursordxProperty INTO @PK_dxProperty, @FK_dxProperty__Parent, @FK_dxPropertyGroup, @ImageIndex, @Name, @Description, @DataType, @FK_dxDomain, @DefaultValue, @FK_dxDomainValue__Default, @FK_dxScaleUnit, @Rank
 END

 CLOSE pk_cursordxProperty 
 DEALLOCATE pk_cursordxProperty
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProperty.trAuditInsUpd] ON [dbo].[dxProperty] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProperty CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProperty from inserted;
 set @tablename = 'dxProperty' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProperty
 FETCH NEXT FROM pk_cursordxProperty INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProperty__Parent )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProperty__Parent', FK_dxProperty__Parent from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPropertyGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', FK_dxPropertyGroup from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ImageIndex )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ImageIndex', ImageIndex from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DataType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DataType', DataType from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDomain )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDomain', FK_dxDomain from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DefaultValue )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DefaultValue', DefaultValue from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDomainValue__Default )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDomainValue__Default', FK_dxDomainValue__Default from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxScaleUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxScaleUnit', FK_dxScaleUnit from dxProperty where PK_dxProperty = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxProperty where PK_dxProperty = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProperty INTO @keyvalue
 END

 CLOSE pk_cursordxProperty 
 DEALLOCATE pk_cursordxProperty
GO
ALTER TABLE [dbo].[dxProperty] ADD CONSTRAINT [PK_dxProperty] PRIMARY KEY CLUSTERED  ([PK_dxProperty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProperty_FK_dxDomain] ON [dbo].[dxProperty] ([FK_dxDomain]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProperty_FK_dxDomainValue__Default] ON [dbo].[dxProperty] ([FK_dxDomainValue__Default]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProperty_FK_dxProperty__Parent] ON [dbo].[dxProperty] ([FK_dxProperty__Parent]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProperty_FK_dxPropertyGroup] ON [dbo].[dxProperty] ([FK_dxPropertyGroup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProperty_FK_dxScaleUnit] ON [dbo].[dxProperty] ([FK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxPropertyName] ON [dbo].[dxProperty] ([Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProperty] ADD CONSTRAINT [dxConstraint_FK_dxDomain_dxProperty] FOREIGN KEY ([FK_dxDomain]) REFERENCES [dbo].[dxDomain] ([PK_dxDomain])
GO
ALTER TABLE [dbo].[dxProperty] ADD CONSTRAINT [dxConstraint_FK_dxDomainValue__Default_dxProperty] FOREIGN KEY ([FK_dxDomainValue__Default]) REFERENCES [dbo].[dxDomainValue] ([PK_dxDomainValue])
GO
ALTER TABLE [dbo].[dxProperty] ADD CONSTRAINT [dxConstraint_FK_dxProperty__Parent_dxProperty] FOREIGN KEY ([FK_dxProperty__Parent]) REFERENCES [dbo].[dxProperty] ([PK_dxProperty])
GO
ALTER TABLE [dbo].[dxProperty] ADD CONSTRAINT [dxConstraint_FK_dxPropertyGroup_dxProperty] FOREIGN KEY ([FK_dxPropertyGroup]) REFERENCES [dbo].[dxPropertyGroup] ([PK_dxPropertyGroup])
GO
ALTER TABLE [dbo].[dxProperty] ADD CONSTRAINT [dxConstraint_FK_dxScaleUnit_dxProperty] FOREIGN KEY ([FK_dxScaleUnit]) REFERENCES [dbo].[dxScaleUnit] ([PK_dxScaleUnit])
GO
