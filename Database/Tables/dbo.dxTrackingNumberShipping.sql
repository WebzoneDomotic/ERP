CREATE TABLE [dbo].[dxTrackingNumberShipping]
(
[PK_dxTrackingNumberShipping] [int] NOT NULL IDENTITY(1, 1),
[FK_dxShipping] [int] NOT NULL,
[TrackingNumber] [varchar] (500) COLLATE French_CI_AS NOT NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTrackingNumberShipping.trAuditDelete] ON [dbo].[dxTrackingNumberShipping]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxTrackingNumberShipping'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxTrackingNumberShipping CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTrackingNumberShipping, FK_dxShipping, TrackingNumber, Note from deleted
 Declare @PK_dxTrackingNumberShipping int, @FK_dxShipping int, @TrackingNumber varchar(500), @Note varchar(2000)

 OPEN pk_cursordxTrackingNumberShipping
 FETCH NEXT FROM pk_cursordxTrackingNumberShipping INTO @PK_dxTrackingNumberShipping, @FK_dxShipping, @TrackingNumber, @Note
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxTrackingNumberShipping, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipping', @FK_dxShipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TrackingNumber', @TrackingNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
FETCH NEXT FROM pk_cursordxTrackingNumberShipping INTO @PK_dxTrackingNumberShipping, @FK_dxShipping, @TrackingNumber, @Note
 END

 CLOSE pk_cursordxTrackingNumberShipping 
 DEALLOCATE pk_cursordxTrackingNumberShipping
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTrackingNumberShipping.trAuditInsUpd] ON [dbo].[dxTrackingNumberShipping] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxTrackingNumberShipping CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTrackingNumberShipping from inserted;
 set @tablename = 'dxTrackingNumberShipping' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxTrackingNumberShipping
 FETCH NEXT FROM pk_cursordxTrackingNumberShipping INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipping', FK_dxShipping from dxTrackingNumberShipping where PK_dxTrackingNumberShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TrackingNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TrackingNumber', TrackingNumber from dxTrackingNumberShipping where PK_dxTrackingNumberShipping = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxTrackingNumberShipping where PK_dxTrackingNumberShipping = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxTrackingNumberShipping INTO @keyvalue
 END

 CLOSE pk_cursordxTrackingNumberShipping 
 DEALLOCATE pk_cursordxTrackingNumberShipping
GO
ALTER TABLE [dbo].[dxTrackingNumberShipping] ADD CONSTRAINT [PK_dxTrackingNumberShipping] PRIMARY KEY CLUSTERED  ([PK_dxTrackingNumberShipping]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTrackingNumberShipping_FK_dxShipping] ON [dbo].[dxTrackingNumberShipping] ([FK_dxShipping]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxTrackingNumberShipping] ADD CONSTRAINT [dxConstraint_FK_dxShipping_dxTrackingNumberShipping] FOREIGN KEY ([FK_dxShipping]) REFERENCES [dbo].[dxShipping] ([PK_dxShipping])
GO
