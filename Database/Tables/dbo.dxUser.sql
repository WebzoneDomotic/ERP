CREATE TABLE [dbo].[dxUser]
(
[PK_dxUser] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Password] [varchar] (200) COLLATE French_CI_AS NOT NULL,
[FirstName] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[LastName] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[FK_dxLanguage] [int] NOT NULL CONSTRAINT [DF_dxUser_FK_dxLanguage] DEFAULT ((1)),
[HireDate] [datetime] NOT NULL CONSTRAINT [DF_dxUser_HireDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[Active] [bit] NOT NULL CONSTRAINT [DF_dxUser_Active] DEFAULT ((1)),
[Address] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxEmployee] [int] NULL,
[ApplySecurityToTheLessRestrictiveGroup] [bit] NOT NULL CONSTRAINT [DF_dxUser_ApplySecurityToTheMostRestrictiveGroup] DEFAULT ((1)),
[DeskTopDirectory] [varchar] (500) COLLATE French_CI_AS NULL,
[ComputerName] [varchar] (500) COLLATE French_CI_AS NULL,
[SPID] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxUser.trAuditDelete] ON [dbo].[dxUser]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxUser'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxUser CURSOR LOCAL FAST_FORWARD for SELECT PK_dxUser, ID, Password, FirstName, LastName, FK_dxLanguage, HireDate, Active, Address, FK_dxEmployee, ApplySecurityToTheLessRestrictiveGroup, DeskTopDirectory, ComputerName, SPID from deleted
 Declare @PK_dxUser int, @ID varchar(50), @Password varchar(200), @FirstName varchar(50), @LastName varchar(50), @FK_dxLanguage int, @HireDate DateTime, @Active Bit, @Address varchar(500), @FK_dxEmployee int, @ApplySecurityToTheLessRestrictiveGroup Bit, @DeskTopDirectory varchar(500), @ComputerName varchar(500), @SPID int

 OPEN pk_cursordxUser
 FETCH NEXT FROM pk_cursordxUser INTO @PK_dxUser, @ID, @Password, @FirstName, @LastName, @FK_dxLanguage, @HireDate, @Active, @Address, @FK_dxEmployee, @ApplySecurityToTheLessRestrictiveGroup, @DeskTopDirectory, @ComputerName, @SPID
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxUser, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Password', @Password
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FirstName', @FirstName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LastName', @LastName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLanguage', @FK_dxLanguage
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'HireDate', @HireDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address', @Address
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', @FK_dxEmployee
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplySecurityToTheLessRestrictiveGroup', @ApplySecurityToTheLessRestrictiveGroup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DeskTopDirectory', @DeskTopDirectory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ComputerName', @ComputerName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'SPID', @SPID
FETCH NEXT FROM pk_cursordxUser INTO @PK_dxUser, @ID, @Password, @FirstName, @LastName, @FK_dxLanguage, @HireDate, @Active, @Address, @FK_dxEmployee, @ApplySecurityToTheLessRestrictiveGroup, @DeskTopDirectory, @ComputerName, @SPID
 END

 CLOSE pk_cursordxUser 
 DEALLOCATE pk_cursordxUser
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxUser.trAuditInsUpd] ON [dbo].[dxUser] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxUser CURSOR LOCAL FAST_FORWARD for SELECT PK_dxUser from inserted;
 set @tablename = 'dxUser' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxUser
 FETCH NEXT FROM pk_cursordxUser INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Password )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Password', Password from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FirstName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FirstName', FirstName from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LastName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LastName', LastName from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLanguage )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLanguage', FK_dxLanguage from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HireDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'HireDate', HireDate from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Address )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address', Address from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', FK_dxEmployee from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ApplySecurityToTheLessRestrictiveGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ApplySecurityToTheLessRestrictiveGroup', ApplySecurityToTheLessRestrictiveGroup from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DeskTopDirectory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'DeskTopDirectory', DeskTopDirectory from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ComputerName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ComputerName', ComputerName from dxUser where PK_dxUser = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SPID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'SPID', SPID from dxUser where PK_dxUser = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxUser INTO @keyvalue
 END

 CLOSE pk_cursordxUser 
 DEALLOCATE pk_cursordxUser
GO
ALTER TABLE [dbo].[dxUser] ADD CONSTRAINT [PK_dxUser] PRIMARY KEY CLUSTERED  ([PK_dxUser]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxUser_FK_dxEmployee] ON [dbo].[dxUser] ([FK_dxEmployee]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxUser_FK_dxLanguage] ON [dbo].[dxUser] ([FK_dxLanguage]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxUser] ON [dbo].[dxUser] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxUser] ADD CONSTRAINT [dxConstraint_FK_dxEmployee_dxUser] FOREIGN KEY ([FK_dxEmployee]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxUser] ADD CONSTRAINT [dxConstraint_FK_dxLanguage_dxUser] FOREIGN KEY ([FK_dxLanguage]) REFERENCES [dbo].[dxLanguage] ([PK_dxLanguage])
GO
