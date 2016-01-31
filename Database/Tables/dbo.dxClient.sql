CREATE TABLE [dbo].[dxClient]
(
[PK_dxClient] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[Reference] [varchar] (50) COLLATE French_CI_AS NULL,
[ClientReferenceNumber] [varchar] (50) COLLATE French_CI_AS NULL,
[ActiveDate] [datetime] NOT NULL CONSTRAINT [DF_dxClient_Since] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[InactiveDate] [datetime] NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_dxClient_Active] DEFAULT ((1)),
[FK_dxLanguage] [int] NOT NULL CONSTRAINT [DF_dxClient_FK_dxLanguage] DEFAULT ((1)),
[FK_dxCurrency] [int] NOT NULL CONSTRAINT [DF_dxClient_FK_dxCurrency] DEFAULT ((1)),
[FK_dxEmployee__Sales] [int] NULL,
[FK_dxPriceLevel] [int] NULL,
[FK_dxShipVia] [int] NULL,
[ShipVia] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxFOB] [int] NULL,
[FOB] [varchar] (500) COLLATE French_CI_AS NULL,
[FK_dxTerms] [int] NOT NULL CONSTRAINT [DF_dxClient_FK_dxTerm] DEFAULT ((1)),
[FK_dxNote] [int] NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FK_dxCreditApprobation] [int] NULL,
[FK_dxClientCategory] [int] NULL,
[FK_dxStatus] [int] NULL,
[EmailSalesFromName] [varchar] (255) COLLATE French_CI_AS NULL,
[EmailSalesFromMail] [varchar] (255) COLLATE French_CI_AS NULL,
[EmailSalesSignature] [varchar] (8000) COLLATE French_CI_AS NULL,
[FK_dxPropertyGroup] [int] NULL,
[FK_dxShippingServiceType] [int] NULL,
[OneClientOrderPerShipping] [bit] NOT NULL CONSTRAINT [DF_dxClient_OneClientOrderPerShipping] DEFAULT ((0)),
[GlobalPriceListDiscount] [float] NOT NULL CONSTRAINT [DF_dxClient_GlobalPriceListDiscount] DEFAULT ((0.0)),
[OrderOverTotalAmount] [float] NOT NULL CONSTRAINT [DF_dxClient_OrderOverTotalAmount] DEFAULT ((0.0)),
[CurrentOrdersOverTotalAmount] [float] NOT NULL CONSTRAINT [DF_dxClient_CurrentOrdersOverTotalAmount] DEFAULT ((0.0)),
[OverdueAccountTotalAmount] [float] NOT NULL CONSTRAINT [DF_dxClient_OverdueAccountTotalAmount] DEFAULT ((0.0)),
[OverdueAccountInDays] [int] NOT NULL CONSTRAINT [DF_dxClient_OverdueAccountInDays] DEFAULT ((0)),
[CreditLimit] [float] NOT NULL CONSTRAINT [DF_dxClient_CreditLimit] DEFAULT ((0.0)),
[DocumentStatus] [int] NOT NULL CONSTRAINT [DF_dxClient_DocumentStatus] DEFAULT ((0)),
[FK_dxTerms__CashFlow] [int] NULL,
[FK_dxPaymentType] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClient.trAuditDelete] ON [dbo].[dxClient]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClient'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClient CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClient, ID, Name, Reference, ClientReferenceNumber, ActiveDate, InactiveDate, Active, FK_dxLanguage, FK_dxCurrency, FK_dxEmployee__Sales, FK_dxPriceLevel, FK_dxShipVia, ShipVia, FK_dxFOB, FOB, FK_dxTerms, FK_dxNote, Note, FK_dxCreditApprobation, FK_dxClientCategory, FK_dxStatus, EmailSalesFromName, EmailSalesFromMail, EmailSalesSignature, FK_dxPropertyGroup, FK_dxShippingServiceType, OneClientOrderPerShipping, GlobalPriceListDiscount, OrderOverTotalAmount, CurrentOrdersOverTotalAmount, OverdueAccountTotalAmount, OverdueAccountInDays, CreditLimit, DocumentStatus, FK_dxTerms__CashFlow, FK_dxPaymentType from deleted
 Declare @PK_dxClient int, @ID varchar(50), @Name varchar(255), @Reference varchar(50), @ClientReferenceNumber varchar(50), @ActiveDate DateTime, @InactiveDate DateTime, @Active Bit, @FK_dxLanguage int, @FK_dxCurrency int, @FK_dxEmployee__Sales int, @FK_dxPriceLevel int, @FK_dxShipVia int, @ShipVia varchar(500), @FK_dxFOB int, @FOB varchar(500), @FK_dxTerms int, @FK_dxNote int, @Note varchar(2000), @FK_dxCreditApprobation int, @FK_dxClientCategory int, @FK_dxStatus int, @EmailSalesFromName varchar(255), @EmailSalesFromMail varchar(255), @EmailSalesSignature varchar(8000), @FK_dxPropertyGroup int, @FK_dxShippingServiceType int, @OneClientOrderPerShipping Bit, @GlobalPriceListDiscount Float, @OrderOverTotalAmount Float, @CurrentOrdersOverTotalAmount Float, @OverdueAccountTotalAmount Float, @OverdueAccountInDays int, @CreditLimit Float, @DocumentStatus int, @FK_dxTerms__CashFlow int, @FK_dxPaymentType int

 OPEN pk_cursordxClient
 FETCH NEXT FROM pk_cursordxClient INTO @PK_dxClient, @ID, @Name, @Reference, @ClientReferenceNumber, @ActiveDate, @InactiveDate, @Active, @FK_dxLanguage, @FK_dxCurrency, @FK_dxEmployee__Sales, @FK_dxPriceLevel, @FK_dxShipVia, @ShipVia, @FK_dxFOB, @FOB, @FK_dxTerms, @FK_dxNote, @Note, @FK_dxCreditApprobation, @FK_dxClientCategory, @FK_dxStatus, @EmailSalesFromName, @EmailSalesFromMail, @EmailSalesSignature, @FK_dxPropertyGroup, @FK_dxShippingServiceType, @OneClientOrderPerShipping, @GlobalPriceListDiscount, @OrderOverTotalAmount, @CurrentOrdersOverTotalAmount, @OverdueAccountTotalAmount, @OverdueAccountInDays, @CreditLimit, @DocumentStatus, @FK_dxTerms__CashFlow, @FK_dxPaymentType
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClient, @tablename, @auditdate, @username, @fk_dxuser
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
        select @pkdataaudit, 'ClientReferenceNumber', @ClientReferenceNumber
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
        select @pkdataaudit, 'FK_dxEmployee__Sales', @FK_dxEmployee__Sales
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevel', @FK_dxPriceLevel
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
        select @pkdataaudit, 'FK_dxCreditApprobation', @FK_dxCreditApprobation
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientCategory', @FK_dxClientCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxStatus', @FK_dxStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesFromName', @EmailSalesFromName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesFromMail', @EmailSalesFromMail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesSignature', @EmailSalesSignature
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', @FK_dxPropertyGroup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', @FK_dxShippingServiceType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'OneClientOrderPerShipping', @OneClientOrderPerShipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GlobalPriceListDiscount', @GlobalPriceListDiscount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderOverTotalAmount', @OrderOverTotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CurrentOrdersOverTotalAmount', @CurrentOrdersOverTotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverdueAccountTotalAmount', @OverdueAccountTotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'OverdueAccountInDays', @OverdueAccountInDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CreditLimit', @CreditLimit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', @DocumentStatus
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms__CashFlow', @FK_dxTerms__CashFlow
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
FETCH NEXT FROM pk_cursordxClient INTO @PK_dxClient, @ID, @Name, @Reference, @ClientReferenceNumber, @ActiveDate, @InactiveDate, @Active, @FK_dxLanguage, @FK_dxCurrency, @FK_dxEmployee__Sales, @FK_dxPriceLevel, @FK_dxShipVia, @ShipVia, @FK_dxFOB, @FOB, @FK_dxTerms, @FK_dxNote, @Note, @FK_dxCreditApprobation, @FK_dxClientCategory, @FK_dxStatus, @EmailSalesFromName, @EmailSalesFromMail, @EmailSalesSignature, @FK_dxPropertyGroup, @FK_dxShippingServiceType, @OneClientOrderPerShipping, @GlobalPriceListDiscount, @OrderOverTotalAmount, @CurrentOrdersOverTotalAmount, @OverdueAccountTotalAmount, @OverdueAccountInDays, @CreditLimit, @DocumentStatus, @FK_dxTerms__CashFlow, @FK_dxPaymentType
 END

 CLOSE pk_cursordxClient 
 DEALLOCATE pk_cursordxClient
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClient.trAuditInsUpd] ON [dbo].[dxClient] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClient CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClient from inserted;
 set @tablename = 'dxClient' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClient
 FETCH NEXT FROM pk_cursordxClient INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Name )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Name', Name from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Reference )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', Reference from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ClientReferenceNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ClientReferenceNumber', ClientReferenceNumber from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ActiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ActiveDate', ActiveDate from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InactiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InactiveDate', InactiveDate from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLanguage )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLanguage', FK_dxLanguage from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee__Sales )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee__Sales', FK_dxEmployee__Sales from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPriceLevel )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPriceLevel', FK_dxPriceLevel from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShipVia', FK_dxShipVia from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShipVia )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ShipVia', ShipVia from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxFOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxFOB', FK_dxFOB from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FOB )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FOB', FOB from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTerms )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms', FK_dxTerms from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxNote )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxNote', FK_dxNote from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCreditApprobation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCreditApprobation', FK_dxCreditApprobation from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClientCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClientCategory', FK_dxClientCategory from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxStatus', FK_dxStatus from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailSalesFromName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesFromName', EmailSalesFromName from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailSalesFromMail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesFromMail', EmailSalesFromMail from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailSalesSignature )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesSignature', EmailSalesSignature from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPropertyGroup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPropertyGroup', FK_dxPropertyGroup from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingServiceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', FK_dxShippingServiceType from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OneClientOrderPerShipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'OneClientOrderPerShipping', OneClientOrderPerShipping from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( GlobalPriceListDiscount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'GlobalPriceListDiscount', GlobalPriceListDiscount from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OrderOverTotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderOverTotalAmount', OrderOverTotalAmount from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CurrentOrdersOverTotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CurrentOrdersOverTotalAmount', CurrentOrdersOverTotalAmount from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OverdueAccountTotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverdueAccountTotalAmount', OverdueAccountTotalAmount from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OverdueAccountInDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'OverdueAccountInDays', OverdueAccountInDays from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CreditLimit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CreditLimit', CreditLimit from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DocumentStatus )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DocumentStatus', DocumentStatus from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTerms__CashFlow )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTerms__CashFlow', FK_dxTerms__CashFlow from dxClient where PK_dxClient = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxClient where PK_dxClient = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClient INTO @keyvalue
 END

 CLOSE pk_cursordxClient 
 DEALLOCATE pk_cursordxClient
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [PK_dxClient] PRIMARY KEY CLUSTERED  ([PK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxClientCategory] ON [dbo].[dxClient] ([FK_dxClientCategory]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxCreditApprobation] ON [dbo].[dxClient] ([FK_dxCreditApprobation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxCurrency] ON [dbo].[dxClient] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxEmployee__Sales] ON [dbo].[dxClient] ([FK_dxEmployee__Sales]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxFOB] ON [dbo].[dxClient] ([FK_dxFOB]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxLanguage] ON [dbo].[dxClient] ([FK_dxLanguage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxNote] ON [dbo].[dxClient] ([FK_dxNote]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxPaymentType] ON [dbo].[dxClient] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxPriceLevel] ON [dbo].[dxClient] ([FK_dxPriceLevel]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxPropertyGroup] ON [dbo].[dxClient] ([FK_dxPropertyGroup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxShippingServiceType] ON [dbo].[dxClient] ([FK_dxShippingServiceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxShipVia] ON [dbo].[dxClient] ([FK_dxShipVia]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxStatus] ON [dbo].[dxClient] ([FK_dxStatus]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxTerms] ON [dbo].[dxClient] ([FK_dxTerms]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClient_FK_dxTerms__CashFlow] ON [dbo].[dxClient] ([FK_dxTerms__CashFlow]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxClient] ON [dbo].[dxClient] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxClientCategory_dxClient] FOREIGN KEY ([FK_dxClientCategory]) REFERENCES [dbo].[dxClientCategory] ([PK_dxClientCategory])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxCreditApprobation_dxClient] FOREIGN KEY ([FK_dxCreditApprobation]) REFERENCES [dbo].[dxCreditApprobation] ([PK_dxCreditApprobation])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxClient] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxEmployee__Sales_dxClient] FOREIGN KEY ([FK_dxEmployee__Sales]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxFOB_dxClient] FOREIGN KEY ([FK_dxFOB]) REFERENCES [dbo].[dxFOB] ([PK_dxFOB])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxLanguage_dxClient] FOREIGN KEY ([FK_dxLanguage]) REFERENCES [dbo].[dxLanguage] ([PK_dxLanguage])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxNote_dxClient] FOREIGN KEY ([FK_dxNote]) REFERENCES [dbo].[dxNote] ([PK_dxNote])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxClient] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxPriceLevel_dxClient] FOREIGN KEY ([FK_dxPriceLevel]) REFERENCES [dbo].[dxPriceLevel] ([PK_dxPriceLevel])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxPropertyGroup_dxClient] FOREIGN KEY ([FK_dxPropertyGroup]) REFERENCES [dbo].[dxPropertyGroup] ([PK_dxPropertyGroup])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxShippingServiceType_dxClient] FOREIGN KEY ([FK_dxShippingServiceType]) REFERENCES [dbo].[dxShippingServiceType] ([PK_dxShippingServiceType])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxShipVia_dxClient] FOREIGN KEY ([FK_dxShipVia]) REFERENCES [dbo].[dxShipVia] ([PK_dxShipVia])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxStatus_dxClient] FOREIGN KEY ([FK_dxStatus]) REFERENCES [dbo].[dxStatus] ([PK_dxStatus])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxTerms_dxClient] FOREIGN KEY ([FK_dxTerms]) REFERENCES [dbo].[dxTerms] ([PK_dxTerms])
GO
ALTER TABLE [dbo].[dxClient] ADD CONSTRAINT [dxConstraint_FK_dxTerms__CashFlow_dxClient] FOREIGN KEY ([FK_dxTerms__CashFlow]) REFERENCES [dbo].[dxTerms] ([PK_dxTerms])
GO
