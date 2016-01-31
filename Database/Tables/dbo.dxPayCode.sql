CREATE TABLE [dbo].[dxPayCode]
(
[PK_dxPayCode] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[FK_dxPayCodeType] [int] NOT NULL,
[FK_dxPayMeasureUnit] [int] NOT NULL,
[FK_dxVendor] [int] NULL,
[PayDetailDefault] [bit] NOT NULL CONSTRAINT [DF_dxPayCode_PayDetailDefault] DEFAULT ((1)),
[IncludeInSummary] [bit] NOT NULL CONSTRAINT [DF_dxPayCode_IncludeInSummary] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayCode.trAuditDelete] ON [dbo].[dxPayCode]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPayCode'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPayCode CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayCode, ID, Description, FK_dxPayCodeType, FK_dxPayMeasureUnit, FK_dxVendor, PayDetailDefault, IncludeInSummary from deleted
 Declare @PK_dxPayCode int, @ID varchar(50), @Description varchar(255), @FK_dxPayCodeType int, @FK_dxPayMeasureUnit int, @FK_dxVendor int, @PayDetailDefault Bit, @IncludeInSummary Bit

 OPEN pk_cursordxPayCode
 FETCH NEXT FROM pk_cursordxPayCode INTO @PK_dxPayCode, @ID, @Description, @FK_dxPayCodeType, @FK_dxPayMeasureUnit, @FK_dxVendor, @PayDetailDefault, @IncludeInSummary
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPayCode, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayCodeType', @FK_dxPayCodeType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayMeasureUnit', @FK_dxPayMeasureUnit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PayDetailDefault', @PayDetailDefault
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'IncludeInSummary', @IncludeInSummary
FETCH NEXT FROM pk_cursordxPayCode INTO @PK_dxPayCode, @ID, @Description, @FK_dxPayCodeType, @FK_dxPayMeasureUnit, @FK_dxVendor, @PayDetailDefault, @IncludeInSummary
 END

 CLOSE pk_cursordxPayCode 
 DEALLOCATE pk_cursordxPayCode
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayCode.trAuditInsUpd] ON [dbo].[dxPayCode] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPayCode CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayCode from inserted;
 set @tablename = 'dxPayCode' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPayCode
 FETCH NEXT FROM pk_cursordxPayCode INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxPayCode where PK_dxPayCode = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPayCode where PK_dxPayCode = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayCodeType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayCodeType', FK_dxPayCodeType from dxPayCode where PK_dxPayCode = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayMeasureUnit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayMeasureUnit', FK_dxPayMeasureUnit from dxPayCode where PK_dxPayCode = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxPayCode where PK_dxPayCode = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PayDetailDefault )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PayDetailDefault', PayDetailDefault from dxPayCode where PK_dxPayCode = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( IncludeInSummary )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'IncludeInSummary', IncludeInSummary from dxPayCode where PK_dxPayCode = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPayCode INTO @keyvalue
 END

 CLOSE pk_cursordxPayCode 
 DEALLOCATE pk_cursordxPayCode
GO
ALTER TABLE [dbo].[dxPayCode] ADD CONSTRAINT [PK_dxPayCode] PRIMARY KEY CLUSTERED  ([PK_dxPayCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayCode_FK_dxPayCodeType] ON [dbo].[dxPayCode] ([FK_dxPayCodeType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayCode_FK_dxPayMeasureUnit] ON [dbo].[dxPayCode] ([FK_dxPayMeasureUnit]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayCode_FK_dxVendor] ON [dbo].[dxPayCode] ([FK_dxVendor]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPayCode] ADD CONSTRAINT [dxConstraint_FK_dxPayCodeType_dxPayCode] FOREIGN KEY ([FK_dxPayCodeType]) REFERENCES [dbo].[dxPayCodeType] ([PK_dxPayCodeType])
GO
ALTER TABLE [dbo].[dxPayCode] ADD CONSTRAINT [dxConstraint_FK_dxPayMeasureUnit_dxPayCode] FOREIGN KEY ([FK_dxPayMeasureUnit]) REFERENCES [dbo].[dxPayMeasureUnit] ([PK_dxPayMeasureUnit])
GO
ALTER TABLE [dbo].[dxPayCode] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxPayCode] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
