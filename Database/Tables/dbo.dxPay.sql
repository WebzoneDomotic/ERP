CREATE TABLE [dbo].[dxPay]
(
[PK_dxPay] [int] NOT NULL IDENTITY(1, 1),
[FK_dxEmployee] [int] NOT NULL,
[FK_dxPayPeriod] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPay.trAuditDelete] ON [dbo].[dxPay]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPay'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPay CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPay, FK_dxEmployee, FK_dxPayPeriod from deleted
 Declare @PK_dxPay int, @FK_dxEmployee int, @FK_dxPayPeriod int

 OPEN pk_cursordxPay
 FETCH NEXT FROM pk_cursordxPay INTO @PK_dxPay, @FK_dxEmployee, @FK_dxPayPeriod
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPay, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', @FK_dxEmployee
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayPeriod', @FK_dxPayPeriod
FETCH NEXT FROM pk_cursordxPay INTO @PK_dxPay, @FK_dxEmployee, @FK_dxPayPeriod
 END

 CLOSE pk_cursordxPay 
 DEALLOCATE pk_cursordxPay
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPay.trAuditInsUpd] ON [dbo].[dxPay] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPay CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPay from inserted;
 set @tablename = 'dxPay' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPay
 FETCH NEXT FROM pk_cursordxPay INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEmployee )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEmployee', FK_dxEmployee from dxPay where PK_dxPay = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayPeriod )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayPeriod', FK_dxPayPeriod from dxPay where PK_dxPay = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPay INTO @keyvalue
 END

 CLOSE pk_cursordxPay 
 DEALLOCATE pk_cursordxPay
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPay.trInsertDefaultPayDetail] ON [dbo].[dxPay]
AFTER INSERT
AS
BEGIN
   INSERT INTO dxPayDetail (FK_dxPay, FK_dxPayCode) SELECT ins.PK_dxPay, pc.PK_dxPayCode FROM inserted ins, dxPayCode pc where pc.PayDetailDefault = 1
END
GO
ALTER TABLE [dbo].[dxPay] ADD CONSTRAINT [PK_dxPay] PRIMARY KEY CLUSTERED  ([PK_dxPay]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPay_FK_dxEmployee] ON [dbo].[dxPay] ([FK_dxEmployee]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPay_FK_dxPayPeriod] ON [dbo].[dxPay] ([FK_dxPayPeriod]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPay] ADD CONSTRAINT [dxConstraint_FK_dxEmployee_dxPay] FOREIGN KEY ([FK_dxEmployee]) REFERENCES [dbo].[dxEmployee] ([PK_dxEmployee])
GO
ALTER TABLE [dbo].[dxPay] ADD CONSTRAINT [dxConstraint_FK_dxPayPeriod_dxPay] FOREIGN KEY ([FK_dxPayPeriod]) REFERENCES [dbo].[dxPayPeriod] ([PK_dxPayPeriod])
GO
