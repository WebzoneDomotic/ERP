CREATE TABLE [dbo].[dxClientPromotion]
(
[PK_dxClientPromotion] [int] NOT NULL IDENTITY(1, 1),
[PromotionName] [varchar] (150) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[EffectiveDate] [datetime] NOT NULL,
[ValidUntil] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientPromotion.trAuditDelete] ON [dbo].[dxClientPromotion]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientPromotion'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientPromotion CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientPromotion, PromotionName, Description, EffectiveDate, ValidUntil from deleted
 Declare @PK_dxClientPromotion int, @PromotionName varchar(150), @Description varchar(500), @EffectiveDate DateTime, @ValidUntil DateTime

 OPEN pk_cursordxClientPromotion
 FETCH NEXT FROM pk_cursordxClientPromotion INTO @PK_dxClientPromotion, @PromotionName, @Description, @EffectiveDate, @ValidUntil
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientPromotion, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PromotionName', @PromotionName
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', @EffectiveDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ValidUntil', @ValidUntil
FETCH NEXT FROM pk_cursordxClientPromotion INTO @PK_dxClientPromotion, @PromotionName, @Description, @EffectiveDate, @ValidUntil
 END

 CLOSE pk_cursordxClientPromotion 
 DEALLOCATE pk_cursordxClientPromotion
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientPromotion.trAuditInsUpd] ON [dbo].[dxClientPromotion] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientPromotion CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientPromotion from inserted;
 set @tablename = 'dxClientPromotion' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientPromotion
 FETCH NEXT FROM pk_cursordxClientPromotion INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PromotionName )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'PromotionName', PromotionName from dxClientPromotion where PK_dxClientPromotion = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxClientPromotion where PK_dxClientPromotion = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EffectiveDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EffectiveDate', EffectiveDate from dxClientPromotion where PK_dxClientPromotion = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ValidUntil )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ValidUntil', ValidUntil from dxClientPromotion where PK_dxClientPromotion = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientPromotion INTO @keyvalue
 END

 CLOSE pk_cursordxClientPromotion 
 DEALLOCATE pk_cursordxClientPromotion
GO
ALTER TABLE [dbo].[dxClientPromotion] ADD CONSTRAINT [PK_dxClientPromotion] PRIMARY KEY CLUSTERED  ([PK_dxClientPromotion]) ON [PRIMARY]
GO
