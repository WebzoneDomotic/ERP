CREATE TABLE [dbo].[dxPayDetail]
(
[PK_dxPayDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPay] [int] NOT NULL,
[FK_dxPayCode] [int] NOT NULL,
[Value] [float] NOT NULL CONSTRAINT [DF_dxPayDetail_Value] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayDetail.trAuditDelete] ON [dbo].[dxPayDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPayDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPayDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayDetail, FK_dxPay, FK_dxPayCode, Value from deleted
 Declare @PK_dxPayDetail int, @FK_dxPay int, @FK_dxPayCode int, @Value Float

 OPEN pk_cursordxPayDetail
 FETCH NEXT FROM pk_cursordxPayDetail INTO @PK_dxPayDetail, @FK_dxPay, @FK_dxPayCode, @Value
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPayDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPay', @FK_dxPay
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayCode', @FK_dxPayCode
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Value', @Value
FETCH NEXT FROM pk_cursordxPayDetail INTO @PK_dxPayDetail, @FK_dxPay, @FK_dxPayCode, @Value
 END

 CLOSE pk_cursordxPayDetail 
 DEALLOCATE pk_cursordxPayDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayDetail.trAuditInsUpd] ON [dbo].[dxPayDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPayDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayDetail from inserted;
 set @tablename = 'dxPayDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPayDetail
 FETCH NEXT FROM pk_cursordxPayDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPay )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPay', FK_dxPay from dxPayDetail where PK_dxPayDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPayCode )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPayCode', FK_dxPayCode from dxPayDetail where PK_dxPayDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Value )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Value', Value from dxPayDetail where PK_dxPayDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPayDetail INTO @keyvalue
 END

 CLOSE pk_cursordxPayDetail 
 DEALLOCATE pk_cursordxPayDetail
GO
ALTER TABLE [dbo].[dxPayDetail] ADD CONSTRAINT [PK_dxPayDetail] PRIMARY KEY CLUSTERED  ([PK_dxPayDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayDetail_FK_dxPay] ON [dbo].[dxPayDetail] ([FK_dxPay]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPayDetail_FK_dxPayCode] ON [dbo].[dxPayDetail] ([FK_dxPayCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPayDetail] ADD CONSTRAINT [dxConstraint_FK_dxPay_dxPayDetail] FOREIGN KEY ([FK_dxPay]) REFERENCES [dbo].[dxPay] ([PK_dxPay])
GO
ALTER TABLE [dbo].[dxPayDetail] ADD CONSTRAINT [dxConstraint_FK_dxPayCode_dxPayDetail] FOREIGN KEY ([FK_dxPayCode]) REFERENCES [dbo].[dxPayCode] ([PK_dxPayCode])
GO
