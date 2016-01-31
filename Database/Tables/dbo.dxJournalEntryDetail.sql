CREATE TABLE [dbo].[dxJournalEntryDetail]
(
[PK_dxJournalEntryDetail] [int] NOT NULL IDENTITY(1, 1),
[FK_dxJournalEntry] [int] NOT NULL,
[Description] [varchar] (255) COLLATE French_CI_AS NULL,
[FK_dxAccount] [int] NOT NULL,
[CT] [float] NOT NULL CONSTRAINT [DF_dxJournalEntryDetail_CT] DEFAULT ((0.0)),
[DT] [float] NOT NULL CONSTRAINT [DF_dxJournalEntryDetail_DT] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxJournalEntryDetail.trAuditDelete] ON [dbo].[dxJournalEntryDetail]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxJournalEntryDetail'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxJournalEntryDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxJournalEntryDetail, FK_dxJournalEntry, Description, FK_dxAccount, CT, DT from deleted
 Declare @PK_dxJournalEntryDetail int, @FK_dxJournalEntry int, @Description varchar(255), @FK_dxAccount int, @CT Float, @DT Float

 OPEN pk_cursordxJournalEntryDetail
 FETCH NEXT FROM pk_cursordxJournalEntryDetail INTO @PK_dxJournalEntryDetail, @FK_dxJournalEntry, @Description, @FK_dxAccount, @CT, @DT
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxJournalEntryDetail, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxJournalEntry', @FK_dxJournalEntry
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', @Description
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', @FK_dxAccount
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CT', @CT
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DT', @DT
FETCH NEXT FROM pk_cursordxJournalEntryDetail INTO @PK_dxJournalEntryDetail, @FK_dxJournalEntry, @Description, @FK_dxAccount, @CT, @DT
 END

 CLOSE pk_cursordxJournalEntryDetail 
 DEALLOCATE pk_cursordxJournalEntryDetail
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxJournalEntryDetail.trAuditInsUpd] ON [dbo].[dxJournalEntryDetail] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxJournalEntryDetail CURSOR LOCAL FAST_FORWARD for SELECT PK_dxJournalEntryDetail from inserted;
 set @tablename = 'dxJournalEntryDetail' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxJournalEntryDetail
 FETCH NEXT FROM pk_cursordxJournalEntryDetail INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxJournalEntry )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxJournalEntry', FK_dxJournalEntry from dxJournalEntryDetail where PK_dxJournalEntryDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( Description )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsString ) 
        select @pkdataaudit, 'Description', Description from dxJournalEntryDetail where PK_dxJournalEntryDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( FK_dxAccount )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsInteger ) 
        select @pkdataaudit, 'FK_dxAccount', FK_dxAccount from dxJournalEntryDetail where PK_dxJournalEntryDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( CT )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'CT', CT from dxJournalEntryDetail where PK_dxJournalEntryDetail = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( DT )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'DT', DT from dxJournalEntryDetail where PK_dxJournalEntryDetail = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxJournalEntryDetail INTO @keyvalue
 END

 CLOSE pk_cursordxJournalEntryDetail 
 DEALLOCATE pk_cursordxJournalEntryDetail
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxJournalEntryDetail.trUpdateSum] ON [dbo].[dxJournalEntryDetail]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   declare @FK int, @FKi int , @FKd int ;
   SET NOCOUNT ON;
   set @FKi  = ( SELECT Coalesce(max(FK_dxJournalEntry ),-1) from inserted )
   set @FKd = ( SELECT Coalesce(max(FK_dxJournalEntry ),-1) from deleted )
   if (@FKi < @FKd)  set @FK = @FKd else  set @FK = @FKi

   update dxJournalEntry
         set
         CT = ( select coalesce( sum(CT) , 0.0 )  from dxJournalEntryDetail where FK_dxJournalEntry = @FK ) ,
         DT = ( select coalesce( sum(DT) , 0.0 )  from dxJournalEntryDetail where FK_dxJournalEntry = @FK )
   where PK_dxJournalEntry = @FK
   SET NOCOUNT OFF;
END
GO
ALTER TABLE [dbo].[dxJournalEntryDetail] ADD CONSTRAINT [PK_dxJournalEntryDetail] PRIMARY KEY CLUSTERED  ([PK_dxJournalEntryDetail]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxJournalEntryDetail_FK_dxAccount] ON [dbo].[dxJournalEntryDetail] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxJournalEntryDetail_FK_dxJournalEntry] ON [dbo].[dxJournalEntryDetail] ([FK_dxJournalEntry]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxJournalEntryDetail] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxJournalEntryDetail] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxJournalEntryDetail] ADD CONSTRAINT [dxConstraint_FK_dxJournalEntry_dxJournalEntryDetail] FOREIGN KEY ([FK_dxJournalEntry]) REFERENCES [dbo].[dxJournalEntry] ([PK_dxJournalEntry])
GO
