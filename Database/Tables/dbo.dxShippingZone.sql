CREATE TABLE [dbo].[dxShippingZone]
(
[PK_dxShippingZone] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE French_CI_AS NULL,
[Geographical] [bit] NOT NULL CONSTRAINT [DF_dxShippingZone_Geographical] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShippingZone.trAuditDelete] ON [dbo].[dxShippingZone]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxShippingZone'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxShippingZone CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShippingZone, ID, Description, Geographical from deleted
 Declare @PK_dxShippingZone int, @ID varchar(50), @Description varchar(250), @Geographical Bit

 OPEN pk_cursordxShippingZone
 FETCH NEXT FROM pk_cursordxShippingZone INTO @PK_dxShippingZone, @ID, @Description, @Geographical
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxShippingZone, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Geographical', @Geographical
FETCH NEXT FROM pk_cursordxShippingZone INTO @PK_dxShippingZone, @ID, @Description, @Geographical
 END

 CLOSE pk_cursordxShippingZone 
 DEALLOCATE pk_cursordxShippingZone
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShippingZone.trAuditInsUpd] ON [dbo].[dxShippingZone] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxShippingZone CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShippingZone from inserted;
 set @tablename = 'dxShippingZone' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxShippingZone
 FETCH NEXT FROM pk_cursordxShippingZone INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxShippingZone where PK_dxShippingZone = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxShippingZone where PK_dxShippingZone = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Geographical )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Geographical', Geographical from dxShippingZone where PK_dxShippingZone = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxShippingZone INTO @keyvalue
 END

 CLOSE pk_cursordxShippingZone 
 DEALLOCATE pk_cursordxShippingZone
GO
ALTER TABLE [dbo].[dxShippingZone] ADD CONSTRAINT [PK_dxShippingZone] PRIMARY KEY CLUSTERED  ([PK_dxShippingZone]) ON [PRIMARY]
GO
