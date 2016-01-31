CREATE TABLE [dbo].[dxSpreadsheetCell]
(
[PK_dxSpreadsheetCell] [int] NOT NULL IDENTITY(1, 1),
[FK_dxSpreadsheet] [int] NOT NULL,
[Formula] [varchar] (1000) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxSpreadsheetCell_Formula] DEFAULT (''),
[AsInteger] [int] NOT NULL CONSTRAINT [DF_dxSpreadsheetCell_AsInteger] DEFAULT ((0)),
[AsFloat] [float] NOT NULL CONSTRAINT [DF_dxSpreadsheetCell_AsFloat] DEFAULT ((0.0)),
[AsString] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxSpreadsheetCell_AsString] DEFAULT (''),
[ACol] [int] NOT NULL CONSTRAINT [DF_dxSpreadsheetCell_ACol] DEFAULT ((0)),
[ARow] [int] NOT NULL CONSTRAINT [DF_dxSpreadsheetCell_ARow] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxSpreadsheetCell.trAuditDelete] ON [dbo].[dxSpreadsheetCell]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxSpreadsheetCell'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxSpreadsheetCell CURSOR LOCAL FAST_FORWARD for SELECT PK_dxSpreadsheetCell, FK_dxSpreadsheet, Formula, AsInteger, AsFloat, AsString, ACol, ARow from deleted
 Declare @PK_dxSpreadsheetCell int, @FK_dxSpreadsheet int, @Formula varchar(1000), @AsInteger int, @AsFloat Float, @AsString varchar(500), @ACol int, @ARow int

 OPEN pk_cursordxSpreadsheetCell
 FETCH NEXT FROM pk_cursordxSpreadsheetCell INTO @PK_dxSpreadsheetCell, @FK_dxSpreadsheet, @Formula, @AsInteger, @AsFloat, @AsString, @ACol, @ARow
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxSpreadsheetCell, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxSpreadsheet', @FK_dxSpreadsheet
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Formula', @Formula
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'AsInteger', @AsInteger
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AsFloat', @AsFloat
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'AsString', @AsString
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ACol', @ACol
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ARow', @ARow
FETCH NEXT FROM pk_cursordxSpreadsheetCell INTO @PK_dxSpreadsheetCell, @FK_dxSpreadsheet, @Formula, @AsInteger, @AsFloat, @AsString, @ACol, @ARow
 END

 CLOSE pk_cursordxSpreadsheetCell 
 DEALLOCATE pk_cursordxSpreadsheetCell
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxSpreadsheetCell.trAuditInsUpd] ON [dbo].[dxSpreadsheetCell] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxSpreadsheetCell CURSOR LOCAL FAST_FORWARD for SELECT PK_dxSpreadsheetCell from inserted;
 set @tablename = 'dxSpreadsheetCell' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxSpreadsheetCell
 FETCH NEXT FROM pk_cursordxSpreadsheetCell INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxSpreadsheet )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxSpreadsheet', FK_dxSpreadsheet from dxSpreadsheetCell where PK_dxSpreadsheetCell = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Formula )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Formula', Formula from dxSpreadsheetCell where PK_dxSpreadsheetCell = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AsInteger )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'AsInteger', AsInteger from dxSpreadsheetCell where PK_dxSpreadsheetCell = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AsFloat )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AsFloat', AsFloat from dxSpreadsheetCell where PK_dxSpreadsheetCell = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AsString )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'AsString', AsString from dxSpreadsheetCell where PK_dxSpreadsheetCell = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ACol )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ACol', ACol from dxSpreadsheetCell where PK_dxSpreadsheetCell = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ARow )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ARow', ARow from dxSpreadsheetCell where PK_dxSpreadsheetCell = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxSpreadsheetCell INTO @keyvalue
 END

 CLOSE pk_cursordxSpreadsheetCell 
 DEALLOCATE pk_cursordxSpreadsheetCell
GO
ALTER TABLE [dbo].[dxSpreadsheetCell] ADD CONSTRAINT [PK_dxSpreadsheetCell] PRIMARY KEY CLUSTERED  ([PK_dxSpreadsheetCell]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSpreadsheetCell_FK_dxSpreadsheet] ON [dbo].[dxSpreadsheetCell] ([FK_dxSpreadsheet]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxSpreadsheetCell] ADD CONSTRAINT [dxConstraint_FK_dxSpreadsheet_dxSpreadsheetCell] FOREIGN KEY ([FK_dxSpreadsheet]) REFERENCES [dbo].[dxSpreadSheet] ([PK_dxSpreadsheet])
GO
