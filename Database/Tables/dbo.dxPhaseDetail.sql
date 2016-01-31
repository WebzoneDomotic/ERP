CREATE TABLE [dbo].[dxPhaseDetail]
(
[PK_dxPhaseDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxPhase] [int] NOT NULL,
[FK_dxResource] [int] NULL,
[Description] [varchar] (500) COLLATE French_CI_AS NULL,
[InternalSetupTime] [datetime] NOT NULL CONSTRAINT [DF_dxPhaseDetail_InternalSetupTime] DEFAULT ((0.0)),
[ExternalSetupTime] [datetime] NOT NULL CONSTRAINT [DF_dxPhaseDetail_ExternalSetupTime] DEFAULT ((0.0)),
[BatchOperationTime] [datetime] NOT NULL CONSTRAINT [DF_dxPhaseDetail_OperationTimePerUnit] DEFAULT ((0.0)),
[BatchSize] [float] NOT NULL CONSTRAINT [DF_dxPhaseDetail_BatchSize] DEFAULT ((1.0)),
[FixeCostPerBatch] [float] NOT NULL CONSTRAINT [DF_dxPhaseDetail_CostPerUnit] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPhaseDetail.trAuditDelete] ON [dbo].[dxPhaseDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPhaseDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPhaseDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPhaseDetail, FK_dxPhase, FK_dxResource, Description, InternalSetupTime, ExternalSetupTime, BatchOperationTime, BatchSize, FixeCostPerBatch from deleted
 Declare @PK_dxPhaseDetail int, @FK_dxPhase int, @FK_dxResource int, @Description varchar(500), @InternalSetupTime DateTime, @ExternalSetupTime DateTime, @BatchOperationTime DateTime, @BatchSize Float, @FixeCostPerBatch Float

 OPEN pk_cursordxPhaseDetail
 FETCH NEXT FROM pk_cursordxPhaseDetail INTO @PK_dxPhaseDetail, @FK_dxPhase, @FK_dxResource, @Description, @InternalSetupTime, @ExternalSetupTime, @BatchOperationTime, @BatchSize, @FixeCostPerBatch
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPhaseDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPhase', @FK_dxPhase
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxResource', @FK_dxResource
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InternalSetupTime', @InternalSetupTime
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExternalSetupTime', @ExternalSetupTime
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'BatchOperationTime', @BatchOperationTime
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BatchSize', @BatchSize
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FixeCostPerBatch', @FixeCostPerBatch
FETCH NEXT FROM pk_cursordxPhaseDetail INTO @PK_dxPhaseDetail, @FK_dxPhase, @FK_dxResource, @Description, @InternalSetupTime, @ExternalSetupTime, @BatchOperationTime, @BatchSize, @FixeCostPerBatch
 END

 CLOSE pk_cursordxPhaseDetail 
 DEALLOCATE pk_cursordxPhaseDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPhaseDetail.trAuditInsUpd] ON [dbo].[dxPhaseDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPhaseDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPhaseDetail from inserted;
 set @tablename = 'dxPhaseDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPhaseDetail
 FETCH NEXT FROM pk_cursordxPhaseDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxPhase )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxPhase', FK_dxPhase from dxPhaseDetail where PK_dxPhaseDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxResource )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxResource', FK_dxResource from dxPhaseDetail where PK_dxPhaseDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxPhaseDetail where PK_dxPhaseDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InternalSetupTime )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'InternalSetupTime', InternalSetupTime from dxPhaseDetail where PK_dxPhaseDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ExternalSetupTime )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'ExternalSetupTime', ExternalSetupTime from dxPhaseDetail where PK_dxPhaseDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BatchOperationTime )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'BatchOperationTime', BatchOperationTime from dxPhaseDetail where PK_dxPhaseDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BatchSize )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BatchSize', BatchSize from dxPhaseDetail where PK_dxPhaseDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FixeCostPerBatch )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'FixeCostPerBatch', FixeCostPerBatch from dxPhaseDetail where PK_dxPhaseDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPhaseDetail INTO @keyvalue
 END

 CLOSE pk_cursordxPhaseDetail 
 DEALLOCATE pk_cursordxPhaseDetail
GO
ALTER TABLE [dbo].[dxPhaseDetail] ADD CONSTRAINT [PK_dxPhaseDetail] PRIMARY KEY CLUSTERED  ([PK_dxPhaseDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPhaseDetail_FK_dxPhase] ON [dbo].[dxPhaseDetail] ([FK_dxPhase]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPhaseDetail_FK_dxResource] ON [dbo].[dxPhaseDetail] ([FK_dxResource]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPhaseDetail] ADD CONSTRAINT [dxConstraint_FK_dxPhase_dxPhaseDetail] FOREIGN KEY ([FK_dxPhase]) REFERENCES [dbo].[dxPhase] ([PK_dxPhase])
GO
ALTER TABLE [dbo].[dxPhaseDetail] ADD CONSTRAINT [dxConstraint_FK_dxResource_dxPhaseDetail] FOREIGN KEY ([FK_dxResource]) REFERENCES [dbo].[dxResource] ([PK_dxResource])
GO
