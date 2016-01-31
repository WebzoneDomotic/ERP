CREATE TABLE [dbo].[dxReception]
(
[PK_dxReception] [int] NOT NULL IDENTITY(40000, 1),
[ID] AS ([PK_dxReception]),
[FK_dxVendor] [int] NOT NULL,
[TransactionDate] [datetime] NOT NULL CONSTRAINT [DF_dxReception_TransactionDate] DEFAULT (getdate()),
[VendorPackingSlipNo] [varchar] (50) COLLATE French_CI_AS NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxReception_Posted] DEFAULT ((0)),
[ListOfPO] [varchar] (500) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxReception_ListOfPO] DEFAULT ('')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReception.trAuditDelete] ON [dbo].[dxReception]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxReception'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxReception CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReception, ID, FK_dxVendor, TransactionDate, VendorPackingSlipNo, Description, FK_dxNote, Note, Posted, ListOfPO from deleted
 Declare @PK_dxReception int, @ID int, @FK_dxVendor int, @TransactionDate DateTime, @VendorPackingSlipNo varchar(50), @Description varchar(500), @FK_dxNote int, @Note varchar(2000), @Posted Bit, @ListOfPO varchar(500)

 OPEN pk_cursordxReception
 FETCH NEXT FROM pk_cursordxReception INTO @PK_dxReception, @ID, @FK_dxVendor, @TransactionDate, @VendorPackingSlipNo, @Description, @FK_dxNote, @Note, @Posted, @ListOfPO
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxReception, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorPackingSlipNo', @VendorPackingSlipNo
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', @FK_dxNote
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfPO', @ListOfPO
FETCH NEXT FROM pk_cursordxReception INTO @PK_dxReception, @ID, @FK_dxVendor, @TransactionDate, @VendorPackingSlipNo, @Description, @FK_dxNote, @Note, @Posted, @ListOfPO
 END

 CLOSE pk_cursordxReception 
 DEALLOCATE pk_cursordxReception
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReception.trAuditInsUpd] ON [dbo].[dxReception] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxReception CURSOR LOCAL FAST_FORWARD for SELECT PK_dxReception from inserted;
 set @tablename = 'dxReception' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxReception
 FETCH NEXT FROM pk_cursordxReception INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxReception where PK_dxReception = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxReception where PK_dxReception = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( VendorPackingSlipNo )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorPackingSlipNo', VendorPackingSlipNo from dxReception where PK_dxReception = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxReception where PK_dxReception = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxReception where PK_dxReception = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxReception where PK_dxReception = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxReception where PK_dxReception = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ListOfPO )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ListOfPO', ListOfPO from dxReception where PK_dxReception = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxReception INTO @keyvalue
 END

 CLOSE pk_cursordxReception 
 DEALLOCATE pk_cursordxReception
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxReception.trDelete] ON [dbo].[dxReception]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  delete from dxReceptionDetail where FK_dxReception in (SELECT PK_dxReception FROM deleted) ;
  delete from dxReception       where PK_dxReception in (SELECT PK_dxReception FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
ALTER TABLE [dbo].[dxReception] ADD CONSTRAINT [PK_dxReception] PRIMARY KEY CLUSTERED  ([PK_dxReception]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReception_FK_dxNote] ON [dbo].[dxReception] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxReception_FK_dxVendor] ON [dbo].[dxReception] ([FK_dxVendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxReceptionDate] ON [dbo].[dxReception] ([TransactionDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxReception] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxReception] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxReception] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxReception] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
