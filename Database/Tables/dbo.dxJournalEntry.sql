CREATE TABLE [dbo].[dxJournalEntry]
(
[PK_dxJournalEntry] [int] NOT NULL IDENTITY(1, 1),
[ID] AS ([PK_dxJournalEntry]),
[AccrualEntry] [bit] NOT NULL CONSTRAINT [DF_dxJournalEntry_AccrualEntry] DEFAULT ((0)),
[Description] [varchar] (255) COLLATE French_CI_AS NOT NULL,
[TransactionDate] [datetime] NOT NULL,
[FK_dxJournal] [int] NOT NULL,
[DT] [float] NOT NULL CONSTRAINT [DF_dxJournalEntry_DT] DEFAULT ((0)),
[CT] [float] NOT NULL CONSTRAINT [DF_dxJournalEntry_CT] DEFAULT ((0)),
[Posted] [bit] NOT NULL CONSTRAINT [DF_dxJournalEntry_Posted] DEFAULT ((0)),
[FK_dxEntryRecurrenceType] [int] NOT NULL CONSTRAINT [DF_dxJournalEntry_PK_dxEntryRecurrenceType] DEFAULT ((1)),
[RecurrenceInMonths] [int] NOT NULL CONSTRAINT [DF_dxJournalEntry_RecurrenceInMonths] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxJournalEntry.trAuditDelete] ON [dbo].[dxJournalEntry]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxJournalEntry'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxJournalEntry CURSOR LOCAL FAST_FORWARD for SELECT PK_dxJournalEntry, ID, AccrualEntry, Description, TransactionDate, FK_dxJournal, DT, CT, Posted, FK_dxEntryRecurrenceType, RecurrenceInMonths from deleted
 Declare @PK_dxJournalEntry int, @ID int, @AccrualEntry Bit, @Description varchar(255), @TransactionDate DateTime, @FK_dxJournal int, @DT Float, @CT Float, @Posted Bit, @FK_dxEntryRecurrenceType int, @RecurrenceInMonths int

 OPEN pk_cursordxJournalEntry
 FETCH NEXT FROM pk_cursordxJournalEntry INTO @PK_dxJournalEntry, @ID, @AccrualEntry, @Description, @TransactionDate, @FK_dxJournal, @DT, @CT, @Posted, @FK_dxEntryRecurrenceType, @RecurrenceInMonths
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxJournalEntry, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AccrualEntry', @AccrualEntry
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', @TransactionDate
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxJournal', @FK_dxJournal
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DT', @DT
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CT', @CT
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', @Posted
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEntryRecurrenceType', @FK_dxEntryRecurrenceType
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'RecurrenceInMonths', @RecurrenceInMonths
FETCH NEXT FROM pk_cursordxJournalEntry INTO @PK_dxJournalEntry, @ID, @AccrualEntry, @Description, @TransactionDate, @FK_dxJournal, @DT, @CT, @Posted, @FK_dxEntryRecurrenceType, @RecurrenceInMonths
 END

 CLOSE pk_cursordxJournalEntry 
 DEALLOCATE pk_cursordxJournalEntry
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxJournalEntry.trAuditInsUpd] ON [dbo].[dxJournalEntry] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxJournalEntry CURSOR LOCAL FAST_FORWARD for SELECT PK_dxJournalEntry from inserted;
 set @tablename = 'dxJournalEntry' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxJournalEntry
 FETCH NEXT FROM pk_cursordxJournalEntry INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( AccrualEntry )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'AccrualEntry', AccrualEntry from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( TransactionDate )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsDate ) 
        select @pkdataaudit, 'TransactionDate', TransactionDate from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxJournal )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxJournal', FK_dxJournal from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DT )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DT', DT from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CT )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CT', CT from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Posted )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsBoolean ) 
        select @pkdataaudit, 'Posted', Posted from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxEntryRecurrenceType )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxEntryRecurrenceType', FK_dxEntryRecurrenceType from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( RecurrenceInMonths )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'RecurrenceInMonths', RecurrenceInMonths from dxJournalEntry where PK_dxJournalEntry = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxJournalEntry INTO @keyvalue
 END

 CLOSE pk_cursordxJournalEntry 
 DEALLOCATE pk_cursordxJournalEntry
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxJournalEntry.trDelete] ON [dbo].[dxJournalEntry]
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON   ;
  delete from dxJournalEntryDetail where FK_dxJournalEntry in (SELECT PK_dxJournalEntry FROM deleted) ;
  delete from dxJournalEntry       where PK_dxJournalEntry in (SELECT PK_dxJournalEntry FROM deleted) ;
  SET NOCOUNT OFF;
END
GO
ALTER TABLE [dbo].[dxJournalEntry] ADD CONSTRAINT [PK_dxJournalEntry] PRIMARY KEY CLUSTERED  ([PK_dxJournalEntry]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxJournalEntry_FK_dxEntryRecurrenceType] ON [dbo].[dxJournalEntry] ([FK_dxEntryRecurrenceType]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxJournalEntry_FK_dxJournal] ON [dbo].[dxJournalEntry] ([FK_dxJournal]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxDB_dxJournalEntryDate] ON [dbo].[dxJournalEntry] ([TransactionDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxJournalEntry] ADD CONSTRAINT [dxConstraint_FK_dxEntryRecurrenceType_dxJournalEntry] FOREIGN KEY ([FK_dxEntryRecurrenceType]) REFERENCES [dbo].[dxEntryRecurrenceType] ([PK_dxEntryRecurrenceType])
GO
ALTER TABLE [dbo].[dxJournalEntry] ADD CONSTRAINT [dxConstraint_FK_dxJournal_dxJournalEntry] FOREIGN KEY ([FK_dxJournal]) REFERENCES [dbo].[dxJournal] ([PK_dxJournal])
GO
