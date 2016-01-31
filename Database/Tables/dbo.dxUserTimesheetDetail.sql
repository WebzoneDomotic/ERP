CREATE TABLE [dbo].[dxUserTimesheetDetail]
(
[PK_dxUserTimesheetDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxUserTimesheet] [int] NULL,
[ID] AS ([PK_dxUserTimesheetDetail]),
[FK_dxProject] [int] NOT NULL,
[FK_dxActivity] [int] NOT NULL,
[Description] [varchar] (1000) COLLATE French_CI_AS NULL,
[Day1Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheetDetail_Day1Hours] DEFAULT ((0.0)),
[Day2Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheetDetail_Day2Hours] DEFAULT ((0.0)),
[Day3Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheetDetail_Day3Hours] DEFAULT ((0.0)),
[Day4Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheetDetail_Day4Hours] DEFAULT ((0.0)),
[Day5Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheetDetail_Day5Hours] DEFAULT ((0.0)),
[Day6Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheetDetail_FridayHours] DEFAULT ((0.0)),
[Day7Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheetDetail_SaturdayHours] DEFAULT ((0.0)),
[TotalHours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheetDetail_TotalHours] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxUserTimesheetDetail.trAuditDelete] ON [dbo].[dxUserTimesheetDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxUserTimesheetDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxUserTimesheetDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxUserTimesheetDetail, FK_dxUserTimesheet, ID, FK_dxProject, FK_dxActivity, Description, Day1Hours, Day2Hours, Day3Hours, Day4Hours, Day5Hours, Day6Hours, Day7Hours, TotalHours from deleted
 Declare @PK_dxUserTimesheetDetail int, @FK_dxUserTimesheet int, @ID int, @FK_dxProject int, @FK_dxActivity int, @Description varchar(1000), @Day1Hours Float, @Day2Hours Float, @Day3Hours Float, @Day4Hours Float, @Day5Hours Float, @Day6Hours Float, @Day7Hours Float, @TotalHours Float

 OPEN pk_cursordxUserTimesheetDetail
 FETCH NEXT FROM pk_cursordxUserTimesheetDetail INTO @PK_dxUserTimesheetDetail, @FK_dxUserTimesheet, @ID, @FK_dxProject, @FK_dxActivity, @Description, @Day1Hours, @Day2Hours, @Day3Hours, @Day4Hours, @Day5Hours, @Day6Hours, @Day7Hours, @TotalHours
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxUserTimesheetDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUserTimesheet', @FK_dxUserTimesheet
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', @FK_dxProject
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxActivity', @FK_dxActivity
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day1Hours', @Day1Hours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day2Hours', @Day2Hours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day3Hours', @Day3Hours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day4Hours', @Day4Hours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day5Hours', @Day5Hours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day6Hours', @Day6Hours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day7Hours', @Day7Hours
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalHours', @TotalHours
FETCH NEXT FROM pk_cursordxUserTimesheetDetail INTO @PK_dxUserTimesheetDetail, @FK_dxUserTimesheet, @ID, @FK_dxProject, @FK_dxActivity, @Description, @Day1Hours, @Day2Hours, @Day3Hours, @Day4Hours, @Day5Hours, @Day6Hours, @Day7Hours, @TotalHours
 END

 CLOSE pk_cursordxUserTimesheetDetail 
 DEALLOCATE pk_cursordxUserTimesheetDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxUserTimesheetDetail.trAuditInsUpd] ON [dbo].[dxUserTimesheetDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxUserTimesheetDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxUserTimesheetDetail from inserted;
 set @tablename = 'dxUserTimesheetDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxUserTimesheetDetail
 FETCH NEXT FROM pk_cursordxUserTimesheetDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxUserTimesheet )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxUserTimesheet', FK_dxUserTimesheet from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxProject )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxProject', FK_dxProject from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxActivity )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxActivity', FK_dxActivity from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Day1Hours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day1Hours', Day1Hours from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Day2Hours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day2Hours', Day2Hours from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Day3Hours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day3Hours', Day3Hours from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Day4Hours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day4Hours', Day4Hours from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Day5Hours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day5Hours', Day5Hours from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Day6Hours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day6Hours', Day6Hours from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Day7Hours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'Day7Hours', Day7Hours from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TotalHours )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'TotalHours', TotalHours from dxUserTimesheetDetail where PK_dxUserTimesheetDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxUserTimesheetDetail INTO @keyvalue
 END

 CLOSE pk_cursordxUserTimesheetDetail 
 DEALLOCATE pk_cursordxUserTimesheetDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxUserTimesheetDetail.trUpdateSum] ON [dbo].[dxUserTimesheetDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  declare @FKA int , @FKAD int , @FKAI int, @PK int,@FK int, @FKi int , @FKd int ;

  set @FKi = ( SELECT Coalesce(max(FK_dxUserTimesheet ),-1) from inserted )
  set @FKd = ( SELECT Coalesce(max(FK_dxUserTimesheet ),-1) from deleted )
  set @FKAI = ( SELECT Coalesce(max(FK_dxActivity ),-1) from inserted )
  set @FKAD = ( SELECT Coalesce(max(FK_dxActivity ),-1) from deleted )

  if (@FKi  < @FKd ) set @FK  = @FKd  else set @FK  = @FKi
  if (@FKAI < @FKAD) set @FKA = @FKAD else set @FKA = @FKAI

  set @PK = -1
  set @PK = ( SELECT Coalesce(max(PK_dxUserTimesheetDetail ),-1) from inserted );
  if (@PK > 0)
  begin
     Update dxUserTimesheetDetail set TotalHours = Day1Hours+Day2Hours+Day3Hours+Day4Hours+Day5Hours+Day6Hours+Day7Hours  where PK_dxUserTimesheetDetail = @PK ;
  end;
  update dxUserTimesheet set
    Day1Hours   = ( select Coalesce(sum( Day1Hours   ), 0.0) from dxUserTimesheetDetail where FK_dxUserTimesheet = @FK ),
    Day2Hours   = ( select Coalesce(sum( Day2Hours   ), 0.0) from dxUserTimesheetDetail where FK_dxUserTimesheet = @FK ),
    Day3Hours   = ( select Coalesce(sum( Day3Hours   ), 0.0) from dxUserTimesheetDetail where FK_dxUserTimesheet = @FK ),
    Day4Hours   = ( select Coalesce(sum( Day4Hours   ), 0.0) from dxUserTimesheetDetail where FK_dxUserTimesheet = @FK ),
    Day5Hours   = ( select Coalesce(sum( Day5Hours   ), 0.0) from dxUserTimesheetDetail where FK_dxUserTimesheet = @FK ),
    Day6Hours   = ( select Coalesce(sum( Day6Hours   ), 0.0) from dxUserTimesheetDetail where FK_dxUserTimesheet = @FK ),
    Day7Hours   = ( select Coalesce(sum( Day7Hours   ), 0.0) from dxUserTimesheetDetail where FK_dxUserTimesheet = @FK ),
    TotalHours  = ( select Coalesce(sum( TotalHours  ), 0.0) from dxUserTimesheetDetail where FK_dxUserTimesheet = @FK )
  where PK_dxUserTimesheet = @FK ;

  Update dxActivity set SpendHours = ( select coalesce(sum(TotalHours),0.0) from dxUserTimeSheetDetail where FK_dxActivity = @FKA ) where PK_dxActivity = @FKA ;

END
GO
ALTER TABLE [dbo].[dxUserTimesheetDetail] ADD CONSTRAINT [PK_dxUserTimesheetDetail] PRIMARY KEY CLUSTERED  ([PK_dxUserTimesheetDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxUserTimesheetDetail_FK_dxActivity] ON [dbo].[dxUserTimesheetDetail] ([FK_dxActivity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxUserTimesheetDetail_FK_dxProject] ON [dbo].[dxUserTimesheetDetail] ([FK_dxProject]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxUserTimesheetDetail_FK_dxUserTimesheet] ON [dbo].[dxUserTimesheetDetail] ([FK_dxUserTimesheet]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxUserTimesheetDetail] ADD CONSTRAINT [dxConstraint_FK_dxActivity_dxUserTimesheetDetail] FOREIGN KEY ([FK_dxActivity]) REFERENCES [dbo].[dxActivity] ([PK_dxActivity])
GO
ALTER TABLE [dbo].[dxUserTimesheetDetail] ADD CONSTRAINT [dxConstraint_FK_dxProject_dxUserTimesheetDetail] FOREIGN KEY ([FK_dxProject]) REFERENCES [dbo].[dxProject] ([PK_dxProject])
GO
ALTER TABLE [dbo].[dxUserTimesheetDetail] ADD CONSTRAINT [dxConstraint_FK_dxUserTimesheet_dxUserTimesheetDetail] FOREIGN KEY ([FK_dxUserTimesheet]) REFERENCES [dbo].[dxUserTimesheet] ([PK_dxUserTimesheet])
GO
