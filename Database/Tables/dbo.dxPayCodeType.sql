CREATE TABLE [dbo].[dxPayCodeType]
(
[PK_dxPayCodeType] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[IsGain] [bit] NOT NULL CONSTRAINT [DF_dxPayCodeType_IsGain] DEFAULT ((0)),
[IsDeduction] [bit] NOT NULL CONSTRAINT [DF_dxPayCodeType_IsDeduction] DEFAULT ((0)),
[SummaryOrder] [int] NOT NULL CONSTRAINT [DF_dxPayCodeType_SummaryOrder] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayCodeType.trAuditDelete] ON [dbo].[dxPayCodeType]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPayCodeType'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPayCodeType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayCodeType, ID, Description, IsGain, IsDeduction, SummaryOrder from deleted
 Declare @PK_dxPayCodeType int, @ID varchar(50), @Description varchar(255), @IsGain Bit, @IsDeduction Bit, @SummaryOrder int

 OPEN pk_cursordxPayCodeType
 FETCH NEXT FROM pk_cursordxPayCodeType INTO @PK_dxPayCodeType, @ID, @Description, @IsGain, @IsDeduction, @SummaryOrder
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPayCodeType, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'IsGain', @IsGain
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'IsDeduction', @IsDeduction
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'SummaryOrder', @SummaryOrder
FETCH NEXT FROM pk_cursordxPayCodeType INTO @PK_dxPayCodeType, @ID, @Description, @IsGain, @IsDeduction, @SummaryOrder
 END

 CLOSE pk_cursordxPayCodeType 
 DEALLOCATE pk_cursordxPayCodeType
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayCodeType.trAuditInsUpd] ON [dbo].[dxPayCodeType] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPayCodeType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayCodeType from inserted;
 set @tablename = 'dxPayCodeType' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPayCodeType
 FETCH NEXT FROM pk_cursordxPayCodeType INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxPayCodeType where PK_dxPayCodeType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPayCodeType where PK_dxPayCodeType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( IsGain )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'IsGain', IsGain from dxPayCodeType where PK_dxPayCodeType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( IsDeduction )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'IsDeduction', IsDeduction from dxPayCodeType where PK_dxPayCodeType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SummaryOrder )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'SummaryOrder', SummaryOrder from dxPayCodeType where PK_dxPayCodeType = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPayCodeType INTO @keyvalue
 END

 CLOSE pk_cursordxPayCodeType 
 DEALLOCATE pk_cursordxPayCodeType
GO
ALTER TABLE [dbo].[dxPayCodeType] ADD CONSTRAINT [PK_dxPayCodeType] PRIMARY KEY CLUSTERED  ([PK_dxPayCodeType]) ON [PRIMARY]
GO
