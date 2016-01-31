CREATE TABLE [dbo].[dxShellExecute]
(
[PK_dxShellExecute] [int] NOT NULL IDENTITY(1, 1),
[FK_dxReport] [int] NOT NULL,
[Rank] [float] NOT NULL CONSTRAINT [DF_dxShellExecute_Rank] DEFAULT ((0.0)),
[Operation] [varchar] (50) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_Operation] DEFAULT (''),
[FileName] [varchar] (1000) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_FileName] DEFAULT (''),
[Parameters] [varchar] (8000) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_Parameters] DEFAULT (''),
[Directory] [varchar] (8000) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_Directory] DEFAULT (''),
[ShowCommand] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxDeclarationDismantling_ShowCommand] DEFAULT ('SW_SHOW')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShellExecute.trAuditDelete] ON [dbo].[dxShellExecute]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxShellExecute'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxShellExecute CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShellExecute, FK_dxReport, Rank, Operation, FileName, Parameters, Directory, ShowCommand from deleted
 Declare @PK_dxShellExecute int, @FK_dxReport int, @Rank Float, @Operation varchar(50), @FileName varchar(1000), @Parameters varchar(8000), @Directory varchar(8000), @ShowCommand varchar(500)

 OPEN pk_cursordxShellExecute
 FETCH NEXT FROM pk_cursordxShellExecute INTO @PK_dxShellExecute, @FK_dxReport, @Rank, @Operation, @FileName, @Parameters, @Directory, @ShowCommand
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxShellExecute, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', @FK_dxReport
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', @Rank
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Operation', @Operation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FileName', @FileName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Parameters', @Parameters
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Directory', @Directory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShowCommand', @ShowCommand
FETCH NEXT FROM pk_cursordxShellExecute INTO @PK_dxShellExecute, @FK_dxReport, @Rank, @Operation, @FileName, @Parameters, @Directory, @ShowCommand
 END

 CLOSE pk_cursordxShellExecute 
 DEALLOCATE pk_cursordxShellExecute
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxShellExecute.trAuditInsUpd] ON [dbo].[dxShellExecute] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxShellExecute CURSOR LOCAL FAST_FORWARD for SELECT PK_dxShellExecute from inserted;
 set @tablename = 'dxShellExecute' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxShellExecute
 FETCH NEXT FROM pk_cursordxShellExecute INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', FK_dxReport from dxShellExecute where PK_dxShellExecute = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Rank )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Rank', Rank from dxShellExecute where PK_dxShellExecute = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Operation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Operation', Operation from dxShellExecute where PK_dxShellExecute = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FileName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FileName', FileName from dxShellExecute where PK_dxShellExecute = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Parameters )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Parameters', Parameters from dxShellExecute where PK_dxShellExecute = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Directory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Directory', Directory from dxShellExecute where PK_dxShellExecute = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShowCommand )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShowCommand', ShowCommand from dxShellExecute where PK_dxShellExecute = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxShellExecute INTO @keyvalue
 END

 CLOSE pk_cursordxShellExecute 
 DEALLOCATE pk_cursordxShellExecute
GO
ALTER TABLE [dbo].[dxShellExecute] ADD CONSTRAINT [PK_dxShellExecute] PRIMARY KEY CLUSTERED  ([PK_dxShellExecute]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxShellExecute_FK_dxReport] ON [dbo].[dxShellExecute] ([FK_dxReport]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxShellExecute] ADD CONSTRAINT [dxConstraint_FK_dxReport_dxShellExecute] FOREIGN KEY ([FK_dxReport]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
