CREATE TABLE [dbo].[dxSetup]
(
[PK_dxSetup] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[Logo] [image] NULL,
[CompanyName] [varchar] (255) COLLATE French_CI_AS NULL,
[LogoAddress] [varchar] (1000) COLLATE French_CI_AS NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NULL,
[FederalRegistrationNumber] [varchar] (50) COLLATE French_CI_AS NULL,
[ProvincialRegistrationNumber] [varchar] (50) COLLATE French_CI_AS NULL,
[GSTCode] [varchar] (50) COLLATE French_CI_AS NULL,
[PSTCode] [varchar] (50) COLLATE French_CI_AS NULL,
[DatabaseStructure] [int] NULL CONSTRAINT [DF_dxSetup_DatabaseStructure] DEFAULT ((1)),
[SMTPServer] [varchar] (50) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxSetup_ServerSMTP] DEFAULT ('relais.videotron.ca'),
[Port] [int] NULL CONSTRAINT [DF_dxSetup_ServerPort] DEFAULT ((25)),
[Login] [varchar] (50) COLLATE French_CI_AS NULL,
[Password] [varchar] (50) COLLATE French_CI_AS NULL,
[OptionHQ] [bit] NOT NULL CONSTRAINT [DF_dxSetup_OptionHQ] DEFAULT ((0)),
[LockoutUsers] [bit] NOT NULL CONSTRAINT [DF_dxSetup_LockoutUsers] DEFAULT ((0)),
[EmailSalesFromName] [varchar] (255) COLLATE French_CI_AS NULL,
[EmailSalesFromMail] [varchar] (255) COLLATE French_CI_AS NULL,
[EmailPurchasesFromName] [varchar] (255) COLLATE French_CI_AS NULL,
[EmailPurchasesFromMail] [varchar] (255) COLLATE French_CI_AS NULL,
[EmailSalesSignature] [varchar] (8000) COLLATE French_CI_AS NULL,
[EmailPurchasesSignature] [varchar] (8000) COLLATE French_CI_AS NULL,
[EmailDelayInSecond] [int] NOT NULL CONSTRAINT [DF_dxSetup_EmailDelayInSecond] DEFAULT ((1)),
[LogonDate] [datetime] NULL,
[ControlLicence] [float] NULL,
[LicenceControl] [float] NULL,
[LicenceNumber] [varchar] (1000) COLLATE French_CI_AS NULL,
[FilterOptionNumberOfRecord] [int] NOT NULL CONSTRAINT [DF_dxSetup_FilterOptionNumberOfRecord] DEFAULT ((1500)),
[ShippingReleaseDelayInDays] [int] NOT NULL CONSTRAINT [DF_dxSetup_ShippingReleaseDelayInDays] DEFAULT ((1)),
[LowerBoundMRPAnalysisInDays] [int] NOT NULL CONSTRAINT [DF_dxSetup_LowerBoundMRPAnalysisInDays] DEFAULT ((7)),
[LiveInventoryAccountingTransaction] [bit] NOT NULL CONSTRAINT [DF_dxSetup_LiveInventoryAccountingTransaction] DEFAULT ((0)),
[LiveForeignCurrencyTransaction] [bit] NOT NULL CONSTRAINT [DF_dxSetup_LiveForeignCurrencyTransaction] DEFAULT ((0)),
[CertificateValidityInSecs] [int] NOT NULL CONSTRAINT [DF_dxSetup_CertificateValidityInSecs] DEFAULT ((300)),
[CustomTransitoryAgent] [varchar] (500) COLLATE French_CI_AS NULL,
[ConsiderUnpostedReceptionInTheMRP] [bit] NOT NULL CONSTRAINT [DF_dxSetup_ConsiderUnpostedReceptionInTheMRP] DEFAULT ((0)),
[LowerLimitTolerenceOnAReception] [float] NOT NULL CONSTRAINT [DF_dxSetup_LowerLimitTolerenceOnAReception] DEFAULT ((5.0)),
[UpperLimitTolerenceOnAReception] [float] NOT NULL CONSTRAINT [DF_dxSetup_UpperLimitTolerenceOnAReception] DEFAULT ((15.0)),
[FK_dxWarehouse__Reception] [int] NOT NULL CONSTRAINT [DF_dxSetup_FK_dxWarehouse] DEFAULT ((3)),
[FK_dxLocation__Reception] [int] NOT NULL CONSTRAINT [DF_dxSetup_FK_dxLocation] DEFAULT ((1)),
[ManageWOWithReservedArea] [bit] NOT NULL CONSTRAINT [DF_dxSetup_ManageWOWithReservedArea] DEFAULT ((0)),
[UseCustomMPRProcedure] [bit] NOT NULL CONSTRAINT [DF_dxSetup_UseCustomMPRProcedure] DEFAULT ((0)),
[LastMRPStartDate] [datetime] NULL,
[LastMRPFinishDate] [datetime] NULL,
[ProductionTolerance] [float] NOT NULL CONSTRAINT [DF_dxSetup_ProductionTolerance] DEFAULT ((0)),
[AccountingStartingPeriod] [int] NOT NULL CONSTRAINT [DF_dxSetup_AccountingStartingPeriod] DEFAULT ((1)),
[FK_dxReport__ProcessDefault] [int] NULL,
[TaxesManagedByItem] [bit] NOT NULL CONSTRAINT [DF_dxSetup_TaxesManagedByItem] DEFAULT ((1))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxSetup.trAuditDelete] ON [dbo].[dxSetup]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxSetup'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxSetup CURSOR LOCAL FAST_FORWARD for SELECT PK_dxSetup, Description, CompanyName, LogoAddress, Note, FederalRegistrationNumber, ProvincialRegistrationNumber, GSTCode, PSTCode, DatabaseStructure, SMTPServer, Port, Login, Password, OptionHQ, LockoutUsers, EmailSalesFromName, EmailSalesFromMail, EmailPurchasesFromName, EmailPurchasesFromMail, EmailSalesSignature, EmailPurchasesSignature, EmailDelayInSecond, LogonDate, ControlLicence, LicenceControl, LicenceNumber, FilterOptionNumberOfRecord, ShippingReleaseDelayInDays, LowerBoundMRPAnalysisInDays, LiveInventoryAccountingTransaction, LiveForeignCurrencyTransaction, CertificateValidityInSecs, CustomTransitoryAgent, ConsiderUnpostedReceptionInTheMRP, LowerLimitTolerenceOnAReception, UpperLimitTolerenceOnAReception, FK_dxWarehouse__Reception, FK_dxLocation__Reception, ManageWOWithReservedArea, UseCustomMPRProcedure, LastMRPStartDate, LastMRPFinishDate, ProductionTolerance, AccountingStartingPeriod, FK_dxReport__ProcessDefault, TaxesManagedByItem from deleted
 Declare @PK_dxSetup int, @Description varchar(255), @CompanyName varchar(255), @LogoAddress varchar(1000), @Note varchar(2000), @FederalRegistrationNumber varchar(50), @ProvincialRegistrationNumber varchar(50), @GSTCode varchar(50), @PSTCode varchar(50), @DatabaseStructure int, @SMTPServer varchar(50), @Port int, @Login varchar(50), @Password varchar(50), @OptionHQ Bit, @LockoutUsers Bit, @EmailSalesFromName varchar(255), @EmailSalesFromMail varchar(255), @EmailPurchasesFromName varchar(255), @EmailPurchasesFromMail varchar(255), @EmailSalesSignature varchar(8000), @EmailPurchasesSignature varchar(8000), @EmailDelayInSecond int, @LogonDate DateTime, @ControlLicence Float, @LicenceControl Float, @LicenceNumber varchar(1000), @FilterOptionNumberOfRecord int, @ShippingReleaseDelayInDays int, @LowerBoundMRPAnalysisInDays int, @LiveInventoryAccountingTransaction Bit, @LiveForeignCurrencyTransaction Bit, @CertificateValidityInSecs int, @CustomTransitoryAgent varchar(500), @ConsiderUnpostedReceptionInTheMRP Bit, @LowerLimitTolerenceOnAReception Float, @UpperLimitTolerenceOnAReception Float, @FK_dxWarehouse__Reception int, @FK_dxLocation__Reception int, @ManageWOWithReservedArea Bit, @UseCustomMPRProcedure Bit, @LastMRPStartDate DateTime, @LastMRPFinishDate DateTime, @ProductionTolerance Float, @AccountingStartingPeriod int, @FK_dxReport__ProcessDefault int, @TaxesManagedByItem Bit

 OPEN pk_cursordxSetup
 FETCH NEXT FROM pk_cursordxSetup INTO @PK_dxSetup, @Description, @CompanyName, @LogoAddress, @Note, @FederalRegistrationNumber, @ProvincialRegistrationNumber, @GSTCode, @PSTCode, @DatabaseStructure, @SMTPServer, @Port, @Login, @Password, @OptionHQ, @LockoutUsers, @EmailSalesFromName, @EmailSalesFromMail, @EmailPurchasesFromName, @EmailPurchasesFromMail, @EmailSalesSignature, @EmailPurchasesSignature, @EmailDelayInSecond, @LogonDate, @ControlLicence, @LicenceControl, @LicenceNumber, @FilterOptionNumberOfRecord, @ShippingReleaseDelayInDays, @LowerBoundMRPAnalysisInDays, @LiveInventoryAccountingTransaction, @LiveForeignCurrencyTransaction, @CertificateValidityInSecs, @CustomTransitoryAgent, @ConsiderUnpostedReceptionInTheMRP, @LowerLimitTolerenceOnAReception, @UpperLimitTolerenceOnAReception, @FK_dxWarehouse__Reception, @FK_dxLocation__Reception, @ManageWOWithReservedArea, @UseCustomMPRProcedure, @LastMRPStartDate, @LastMRPFinishDate, @ProductionTolerance, @AccountingStartingPeriod, @FK_dxReport__ProcessDefault, @TaxesManagedByItem
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxSetup, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'CompanyName', @CompanyName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LogoAddress', @LogoAddress
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FederalRegistrationNumber', @FederalRegistrationNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ProvincialRegistrationNumber', @ProvincialRegistrationNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'GSTCode', @GSTCode
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PSTCode', @PSTCode
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DatabaseStructure', @DatabaseStructure
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SMTPServer', @SMTPServer
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'Port', @Port
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Login', @Login
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Password', @Password
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'OptionHQ', @OptionHQ
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'LockoutUsers', @LockoutUsers
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesFromName', @EmailSalesFromName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesFromMail', @EmailSalesFromMail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailPurchasesFromName', @EmailPurchasesFromName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailPurchasesFromMail', @EmailPurchasesFromMail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesSignature', @EmailSalesSignature
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailPurchasesSignature', @EmailPurchasesSignature
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'EmailDelayInSecond', @EmailDelayInSecond
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'LogonDate', @LogonDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ControlLicence', @ControlLicence
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LicenceControl', @LicenceControl
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LicenceNumber', @LicenceNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FilterOptionNumberOfRecord', @FilterOptionNumberOfRecord
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ShippingReleaseDelayInDays', @ShippingReleaseDelayInDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'LowerBoundMRPAnalysisInDays', @LowerBoundMRPAnalysisInDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'LiveInventoryAccountingTransaction', @LiveInventoryAccountingTransaction
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'LiveForeignCurrencyTransaction', @LiveForeignCurrencyTransaction
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'CertificateValidityInSecs', @CertificateValidityInSecs
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'CustomTransitoryAgent', @CustomTransitoryAgent
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ConsiderUnpostedReceptionInTheMRP', @ConsiderUnpostedReceptionInTheMRP
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LowerLimitTolerenceOnAReception', @LowerLimitTolerenceOnAReception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UpperLimitTolerenceOnAReception', @UpperLimitTolerenceOnAReception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse__Reception', @FK_dxWarehouse__Reception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Reception', @FK_dxLocation__Reception
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ManageWOWithReservedArea', @ManageWOWithReservedArea
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'UseCustomMPRProcedure', @UseCustomMPRProcedure
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'LastMRPStartDate', @LastMRPStartDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'LastMRPFinishDate', @LastMRPFinishDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductionTolerance', @ProductionTolerance
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'AccountingStartingPeriod', @AccountingStartingPeriod
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport__ProcessDefault', @FK_dxReport__ProcessDefault
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'TaxesManagedByItem', @TaxesManagedByItem
FETCH NEXT FROM pk_cursordxSetup INTO @PK_dxSetup, @Description, @CompanyName, @LogoAddress, @Note, @FederalRegistrationNumber, @ProvincialRegistrationNumber, @GSTCode, @PSTCode, @DatabaseStructure, @SMTPServer, @Port, @Login, @Password, @OptionHQ, @LockoutUsers, @EmailSalesFromName, @EmailSalesFromMail, @EmailPurchasesFromName, @EmailPurchasesFromMail, @EmailSalesSignature, @EmailPurchasesSignature, @EmailDelayInSecond, @LogonDate, @ControlLicence, @LicenceControl, @LicenceNumber, @FilterOptionNumberOfRecord, @ShippingReleaseDelayInDays, @LowerBoundMRPAnalysisInDays, @LiveInventoryAccountingTransaction, @LiveForeignCurrencyTransaction, @CertificateValidityInSecs, @CustomTransitoryAgent, @ConsiderUnpostedReceptionInTheMRP, @LowerLimitTolerenceOnAReception, @UpperLimitTolerenceOnAReception, @FK_dxWarehouse__Reception, @FK_dxLocation__Reception, @ManageWOWithReservedArea, @UseCustomMPRProcedure, @LastMRPStartDate, @LastMRPFinishDate, @ProductionTolerance, @AccountingStartingPeriod, @FK_dxReport__ProcessDefault, @TaxesManagedByItem
 END

 CLOSE pk_cursordxSetup 
 DEALLOCATE pk_cursordxSetup
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxSetup.trAuditInsUpd] ON [dbo].[dxSetup] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxSetup CURSOR LOCAL FAST_FORWARD for SELECT PK_dxSetup from inserted;
 set @tablename = 'dxSetup' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxSetup
 FETCH NEXT FROM pk_cursordxSetup INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CompanyName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'CompanyName', CompanyName from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LogoAddress )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LogoAddress', LogoAddress from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FederalRegistrationNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'FederalRegistrationNumber', FederalRegistrationNumber from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProvincialRegistrationNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ProvincialRegistrationNumber', ProvincialRegistrationNumber from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( GSTCode )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'GSTCode', GSTCode from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PSTCode )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PSTCode', PSTCode from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DatabaseStructure )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'DatabaseStructure', DatabaseStructure from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SMTPServer )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'SMTPServer', SMTPServer from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Port )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'Port', Port from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Login )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Login', Login from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Password )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Password', Password from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OptionHQ )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'OptionHQ', OptionHQ from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LockoutUsers )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'LockoutUsers', LockoutUsers from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailSalesFromName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesFromName', EmailSalesFromName from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailSalesFromMail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesFromMail', EmailSalesFromMail from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailPurchasesFromName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailPurchasesFromName', EmailPurchasesFromName from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailPurchasesFromMail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailPurchasesFromMail', EmailPurchasesFromMail from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailSalesSignature )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailSalesSignature', EmailSalesSignature from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailPurchasesSignature )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'EmailPurchasesSignature', EmailPurchasesSignature from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EmailDelayInSecond )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'EmailDelayInSecond', EmailDelayInSecond from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LogonDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'LogonDate', LogonDate from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ControlLicence )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ControlLicence', ControlLicence from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LicenceControl )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LicenceControl', LicenceControl from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LicenceNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'LicenceNumber', LicenceNumber from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FilterOptionNumberOfRecord )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FilterOptionNumberOfRecord', FilterOptionNumberOfRecord from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ShippingReleaseDelayInDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ShippingReleaseDelayInDays', ShippingReleaseDelayInDays from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LowerBoundMRPAnalysisInDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'LowerBoundMRPAnalysisInDays', LowerBoundMRPAnalysisInDays from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LiveInventoryAccountingTransaction )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'LiveInventoryAccountingTransaction', LiveInventoryAccountingTransaction from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LiveForeignCurrencyTransaction )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'LiveForeignCurrencyTransaction', LiveForeignCurrencyTransaction from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CertificateValidityInSecs )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'CertificateValidityInSecs', CertificateValidityInSecs from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CustomTransitoryAgent )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'CustomTransitoryAgent', CustomTransitoryAgent from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ConsiderUnpostedReceptionInTheMRP )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ConsiderUnpostedReceptionInTheMRP', ConsiderUnpostedReceptionInTheMRP from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LowerLimitTolerenceOnAReception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LowerLimitTolerenceOnAReception', LowerLimitTolerenceOnAReception from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UpperLimitTolerenceOnAReception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'UpperLimitTolerenceOnAReception', UpperLimitTolerenceOnAReception from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxWarehouse__Reception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxWarehouse__Reception', FK_dxWarehouse__Reception from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxLocation__Reception )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxLocation__Reception', FK_dxLocation__Reception from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ManageWOWithReservedArea )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'ManageWOWithReservedArea', ManageWOWithReservedArea from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( UseCustomMPRProcedure )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'UseCustomMPRProcedure', UseCustomMPRProcedure from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LastMRPStartDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'LastMRPStartDate', LastMRPStartDate from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LastMRPFinishDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'LastMRPFinishDate', LastMRPFinishDate from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ProductionTolerance )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ProductionTolerance', ProductionTolerance from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AccountingStartingPeriod )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'AccountingStartingPeriod', AccountingStartingPeriod from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReport__ProcessDefault )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReport__ProcessDefault', FK_dxReport__ProcessDefault from dxSetup where PK_dxSetup = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TaxesManagedByItem )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'TaxesManagedByItem', TaxesManagedByItem from dxSetup where PK_dxSetup = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxSetup INTO @keyvalue
 END

 CLOSE pk_cursordxSetup 
 DEALLOCATE pk_cursordxSetup
GO
ALTER TABLE [dbo].[dxSetup] ADD CONSTRAINT [PK_dxSetup] PRIMARY KEY CLUSTERED  ([PK_dxSetup]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSetup_FK_dxLocation__Reception] ON [dbo].[dxSetup] ([FK_dxLocation__Reception]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSetup_FK_dxReport__ProcessDefault] ON [dbo].[dxSetup] ([FK_dxReport__ProcessDefault]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxSetup_FK_dxWarehouse__Reception] ON [dbo].[dxSetup] ([FK_dxWarehouse__Reception]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxSetup] ADD CONSTRAINT [dxConstraint_FK_dxLocation__Reception_dxSetup] FOREIGN KEY ([FK_dxLocation__Reception]) REFERENCES [dbo].[dxLocation] ([PK_dxLocation])
GO
ALTER TABLE [dbo].[dxSetup] ADD CONSTRAINT [dxConstraint_FK_dxReport__ProcessDefault_dxSetup] FOREIGN KEY ([FK_dxReport__ProcessDefault]) REFERENCES [dbo].[dxReport] ([PK_dxReport])
GO
ALTER TABLE [dbo].[dxSetup] ADD CONSTRAINT [dxConstraint_FK_dxWarehouse__Reception_dxSetup] FOREIGN KEY ([FK_dxWarehouse__Reception]) REFERENCES [dbo].[dxWarehouse] ([PK_dxWarehouse])
GO
