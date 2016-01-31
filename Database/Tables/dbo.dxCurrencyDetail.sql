CREATE TABLE [dbo].[dxCurrencyDetail]
(
[PK_dxCurrencyDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxCurrency] [int] NOT NULL,
[FK_dxPeriod] [int] NOT NULL,
[AverageRate] [float] NOT NULL CONSTRAINT [DF_dxCurrencyDetail_AverageRate] DEFAULT ((1.0)),
[ClosingRate] [float] NOT NULL CONSTRAINT [DF_dxCurrencyDetail_ClosingRate] DEFAULT ((1.0)),
[NegotiatedAverageRate] [float] NOT NULL CONSTRAINT [DF_dxCurrencyDetail_NegotiatedAverageRate] DEFAULT ((1.0)),
[NegotiatedClosingRate] [float] NOT NULL CONSTRAINT [DF_dxCurrencyDetail_NegotiatedClosingRate] DEFAULT ((1.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCurrencyDetail.trAuditDelete] ON [dbo].[dxCurrencyDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCurrencyDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCurrencyDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCurrencyDetail, FK_dxCurrency, FK_dxPeriod, AverageRate, ClosingRate, NegotiatedAverageRate, NegotiatedClosingRate from deleted
 Declare @PK_dxCurrencyDetail int, @FK_dxCurrency int, @FK_dxPeriod int, @AverageRate Float, @ClosingRate Float, @NegotiatedAverageRate Float, @NegotiatedClosingRate Float

 OPEN pk_cursordxCurrencyDetail
 FETCH NEXT FROM pk_cursordxCurrencyDetail INTO @PK_dxCurrencyDetail, @FK_dxCurrency, @FK_dxPeriod, @AverageRate, @ClosingRate, @NegotiatedAverageRate, @NegotiatedClosingRate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCurrencyDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPeriod', @FK_dxPeriod
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AverageRate', @AverageRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ClosingRate', @ClosingRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NegotiatedAverageRate', @NegotiatedAverageRate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NegotiatedClosingRate', @NegotiatedClosingRate
FETCH NEXT FROM pk_cursordxCurrencyDetail INTO @PK_dxCurrencyDetail, @FK_dxCurrency, @FK_dxPeriod, @AverageRate, @ClosingRate, @NegotiatedAverageRate, @NegotiatedClosingRate
 END

 CLOSE pk_cursordxCurrencyDetail 
 DEALLOCATE pk_cursordxCurrencyDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCurrencyDetail.trAuditInsUpd] ON [dbo].[dxCurrencyDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCurrencyDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCurrencyDetail from inserted;
 set @tablename = 'dxCurrencyDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCurrencyDetail
 FETCH NEXT FROM pk_cursordxCurrencyDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxCurrencyDetail where PK_dxCurrencyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPeriod )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPeriod', FK_dxPeriod from dxCurrencyDetail where PK_dxCurrencyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AverageRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AverageRate', AverageRate from dxCurrencyDetail where PK_dxCurrencyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ClosingRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ClosingRate', ClosingRate from dxCurrencyDetail where PK_dxCurrencyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NegotiatedAverageRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NegotiatedAverageRate', NegotiatedAverageRate from dxCurrencyDetail where PK_dxCurrencyDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NegotiatedClosingRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NegotiatedClosingRate', NegotiatedClosingRate from dxCurrencyDetail where PK_dxCurrencyDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCurrencyDetail INTO @keyvalue
 END

 CLOSE pk_cursordxCurrencyDetail 
 DEALLOCATE pk_cursordxCurrencyDetail
GO
ALTER TABLE [dbo].[dxCurrencyDetail] ADD CONSTRAINT [PK_dxCurrencyDetail] PRIMARY KEY CLUSTERED  ([PK_dxCurrencyDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrencyDetail_FK_dxCurrency] ON [dbo].[dxCurrencyDetail] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxCurrencyDetail] ON [dbo].[dxCurrencyDetail] ([FK_dxCurrency], [FK_dxPeriod]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxCurrencyDetail_FK_dxPeriod] ON [dbo].[dxCurrencyDetail] ([FK_dxPeriod]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxCurrencyDetail] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxCurrencyDetail] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxCurrencyDetail] ADD CONSTRAINT [dxConstraint_FK_dxPeriod_dxCurrencyDetail] FOREIGN KEY ([FK_dxPeriod]) REFERENCES [dbo].[dxPeriod] ([PK_dxPeriod])
GO
