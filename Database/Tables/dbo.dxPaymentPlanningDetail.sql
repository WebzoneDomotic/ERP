CREATE TABLE [dbo].[dxPaymentPlanningDetail]
(
[PK_dxPaymentPlanningDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPaymentPlanning] [int] NOT NULL,
[Approuved] [bit] NOT NULL CONSTRAINT [DF_PaymentPlanningDetail_Approuved] DEFAULT ((0)),
[FK_dxVendor] [int] NOT NULL,
[FK_dxPayableInvoice] [int] NOT NULL,
[InvoiceDate] [datetime] NOT NULL,
[SuggestPaymentDate] [datetime] NOT NULL,
[NumberOfDays] [int] NOT NULL CONSTRAINT [DF_PaymentPlanningDetail_NumberOfDay] DEFAULT ((0)),
[ActualBalanceAmount] [float] NOT NULL CONSTRAINT [DF_PaymentPlanningDetail_ActualBalanceAmount] DEFAULT ((0.0)),
[AmountToPay] [float] NOT NULL CONSTRAINT [DF_PaymentPlanningDetail_AmountToPay] DEFAULT ((0.0)),
[FK_dxCurrency] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentPlanningDetail.trAuditDelete] ON [dbo].[dxPaymentPlanningDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPaymentPlanningDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPaymentPlanningDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentPlanningDetail, FK_dxPaymentPlanning, Approuved, FK_dxVendor, FK_dxPayableInvoice, InvoiceDate, SuggestPaymentDate, NumberOfDays, ActualBalanceAmount, AmountToPay, FK_dxCurrency from deleted
 Declare @PK_dxPaymentPlanningDetail int, @FK_dxPaymentPlanning int, @Approuved Bit, @FK_dxVendor int, @FK_dxPayableInvoice int, @InvoiceDate DateTime, @SuggestPaymentDate DateTime, @NumberOfDays int, @ActualBalanceAmount Float, @AmountToPay Float, @FK_dxCurrency int

 OPEN pk_cursordxPaymentPlanningDetail
 FETCH NEXT FROM pk_cursordxPaymentPlanningDetail INTO @PK_dxPaymentPlanningDetail, @FK_dxPaymentPlanning, @Approuved, @FK_dxVendor, @FK_dxPayableInvoice, @InvoiceDate, @SuggestPaymentDate, @NumberOfDays, @ActualBalanceAmount, @AmountToPay, @FK_dxCurrency
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPaymentPlanningDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentPlanning', @FK_dxPaymentPlanning
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Approuved', @Approuved
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', @FK_dxVendor
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoice', @FK_dxPayableInvoice
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InvoiceDate', @InvoiceDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestPaymentDate', @SuggestPaymentDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfDays', @NumberOfDays
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ActualBalanceAmount', @ActualBalanceAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AmountToPay', @AmountToPay
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
FETCH NEXT FROM pk_cursordxPaymentPlanningDetail INTO @PK_dxPaymentPlanningDetail, @FK_dxPaymentPlanning, @Approuved, @FK_dxVendor, @FK_dxPayableInvoice, @InvoiceDate, @SuggestPaymentDate, @NumberOfDays, @ActualBalanceAmount, @AmountToPay, @FK_dxCurrency
 END

 CLOSE pk_cursordxPaymentPlanningDetail 
 DEALLOCATE pk_cursordxPaymentPlanningDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentPlanningDetail.trAuditInsUpd] ON [dbo].[dxPaymentPlanningDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPaymentPlanningDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPaymentPlanningDetail from inserted;
 set @tablename = 'dxPaymentPlanningDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPaymentPlanningDetail
 FETCH NEXT FROM pk_cursordxPaymentPlanningDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPaymentPlanning )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPaymentPlanning', FK_dxPaymentPlanning from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Approuved )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Approuved', Approuved from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxVendor )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxVendor', FK_dxVendor from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayableInvoice )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoice', FK_dxPayableInvoice from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InvoiceDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InvoiceDate', InvoiceDate from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SuggestPaymentDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'SuggestPaymentDate', SuggestPaymentDate from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NumberOfDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'NumberOfDays', NumberOfDays from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ActualBalanceAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'ActualBalanceAmount', ActualBalanceAmount from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AmountToPay )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AmountToPay', AmountToPay from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxPaymentPlanningDetail where PK_dxPaymentPlanningDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPaymentPlanningDetail INTO @keyvalue
 END

 CLOSE pk_cursordxPaymentPlanningDetail 
 DEALLOCATE pk_cursordxPaymentPlanningDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPaymentPlanningDetail.trUpdateSum] ON [dbo].[dxPaymentPlanningDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  declare @FK int, @FKi int , @FKd int, @NbCheque int, @ApprouvedAmount float ;
  set @FKi  = ( SELECT Coalesce(max(FK_dxPaymentPlanning ),-1) from inserted )
  set @FKd  = ( SELECT Coalesce(max(FK_dxPaymentPlanning ),-1) from deleted  )
  if (@FKi < @FKd) set @FK = @FKd else set @FK = @FKi

  set @NbCheque =  (Select Count(*) from ( Select Distinct FK_dxVendor from dxPaymentPlanningDetail
                     where FK_dxPaymentPlanning = @FK and Approuved = 1  ) as DerivedTable )
  if @NbCheque is null set @NbCheque = 0

  update dxPaymentPlanning set
     NumberOfChequeToDo    = @NbCheque ,
     TotalAmount           = ( select Coalesce(sum( AmountToPay ), 0.0) from dxPaymentPlanningDetail where FK_dxPaymentPlanning = @FK  ) ,
     ApprouvedTotalAmount  = ( select Coalesce(sum( AmountToPay ), 0.0) from dxPaymentPlanningDetail where FK_dxPaymentPlanning = @FK and Approuved = 1 )
  where PK_dxPaymentPlanning = @FK ;
END
GO
ALTER TABLE [dbo].[dxPaymentPlanningDetail] ADD CONSTRAINT [PK_PaymentPlanningDetail] PRIMARY KEY CLUSTERED  ([PK_dxPaymentPlanningDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentPlanningDetail_FK_dxCurrency] ON [dbo].[dxPaymentPlanningDetail] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentPlanningDetail_FK_dxPayableInvoice] ON [dbo].[dxPaymentPlanningDetail] ([FK_dxPayableInvoice]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentPlanningDetail_FK_dxPaymentPlanning] ON [dbo].[dxPaymentPlanningDetail] ([FK_dxPaymentPlanning]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPaymentPlanningDetail_FK_dxVendor] ON [dbo].[dxPaymentPlanningDetail] ([FK_dxVendor]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPaymentPlanningDetail] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxPaymentPlanningDetail] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxPaymentPlanningDetail] ADD CONSTRAINT [dxConstraint_FK_dxPayableInvoice_dxPaymentPlanningDetail] FOREIGN KEY ([FK_dxPayableInvoice]) REFERENCES [dbo].[dxPayableInvoice] ([PK_dxPayableInvoice])
GO
ALTER TABLE [dbo].[dxPaymentPlanningDetail] ADD CONSTRAINT [dxConstraint_FK_dxPaymentPlanning_dxPaymentPlanningDetail] FOREIGN KEY ([FK_dxPaymentPlanning]) REFERENCES [dbo].[dxPaymentPlanning] ([PK_dxPaymentPlanning])
GO
ALTER TABLE [dbo].[dxPaymentPlanningDetail] ADD CONSTRAINT [dxConstraint_FK_dxVendor_dxPaymentPlanningDetail] FOREIGN KEY ([FK_dxVendor]) REFERENCES [dbo].[dxVendor] ([PK_dxVendor])
GO
