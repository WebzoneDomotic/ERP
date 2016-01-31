SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-01-19
-- Description:	Create Accounting Transaction for a Journal Entry
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxPostJournalEntry] @FK_dxJournalEntry int
AS
BEGIN

  SET NOCOUNT ON

  --Declare @FK_dxJournalEntry int
  --set @FK_dxJournalEntry = 20001

  Declare @FK_dxCurrency__System int, @Journal int
  Declare @TransactionDate Datetime
  Declare @Recurrence int, @RecLoop int
  Declare @ADate Datetime, @FK_dxPeriod int

  -- Validate Accounting Period
  set @TransactionDate = ( Select TransactionDate    from dxJournalEntry where PK_dxJournalEntry =  @FK_dxJournalEntry )
  set @Recurrence      = ( Select RecurrenceInMonths from dxJournalEntry where PK_dxJournalEntry =  @FK_dxJournalEntry )
  set @RecLoop         = 0

  Exec [dbo].[pdxValidateAccountingPeriod] @Date = @TransactionDate

  Select @FK_dxCurrency__System = FK_dxCurrency__System from dxAccountConfiguration

  Declare @KOD   int -- Kind of Document
  Declare @PK    int -- Primary key value of Document
  Declare @Entry int -- Entry

  set @KOD = 1
  set @Journal = 10
  set @PK  = @FK_dxJournalEntry

  -- Search for entry linked with this Document
  Select @Entry = PK_dxEntry from dxEntry where KindOfDocument = @KOD  and PrimaryKeyValue = @PK
  -- If not found then create it
  if @Entry is Null Insert into dxEntry ( KindOfDocument,  PrimaryKeyValue )  values( @KOD  , @PK )
  -- Search again
  Select @Entry = PK_dxEntry from dxEntry where KindOfDocument =@KOD  and PrimaryKeyValue = @PK
  -- Delete Accounting Transaction Entry for this Document
  Delete from dxAccountTransaction
   where PrimaryKeyValue = @PK
     and KindOfDocument  = @KOD

  While @RecLoop <= @Recurrence
  begin
    set @ADate = DATEADD ( M , @RecLoop, @TransactionDate )
    set @FK_dxPeriod = (Select PK_dxPeriod From dxPeriod where @ADate between StartDate and EndDate )

    -- Journal Entry DT and CT
    Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodInventory, KindOfDocument,PrimaryKeyValue )
    Select
          @Entry
         ,@ADate
         ,@Journal
         ,@FK_dxPeriod
         ,id.FK_dxAccount
         ,Convert(varchar(100),id.Description)
         ,id.DT
         ,id.CT
         ,ac.FK_dxCurrency ,0 ,@KOD ,@PK
    From dbo.dxJournalEntryDetail id
    left join dxJournalEntry  iv on ( iv.PK_dxJournalEntry = id.FK_dxJournalEntry )
    left outer join dxPeriod   pe on ( iv.TransactionDate between pe.StartDate and pe.EndDate)
    left outer join dxAccount  ac on ( ac.PK_dxAccount = id.FK_dxAccount )
    Where ((abs( id.DT ) > 0.0001) or (ABS(id.CT) > 0.001))
      and id.FK_dxJournalEntry = @PK
    -- Set net recurrence
    Set @RecLoop = @RecLoop +1
  end ; --- End Loop
  Update dxJournalEntry set Posted = 1 where PK_dxJournalEntry = @PK and Posted = 0
  Exec [dbo].[pdxValidateEntry]
  Exec [dbo].[pdxUpdateAccountPeriod]

END
GO
