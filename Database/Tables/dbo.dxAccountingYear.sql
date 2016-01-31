CREATE TABLE [dbo].[dxAccountingYear]
(
[PK_dxAccountingYear] [int] NOT NULL,
[ID] [int] NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[EndingPeriod] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountingYear.trAuditDelete] ON [dbo].[dxAccountingYear]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAccountingYear'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAccountingYear CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccountingYear, ID, Description, EndingPeriod from deleted
 Declare @PK_dxAccountingYear int, @ID int, @Description varchar(255), @EndingPeriod int

 OPEN pk_cursordxAccountingYear
 FETCH NEXT FROM pk_cursordxAccountingYear INTO @PK_dxAccountingYear, @ID, @Description, @EndingPeriod
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAccountingYear, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'EndingPeriod', @EndingPeriod
FETCH NEXT FROM pk_cursordxAccountingYear INTO @PK_dxAccountingYear, @ID, @Description, @EndingPeriod
 END

 CLOSE pk_cursordxAccountingYear 
 DEALLOCATE pk_cursordxAccountingYear
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccountingYear.trAuditInsUpd] ON [dbo].[dxAccountingYear] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAccountingYear CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccountingYear from inserted;
 set @tablename = 'dxAccountingYear' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAccountingYear
 FETCH NEXT FROM pk_cursordxAccountingYear INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ID', ID from dxAccountingYear where PK_dxAccountingYear = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxAccountingYear where PK_dxAccountingYear = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EndingPeriod )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'EndingPeriod', EndingPeriod from dxAccountingYear where PK_dxAccountingYear = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAccountingYear INTO @keyvalue
 END

 CLOSE pk_cursordxAccountingYear 
 DEALLOCATE pk_cursordxAccountingYear
GO
ALTER TABLE [dbo].[dxAccountingYear] ADD CONSTRAINT [PK_dxAccountingYear] PRIMARY KEY CLUSTERED  ([PK_dxAccountingYear]) ON [PRIMARY]
GO
