CREATE TABLE [dbo].[dxCreditApprobation]
(
[PK_dxCreditApprobation] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[OrderOverTotalAmount] [float] NULL,
[CurrentOrdersOverTotalAmount] [float] NULL,
[OverdueAccountTotalAmount] [float] NULL,
[OverdueAccountInDays] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCreditApprobation.trAuditDelete] ON [dbo].[dxCreditApprobation]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxCreditApprobation'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxCreditApprobation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCreditApprobation, ID, Description, OrderOverTotalAmount, CurrentOrdersOverTotalAmount, OverdueAccountTotalAmount, OverdueAccountInDays from deleted
 Declare @PK_dxCreditApprobation int, @ID varchar(50), @Description varchar(255), @OrderOverTotalAmount Float, @CurrentOrdersOverTotalAmount Float, @OverdueAccountTotalAmount Float, @OverdueAccountInDays int

 OPEN pk_cursordxCreditApprobation
 FETCH NEXT FROM pk_cursordxCreditApprobation INTO @PK_dxCreditApprobation, @ID, @Description, @OrderOverTotalAmount, @CurrentOrdersOverTotalAmount, @OverdueAccountTotalAmount, @OverdueAccountInDays
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxCreditApprobation, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderOverTotalAmount', @OrderOverTotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CurrentOrdersOverTotalAmount', @CurrentOrdersOverTotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverdueAccountTotalAmount', @OverdueAccountTotalAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'OverdueAccountInDays', @OverdueAccountInDays
FETCH NEXT FROM pk_cursordxCreditApprobation INTO @PK_dxCreditApprobation, @ID, @Description, @OrderOverTotalAmount, @CurrentOrdersOverTotalAmount, @OverdueAccountTotalAmount, @OverdueAccountInDays
 END

 CLOSE pk_cursordxCreditApprobation 
 DEALLOCATE pk_cursordxCreditApprobation
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxCreditApprobation.trAuditInsUpd] ON [dbo].[dxCreditApprobation] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxCreditApprobation CURSOR LOCAL FAST_FORWARD for SELECT PK_dxCreditApprobation from inserted;
 set @tablename = 'dxCreditApprobation' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxCreditApprobation
 FETCH NEXT FROM pk_cursordxCreditApprobation INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxCreditApprobation where PK_dxCreditApprobation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxCreditApprobation where PK_dxCreditApprobation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OrderOverTotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OrderOverTotalAmount', OrderOverTotalAmount from dxCreditApprobation where PK_dxCreditApprobation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CurrentOrdersOverTotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CurrentOrdersOverTotalAmount', CurrentOrdersOverTotalAmount from dxCreditApprobation where PK_dxCreditApprobation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OverdueAccountTotalAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OverdueAccountTotalAmount', OverdueAccountTotalAmount from dxCreditApprobation where PK_dxCreditApprobation = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OverdueAccountInDays )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'OverdueAccountInDays', OverdueAccountInDays from dxCreditApprobation where PK_dxCreditApprobation = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxCreditApprobation INTO @keyvalue
 END

 CLOSE pk_cursordxCreditApprobation 
 DEALLOCATE pk_cursordxCreditApprobation
GO
ALTER TABLE [dbo].[dxCreditApprobation] ADD CONSTRAINT [PK_dxCreditApprobation] PRIMARY KEY CLUSTERED  ([PK_dxCreditApprobation]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxCreditApprobation] ON [dbo].[dxCreditApprobation] ([ID]) ON [PRIMARY]
GO
