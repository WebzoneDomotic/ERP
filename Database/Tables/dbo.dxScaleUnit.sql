CREATE TABLE [dbo].[dxScaleUnit]
(
[PK_dxScaleUnit] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Symbol] [varchar] (10) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[EnglishDescription] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[EnglishSymbol] [varchar] (10) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxScaleUnit.trAuditDelete] ON [dbo].[dxScaleUnit]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxScaleUnit'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxScaleUnit CURSOR LOCAL FAST_FORWARD for SELECT PK_dxScaleUnit, ID, Symbol, Description, EnglishDescription, EnglishSymbol from deleted
 Declare @PK_dxScaleUnit int, @ID varchar(50), @Symbol varchar(10), @Description varchar(255), @EnglishDescription varchar(255), @EnglishSymbol varchar(10)

 OPEN pk_cursordxScaleUnit
 FETCH NEXT FROM pk_cursordxScaleUnit INTO @PK_dxScaleUnit, @ID, @Symbol, @Description, @EnglishDescription, @EnglishSymbol
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxScaleUnit, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Symbol', @Symbol
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', @EnglishDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishSymbol', @EnglishSymbol
FETCH NEXT FROM pk_cursordxScaleUnit INTO @PK_dxScaleUnit, @ID, @Symbol, @Description, @EnglishDescription, @EnglishSymbol
 END

 CLOSE pk_cursordxScaleUnit 
 DEALLOCATE pk_cursordxScaleUnit
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxScaleUnit.trAuditInsUpd] ON [dbo].[dxScaleUnit] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxScaleUnit CURSOR LOCAL FAST_FORWARD for SELECT PK_dxScaleUnit from inserted;
 set @tablename = 'dxScaleUnit' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxScaleUnit
 FETCH NEXT FROM pk_cursordxScaleUnit INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxScaleUnit where PK_dxScaleUnit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Symbol )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Symbol', Symbol from dxScaleUnit where PK_dxScaleUnit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxScaleUnit where PK_dxScaleUnit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishDescription', EnglishDescription from dxScaleUnit where PK_dxScaleUnit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EnglishSymbol )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EnglishSymbol', EnglishSymbol from dxScaleUnit where PK_dxScaleUnit = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxScaleUnit INTO @keyvalue
 END

 CLOSE pk_cursordxScaleUnit 
 DEALLOCATE pk_cursordxScaleUnit
GO
ALTER TABLE [dbo].[dxScaleUnit] ADD CONSTRAINT [PK_dxScaleUnit] PRIMARY KEY CLUSTERED  ([PK_dxScaleUnit]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxScaleUnit] ON [dbo].[dxScaleUnit] ([ID]) ON [PRIMARY]
GO
