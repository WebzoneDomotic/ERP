CREATE TABLE [dbo].[dxShippingServiceType]
(
[PK_dxShippingServiceType] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE French_CI_AS NULL,
[ShippingDelayInHours] [int] NOT NULL CONSTRAINT [DF_dxShippingServiceType_ShippingDelayInHours] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShippingServiceType.trAuditDelete] ON [dbo].[dxShippingServiceType]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxShippingServiceType'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxShippingServiceType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShippingServiceType, ID, Description, ShippingDelayInHours from deleted
 Declare @PK_dxShippingServiceType int, @ID varchar(50), @Description varchar(250), @ShippingDelayInHours int

 OPEN pk_cursordxShippingServiceType
 FETCH NEXT FROM pk_cursordxShippingServiceType INTO @PK_dxShippingServiceType, @ID, @Description, @ShippingDelayInHours
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxShippingServiceType, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ShippingDelayInHours', @ShippingDelayInHours
FETCH NEXT FROM pk_cursordxShippingServiceType INTO @PK_dxShippingServiceType, @ID, @Description, @ShippingDelayInHours
 END

 CLOSE pk_cursordxShippingServiceType 
 DEALLOCATE pk_cursordxShippingServiceType
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShippingServiceType.trAuditInsUpd] ON [dbo].[dxShippingServiceType] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxShippingServiceType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShippingServiceType from inserted;
 set @tablename = 'dxShippingServiceType' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxShippingServiceType
 FETCH NEXT FROM pk_cursordxShippingServiceType INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxShippingServiceType where PK_dxShippingServiceType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxShippingServiceType where PK_dxShippingServiceType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShippingDelayInHours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ShippingDelayInHours', ShippingDelayInHours from dxShippingServiceType where PK_dxShippingServiceType = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxShippingServiceType INTO @keyvalue
 END

 CLOSE pk_cursordxShippingServiceType 
 DEALLOCATE pk_cursordxShippingServiceType
GO
ALTER TABLE [dbo].[dxShippingServiceType] ADD CONSTRAINT [PK_dxShippingServiceType] PRIMARY KEY CLUSTERED  ([PK_dxShippingServiceType]) ON [PRIMARY]
GO
