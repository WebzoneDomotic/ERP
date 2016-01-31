CREATE TABLE [dbo].[dxAccrualPayableCorrection]
(
[PK_dxAccrualPayableCorrection] [int] NOT NULL IDENTITY(1, 1),
[FK_dxReceptionDetail] [int] NULL,
[FK_dxPayableInvoiceDetail] [int] NULL,
[CorrectionDate] [datetime] NOT NULL,
[Description] [varchar] (2000) COLLATE French_CI_AS NULL,
[Note] [varchar] (2000) COLLATE French_CI_AS NOT NULL,
[Amount] [float] NOT NULL CONSTRAINT [DF_dxAccrualPayableCorrection_Amount] DEFAULT ((0.0)),
[FK_dxCurrency] [int] NOT NULL,
[FK_dxAccount__Imputation] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccrualPayableCorrection.trAuditDelete] ON [dbo].[dxAccrualPayableCorrection]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxAccrualPayableCorrection'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxAccrualPayableCorrection CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccrualPayableCorrection, FK_dxReceptionDetail, FK_dxPayableInvoiceDetail, CorrectionDate, Description, Note, Amount, FK_dxCurrency, FK_dxAccount__Imputation from deleted
 Declare @PK_dxAccrualPayableCorrection int, @FK_dxReceptionDetail int, @FK_dxPayableInvoiceDetail int, @CorrectionDate DateTime, @Description varchar(2000), @Note varchar(2000), @Amount Float, @FK_dxCurrency int, @FK_dxAccount__Imputation int

 OPEN pk_cursordxAccrualPayableCorrection
 FETCH NEXT FROM pk_cursordxAccrualPayableCorrection INTO @PK_dxAccrualPayableCorrection, @FK_dxReceptionDetail, @FK_dxPayableInvoiceDetail, @CorrectionDate, @Description, @Note, @Amount, @FK_dxCurrency, @FK_dxAccount__Imputation
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxAccrualPayableCorrection, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReceptionDetail', @FK_dxReceptionDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoiceDetail', @FK_dxPayableInvoiceDetail
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'CorrectionDate', @CorrectionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', @Note
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', @Amount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', @FK_dxCurrency
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Imputation', @FK_dxAccount__Imputation
FETCH NEXT FROM pk_cursordxAccrualPayableCorrection INTO @PK_dxAccrualPayableCorrection, @FK_dxReceptionDetail, @FK_dxPayableInvoiceDetail, @CorrectionDate, @Description, @Note, @Amount, @FK_dxCurrency, @FK_dxAccount__Imputation
 END

 CLOSE pk_cursordxAccrualPayableCorrection 
 DEALLOCATE pk_cursordxAccrualPayableCorrection
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxAccrualPayableCorrection.trAuditInsUpd] ON [dbo].[dxAccrualPayableCorrection] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxAccrualPayableCorrection CURSOR LOCAL FAST_FORWARD for SELECT PK_dxAccrualPayableCorrection from inserted;
 set @tablename = 'dxAccrualPayableCorrection' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxAccrualPayableCorrection
 FETCH NEXT FROM pk_cursordxAccrualPayableCorrection INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxReceptionDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxReceptionDetail', FK_dxReceptionDetail from dxAccrualPayableCorrection where PK_dxAccrualPayableCorrection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayableInvoiceDetail )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayableInvoiceDetail', FK_dxPayableInvoiceDetail from dxAccrualPayableCorrection where PK_dxAccrualPayableCorrection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CorrectionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'CorrectionDate', CorrectionDate from dxAccrualPayableCorrection where PK_dxAccrualPayableCorrection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxAccrualPayableCorrection where PK_dxAccrualPayableCorrection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Note )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Note', Note from dxAccrualPayableCorrection where PK_dxAccrualPayableCorrection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Amount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Amount', Amount from dxAccrualPayableCorrection where PK_dxAccrualPayableCorrection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCurrency )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCurrency', FK_dxCurrency from dxAccrualPayableCorrection where PK_dxAccrualPayableCorrection = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount__Imputation )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount__Imputation', FK_dxAccount__Imputation from dxAccrualPayableCorrection where PK_dxAccrualPayableCorrection = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxAccrualPayableCorrection INTO @keyvalue
 END

 CLOSE pk_cursordxAccrualPayableCorrection 
 DEALLOCATE pk_cursordxAccrualPayableCorrection
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create TRIGGER [dbo].[dxAccrualPayableCorrection.trInsertAccountTransaction] ON [dbo].[dxAccrualPayableCorrection]
AFTER INSERT
AS
BEGIN

  -- Create Entry number for this document
  Insert into dxEntry ( KindOfDocument,  PrimaryKeyValue )
  select (Case when ei.FK_dxReceptionDetail is null and ei.FK_dxPayableInvoiceDetail is null then 22 else 23 end) , ei.PK_dxAccrualPayableCorrection from inserted ei
  where ( not exists ( select 1 from dxEntry en
                        where en.KindOfDocument =(Case when ei.FK_dxReceptionDetail is null and ei.FK_dxPayableInvoiceDetail is null then 22 else 23 end)
                          and en.PrimaryKeyValue = ei.PK_dxAccrualPayableCorrection))

  -- First leg reverse the accrual amount
  Insert into dxAccountTransaction (
               FK_dxEntry
             , TransactionDate
             , FK_dxJournal
             , FK_dxPeriod
             , FK_dxAccount
             , Description
             , DT
             , CT
             , FK_dxCurrency
             , KindOfDocument
             , KEY_dxReceptionDetail
             , FK_dxPayableInvoiceDetail
             , FK_dxAccrualPayableCorrection
             , PrimaryKeyValue )
      Select
             en.PK_dxEntry
            ,ei.CorrectionDate
            ,76
            ,pe.PK_dxPeriod
            ,cu.FK_dxAccount__PayableAccrual
            ,left('Accrual Correction '+ei.description,100)
            ,dbo.fdxDT( ei.Amount )
            ,dbo.fdxCT( ei.Amount )
            ,ei.FK_dxCurrency
            ,en.KindOfDocument
            ,ei.FK_dxReceptionDetail
            ,ei.FK_dxPayableInvoiceDetail
            ,ei.PK_dxAccrualPayableCorrection
            ,ei.PK_dxAccrualPayableCorrection
      From inserted ei
      left join dxEntry     en on ( en.KindOfDocument = (Case when ei.FK_dxReceptionDetail is null and ei.FK_dxPayableInvoiceDetail is null then 22 else 23 end) and en.PrimaryKeyValue = ei.PK_dxAccrualPayableCorrection )
      left join dxPeriod    pe on ( ei.CorrectionDate between pe.StartDate and pe.EndDate)
      left join dxCurrency  cu on ( cu.PK_dxCurrency = ei.FK_dxCurrency )

  -- Second led with imputation amount
  Insert into dxAccountTransaction (
               FK_dxEntry
             , TransactionDate
             , FK_dxJournal
             , FK_dxPeriod
             , FK_dxAccount
             , Description
             , DT
             , CT
             , FK_dxCurrency
             , KindOfDocument
             , KEY_dxReceptionDetail
             , FK_dxPayableInvoiceDetail
             , FK_dxAccrualPayableCorrection
             , PrimaryKeyValue )
      Select
             en.PK_dxEntry
            ,ei.CorrectionDate
            ,76
            ,pe.PK_dxPeriod
            ,ei.FK_dxAccount__Imputation
            ,left('Accrual Correction '+ei.description,100)
            ,dbo.fdxCT( ei.Amount )
            ,dbo.fdxDT( ei.Amount )
            ,ei.FK_dxCurrency
            ,en.KindOfDocument
            ,ei.FK_dxReceptionDetail
            ,ei.FK_dxPayableInvoiceDetail
            ,ei.PK_dxAccrualPayableCorrection
            ,ei.PK_dxAccrualPayableCorrection
      From inserted ei
      left join dxEntry     en on ( en.KindOfDocument = (Case when ei.FK_dxReceptionDetail is null and ei.FK_dxPayableInvoiceDetail is null then 22 else 23 end) and en.PrimaryKeyValue = ei.PK_dxAccrualPayableCorrection )
      left join dxPeriod    pe on ( ei.CorrectionDate between pe.StartDate and pe.EndDate)
      left join dxCurrency  cu on ( cu.PK_dxCurrency = ei.FK_dxCurrency )

      Exec [dbo].[pdxUpdateAccountPeriod]

END
GO
ALTER TABLE [dbo].[dxAccrualPayableCorrection] ADD CONSTRAINT [PK_dxAccrualPayableCorrection] PRIMARY KEY CLUSTERED  ([PK_dxAccrualPayableCorrection]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccrualPayableCorrection_FK_dxAccount__Imputation] ON [dbo].[dxAccrualPayableCorrection] ([FK_dxAccount__Imputation]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccrualPayableCorrection_FK_dxCurrency] ON [dbo].[dxAccrualPayableCorrection] ([FK_dxCurrency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccrualPayableCorrection_FK_dxPayableInvoiceDetail] ON [dbo].[dxAccrualPayableCorrection] ([FK_dxPayableInvoiceDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxAccrualPayableCorrection_FK_dxReceptionDetail] ON [dbo].[dxAccrualPayableCorrection] ([FK_dxReceptionDetail]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxAccrualPayableCorrection] ADD CONSTRAINT [dxConstraint_FK_dxAccount__Imputation_dxAccrualPayableCorrection] FOREIGN KEY ([FK_dxAccount__Imputation]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxAccrualPayableCorrection] ADD CONSTRAINT [dxConstraint_FK_dxCurrency_dxAccrualPayableCorrection] FOREIGN KEY ([FK_dxCurrency]) REFERENCES [dbo].[dxCurrency] ([PK_dxCurrency])
GO
ALTER TABLE [dbo].[dxAccrualPayableCorrection] ADD CONSTRAINT [dxConstraint_FK_dxPayableInvoiceDetail_dxAccrualPayableCorrection] FOREIGN KEY ([FK_dxPayableInvoiceDetail]) REFERENCES [dbo].[dxPayableInvoiceDetail] ([PK_dxPayableInvoiceDetail])
GO
ALTER TABLE [dbo].[dxAccrualPayableCorrection] ADD CONSTRAINT [dxConstraint_FK_dxReceptionDetail_dxAccrualPayableCorrection] FOREIGN KEY ([FK_dxReceptionDetail]) REFERENCES [dbo].[dxReceptionDetail] ([PK_dxReceptionDetail])
GO
