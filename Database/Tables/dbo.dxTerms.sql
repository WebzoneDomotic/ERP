CREATE TABLE [dbo].[dxTerms]
(
[PK_dxTerms] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[CreditCard] [bit] NOT NULL CONSTRAINT [DF_dxTerms_CreditCard] DEFAULT ((0)),
[TermsDiscountDays] [int] NOT NULL CONSTRAINT [DF_dxTerms_TermsDiscountDays] DEFAULT ((0)),
[TermsDiscount] [float] NOT NULL CONSTRAINT [DF_dxTerms_TermsDiscount] DEFAULT ((0)),
[TermsDueDays] [int] NOT NULL CONSTRAINT [DF_dxTerms_TermsDueDays] DEFAULT ((0)),
[TermsDueRate] [float] NOT NULL CONSTRAINT [DF_dxTerms_TermsDueRate] DEFAULT ((0)),
[DueDaysMatchNextCalendarDay] [bit] NOT NULL CONSTRAINT [DF_dxTerms_DueDayMatchNextCalendarDay] DEFAULT ((0)),
[DiscountDaysMatchNextCalendarDay] [bit] NOT NULL CONSTRAINT [DF_dxTerms_DiscountDaysMatchNextCalendarDay] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_dxTerms_Active] DEFAULT ((1)),
[FK_dxPaymentType] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTerms.trAuditDelete] ON [dbo].[dxTerms]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxTerms'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxTerms CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTerms, ID, Description, CreditCard, TermsDiscountDays, TermsDiscount, TermsDueDays, TermsDueRate, DueDaysMatchNextCalendarDay, DiscountDaysMatchNextCalendarDay, Active, FK_dxPaymentType from deleted
 Declare @PK_dxTerms int, @ID varchar(50), @Description varchar(255), @CreditCard Bit, @TermsDiscountDays int, @TermsDiscount Float, @TermsDueDays int, @TermsDueRate Float, @DueDaysMatchNextCalendarDay Bit, @DiscountDaysMatchNextCalendarDay Bit, @Active Bit, @FK_dxPaymentType int

 OPEN pk_cursordxTerms
 FETCH NEXT FROM pk_cursordxTerms INTO @PK_dxTerms, @ID, @Description, @CreditCard, @TermsDiscountDays, @TermsDiscount, @TermsDueDays, @TermsDueRate, @DueDaysMatchNextCalendarDay, @DiscountDaysMatchNextCalendarDay, @Active, @FK_dxPaymentType
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxTerms, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'CreditCard', @CreditCard
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'TermsDiscountDays', @TermsDiscountDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsDiscount', @TermsDiscount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'TermsDueDays', @TermsDueDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsDueRate', @TermsDueRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DueDaysMatchNextCalendarDay', @DueDaysMatchNextCalendarDay
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DiscountDaysMatchNextCalendarDay', @DiscountDaysMatchNextCalendarDay
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', @FK_dxPaymentType
FETCH NEXT FROM pk_cursordxTerms INTO @PK_dxTerms, @ID, @Description, @CreditCard, @TermsDiscountDays, @TermsDiscount, @TermsDueDays, @TermsDueRate, @DueDaysMatchNextCalendarDay, @DiscountDaysMatchNextCalendarDay, @Active, @FK_dxPaymentType
 END

 CLOSE pk_cursordxTerms 
 DEALLOCATE pk_cursordxTerms
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTerms.trAuditInsUpd] ON [dbo].[dxTerms] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxTerms CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTerms from inserted;
 set @tablename = 'dxTerms' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxTerms
 FETCH NEXT FROM pk_cursordxTerms INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CreditCard )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'CreditCard', CreditCard from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TermsDiscountDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'TermsDiscountDays', TermsDiscountDays from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TermsDiscount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsDiscount', TermsDiscount from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TermsDueDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'TermsDueDays', TermsDueDays from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TermsDueRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TermsDueRate', TermsDueRate from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DueDaysMatchNextCalendarDay )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DueDaysMatchNextCalendarDay', DueDaysMatchNextCalendarDay from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DiscountDaysMatchNextCalendarDay )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'DiscountDaysMatchNextCalendarDay', DiscountDaysMatchNextCalendarDay from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxTerms where PK_dxTerms = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentType', FK_dxPaymentType from dxTerms where PK_dxTerms = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxTerms INTO @keyvalue
 END

 CLOSE pk_cursordxTerms 
 DEALLOCATE pk_cursordxTerms
GO
ALTER TABLE [dbo].[dxTerms] ADD CONSTRAINT [PK_dxTerms] PRIMARY KEY CLUSTERED  ([PK_dxTerms]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTerms_FK_dxPaymentType] ON [dbo].[dxTerms] ([FK_dxPaymentType]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxTerms] ON [dbo].[dxTerms] ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxTerms] ADD CONSTRAINT [dxConstraint_FK_dxPaymentType_dxTerms] FOREIGN KEY ([FK_dxPaymentType]) REFERENCES [dbo].[dxPaymentType] ([PK_dxPaymentType])
GO
