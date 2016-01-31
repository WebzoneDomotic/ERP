CREATE TABLE [dbo].[dxSetupOption]
(
[PK_dxSetupOption] [int] NOT NULL IDENTITY(1, 1),
[FK_dxSetup] [int] NOT NULL,
[OptionGroup] [int] NOT NULL CONSTRAINT [DF_dxSetupOption_OptionGroup] DEFAULT ((1)),
[OptionDescription] [varchar] (1000) COLLATE French_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_dxSetupOption_Enabled] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxSetupOption.trAuditDelete] ON [dbo].[dxSetupOption]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxSetupOption'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxSetupOption CURSOR LOCAL FAST_FORWARD for SELECT PK_dxSetupOption, FK_dxSetup, OptionGroup, OptionDescription, Enabled from deleted
 Declare @PK_dxSetupOption int, @FK_dxSetup int, @OptionGroup int, @OptionDescription varchar(1000), @Enabled Bit

 OPEN pk_cursordxSetupOption
 FETCH NEXT FROM pk_cursordxSetupOption INTO @PK_dxSetupOption, @FK_dxSetup, @OptionGroup, @OptionDescription, @Enabled
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxSetupOption, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxSetup', @FK_dxSetup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'OptionGroup', @OptionGroup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'OptionDescription', @OptionDescription
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Enabled', @Enabled
FETCH NEXT FROM pk_cursordxSetupOption INTO @PK_dxSetupOption, @FK_dxSetup, @OptionGroup, @OptionDescription, @Enabled
 END

 CLOSE pk_cursordxSetupOption 
 DEALLOCATE pk_cursordxSetupOption
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxSetupOption.trAuditInsUpd] ON [dbo].[dxSetupOption] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxSetupOption CURSOR LOCAL FAST_FORWARD for SELECT PK_dxSetupOption from inserted;
 set @tablename = 'dxSetupOption' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxSetupOption
 FETCH NEXT FROM pk_cursordxSetupOption INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxSetup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxSetup', FK_dxSetup from dxSetupOption where PK_dxSetupOption = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OptionGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'OptionGroup', OptionGroup from dxSetupOption where PK_dxSetupOption = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OptionDescription )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'OptionDescription', OptionDescription from dxSetupOption where PK_dxSetupOption = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Enabled )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Enabled', Enabled from dxSetupOption where PK_dxSetupOption = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxSetupOption INTO @keyvalue
 END

 CLOSE pk_cursordxSetupOption 
 DEALLOCATE pk_cursordxSetupOption
GO
ALTER TABLE [dbo].[dxSetupOption] ADD CONSTRAINT [PK_dxSetupOption] PRIMARY KEY CLUSTERED  ([PK_dxSetupOption]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSetupOption_FK_dxSetup] ON [dbo].[dxSetupOption] ([FK_dxSetup]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxSetupOption] ADD CONSTRAINT [dxConstraint_FK_dxSetup_dxSetupOption] FOREIGN KEY ([FK_dxSetup]) REFERENCES [dbo].[dxSetup] ([PK_dxSetup])
GO
