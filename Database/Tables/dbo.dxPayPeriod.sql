CREATE TABLE [dbo].[dxPayPeriod]
(
[PK_dxPayPeriod] [int] NOT NULL IDENTITY(1, 1),
[ID] [int] NOT NULL,
[StartDate] [date] NOT NULL,
[EndDate] [date] NOT NULL,
[PaymentDate] [date] NULL,
[PeriodIsClosed] [bit] NOT NULL CONSTRAINT [DF_dxPayPeriod_PeriodIsClosed] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayPeriod.trAuditDelete] ON [dbo].[dxPayPeriod]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPayPeriod'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPayPeriod CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayPeriod, ID, StartDate, EndDate, PaymentDate, PeriodIsClosed from deleted
 Declare @PK_dxPayPeriod int, @ID int, @StartDate DateTime, @EndDate DateTime, @PaymentDate DateTime, @PeriodIsClosed Bit

 OPEN pk_cursordxPayPeriod
 FETCH NEXT FROM pk_cursordxPayPeriod INTO @PK_dxPayPeriod, @ID, @StartDate, @EndDate, @PaymentDate, @PeriodIsClosed
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPayPeriod, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'StartDate', @StartDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EndDate', @EndDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'PaymentDate', @PaymentDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PeriodIsClosed', @PeriodIsClosed
FETCH NEXT FROM pk_cursordxPayPeriod INTO @PK_dxPayPeriod, @ID, @StartDate, @EndDate, @PaymentDate, @PeriodIsClosed
 END

 CLOSE pk_cursordxPayPeriod 
 DEALLOCATE pk_cursordxPayPeriod
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayPeriod.trAuditInsUpd] ON [dbo].[dxPayPeriod] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPayPeriod CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPayPeriod from inserted;
 set @tablename = 'dxPayPeriod' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPayPeriod
 FETCH NEXT FROM pk_cursordxPayPeriod INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'ID', ID from dxPayPeriod where PK_dxPayPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( StartDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'StartDate', StartDate from dxPayPeriod where PK_dxPayPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EndDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EndDate', EndDate from dxPayPeriod where PK_dxPayPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PaymentDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'PaymentDate', PaymentDate from dxPayPeriod where PK_dxPayPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PeriodIsClosed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'PeriodIsClosed', PeriodIsClosed from dxPayPeriod where PK_dxPayPeriod = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPayPeriod INTO @keyvalue
 END

 CLOSE pk_cursordxPayPeriod 
 DEALLOCATE pk_cursordxPayPeriod
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayPeriod.trDeletePayPeriod] ON [dbo].[dxPayPeriod]
AFTER DELETE
AS
BEGIN
   SET NOCOUNT ON

   -- An opened pay period cannot be deleted
   IF EXISTS(SELECT 1 FROM deleted WHERE PeriodIsClosed = 1)
   BEGIN
      RAISERROR(50005, 16, 1); -- A closed pay period cannot be deleted.
      ROLLBACK TRANSACTION;
      RETURN 
   END
   
   DECLARE @LastPayPeriodStartDate date;
   SET @LastPayPeriodStartDate = (SELECT Max(StartDate) FROM dxPayPeriod);
   
   -- Only the last periods can be deleted
   IF EXISTS(SELECT 1 FROM deleted WHERE StartDate < @LastPayPeriodStartDate)
   BEGIN
      RAISERROR(50006, 16, 1); -- Only the last pay period can be deleted.
      ROLLBACK TRANSACTION;
      RETURN 
   END
   
   SET NOCOUNT OFF
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPayPeriod.trUpdatePayPeriod] ON [dbo].[dxPayPeriod]
AFTER INSERT, UPDATE
AS
BEGIN
   SET NOCOUNT ON

   -- Closed periods can't be modified, unless reopened
   IF NOT UPDATE(PeriodIsClosed) AND EXISTS(SELECT 1 FROM inserted ins JOIN deleted del ON del.PK_dxPayPeriod = ins.PK_dxPayPeriod WHERE del.PeriodIsClosed = 1)
   BEGIN
      RAISERROR(50001, 16, 1); -- A closed pay period cannot be modified.
      ROLLBACK TRANSACTION;
      RETURN 
   END
   ELSE
   BEGIN
      -- PaymentDate can't be prior to the EndDate
      -- *** Validation could be wrong... PaymentDate could be before in the real world
      -- IF (UPDATE(PaymentDate) OR UPDATE(EndDate)) AND EXISTS(SELECT 1 FROM inserted WHERE PaymentDate < EndDate)
      -- BEGIN
      --   RAISERROR(50002, 16, 1); -- Payment date cannot be prior to the end date.
      --   ROLLBACK TRANSACTION;
      --   RETURN;
      -- END
   
      -- EndDate can't be prior to the StartDate
      IF UPDATE(EndDate) AND EXISTS(SELECT 1 FROM inserted WHERE EndDate < StartDate)
      BEGIN
         RAISERROR(50003, 16, 1); -- Pay end date cannot be prior to start date.
         ROLLBACK TRANSACTION;
         RETURN;
      END
            
      DECLARE @LastPayPeriodStartDate date;
      SET @LastPayPeriodStartDate = (SELECT Max(StartDate) FROM dxPayPeriod);
   
      -- Start and end dates can't be modified unless it's the last opened period
      IF (UPDATE(EndDate) OR UPDATE(StartDate)) AND EXISTS(SELECT 1 FROM inserted ins INNER JOIN deleted del on del.PK_dxPayPeriod = ins.PK_dxPayPeriod WHERE ins.StartDate < @LastPayPeriodStartDate)
      BEGIN
         RAISERROR(50004, 16, 1); -- Only the last opened pay period can be modified.
         ROLLBACK TRANSACTION;
         RETURN;
      END

      -- Pay period cannot overlap another pay period
      IF EXISTS(SELECT 1 FROM inserted AS T1
                 INNER JOIN dxPayPeriod AS T2 ON COALESCE(T1.StartDate, '1753-01-01') <= COALESCE(T2.EndDate, '9999-12-31') AND
                 COALESCE(T1.EndDate, '9999-12-31') >= COALESCE(T2.StartDate, '1753-01-01') AND
                 T1.PK_dxPayPeriod <> T2.PK_dxPayPeriod)
      BEGIN
         RAISERROR(50007, 16, 1); -- A pay period cannot overlap another one.
         ROLLBACK TRANSACTION;
         RETURN;
      END

   END
   SET NOCOUNT OFF
END
GO
ALTER TABLE [dbo].[dxPayPeriod] ADD CONSTRAINT [PK_dxPayPeriod] PRIMARY KEY CLUSTERED  ([PK_dxPayPeriod]) ON [PRIMARY]
GO
