CREATE TABLE [dbo].[dxVendor]
(
[PK_dxVendor] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[Reference] [varchar] (50) COLLATE French_CI_AS NULL,
[VendorReferenceNumber] [varchar] (50) COLLATE French_CI_AS NULL,
[ActiveDate] [datetime] NOT NULL CONSTRAINT [DF_dxVendor_ActiveDate] DEFAULT (CONVERT([int],getdate(),(0))),
[InactiveDate] [datetime] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxVendor_Active] DEFAULT ((1)),
[FK_dxLanguage] [int] NOT NULL CONSTRAINT [DF_dxVendor_FK_dxLanguage] DEFAULT ((1)),
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxVendor_FK_dxCurrency] DEFAULT ((1)),
[FK_dxEmployee__Purchasing] [int] NULL,
[FK_dxCostLevel] [int] NULL,
[FK_dxShipVia] [int] NULL,
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxFOB] [int] NULL,
[FOB] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxTerms] [int] NOT NULL CONSTRAINT [DF_dxVendor_FK_dxTerms] DEFAULT ((1)),
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxVendorCategory] [int] NULL,
[FK_dxStatus] [int] NULL,
[FK_dxPropertyGroup] [int] NULL,
[FK_dxShippingServiceType] [int] NULL,
[FK_dxBankAccount] [int] NULL,
[WithholdAllInvoicePayment] [bit] NOT NULL CONSTRAINT [DF_dxVendor_WithholdAllInvoicePayment] DEFAULT ((0)),
[FK_dxPaymentType] [int] NULL,
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxVendor_DocumentStatus] DEFAULT ((0)),
[FK_dxTerms__CashFlow] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxVendor.trAuditDelete] ON [dbo].[dxVendor]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxVendor'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxVendor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxVendor, ID, Name, Reference, VendorReferenceNumber, ActiveDate, InactiveDate, Active, FK_dxLanguage, FK_dxCurrency, FK_dxEmployee__Purchasing, FK_dxCostLevel, FK_dxShipVia, ShipVia, FK_dxFOB, FOB, FK_dxTerms, FK_dxNote, Note, FK_dxVendorCategory, FK_dxStatus, FK_dxPropertyGroup, FK_dxShippingServiceType, FK_dxBankAccount, WithholdAllInvoicePayment, FK_dxPaymentType, DocumentStatus, FK_dxTerms__CashFlow from deleted
 Declare @PK_dxVendor int, @ID varchar(50), @Name varchar(255), @Reference varchar(50), @VendorReferenceNumber varchar(50), @ActiveDate DateTime, @InactiveDate DateTime, @Active Bit, @FK_dxLanguage int, @FK_dxCurrency int, @FK_dxEmployee__Purchasing int, @FK_dxCostLevel int, @FK_dxShipVia int, @ShipVia varchar(500), @FK_dxFOB int, @FOB varchar(500), @FK_dxTerms int, @FK_dxNote int, @Note varchar(2000), @FK_dxVendorCategory int, @FK_dxStatus int, @FK_dxPropertyGroup int, @FK_dxShippingServiceType int, @FK_dxBankAccount int, @WithholdAllInvoicePayment Bit, @FK_dxPaymentType int, @DocumentStatus int, @FK_dxTerms__CashFlow int

 OPEN pk_cursordxVendor
 FETCH NEXT FROM pk_cursordxVendor INTO @PK_dxVendor, @ID, @Name, @Reference, @VendorReferenceNumber, @ActiveDate, @InactiveDate, @Active, @FK_dxLanguage, @FK_dxCurrency, @FK_dxEmployee__Purchasing, @FK_dxCostLevel, @FK_dxShipVia, @ShipVia, @FK_dxFOB, @FOB, @FK_dxTerms, @FK_dxNote, @Note, @FK_dxVendorCategory, @FK_dxStatus, @FK_dxPropertyGroup, @FK_dxShippingServiceType, @FK_dxBankAccount, @WithholdAllInvoicePayment, @FK_dxPaymentType, @DocumentStatus, @FK_dxTerms__CashFlow
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxVendor, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', @Name
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', @Reference
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorReferenceNumber', @VendorReferenceNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ActiveDate', @ActiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InactiveDate', @InactiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLanguage', @FK_dxLanguage
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Purchasing', @FK_dxEmployee__Purchasing
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCostLevel', @FK_dxCostLevel
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', @FK_dxShipVia
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', @ShipVia
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', @FK_dxFOB
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', @FOB
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms', @FK_dxTerms
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', @FK_dxNote
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendorCategory', @FK_dxVendorCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxStatus', @FK_dxStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', @FK_dxPropertyGroup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', @FK_dxShippingServiceType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', @FK_dxBankAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'WithholdAllInvoicePayment', @WithholdAllInvoicePayment
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms__CashFlow', @FK_dxTerms__CashFlow
FETCH NEXT FROM pk_cursordxVendor INTO @PK_dxVendor, @ID, @Name, @Reference, @VendorReferenceNumber, @ActiveDate, @InactiveDate, @Active, @FK_dxLanguage, @FK_dxCurrency, @FK_dxEmployee__Purchasing, @FK_dxCostLevel, @FK_dxShipVia, @ShipVia, @FK_dxFOB, @FOB, @FK_dxTerms, @FK_dxNote, @Note, @FK_dxVendorCategory, @FK_dxStatus, @FK_dxPropertyGroup, @FK_dxShippingServiceType, @FK_dxBankAccount, @WithholdAllInvoicePayment, @FK_dxPaymentType, @DocumentStatus, @FK_dxTerms__CashFlow
 END

 CLOSE pk_cursordxVendor 
 DEALLOCATE pk_cursordxVendor
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxVendor.trAuditInsUpd] ON [dbo].[dxVendor] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxVendor CURSOR LOCAL FAST_FORWARD for SELECT PK_dxVendor from inserted;
 set @tablename = 'dxVendor' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxVendor
 FETCH NEXT FROM pk_cursordxVendor INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Reference )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', Reference from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( VendorReferenceNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'VendorReferenceNumber', VendorReferenceNumber from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ActiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ActiveDate', ActiveDate from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InactiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InactiveDate', InactiveDate from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLanguage )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLanguage', FK_dxLanguage from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__Purchasing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Purchasing', FK_dxEmployee__Purchasing from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCostLevel )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCostLevel', FK_dxCostLevel from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', FK_dxShipVia from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', FK_dxFOB from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', FOB from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTerms )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms', FK_dxTerms from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendorCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendorCategory', FK_dxVendorCategory from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxStatus', FK_dxStatus from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPropertyGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', FK_dxPropertyGroup from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingServiceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', FK_dxShippingServiceType from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxBankAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxBankAccount', FK_dxBankAccount from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( WithholdAllInvoicePayment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'WithholdAllInvoicePayment', WithholdAllInvoicePayment from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxVendor where PK_dxVendor = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTerms__CashFlow )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms__CashFlow', FK_dxTerms__CashFlow from dxVendor where PK_dxVendor = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxVendor INTO @keyvalue
 END

 CLOSE pk_cursordxVendor 
 DEALLOCATE pk_cursordxVendor
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [PK_dxVendor] PRIMARY KEY CLUSTERED  ([PK_dxVendor]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxBankAccount] ON [dbo].[dxVendor] ([FK_dxBankAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxCostLevel] ON [dbo].[dxVendor] ([FK_dxCostLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxCurrency] ON [dbo].[dxVendor] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxEmployee__Purchasing] ON [dbo].[dxVendor] ([FK_dxEmployee__Purchasing]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxFOB] ON [dbo].[dxVendor] ([FK_dxFOB]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxLanguage] ON [dbo].[dxVendor] ([FK_dxLanguage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxNote] ON [dbo].[dxVendor] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxPaymentType] ON [dbo].[dxVendor] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxPropertyGroup] ON [dbo].[dxVendor] ([FK_dxPropertyGroup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxShippingServiceType] ON [dbo].[dxVendor] ([FK_dxShippingServiceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxShipVia] ON [dbo].[dxVendor] ([FK_dxShipVia]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxStatus] ON [dbo].[dxVendor] ([FK_dxStatus]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxTerms] ON [dbo].[dxVendor] ([FK_dxTerms]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxTerms__CashFlow] ON [dbo].[dxVendor] ([FK_dxTerms__CashFlow]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxVendor_FK_dxVendorCategory] ON [dbo].[dxVendor] ([FK_dxVendorCategory]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxVendor] ON [dbo].[dxVendor] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxBankAccount_dxVendor] FOREIGN KEY ([FK_dxBankAccount]) REFERENCES [dbo].[dxBankAccount] ([PK_dxBankAccount])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxCostLevel_dxVendor] FOREIGN KEY ([FK_dxCostLevel]) REFERENCES [dbo].[dxCostLevel] ([PK_dxCostLevel])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxVendor] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__Purchasing_dxVendor] FOREIGN KEY ([FK_dxEmployee__Purchasing]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxFOB_dxVendor] FOREIGN KEY ([FK_dxFOB]) REFERENCES [dbo].[dxFOB] ([PK_dxFOB])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxLanguage_dxVendor] FOREIGN KEY ([FK_dxLanguage]) REFERENCES [dbo].[dxLanguage] ([PK_dxLanguage])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxVendor] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxVendor] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxPropertyGroup_dxVendor] FOREIGN KEY ([FK_dxPropertyGroup]) REFERENCES [dbo].[dxPropertyGroup] ([PK_dxPropertyGroup])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxShippingServiceType_dxVendor] FOREIGN KEY ([FK_dxShippingServiceType]) REFERENCES [dbo].[dxShippingServiceType] ([PK_dxShippingServiceType])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxShipVia_dxVendor] FOREIGN KEY ([FK_dxShipVia]) REFERENCES [dbo].[dxShipVia] ([PK_dxShipVia])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxStatus_dxVendor] FOREIGN KEY ([FK_dxStatus]) REFERENCES [dbo].[dxStatus] ([PK_dxStatus])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxTerms_dxVendor] FOREIGN KEY ([FK_dxTerms]) REFERENCES [dbo].[dxTerms] ([PK_dxTerms])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxTerms__CashFlow_dxVendor] FOREIGN KEY ([FK_dxTerms__CashFlow]) REFERENCES [dbo].[dxTerms] ([PK_dxTerms])
GO
ALTER TABLE [dbo].[dxVendor] ADD CONSTRAINT [dxConstraint_FK_dxVendorCategory_dxVendor] FOREIGN KEY ([FK_dxVendorCategory]) REFERENCES [dbo].[dxVendorCategory] ([PK_dxVendorCategory])
GO
