CREATE TABLE [dbo].[dxPayMeasureUnit]
(
[PK_dxPayMeasureUnit] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Symbol] [varchar] (10) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayMeasureUnit.trAuditDelete] ON [dbo].[dxPayMeasureUnit]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPayMeasureUnit'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPayMeasureUnit CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayMeasureUnit, ID, Symbol, Description from deleted
 Declare @PK_dxPayMeasureUnit int, @ID varchar(50), @Symbol varchar(10), @Description varchar(255)

 OPEN pk_cursordxPayMeasureUnit
 FETCH NEXT FROM pk_cursordxPayMeasureUnit INTO @PK_dxPayMeasureUnit, @ID, @Symbol, @Description
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPayMeasureUnit, @tablename, @auditdate, @username, @fk_dxuser
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
FETCH NEXT FROM pk_cursordxPayMeasureUnit INTO @PK_dxPayMeasureUnit, @ID, @Symbol, @Description
 END

 CLOSE pk_cursordxPayMeasureUnit 
 DEALLOCATE pk_cursordxPayMeasureUnit
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayMeasureUnit.trAuditInsUpd] ON [dbo].[dxPayMeasureUnit] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPayMeasureUnit CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayMeasureUnit from inserted;
 set @tablename = 'dxPayMeasureUnit' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPayMeasureUnit
 FETCH NEXT FROM pk_cursordxPayMeasureUnit INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxPayMeasureUnit where PK_dxPayMeasureUnit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Symbol )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Symbol', Symbol from dxPayMeasureUnit where PK_dxPayMeasureUnit = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPayMeasureUnit where PK_dxPayMeasureUnit = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPayMeasureUnit INTO @keyvalue
 END

 CLOSE pk_cursordxPayMeasureUnit 
 DEALLOCATE pk_cursordxPayMeasureUnit
GO
ALTER TABLE [dbo].[dxPayMeasureUnit] ADD CONSTRAINT [PK_dxPayMeasureUnit] PRIMARY KEY CLUSTERED  ([PK_dxPayMeasureUnit]) ON [PRIMARY]
GO
