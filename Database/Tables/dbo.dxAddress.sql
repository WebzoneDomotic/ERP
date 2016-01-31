CREATE TABLE [dbo].[dxAddress]
(
[PK_dxAddress] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Address] [varchar] (1000) COLLATE French_CI_AS NULL,
[CompanyName] [varchar] (120) COLLATE French_CI_AS NULL,
[FirstName] [varchar] (120) COLLATE French_CI_AS NULL,
[LastName] [varchar] (120) COLLATE French_CI_AS NULL,
[Address1] [varchar] (120) COLLATE French_CI_AS NULL,
[Address2] [varchar] (120) COLLATE French_CI_AS NULL,
[Suite] [varchar] (50) COLLATE French_CI_AS NULL,
[FK_dxCity] [int] NULL,
[FK_dxState] [int] NULL,
[FK_dxCountry] [int] NULL,
[ZipCode] [varchar] (50) COLLATE French_CI_AS NULL,
[Phone] [varchar] (50) COLLATE French_CI_AS NULL,
[Fax] [varchar] (50) COLLATE French_CI_AS NULL,
[Cellular] [varchar] (50) COLLATE French_CI_AS NULL,
[EMail] [varchar] (50) COLLATE French_CI_AS NULL,
[WebSite] [varchar] (50) COLLATE French_CI_AS NULL,
[Distance] [float] NULL,
[FK_dxTax] [int] NOT NULL CONSTRAINT [DF_dxAddress_FK_dxTax] DEFAULT ((1)),
[FK_dxSetup] [int] NULL,
[FK_dxClient] [int] NULL,
[FK_dxVendor] [int] NULL,
[FK_dxEmployee] [int] NULL,
[DefaultShipping] [bit] NOT NULL CONSTRAINT [DF_dxAddress_DefaultShipping] DEFAULT ((0)),
[DefaultInvoicing] [bit] NOT NULL CONSTRAINT [DF_dxAddress_DefaultInvoicing] DEFAULT ((0)),
[DefaultPayment] [bit] NOT NULL CONSTRAINT [DF_dxAddress_DefaultPayment] DEFAULT ((0)),
[Home] [bit] NOT NULL CONSTRAINT [DF_dxAddress_Home] DEFAULT ((0)),
[Work] [bit] NOT NULL CONSTRAINT [DF_dxAddress_Work] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_dxAddress_Active] DEFAULT ((1)),
[FK_dxShippingZone] [int] NULL,
[IRS_TaxNumber] [varchar] (50) COLLATE French_CI_AS NULL,
[FK_dxShippingServiceType] [int] NULL,
[FK_dxLanguage] [int] NULL,
[TollFreeNumber] [varchar] (50) COLLATE French_CI_AS NULL,
[PickUp] [bit] NOT NULL CONSTRAINT [DF_dxAddress_PickUp] DEFAULT ((0)),
[SignatureRequired] [bit] NOT NULL CONSTRAINT [DF_dxAddress_SignatureRequired] DEFAULT ((0)),
[Contact] [bit] NOT NULL CONSTRAINT [DF_dxAddress_Contact] DEFAULT ((0)),
[FK_dxAddress__Forwarding] [int] NULL,
[FK_dxAddressType] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAddress.trAuditDelete] ON [dbo].[dxAddress]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAddress'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAddress CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAddress, ID, Address, CompanyName, FirstName, LastName, Address1, Address2, Suite, FK_dxCity, FK_dxState, FK_dxCountry, ZipCode, Phone, Fax, Cellular, EMail, WebSite, Distance, FK_dxTax, FK_dxSetup, FK_dxClient, FK_dxVendor, FK_dxEmployee, DefaultShipping, DefaultInvoicing, DefaultPayment, Home, Work, Active, FK_dxShippingZone, IRS_TaxNumber, FK_dxShippingServiceType, FK_dxLanguage, TollFreeNumber, PickUp, SignatureRequired, Contact, FK_dxAddress__Forwarding, FK_dxAddressType from deleted
 Declare @PK_dxAddress int, @ID varchar(50), @Address varchar(1000), @CompanyName varchar(120), @FirstName varchar(120), @LastName varchar(120), @Address1 varchar(120), @Address2 varchar(120), @Suite varchar(50), @FK_dxCity int, @FK_dxState int, @FK_dxCountry int, @ZipCode varchar(50), @Phone varchar(50), @Fax varchar(50), @Cellular varchar(50), @EMail varchar(50), @WebSite varchar(50), @Distance Float, @FK_dxTax int, @FK_dxSetup int, @FK_dxClient int, @FK_dxVendor int, @FK_dxEmployee int, @DefaultShipping Bit, @DefaultInvoicing Bit, @DefaultPayment Bit, @Home Bit, @Work Bit, @Active Bit, @FK_dxShippingZone int, @IRS_TaxNumber varchar(50), @FK_dxShippingServiceType int, @FK_dxLanguage int, @TollFreeNumber varchar(50), @PickUp Bit, @SignatureRequired Bit, @Contact Bit, @FK_dxAddress__Forwarding int, @FK_dxAddressType int

 OPEN pk_cursordxAddress
 FETCH NEXT FROM pk_cursordxAddress INTO @PK_dxAddress, @ID, @Address, @CompanyName, @FirstName, @LastName, @Address1, @Address2, @Suite, @FK_dxCity, @FK_dxState, @FK_dxCountry, @ZipCode, @Phone, @Fax, @Cellular, @EMail, @WebSite, @Distance, @FK_dxTax, @FK_dxSetup, @FK_dxClient, @FK_dxVendor, @FK_dxEmployee, @DefaultShipping, @DefaultInvoicing, @DefaultPayment, @Home, @Work, @Active, @FK_dxShippingZone, @IRS_TaxNumber, @FK_dxShippingServiceType, @FK_dxLanguage, @TollFreeNumber, @PickUp, @SignatureRequired, @Contact, @FK_dxAddress__Forwarding, @FK_dxAddressType
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAddress, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address', @Address
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'CompanyName', @CompanyName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FirstName', @FirstName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LastName', @LastName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address1', @Address1
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address2', @Address2
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Suite', @Suite
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCity', @FK_dxCity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxState', @FK_dxState
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCountry', @FK_dxCountry
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ZipCode', @ZipCode
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Phone', @Phone
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Fax', @Fax
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Cellular', @Cellular
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EMail', @EMail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'WebSite', @WebSite
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Distance', @Distance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', @FK_dxTax
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxSetup', @FK_dxSetup
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', @FK_dxEmployee
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DefaultShipping', @DefaultShipping
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DefaultInvoicing', @DefaultInvoicing
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DefaultPayment', @DefaultPayment
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Home', @Home
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Work', @Work
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingZone', @FK_dxShippingZone
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'IRS_TaxNumber', @IRS_TaxNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', @FK_dxShippingServiceType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLanguage', @FK_dxLanguage
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TollFreeNumber', @TollFreeNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PickUp', @PickUp
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'SignatureRequired', @SignatureRequired
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Contact', @Contact
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Forwarding', @FK_dxAddress__Forwarding
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddressType', @FK_dxAddressType
FETCH NEXT FROM pk_cursordxAddress INTO @PK_dxAddress, @ID, @Address, @CompanyName, @FirstName, @LastName, @Address1, @Address2, @Suite, @FK_dxCity, @FK_dxState, @FK_dxCountry, @ZipCode, @Phone, @Fax, @Cellular, @EMail, @WebSite, @Distance, @FK_dxTax, @FK_dxSetup, @FK_dxClient, @FK_dxVendor, @FK_dxEmployee, @DefaultShipping, @DefaultInvoicing, @DefaultPayment, @Home, @Work, @Active, @FK_dxShippingZone, @IRS_TaxNumber, @FK_dxShippingServiceType, @FK_dxLanguage, @TollFreeNumber, @PickUp, @SignatureRequired, @Contact, @FK_dxAddress__Forwarding, @FK_dxAddressType
 END

 CLOSE pk_cursordxAddress 
 DEALLOCATE pk_cursordxAddress
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAddress.trAuditInsUpd] ON [dbo].[dxAddress] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAddress CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAddress from inserted;
 set @tablename = 'dxAddress' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAddress
 FETCH NEXT FROM pk_cursordxAddress INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Address )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address', Address from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CompanyName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'CompanyName', CompanyName from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FirstName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FirstName', FirstName from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LastName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LastName', LastName from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Address1 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address1', Address1 from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Address2 )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Address2', Address2 from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Suite )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Suite', Suite from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCity', FK_dxCity from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxState )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxState', FK_dxState from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCountry )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCountry', FK_dxCountry from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ZipCode )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ZipCode', ZipCode from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Phone )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Phone', Phone from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Fax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Fax', Fax from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Cellular )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Cellular', Cellular from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EMail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EMail', EMail from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( WebSite )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'WebSite', WebSite from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Distance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Distance', Distance from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', FK_dxTax from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxSetup )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxSetup', FK_dxSetup from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', FK_dxEmployee from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DefaultShipping )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DefaultShipping', DefaultShipping from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DefaultInvoicing )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DefaultInvoicing', DefaultInvoicing from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DefaultPayment )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DefaultPayment', DefaultPayment from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Home )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Home', Home from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Work )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Work', Work from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingZone )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingZone', FK_dxShippingZone from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( IRS_TaxNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'IRS_TaxNumber', IRS_TaxNumber from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxShippingServiceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxShippingServiceType', FK_dxShippingServiceType from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLanguage )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLanguage', FK_dxLanguage from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TollFreeNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'TollFreeNumber', TollFreeNumber from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PickUp )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PickUp', PickUp from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SignatureRequired )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'SignatureRequired', SignatureRequired from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Contact )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Contact', Contact from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddress__Forwarding )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddress__Forwarding', FK_dxAddress__Forwarding from dxAddress where PK_dxAddress = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAddressType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAddressType', FK_dxAddressType from dxAddress where PK_dxAddress = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAddress INTO @keyvalue
 END

 CLOSE pk_cursordxAddress 
 DEALLOCATE pk_cursordxAddress
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [PK_dxAddress] PRIMARY KEY CLUSTERED  ([PK_dxAddress]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxAddress__Forwarding] ON [dbo].[dxAddress] ([FK_dxAddress__Forwarding]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxAddressType] ON [dbo].[dxAddress] ([FK_dxAddressType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxCity] ON [dbo].[dxAddress] ([FK_dxCity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxClient] ON [dbo].[dxAddress] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxCountry] ON [dbo].[dxAddress] ([FK_dxCountry]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxEmployee] ON [dbo].[dxAddress] ([FK_dxEmployee]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxLanguage] ON [dbo].[dxAddress] ([FK_dxLanguage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxSetup] ON [dbo].[dxAddress] ([FK_dxSetup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxShippingServiceType] ON [dbo].[dxAddress] ([FK_dxShippingServiceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxShippingZone] ON [dbo].[dxAddress] ([FK_dxShippingZone]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxState] ON [dbo].[dxAddress] ([FK_dxState]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxTax] ON [dbo].[dxAddress] ([FK_dxTax]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAddress_FK_dxVendor] ON [dbo].[dxAddress] ([FK_dxVendor]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxAddress__Forwarding_dxAddress] FOREIGN KEY ([FK_dxAddress__Forwarding]) REFERENCES [dbo].[dxAddress] ([PK_dxAddress])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxAddressType_dxAddress] FOREIGN KEY ([FK_dxAddressType]) REFERENCES [dbo].[dxAddressType] ([PK_dxAddressType])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxCity_dxAddress] FOREIGN KEY ([FK_dxCity]) REFERENCES [dbo].[dxCity] ([PK_dxCity])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxAddress] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxCountry_dxAddress] FOREIGN KEY ([FK_dxCountry]) REFERENCES [dbo].[dxCountry] ([PK_dxCountry])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxEmployee_dxAddress] FOREIGN KEY ([FK_dxEmployee]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxLanguage_dxAddress] FOREIGN KEY ([FK_dxLanguage]) REFERENCES [dbo].[dxLanguage] ([PK_dxLanguage])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxSetup_dxAddress] FOREIGN KEY ([FK_dxSetup]) REFERENCES [dbo].[dxSetup] ([PK_dxSetup])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxShippingServiceType_dxAddress] FOREIGN KEY ([FK_dxShippingServiceType]) REFERENCES [dbo].[dxShippingServiceType] ([PK_dxShippingServiceType])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxShippingZone_dxAddress] FOREIGN KEY ([FK_dxShippingZone]) REFERENCES [dbo].[dxShippingZone] ([PK_dxShippingZone])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxState_dxAddress] FOREIGN KEY ([FK_dxState]) REFERENCES [dbo].[dxState] ([PK_dxState])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxAddress] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
ALTER TABLE [dbo].[dxAddress] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxAddress] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
