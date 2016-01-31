CREATE TABLE [dbo].[dxActivity]
(
[PK_dxActivity] [int] NOT NULL IDENTITY(1, 1),
[FK_dxProject] [int] NOT NULL,
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE French_CI_AS NULL,
[EstimatedHours] [float] NOT NULL CONSTRAINT [DF_dxActivity_EstimatedHours] DEFAULT ((0.0)),
[BudgetedHours] [float] NOT NULL CONSTRAINT [DF_dxActivity_BudgetedHours] DEFAULT ((0.0)),
[SpendHours] [float] NOT NULL CONSTRAINT [DF_dxActivity_SpendHours] DEFAULT ((0.0)),
[EstimatedCost] [float] NOT NULL CONSTRAINT [DF_dxActivity_EstimatedCost] DEFAULT ((0.0)),
[BudgetedCost] [float] NOT NULL CONSTRAINT [DF_dxActivity_BudgetedCost] DEFAULT ((0.0)),
[SpendCost] [float] NOT NULL CONSTRAINT [DF_dxActivity_SpendCost] DEFAULT ((0.0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_dxActivity_Active] DEFAULT ((1)),
[EstimatedStartDate] [datetime] NOT NULL CONSTRAINT [DF_dxActivity_EstimatedStartDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[EstimatedEndDate] [datetime] NOT NULL CONSTRAINT [DF_dxActivity_EstimatedEndDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[Billable] [bit] NOT NULL CONSTRAINT [DF_dxActivity_Billable] DEFAULT ((1)),
[HourlyRate] [float] NOT NULL CONSTRAINT [DF_dxActivity_HourlyRate] DEFAULT ((0.0)),
[BudgetedCostProgress] AS (case [BudgetedCost] when (0.0) then (0.0) else round(([SpendCost]/[BudgetedCost])*(100),(2)) end),
[EstimatedCostProgress] AS (case [EstimatedCost] when (0.0) then (0.0) else round(([SpendCost]/[EstimatedCost])*(100),(2)) end),
[BudgetedHoursProgress] AS (case [BudgetedHours] when (0.0) then (0.0) else round(([SpendHours]/[BudgetedHours])*(100),(2)) end),
[EstimatedHoursProgress] AS (case [EstimatedHours] when (0.0) then (0.0) else round(([SpendHours]/[EstimatedHours])*(100),(2)) end)
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxActivity.trAuditDelete] ON [dbo].[dxActivity]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxActivity'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxActivity CURSOR LOCAL FAST_FORWARD for SELECT PK_dxActivity, FK_dxProject, ID, Description, EstimatedHours, BudgetedHours, SpendHours, EstimatedCost, BudgetedCost, SpendCost, Active, EstimatedStartDate, EstimatedEndDate, Billable, HourlyRate, BudgetedCostProgress, EstimatedCostProgress, BudgetedHoursProgress, EstimatedHoursProgress from deleted
 Declare @PK_dxActivity int, @FK_dxProject int, @ID varchar(50), @Description varchar(1000), @EstimatedHours Float, @BudgetedHours Float, @SpendHours Float, @EstimatedCost Float, @BudgetedCost Float, @SpendCost Float, @Active Bit, @EstimatedStartDate DateTime, @EstimatedEndDate DateTime, @Billable Bit, @HourlyRate Float, @BudgetedCostProgress Float, @EstimatedCostProgress Float, @BudgetedHoursProgress Float, @EstimatedHoursProgress Float

 OPEN pk_cursordxActivity
 FETCH NEXT FROM pk_cursordxActivity INTO @PK_dxActivity, @FK_dxProject, @ID, @Description, @EstimatedHours, @BudgetedHours, @SpendHours, @EstimatedCost, @BudgetedCost, @SpendCost, @Active, @EstimatedStartDate, @EstimatedEndDate, @Billable, @HourlyRate, @BudgetedCostProgress, @EstimatedCostProgress, @BudgetedHoursProgress, @EstimatedHoursProgress
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxActivity, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', @FK_dxProject
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
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
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Billable', @Billable
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'HourlyRate', @HourlyRate
FETCH NEXT FROM pk_cursordxActivity INTO @PK_dxActivity, @FK_dxProject, @ID, @Description, @EstimatedHours, @BudgetedHours, @SpendHours, @EstimatedCost, @BudgetedCost, @SpendCost, @Active, @EstimatedStartDate, @EstimatedEndDate, @Billable, @HourlyRate, @BudgetedCostProgress, @EstimatedCostProgress, @BudgetedHoursProgress, @EstimatedHoursProgress
 END

 CLOSE pk_cursordxActivity 
 DEALLOCATE pk_cursordxActivity
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxActivity.trAuditInsUpd] ON [dbo].[dxActivity] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxActivity CURSOR LOCAL FAST_FORWARD for SELECT PK_dxActivity from inserted;
 set @tablename = 'dxActivity' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxActivity
 FETCH NEXT FROM pk_cursordxActivity INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EstimatedHours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EstimatedHours', EstimatedHours from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BudgetedHours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BudgetedHours', BudgetedHours from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpendHours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SpendHours', SpendHours from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EstimatedCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'EstimatedCost', EstimatedCost from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( BudgetedCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'BudgetedCost', BudgetedCost from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( SpendCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'SpendCost', SpendCost from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Active )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Active', Active from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EstimatedStartDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EstimatedStartDate', EstimatedStartDate from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EstimatedEndDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EstimatedEndDate', EstimatedEndDate from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Billable )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Billable', Billable from dxActivity where PK_dxActivity = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( HourlyRate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'HourlyRate', HourlyRate from dxActivity where PK_dxActivity = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxActivity INTO @keyvalue
 END

 CLOSE pk_cursordxActivity 
 DEALLOCATE pk_cursordxActivity
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxActivity.trUpdateSum] ON [dbo].[dxActivity]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;

   set @FKi  = ( SELECT Coalesce(max(FK_dxProject ),-1) from inserted )
   set @FKd  = ( SELECT Coalesce(max(FK_dxProject ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   Update dxProject  set
          Active             = ( select Convert( bit, coalesce(Max( Convert( int, Active) ),0)) from dxActivity where FK_dxProject = dxProject.PK_dxProject ),
          BudgetedHours      = ( select coalesce(sum(BudgetedHours  ),0.0) from dxActivity where FK_dxProject = dxProject.PK_dxProject ),
          BudgetedCost       = ( select coalesce(sum(BudgetedCost   ),0.0) from dxActivity where FK_dxProject = dxProject.PK_dxProject ),
          EstimatedHours     = ( select coalesce(sum(EstimatedHours ),0.0) from dxActivity where FK_dxProject = dxProject.PK_dxProject ),
          EstimatedCost      = ( select coalesce(sum(EstimatedCost  ),0.0) from dxActivity where FK_dxProject = dxProject.PK_dxProject ),
          SpendHours         = ( select coalesce(sum(SpendHours     ),0.0) from dxActivity where FK_dxProject = dxProject.PK_dxProject ),
          EstimatedStartDate = ( select coalesce(Min(EstimatedStartDate ),GetDate()) from dxActivity where FK_dxProject = dxProject.PK_dxProject ) ,
          EstimatedEndDate   = ( select coalesce(Max(EstimatedEndDate   ),GetDate()) from dxActivity where FK_dxProject = dxProject.PK_dxProject )
   where PK_dxProject = @FK
END
GO
ALTER TABLE [dbo].[dxActivity] ADD CONSTRAINT [PK_dxActivity] PRIMARY KEY CLUSTERED  ([PK_dxActivity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxActivity_FK_dxProject] ON [dbo].[dxActivity] ([FK_dxProject]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxActivity] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxActivity] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
