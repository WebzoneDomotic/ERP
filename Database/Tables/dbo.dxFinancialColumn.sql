CREATE TABLE [dbo].[dxFinancialColumn]
(
[PK_dxFinancialColumn] [int] NOT NULL IDENTITY(1, 1),
[FK_dxFinancialStatement] [int] NOT NULL,
[ID] [varchar] (50) COLLATE French_CI_AS NULL,
[DeltaPeriod] [int] NOT NULL CONSTRAINT [DF_dxFinancialColumn_DeltaPeriod] DEFAULT ((0)),
[Title1] [varchar] (255) COLLATE French_CI_AS NULL,
[Title2] [varchar] (255) COLLATE French_CI_AS NULL,
[Title3] [varchar] (255) COLLATE French_CI_AS NULL,
[Formula] [varchar] (1000) COLLATE French_CI_AS NULL,
[FK_dxFinancialColumnType] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialColumn.trAuditDelete] ON [dbo].[dxFinancialColumn]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxFinancialColumn'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxFinancialColumn CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialColumn, FK_dxFinancialStatement, ID, DeltaPeriod, Title1, Title2, Title3, Formula, FK_dxFinancialColumnType from deleted
 Declare @PK_dxFinancialColumn int, @FK_dxFinancialStatement int, @ID varchar(50), @DeltaPeriod int, @Title1 varchar(255), @Title2 varchar(255), @Title3 varchar(255), @Formula varchar(1000), @FK_dxFinancialColumnType int

 OPEN pk_cursordxFinancialColumn
 FETCH NEXT FROM pk_cursordxFinancialColumn INTO @PK_dxFinancialColumn, @FK_dxFinancialStatement, @ID, @DeltaPeriod, @Title1, @Title2, @Title3, @Formula, @FK_dxFinancialColumnType
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxFinancialColumn, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialStatement', @FK_dxFinancialStatement
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DeltaPeriod', @DeltaPeriod
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Title1', @Title1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Title2', @Title2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Title3', @Title3
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Formula', @Formula
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialColumnType', @FK_dxFinancialColumnType
FETCH NEXT FROM pk_cursordxFinancialColumn INTO @PK_dxFinancialColumn, @FK_dxFinancialStatement, @ID, @DeltaPeriod, @Title1, @Title2, @Title3, @Formula, @FK_dxFinancialColumnType
 END

 CLOSE pk_cursordxFinancialColumn 
 DEALLOCATE pk_cursordxFinancialColumn
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxFinancialColumn.trAuditInsUpd] ON [dbo].[dxFinancialColumn] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxFinancialColumn CURSOR LOCAL FAST_FORWARD for SELECT PK_dxFinancialColumn from inserted;
 set @tablename = 'dxFinancialColumn' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxFinancialColumn
 FETCH NEXT FROM pk_cursordxFinancialColumn INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFinancialStatement )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialStatement', FK_dxFinancialStatement from dxFinancialColumn where PK_dxFinancialColumn = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxFinancialColumn where PK_dxFinancialColumn = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DeltaPeriod )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DeltaPeriod', DeltaPeriod from dxFinancialColumn where PK_dxFinancialColumn = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Title1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Title1', Title1 from dxFinancialColumn where PK_dxFinancialColumn = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Title2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Title2', Title2 from dxFinancialColumn where PK_dxFinancialColumn = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Title3 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Title3', Title3 from dxFinancialColumn where PK_dxFinancialColumn = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Formula )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Formula', Formula from dxFinancialColumn where PK_dxFinancialColumn = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFinancialColumnType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFinancialColumnType', FK_dxFinancialColumnType from dxFinancialColumn where PK_dxFinancialColumn = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxFinancialColumn INTO @keyvalue
 END

 CLOSE pk_cursordxFinancialColumn 
 DEALLOCATE pk_cursordxFinancialColumn
GO
ALTER TABLE [dbo].[dxFinancialColumn] ADD CONSTRAINT [PK_dxFinancialColumn] PRIMARY KEY CLUSTERED  ([PK_dxFinancialColumn]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFinancialColumn_FK_dxFinancialColumnType] ON [dbo].[dxFinancialColumn] ([FK_dxFinancialColumnType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxFinancialColumn_FK_dxFinancialStatement] ON [dbo].[dxFinancialColumn] ([FK_dxFinancialStatement]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxFinancialColumn] ADD CONSTRAINT [dxConstraint_FK_dxFinancialColumnType_dxFinancialColumn] FOREIGN KEY ([FK_dxFinancialColumnType]) REFERENCES [dbo].[dxFinancialColumnType] ([PK_dxFinancialColumnType])
GO
ALTER TABLE [dbo].[dxFinancialColumn] ADD CONSTRAINT [dxConstraint_FK_dxFinancialStatement_dxFinancialColumn] FOREIGN KEY ([FK_dxFinancialStatement]) REFERENCES [dbo].[dxFinancialStatement] ([PK_dxFinancialStatement])
GO
