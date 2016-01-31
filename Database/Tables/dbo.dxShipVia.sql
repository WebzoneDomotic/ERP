CREATE TABLE [dbo].[dxShipVia]
(
[PK_dxShipVia] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[TrackingNumberHTMLLink] [varchar] (500) COLLATE French_CI_AS NULL,
[PickUp] [bit] NOT NULL CONSTRAINT [DF_dxShipVia_PickUp] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShipVia.trAuditDelete] ON [dbo].[dxShipVia]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxShipVia'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxShipVia CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShipVia, ID, ShipVia, TrackingNumberHTMLLink, PickUp from deleted
 Declare @PK_dxShipVia int, @ID varchar(50), @ShipVia varchar(500), @TrackingNumberHTMLLink varchar(500), @PickUp Bit

 OPEN pk_cursordxShipVia
 FETCH NEXT FROM pk_cursordxShipVia INTO @PK_dxShipVia, @ID, @ShipVia, @TrackingNumberHTMLLink, @PickUp
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxShipVia, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', @ShipVia
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TrackingNumberHTMLLink', @TrackingNumberHTMLLink
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PickUp', @PickUp
FETCH NEXT FROM pk_cursordxShipVia INTO @PK_dxShipVia, @ID, @ShipVia, @TrackingNumberHTMLLink, @PickUp
 END

 CLOSE pk_cursordxShipVia 
 DEALLOCATE pk_cursordxShipVia
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShipVia.trAuditInsUpd] ON [dbo].[dxShipVia] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxShipVia CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShipVia from inserted;
 set @tablename = 'dxShipVia' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxShipVia
 FETCH NEXT FROM pk_cursordxShipVia INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxShipVia where PK_dxShipVia = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxShipVia where PK_dxShipVia = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TrackingNumberHTMLLink )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TrackingNumberHTMLLink', TrackingNumberHTMLLink from dxShipVia where PK_dxShipVia = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PickUp )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PickUp', PickUp from dxShipVia where PK_dxShipVia = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxShipVia INTO @keyvalue
 END

 CLOSE pk_cursordxShipVia 
 DEALLOCATE pk_cursordxShipVia
GO
ALTER TABLE [dbo].[dxShipVia] ADD CONSTRAINT [PK_dxShipVia] PRIMARY KEY CLUSTERED  ([PK_dxShipVia]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxShipVia] ON [dbo].[dxShipVia] ([ID]) ON [PRIMARY]
GO
