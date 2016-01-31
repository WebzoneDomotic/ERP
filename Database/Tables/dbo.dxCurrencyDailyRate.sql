CREATE TABLE [dbo].[dxCurrencyDailyRate]
(
[PK_dxCurrencyDailyRate] [int] NOT NULL IDENTITY(1, 1),
[FK_dxCurrency] [int] NOT NULL,
[RateDate] [datetime] NOT NULL,
[NoonRate] [float] NOT NULL CONSTRAINT [DF_dxCurrencyDailyRate_MoonRate] DEFAULT ((1.0)),
[ClosingRate] [float] NOT NULL CONSTRAINT [DF_dxCurrencyDailyRate_ClosingRate] DEFAULT ((1.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCurrencyDailyRate.trAuditDelete] ON [dbo].[dxCurrencyDailyRate]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCurrencyDailyRate'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCurrencyDailyRate CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCurrencyDailyRate, FK_dxCurrency, RateDate, NoonRate, ClosingRate from deleted
 Declare @PK_dxCurrencyDailyRate int, @FK_dxCurrency int, @RateDate DateTime, @NoonRate Float, @ClosingRate Float

 OPEN pk_cursordxCurrencyDailyRate
 FETCH NEXT FROM pk_cursordxCurrencyDailyRate INTO @PK_dxCurrencyDailyRate, @FK_dxCurrency, @RateDate, @NoonRate, @ClosingRate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCurrencyDailyRate, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'RateDate', @RateDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NoonRate', @NoonRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ClosingRate', @ClosingRate
FETCH NEXT FROM pk_cursordxCurrencyDailyRate INTO @PK_dxCurrencyDailyRate, @FK_dxCurrency, @RateDate, @NoonRate, @ClosingRate
 END

 CLOSE pk_cursordxCurrencyDailyRate 
 DEALLOCATE pk_cursordxCurrencyDailyRate
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCurrencyDailyRate.trAuditInsUpd] ON [dbo].[dxCurrencyDailyRate] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCurrencyDailyRate CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCurrencyDailyRate from inserted;
 set @tablename = 'dxCurrencyDailyRate' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCurrencyDailyRate
 FETCH NEXT FROM pk_cursordxCurrencyDailyRate INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxCurrencyDailyRate where PK_dxCurrencyDailyRate = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RateDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'RateDate', RateDate from dxCurrencyDailyRate where PK_dxCurrencyDailyRate = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NoonRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NoonRate', NoonRate from dxCurrencyDailyRate where PK_dxCurrencyDailyRate = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ClosingRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ClosingRate', ClosingRate from dxCurrencyDailyRate where PK_dxCurrencyDailyRate = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCurrencyDailyRate INTO @keyvalue
 END

 CLOSE pk_cursordxCurrencyDailyRate 
 DEALLOCATE pk_cursordxCurrencyDailyRate
GO
ALTER TABLE [dbo].[dxCurrencyDailyRate] ADD CONSTRAINT [PK_dxCurrencyDailyRate] PRIMARY KEY CLUSTERED  ([PK_dxCurrencyDailyRate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrencyDailyRate_FK_dxCurrency] ON [dbo].[dxCurrencyDailyRate] ([FK_dxCurrency]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCurrencyDailyRate] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxCurrencyDailyRate] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
