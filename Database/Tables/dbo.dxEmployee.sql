CREATE TABLE [dbo].[dxEmployee]
(
[PK_dxEmployee] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[FirstName] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[LastName] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Photo] [image] NULL,
[HireDate] [char] (10) COLLATE French_CI_AS NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxEmployee_Active] DEFAULT ((1)),
[Birthday] [datetime] NOT NULL,
[Sex] [int] NOT NULL CONSTRAINT [DF_dxEmployee_Sex] DEFAULT ((0)),
[FK_dxPropertyGroup] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxEmployee.trAuditDelete] ON [dbo].[dxEmployee]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxEmployee'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxEmployee CURSOR LOCAL FAST_FORWARD for SELECT PK_dxEmployee, ID, FirstName, LastName, HireDate, Active, Birthday, Sex, FK_dxPropertyGroup from deleted
 Declare @PK_dxEmployee int, @ID varchar(50), @FirstName varchar(50), @LastName varchar(50), @HireDate varchar(10), @Active Bit, @Birthday DateTime, @Sex int, @FK_dxPropertyGroup int

 OPEN pk_cursordxEmployee
 FETCH NEXT FROM pk_cursordxEmployee INTO @PK_dxEmployee, @ID, @FirstName, @LastName, @HireDate, @Active, @Birthday, @Sex, @FK_dxPropertyGroup
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxEmployee, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FirstName', @FirstName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LastName', @LastName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'HireDate', @HireDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'Birthday', @Birthday
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'Sex', @Sex
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', @FK_dxPropertyGroup
FETCH NEXT FROM pk_cursordxEmployee INTO @PK_dxEmployee, @ID, @FirstName, @LastName, @HireDate, @Active, @Birthday, @Sex, @FK_dxPropertyGroup
 END

 CLOSE pk_cursordxEmployee 
 DEALLOCATE pk_cursordxEmployee
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxEmployee.trAuditInsUpd] ON [dbo].[dxEmployee] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxEmployee CURSOR LOCAL FAST_FORWARD for SELECT PK_dxEmployee from inserted;
 set @tablename = 'dxEmployee' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxEmployee
 FETCH NEXT FROM pk_cursordxEmployee INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxEmployee where PK_dxEmployee = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FirstName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FirstName', FirstName from dxEmployee where PK_dxEmployee = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LastName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LastName', LastName from dxEmployee where PK_dxEmployee = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HireDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'HireDate', HireDate from dxEmployee where PK_dxEmployee = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxEmployee where PK_dxEmployee = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Birthday )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'Birthday', Birthday from dxEmployee where PK_dxEmployee = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Sex )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'Sex', Sex from dxEmployee where PK_dxEmployee = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPropertyGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', FK_dxPropertyGroup from dxEmployee where PK_dxEmployee = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxEmployee INTO @keyvalue
 END

 CLOSE pk_cursordxEmployee 
 DEALLOCATE pk_cursordxEmployee
GO
ALTER TABLE [dbo].[dxEmployee] ADD CONSTRAINT [PK_dxEmployee] PRIMARY KEY CLUSTERED  ([PK_dxEmployee]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxEmployee_FK_dxPropertyGroup] ON [dbo].[dxEmployee] ([FK_dxPropertyGroup]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxEmployee] ADD CONSTRAINT [dxConstraint_FK_dxPropertyGroup_dxEmployee] FOREIGN KEY ([FK_dxPropertyGroup]) REFERENCES [dbo].[dxPropertyGroup] ([PK_dxPropertyGroup])
GO
