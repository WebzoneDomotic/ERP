CREATE TABLE [dbo].[dxPhase]
(
[PK_dxPhase] [int] NOT NULL IDENTITY(1, 1),
[FK_dxRouting] [int] NOT NULL,
[PhaseNumber] [int] NOT NULL CONSTRAINT [DF_dxPhase_PhaseNumber] DEFAULT ((10)),
[Name] [varchar] (100) COLLATE French_CI_AS NOT NULL,
[Instructions] [varchar] (8000) COLLATE French_CI_AS NULL,
[TransfertTime] [datetime] NOT NULL CONSTRAINT [DF_dxPhase_TransfertTime] DEFAULT ((0.0)),
[MandatoryDeclaration] [bit] NOT NULL CONSTRAINT [DF_dxPhase_Mandatory] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPhase.trAuditDelete] ON [dbo].[dxPhase]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPhase'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPhase CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPhase, FK_dxRouting, PhaseNumber, Name, Instructions, TransfertTime, MandatoryDeclaration from deleted
 Declare @PK_dxPhase int, @FK_dxRouting int, @PhaseNumber int, @Name varchar(100), @Instructions varchar(8000), @TransfertTime DateTime, @MandatoryDeclaration Bit

 OPEN pk_cursordxPhase
 FETCH NEXT FROM pk_cursordxPhase INTO @PK_dxPhase, @FK_dxRouting, @PhaseNumber, @Name, @Instructions, @TransfertTime, @MandatoryDeclaration
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPhase, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRouting', @FK_dxRouting
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PhaseNumber', @PhaseNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', @Instructions
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransfertTime', @TransfertTime
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'MandatoryDeclaration', @MandatoryDeclaration
FETCH NEXT FROM pk_cursordxPhase INTO @PK_dxPhase, @FK_dxRouting, @PhaseNumber, @Name, @Instructions, @TransfertTime, @MandatoryDeclaration
 END

 CLOSE pk_cursordxPhase 
 DEALLOCATE pk_cursordxPhase
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPhase.trAuditInsUpd] ON [dbo].[dxPhase] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPhase CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPhase from inserted;
 set @tablename = 'dxPhase' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPhase
 FETCH NEXT FROM pk_cursordxPhase INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxRouting )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxRouting', FK_dxRouting from dxPhase where PK_dxPhase = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PhaseNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PhaseNumber', PhaseNumber from dxPhase where PK_dxPhase = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxPhase where PK_dxPhase = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Instructions )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Instructions', Instructions from dxPhase where PK_dxPhase = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransfertTime )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransfertTime', TransfertTime from dxPhase where PK_dxPhase = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MandatoryDeclaration )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'MandatoryDeclaration', MandatoryDeclaration from dxPhase where PK_dxPhase = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPhase INTO @keyvalue
 END

 CLOSE pk_cursordxPhase 
 DEALLOCATE pk_cursordxPhase
GO
ALTER TABLE [dbo].[dxPhase] ADD CONSTRAINT [PK_dxPhase] PRIMARY KEY CLUSTERED  ([PK_dxPhase]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPhase_FK_dxRouting] ON [dbo].[dxPhase] ([FK_dxRouting]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPhase] ADD CONSTRAINT [dxConstraint_FK_dxRouting_dxPhase] FOREIGN KEY ([FK_dxRouting]) REFERENCES [dbo].[dxRouting] ([PK_dxRouting])
GO
