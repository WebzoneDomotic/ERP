CREATE TABLE [dbo].[dxPriceLevel]
(
[PK_dxPriceLevel] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxPriceLevel_FK_dxCurrency] DEFAULT ((1))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPriceLevel.trAuditDelete] ON [dbo].[dxPriceLevel]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPriceLevel'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPriceLevel CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPriceLevel, ID, Description, FK_dxCurrency from deleted
 Declare @PK_dxPriceLevel int, @ID varchar(50), @Description varchar(255), @FK_dxCurrency int

 OPEN pk_cursordxPriceLevel
 FETCH NEXT FROM pk_cursordxPriceLevel INTO @PK_dxPriceLevel, @ID, @Description, @FK_dxCurrency
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPriceLevel, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
FETCH NEXT FROM pk_cursordxPriceLevel INTO @PK_dxPriceLevel, @ID, @Description, @FK_dxCurrency
 END

 CLOSE pk_cursordxPriceLevel 
 DEALLOCATE pk_cursordxPriceLevel
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPriceLevel.trAuditInsUpd] ON [dbo].[dxPriceLevel] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPriceLevel CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPriceLevel from inserted;
 set @tablename = 'dxPriceLevel' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPriceLevel
 FETCH NEXT FROM pk_cursordxPriceLevel INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxPriceLevel where PK_dxPriceLevel = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPriceLevel where PK_dxPriceLevel = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxPriceLevel where PK_dxPriceLevel = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPriceLevel INTO @keyvalue
 END

 CLOSE pk_cursordxPriceLevel 
 DEALLOCATE pk_cursordxPriceLevel
GO
ALTER TABLE [dbo].[dxPriceLevel] ADD CONSTRAINT [PK_dxPriceLevel] PRIMARY KEY CLUSTERED  ([PK_dxPriceLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPriceLevel_FK_dxCurrency] ON [dbo].[dxPriceLevel] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxPriceLevel] ON [dbo].[dxPriceLevel] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPriceLevel] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxPriceLevel] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
