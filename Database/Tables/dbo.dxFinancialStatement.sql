CREATE TABLE [dbo].[dxFinancialStatement]
(
[PK_dxFinancialStatement] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxReport] [int] NULL,
[SpreadSheet] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialStatement.trAuditDelete] ON [dbo].[dxFinancialStatement]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxFinancialStatement'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxFinancialStatement CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialStatement, ID, Description, FK_dxReport from deleted
 Declare @PK_dxFinancialStatement int, @ID varchar(50), @Description varchar(1000), @FK_dxReport int

 OPEN pk_cursordxFinancialStatement
 FETCH NEXT FROM pk_cursordxFinancialStatement INTO @PK_dxFinancialStatement, @ID, @Description, @FK_dxReport
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxFinancialStatement, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', @FK_dxReport
FETCH NEXT FROM pk_cursordxFinancialStatement INTO @PK_dxFinancialStatement, @ID, @Description, @FK_dxReport
 END

 CLOSE pk_cursordxFinancialStatement 
 DEALLOCATE pk_cursordxFinancialStatement
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialStatement.trAuditInsUpd] ON [dbo].[dxFinancialStatement] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxFinancialStatement CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialStatement from inserted;
 set @tablename = 'dxFinancialStatement' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxFinancialStatement
 FETCH NEXT FROM pk_cursordxFinancialStatement INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxFinancialStatement where PK_dxFinancialStatement = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxFinancialStatement where PK_dxFinancialStatement = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport', FK_dxReport from dxFinancialStatement where PK_dxFinancialStatement = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxFinancialStatement INTO @keyvalue
 END

 CLOSE pk_cursordxFinancialStatement 
 DEALLOCATE pk_cursordxFinancialStatement
GO
ALTER TABLE [dbo].[dxFinancialStatement] ADD CONSTRAINT [PK_dxFinancialStatement] PRIMARY KEY CLUSTERED  ([PK_dxFinancialStatement]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFinancialStatement_FK_dxReport] ON [dbo].[dxFinancialStatement] ([FK_dxReport]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxFinancialStatement] ADD CONSTRAINT [dxConstraint_FK_dxReport_dxFinancialStatement] FOREIGN KEY ([FK_dxReport]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
