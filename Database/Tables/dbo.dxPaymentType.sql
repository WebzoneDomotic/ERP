CREATE TABLE [dbo].[dxPaymentType]
(
[PK_dxPaymentType] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (50) COLLATE French_CI_AS NULL,
[DirectDeposit] [bit] NOT NULL CONSTRAINT [DF_dxPaymentType_DirectDeposit] DEFAULT ((0)),
[FK_dxBankAccount__Default] [int] NULL,
[GroupedDeposit] [bit] NOT NULL CONSTRAINT [DF_dxPaymentType_GroupedDeposit] DEFAULT ((0)),
[Watermark] [varchar] (100) COLLATE French_CI_AS NOT NULL CONSTRAINT [DF_dxPaymentType_Watermark] DEFAULT ('')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentType.trAuditDelete] ON [dbo].[dxPaymentType]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPaymentType'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPaymentType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentType, ID, Description, DirectDeposit, FK_dxBankAccount__Default, GroupedDeposit, Watermark from deleted
 Declare @PK_dxPaymentType int, @ID varchar(50), @Description varchar(50), @DirectDeposit Bit, @FK_dxBankAccount__Default int, @GroupedDeposit Bit, @Watermark varchar(100)

 OPEN pk_cursordxPaymentType
 FETCH NEXT FROM pk_cursordxPaymentType INTO @PK_dxPaymentType, @ID, @Description, @DirectDeposit, @FK_dxBankAccount__Default, @GroupedDeposit, @Watermark
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPaymentType, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DirectDeposit', @DirectDeposit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount__Default', @FK_dxBankAccount__Default
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'GroupedDeposit', @GroupedDeposit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Watermark', @Watermark
FETCH NEXT FROM pk_cursordxPaymentType INTO @PK_dxPaymentType, @ID, @Description, @DirectDeposit, @FK_dxBankAccount__Default, @GroupedDeposit, @Watermark
 END

 CLOSE pk_cursordxPaymentType 
 DEALLOCATE pk_cursordxPaymentType
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentType.trAuditInsUpd] ON [dbo].[dxPaymentType] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPaymentType CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentType from inserted;
 set @tablename = 'dxPaymentType' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPaymentType
 FETCH NEXT FROM pk_cursordxPaymentType INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxPaymentType where PK_dxPaymentType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPaymentType where PK_dxPaymentType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DirectDeposit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DirectDeposit', DirectDeposit from dxPaymentType where PK_dxPaymentType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBankAccount__Default )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount__Default', FK_dxBankAccount__Default from dxPaymentType where PK_dxPaymentType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( GroupedDeposit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'GroupedDeposit', GroupedDeposit from dxPaymentType where PK_dxPaymentType = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Watermark )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Watermark', Watermark from dxPaymentType where PK_dxPaymentType = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPaymentType INTO @keyvalue
 END

 CLOSE pk_cursordxPaymentType 
 DEALLOCATE pk_cursordxPaymentType
GO
ALTER TABLE [dbo].[dxPaymentType] ADD CONSTRAINT [PK_dxPaymentType] PRIMARY KEY CLUSTERED  ([PK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentType_FK_dxBankAccount__Default] ON [dbo].[dxPaymentType] ([FK_dxBankAccount__Default]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPaymentType] ADD CONSTRAINT [dxConstraint_FK_dxBankAccount__Default_dxPaymentType] FOREIGN KEY ([FK_dxBankAccount__Default]) REFERENCES [dbo].[dxBankAccount] ([PK_dxBankAccount])
GO
