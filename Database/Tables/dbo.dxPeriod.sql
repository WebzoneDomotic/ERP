CREATE TABLE [dbo].[dxPeriod]
(
[PK_dxPeriod] [int] NOT NULL,
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[PeriodNumber] [int] NOT NULL,
[FK_dxAccountingYear] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[AccountingIsClosed] [bit] NULL CONSTRAINT [DF_dxPeriod_AccountingIsClosed] DEFAULT ((0)),
[InventoryIsClosed] [bit] NULL CONSTRAINT [DF_dxPeriod_InventoryIsClosed] DEFAULT ((0)),
[NumberOfDays] AS (CONVERT([int],([EndDate]-[StartDate])+(1),(0))),
[AccountingPeriod] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPeriod.trAuditDelete] ON [dbo].[dxPeriod]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxPeriod'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxPeriod CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPeriod, ID, PeriodNumber, FK_dxAccountingYear, StartDate, EndDate, AccountingIsClosed, InventoryIsClosed, NumberOfDays, AccountingPeriod from deleted
 Declare @PK_dxPeriod int, @ID varchar(50), @PeriodNumber int, @FK_dxAccountingYear int, @StartDate DateTime, @EndDate DateTime, @AccountingIsClosed Bit, @InventoryIsClosed Bit, @NumberOfDays int, @AccountingPeriod int

 OPEN pk_cursordxPeriod
 FETCH NEXT FROM pk_cursordxPeriod INTO @PK_dxPeriod, @ID, @PeriodNumber, @FK_dxAccountingYear, @StartDate, @EndDate, @AccountingIsClosed, @InventoryIsClosed, @NumberOfDays, @AccountingPeriod
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxPeriod, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', @ID
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PeriodNumber', @PeriodNumber
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountingYear', @FK_dxAccountingYear
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'StartDate', @StartDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EndDate', @EndDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AccountingIsClosed', @AccountingIsClosed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'InventoryIsClosed', @InventoryIsClosed
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'AccountingPeriod', @AccountingPeriod
FETCH NEXT FROM pk_cursordxPeriod INTO @PK_dxPeriod, @ID, @PeriodNumber, @FK_dxAccountingYear, @StartDate, @EndDate, @AccountingIsClosed, @InventoryIsClosed, @NumberOfDays, @AccountingPeriod
 END

 CLOSE pk_cursordxPeriod 
 DEALLOCATE pk_cursordxPeriod
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPeriod.trAuditInsUpd] ON [dbo].[dxPeriod] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxPeriod CURSOR LOCAL FAST_FORWARD for SELECT PK_dxPeriod from inserted;
 set @tablename = 'dxPeriod' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxPeriod
 FETCH NEXT FROM pk_cursordxPeriod INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( ID )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'ID', ID from dxPeriod where PK_dxPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( PeriodNumber )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'PeriodNumber', PeriodNumber from dxPeriod where PK_dxPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccountingYear )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccountingYear', FK_dxAccountingYear from dxPeriod where PK_dxPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( StartDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'StartDate', StartDate from dxPeriod where PK_dxPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( EndDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'EndDate', EndDate from dxPeriod where PK_dxPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AccountingIsClosed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AccountingIsClosed', AccountingIsClosed from dxPeriod where PK_dxPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( InventoryIsClosed )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'InventoryIsClosed', InventoryIsClosed from dxPeriod where PK_dxPeriod = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AccountingPeriod )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'AccountingPeriod', AccountingPeriod from dxPeriod where PK_dxPeriod = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxPeriod INTO @keyvalue
 END

 CLOSE pk_cursordxPeriod 
 DEALLOCATE pk_cursordxPeriod
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Caculate the total amount of the document
CREATE TRIGGER [dbo].[dxPeriod.trClosePeriod] ON [dbo].[dxPeriod]
AFTER INSERT, UPDATE
AS
BEGIN
   SET NOCOUNT ON

   Declare  @PK_dxPeriod int
           ,@AccountingIsClosed bit
           ,@InventoryIsClosed bit
           ,@FirstOpenPeriod  int
           ,@LastClosedPeriod int
           ,@LastPeriodoftheYear int
           ,@CurrentAccountingYear int
           ,@NextYear int

   IF TRIGGER_NESTLEVEL() > 10 RETURN
   IF Update(AccountingPeriod) RETURN

   set @LastClosedPeriod = Coalesce(( select top 1 PK_dxPeriod from dxPeriod where AccountingIsClosed =1 order by StartDate Desc ), -1)
   set @FirstOpenPeriod  = Coalesce(( select top 1 PK_dxPeriod from dxPeriod where AccountingIsClosed =0 order by StartDate Asc  ), 650000)

   Declare CR_ClosePeriod Cursor LOCAL FAST_FORWARD for Select PK_dxPeriod,Coalesce( AccountingPeriod/100,FK_dxAccountingYear),AccountingIsClosed,InventoryIsClosed from inserted
   Open CR_ClosePeriod

   Fetch Next FROM CR_ClosePeriod INTO @PK_dxPeriod, @CurrentAccountingYear,@AccountingIsClosed,@InventoryIsClosed
   -- For each line of the document we recalculate the amount
   While @@FETCH_STATUS = 0
   Begin

     set @LastPeriodoftheYear = ( select top 1 PK_dxPeriod from dxPeriod
          where Coalesce( AccountingPeriod/100,FK_dxAccountingYear) = @CurrentAccountingYear order by StartDate Desc)
     -- Cancel trigger if last closed period > current period
     if Update (AccountingIsClosed) and (@LastClosedPeriod > @PK_dxPeriod)
     begin
        ROLLBACK TRANSACTION
        RAISERROR('Une période postérieure à la période que vous tentez d''ouvrir est fermée.', 16, 1)
        RETURN
     end else
     -- Cancel trigger if first open period < current period
     if  Update (AccountingIsClosed) and (@FirstOpenPeriod < @PK_dxPeriod)
     begin
        ROLLBACK TRANSACTION
        RAISERROR('Une période antérieure à la période que vous tentez de fermer est ouverte.', 16, 1)
        RETURN
     end else
     -- Cancel trigger if first open period < current period
     if  Update (InventoryIsClosed) and ( @InventoryIsClosed = 0 ) and ( @AccountingIsClosed = 1 )
     begin
        ROLLBACK TRANSACTION
        RAISERROR('Il faut ouvrir la comptabilité d''abord', 16, 1)
        RETURN
     end
     -- Delete all End of Year Transactions before processing
     Delete from dxAccountTransaction where EndOfYearTransaction = 1 and FK_dxPeriod >= @PK_dxPeriod
     if Update (AccountingIsClosed) and ( @AccountingIsClosed = 1 )
     begin
         Update dxPeriod set InventoryIsClosed = 1 where PK_dxPeriod = @PK_dxPeriod
         --Génération des écritures de taux de change
         Execute [dbo].[pdxGLEntryCurrency] @ClosingPeriod = @PK_dxPeriod
         --Generate end of year transaction
         if ( @PK_dxPeriod =@LastPeriodoftheYear )
         begin
            Execute [dbo].[pdxGLEntryEndOfYear] @AccountingYear = @CurrentAccountingYear
            -- Update GL For all the account to the rest of the year from this period
            Execute [dbo].[pdxGLEntryUpdateToEndOfYear] @PK_dxPeriod
            -- Update GL For the next Year
            set @NextYear =  @CurrentAccountingYear+1
            Execute [dbo].[pdxGLEntryUpdateForTheYear] @AccountingYear = @NextYear
         end else
            -- Update GL For all the account to the rest of the year from this period
            Execute dbo.pdxGLEntryUpdateToEndOfYear @PK_dxPeriod
     end
     Fetch Next FROM CR_ClosePeriod INTO @PK_dxPeriod, @CurrentAccountingYear,@AccountingIsClosed,@InventoryIsClosed
   End
   -- Update Account Period total Amount from new transactions that have been created
   Execute [dbo].[pdxUpdateAccountPeriod]
   -- Close cursor and free ressource
   CLOSE CR_ClosePeriod
   DEALLOCATE CR_ClosePeriod
   SET NOCOUNT OFF
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxPeriod.trPeriodCurrency] ON [dbo].[dxPeriod]
AFTER INSERT
AS
BEGIN
   SET NOCOUNT ON
   IF TRIGGER_NESTLEVEL() > 10 RETURN
   Execute [dbo].[pdxGLEntryPeriodCurrency]
   SET NOCOUNT OFF
END
GO
ALTER TABLE [dbo].[dxPeriod] ADD CONSTRAINT [PK_dxPeriod] PRIMARY KEY CLUSTERED  ([PK_dxPeriod]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxPeriodEndDate] ON [dbo].[dxPeriod] ([EndDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxPeriodAccountingYear] ON [dbo].[dxPeriod] ([FK_dxAccountingYear]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxPeriod_FK_dxAccountingYear] ON [dbo].[dxPeriod] ([FK_dxAccountingYear]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxPeriodID] ON [dbo].[dxPeriod] ([ID] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxPeriodStartDate] ON [dbo].[dxPeriod] ([StartDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxPeriod] ADD CONSTRAINT [dxConstraint_FK_dxAccountingYear_dxPeriod] FOREIGN KEY ([FK_dxAccountingYear]) REFERENCES [dbo].[dxAccountingYear] ([PK_dxAccountingYear])
GO
