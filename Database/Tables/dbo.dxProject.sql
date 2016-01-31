CREATE TABLE [dbo].[dxProject]
(
[PK_dxProject] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE French_CI_AS NOT NULL,
[FK_dxProjectCategory] [int] NOT NULL CONSTRAINT [DF_dxProject_FK_dxProjectCategory] DEFAULT ((10)),
[FK_dxClient] [int] NOT NULL,
[EstimatedHours] [float] NOT NULL CONSTRAINT [DF_dxProject_EstimatedHours] DEFAULT ((0.0)),
[BudgetedHours] [float] NOT NULL CONSTRAINT [DF_dxProject_BudgetedHours] DEFAULT ((0.0)),
[SpendHours] [float] NOT NULL CONSTRAINT [DF_dxProject_SpendHours] DEFAULT ((0.0)),
[EstimatedCost] [float] NOT NULL CONSTRAINT [DF_dxProject_EstimatedCost] DEFAULT ((0.0)),
[BudgetedCost] [float] NOT NULL CONSTRAINT [DF_dxProject_BudgetedCost] DEFAULT ((0.0)),
[SpendCost] [float] NOT NULL CONSTRAINT [DF_dxProject_SpendCost] DEFAULT ((0.0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_dxProject_Active] DEFAULT ((1)),
[EstimatedStartDate] [datetime] NOT NULL CONSTRAINT [DF_dxProject_StartDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[EstimatedEndDate] [datetime] NOT NULL CONSTRAINT [DF_dxProject_EndDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[SpreadSheet] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProject.trAuditDelete] ON [dbo].[dxProject]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProject'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProject CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProject, ID, Description, FK_dxProjectCategory, FK_dxClient, EstimatedHours, BudgetedHours, SpendHours, EstimatedCost, BudgetedCost, SpendCost, Active, EstimatedStartDate, EstimatedEndDate from deleted
 Declare @PK_dxProject int, @ID varchar(50), @Description varchar(1000), @FK_dxProjectCategory int, @FK_dxClient int, @EstimatedHours Float, @BudgetedHours Float, @SpendHours Float, @EstimatedCost Float, @BudgetedCost Float, @SpendCost Float, @Active Bit, @EstimatedStartDate DateTime, @EstimatedEndDate DateTime

 OPEN pk_cursordxProject
 FETCH NEXT FROM pk_cursordxProject INTO @PK_dxProject, @ID, @Description, @FK_dxProjectCategory, @FK_dxClient, @EstimatedHours, @BudgetedHours, @SpendHours, @EstimatedCost, @BudgetedCost, @SpendCost, @Active, @EstimatedStartDate, @EstimatedEndDate
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProject, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProjectCategory', @FK_dxProjectCategory
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', @FK_dxClient
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EstimatedHours', @EstimatedHours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BudgetedHours', @BudgetedHours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SpendHours', @SpendHours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EstimatedCost', @EstimatedCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BudgetedCost', @BudgetedCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SpendCost', @SpendCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', @Active
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EstimatedStartDate', @EstimatedStartDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EstimatedEndDate', @EstimatedEndDate
FETCH NEXT FROM pk_cursordxProject INTO @PK_dxProject, @ID, @Description, @FK_dxProjectCategory, @FK_dxClient, @EstimatedHours, @BudgetedHours, @SpendHours, @EstimatedCost, @BudgetedCost, @SpendCost, @Active, @EstimatedStartDate, @EstimatedEndDate
 END

 CLOSE pk_cursordxProject 
 DEALLOCATE pk_cursordxProject
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProject.trAuditInsUpd] ON [dbo].[dxProject] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProject CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProject from inserted;
 set @tablename = 'dxProject' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProject
 FETCH NEXT FROM pk_cursordxProject INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProjectCategory )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProjectCategory', FK_dxProjectCategory from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxClient )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxClient', FK_dxClient from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EstimatedHours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EstimatedHours', EstimatedHours from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BudgetedHours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BudgetedHours', BudgetedHours from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpendHours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SpendHours', SpendHours from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EstimatedCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EstimatedCost', EstimatedCost from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BudgetedCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BudgetedCost', BudgetedCost from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpendCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SpendCost', SpendCost from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EstimatedStartDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EstimatedStartDate', EstimatedStartDate from dxProject where PK_dxProject = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EstimatedEndDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EstimatedEndDate', EstimatedEndDate from dxProject where PK_dxProject = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProject INTO @keyvalue
 END

 CLOSE pk_cursordxProject 
 DEALLOCATE pk_cursordxProject
GO
ALTER TABLE [dbo].[dxProject] ADD CONSTRAINT [PK_dxProject] PRIMARY KEY CLUSTERED  ([PK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProject_FK_dxClient] ON [dbo].[dxProject] ([FK_dxClient]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxProject_FK_dxProjectCategory] ON [dbo].[dxProject] ([FK_dxProjectCategory]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxProject] ADD CONSTRAINT [dxConstraint_FK_dxClient_dxProject] FOREIGN KEY ([FK_dxClient]) REFERENCES [dbo].[dxClient] ([PK_dxClient])
GO
ALTER TABLE [dbo].[dxProject] ADD CONSTRAINT [dxConstraint_FK_dxProjectCategory_dxProject] FOREIGN KEY ([FK_dxProjectCategory]) REFERENCES [dbo].[dxProjectCategory] ([PK_dxProjectCategory])
GO
