CREATE TABLE [dbo].[dxDepositDetail]
(
[PK_dxDepositDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxDeposit] [int] NOT NULL,
[FK_dxCashReceipt] [int] NOT NULL,
[Reference] [varchar] (50) COLLATE French_CI_AS NULL,
[TotalAmount] [float] NOT NULL CONSTRAINT [DF_dxDepositDetail_TotalAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDepositDetail.trAuditDelete] ON [dbo].[dxDepositDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxDepositDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxDepositDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDepositDetail, FK_dxDeposit, FK_dxCashReceipt, Reference, TotalAmount from deleted
 Declare @PK_dxDepositDetail int, @FK_dxDeposit int, @FK_dxCashReceipt int, @Reference varchar(50), @TotalAmount Float

 OPEN pk_cursordxDepositDetail
 FETCH NEXT FROM pk_cursordxDepositDetail INTO @PK_dxDepositDetail, @FK_dxDeposit, @FK_dxCashReceipt, @Reference, @TotalAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxDepositDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeposit', @FK_dxDeposit
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCashReceipt', @FK_dxCashReceipt
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', @Reference
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', @TotalAmount
FETCH NEXT FROM pk_cursordxDepositDetail INTO @PK_dxDepositDetail, @FK_dxDeposit, @FK_dxCashReceipt, @Reference, @TotalAmount
 END

 CLOSE pk_cursordxDepositDetail 
 DEALLOCATE pk_cursordxDepositDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDepositDetail.trAuditInsUpd] ON [dbo].[dxDepositDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxDepositDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxDepositDetail from inserted;
 set @tablename = 'dxDepositDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxDepositDetail
 FETCH NEXT FROM pk_cursordxDepositDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxDeposit )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxDeposit', FK_dxDeposit from dxDepositDetail where PK_dxDepositDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxCashReceipt )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxCashReceipt', FK_dxCashReceipt from dxDepositDetail where PK_dxDepositDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Reference )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Reference', Reference from dxDepositDetail where PK_dxDepositDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalAmount', TotalAmount from dxDepositDetail where PK_dxDepositDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxDepositDetail INTO @keyvalue
 END

 CLOSE pk_cursordxDepositDetail 
 DEALLOCATE pk_cursordxDepositDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxDepositDetail.trUpdateSum] ON [dbo].[dxDepositDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  declare @FK int, @FKi int , @FKd int, @TotalAmount float ;
  SET NOCOUNT ON;
  set @FKi  = ( SELECT Coalesce(max(FK_dxDeposit ),-1) from inserted )
  set @FKd  = ( SELECT Coalesce(max(FK_dxDeposit ),-1) from deleted  )
  if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

  set @TotalAmount = ( select Coalesce(Sum(TotalAmount), 0.0) from dxDepositDetail where FK_dxDeposit = @FK )

  update dxDeposit set TotalAmount = @TotalAmount where PK_dxDeposit = @FK ;
  SET NOCOUNT OFF;
END
GO
ALTER TABLE [dbo].[dxDepositDetail] ADD CONSTRAINT [PK_dxDepositDetail] PRIMARY KEY CLUSTERED  ([PK_dxDepositDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDepositDetail_FK_dxCashReceipt] ON [dbo].[dxDepositDetail] ([FK_dxCashReceipt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxDepositDetail_FK_dxDeposit] ON [dbo].[dxDepositDetail] ([FK_dxDeposit]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxDepositDetail] ON [dbo].[dxDepositDetail] ([FK_dxDeposit], [FK_dxCashReceipt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxDepositDetail] ADD CONSTRAINT [dxConstraint_FK_dxCashReceipt_dxDepositDetail] FOREIGN KEY ([FK_dxCashReceipt]) REFERENCES [dbo].[dxCashReceipt] ([PK_dxCashReceipt])
GO
ALTER TABLE [dbo].[dxDepositDetail] ADD CONSTRAINT [dxConstraint_FK_dxDeposit_dxDepositDetail] FOREIGN KEY ([FK_dxDeposit]) REFERENCES [dbo].[dxDeposit] ([PK_dxDeposit])
GO
