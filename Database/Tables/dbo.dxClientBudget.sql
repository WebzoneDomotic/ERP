CREATE TABLE [dbo].[dxClientBudget]
(
[PK_dxClientBudget] [int] NOT NULL IDENTITY(1, 1),
[FK_dxClient] [int] NOT NULL,
[FK_dxAccountingYear] [int] NOT NULL,
[JanuaryAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_JanuaryAmount] DEFAULT ((0.0)),
[FebruaryAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_FebruaryAmount] DEFAULT ((0.0)),
[MarchAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_MarchAmount] DEFAULT ((0.0)),
[AprilAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_AprilAmount] DEFAULT ((0.0)),
[MayAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_MayAmount] DEFAULT ((0.0)),
[JuneAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_JuneAmount] DEFAULT ((0.0)),
[JulyAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_JulyAmount] DEFAULT ((0.0)),
[AugustAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_AugustAmount] DEFAULT ((0.0)),
[SeptemberAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_SeptemberAmount] DEFAULT ((0.0)),
[OctoberAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_OctoberAmount] DEFAULT ((0.0)),
[NovemberAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_NovemberAmount] DEFAULT ((0.0)),
[DecemberAmount] [float] NOT NULL CONSTRAINT [DF_dxClientBudget_DecemberAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientBudget.trAuditDelete] ON [dbo].[dxClientBudget]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxClientBudget'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxClientBudget CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientBudget, FK_dxClient, FK_dxAccountingYear, JanuaryAmount, FebruaryAmount, MarchAmount, AprilAmount, MayAmount, JuneAmount, JulyAmount, AugustAmount, SeptemberAmount, OctoberAmount, NovemberAmount, DecemberAmount from deleted
 Declare @PK_dxClientBudget int, @FK_dxClient int, @FK_dxAccountingYear int, @JanuaryAmount Float, @FebruaryAmount Float, @MarchAmount Float, @AprilAmount Float, @MayAmount Float, @JuneAmount Float, @JulyAmount Float, @AugustAmount Float, @SeptemberAmount Float, @OctoberAmount Float, @NovemberAmount Float, @DecemberAmount Float

 OPEN pk_cursordxClientBudget
 FETCH NEXT FROM pk_cursordxClientBudget INTO @PK_dxClientBudget, @FK_dxClient, @FK_dxAccountingYear, @JanuaryAmount, @FebruaryAmount, @MarchAmount, @AprilAmount, @MayAmount, @JuneAmount, @JulyAmount, @AugustAmount, @SeptemberAmount, @OctoberAmount, @NovemberAmount, @DecemberAmount
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxClientBudget, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountingYear', @FK_dxAccountingYear
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JanuaryAmount', @JanuaryAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FebruaryAmount', @FebruaryAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MarchAmount', @MarchAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AprilAmount', @AprilAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MayAmount', @MayAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JuneAmount', @JuneAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JulyAmount', @JulyAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AugustAmount', @AugustAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SeptemberAmount', @SeptemberAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OctoberAmount', @OctoberAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NovemberAmount', @NovemberAmount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DecemberAmount', @DecemberAmount
FETCH NEXT FROM pk_cursordxClientBudget INTO @PK_dxClientBudget, @FK_dxClient, @FK_dxAccountingYear, @JanuaryAmount, @FebruaryAmount, @MarchAmount, @AprilAmount, @MayAmount, @JuneAmount, @JulyAmount, @AugustAmount, @SeptemberAmount, @OctoberAmount, @NovemberAmount, @DecemberAmount
 END

 CLOSE pk_cursordxClientBudget 
 DEALLOCATE pk_cursordxClientBudget
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxClientBudget.trAuditInsUpd] ON [dbo].[dxClientBudget] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxClientBudget CURSOR LOCAL FAST_FORWARD for SELECT PK_dxClientBudget from inserted;
 set @tablename = 'dxClientBudget' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxClientBudget
 FETCH NEXT FROM pk_cursordxClientBudget INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccountingYear )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountingYear', FK_dxAccountingYear from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( JanuaryAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JanuaryAmount', JanuaryAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FebruaryAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FebruaryAmount', FebruaryAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MarchAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MarchAmount', MarchAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AprilAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AprilAmount', AprilAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( MayAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'MayAmount', MayAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( JuneAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JuneAmount', JuneAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( JulyAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'JulyAmount', JulyAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AugustAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'AugustAmount', AugustAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SeptemberAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SeptemberAmount', SeptemberAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( OctoberAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'OctoberAmount', OctoberAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( NovemberAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'NovemberAmount', NovemberAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DecemberAmount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DecemberAmount', DecemberAmount from dxClientBudget where PK_dxClientBudget = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxClientBudget INTO @keyvalue
 END

 CLOSE pk_cursordxClientBudget 
 DEALLOCATE pk_cursordxClientBudget
GO
ALTER TABLE [dbo].[dxClientBudget] ADD CONSTRAINT [PK_dxClientBudget] PRIMARY KEY CLUSTERED  ([PK_dxClientBudget]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientBudget_FK_dxAccountingYear] ON [dbo].[dxClientBudget] ([FK_dxAccountingYear]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxClientBudget_FK_dxClient] ON [dbo].[dxClientBudget] ([FK_dxClient]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxClientBudget] ADD CONSTRAINT [dxConstraint_FK_dxAccountingYear_dxClientBudget] FOREIGN KEY ([FK_dxAccountingYear]) REFERENCES [dbo].[dxAccountingYear] ([PK_dxAccountingYear])
GO
ALTER TABLE [dbo].[dxClientBudget] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxClientBudget] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
