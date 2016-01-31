CREATE TABLE [dbo].[dxTaxDetail]
(
[PK_dxTaxDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxTax] [int] NOT NULL,
[EffectiveDate] [datetime] NOT NULL,
[Tax1Rate] [float] NOT NULL CONSTRAINT [DF_dxTaxDetail_Tax1Rate] DEFAULT ((0.0)),
[Tax2Rate] [float] NOT NULL CONSTRAINT [DF_dxTaxDetail_Tax2Rate] DEFAULT ((0.0)),
[Tax3Rate] [float] NOT NULL CONSTRAINT [DF_dxTaxDetail_Tax3Rate] DEFAULT ((0.0)),
[Tax1Formula] [varchar] (255) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxTaxDetail_Tax1Formula] DEFAULT ('0.0'),
[Tax2Formula] [varchar] (255) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxTaxDetail_Tax2Formula] DEFAULT ('0.0'),
[Tax3Formula] [varchar] (255) COLLATE French_CI_AS NULL CONSTRAINT [DF_dxTaxDetail_Tax3Formula] DEFAULT ('0.0')
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTaxDetail.trAuditDelete] ON [dbo].[dxTaxDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxTaxDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxTaxDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTaxDetail, FK_dxTax, EffectiveDate, Tax1Rate, Tax2Rate, Tax3Rate, Tax1Formula, Tax2Formula, Tax3Formula from deleted
 Declare @PK_dxTaxDetail int, @FK_dxTax int, @EffectiveDate DateTime, @Tax1Rate Float, @Tax2Rate Float, @Tax3Rate Float, @Tax1Formula varchar(255), @Tax2Formula varchar(255), @Tax3Formula varchar(255)

 OPEN pk_cursordxTaxDetail
 FETCH NEXT FROM pk_cursordxTaxDetail INTO @PK_dxTaxDetail, @FK_dxTax, @EffectiveDate, @Tax1Rate, @Tax2Rate, @Tax3Rate, @Tax1Formula, @Tax2Formula, @Tax3Formula
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxTaxDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', @FK_dxTax
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Rate', @Tax1Rate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Rate', @Tax2Rate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Rate', @Tax3Rate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax1Formula', @Tax1Formula
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax2Formula', @Tax2Formula
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax3Formula', @Tax3Formula
FETCH NEXT FROM pk_cursordxTaxDetail INTO @PK_dxTaxDetail, @FK_dxTax, @EffectiveDate, @Tax1Rate, @Tax2Rate, @Tax3Rate, @Tax1Formula, @Tax2Formula, @Tax3Formula
 END

 CLOSE pk_cursordxTaxDetail 
 DEALLOCATE pk_cursordxTaxDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxTaxDetail.trAuditInsUpd] ON [dbo].[dxTaxDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxTaxDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxTaxDetail from inserted;
 set @tablename = 'dxTaxDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxTaxDetail
 FETCH NEXT FROM pk_cursordxTaxDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxTax )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxTax', FK_dxTax from dxTaxDetail where PK_dxTaxDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxTaxDetail where PK_dxTaxDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax1Rate', Tax1Rate from dxTaxDetail where PK_dxTaxDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax2Rate', Tax2Rate from dxTaxDetail where PK_dxTaxDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Rate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Tax3Rate', Tax3Rate from dxTaxDetail where PK_dxTaxDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax1Formula )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax1Formula', Tax1Formula from dxTaxDetail where PK_dxTaxDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax2Formula )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax2Formula', Tax2Formula from dxTaxDetail where PK_dxTaxDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Tax3Formula )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Tax3Formula', Tax3Formula from dxTaxDetail where PK_dxTaxDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxTaxDetail INTO @keyvalue
 END

 CLOSE pk_cursordxTaxDetail 
 DEALLOCATE pk_cursordxTaxDetail
GO
ALTER TABLE [dbo].[dxTaxDetail] ADD CONSTRAINT [PK_dxTaxDetail] PRIMARY KEY CLUSTERED  ([PK_dxTaxDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxTaxDetail_FK_dxTax] ON [dbo].[dxTaxDetail] ([FK_dxTax]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxTaxDetail] ON [dbo].[dxTaxDetail] ([FK_dxTax], [EffectiveDate] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxTaxDetail] ADD CONSTRAINT [dxConstraint_FK_dxTax_dxTaxDetail] FOREIGN KEY ([FK_dxTax]) REFERENCES [dbo].[dxTax] ([PK_dxTax])
GO
