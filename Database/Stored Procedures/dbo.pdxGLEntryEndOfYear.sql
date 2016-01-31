SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxGLEntryEndOfYear] ( @AccountingYear int )
AS
Declare @Entry int,  @FirstPeriod int,@LastPeriod int,
        @DT float ,@CT float,  @SystemCurrency int,
        @EndDate DateTime, @ProfitAndLossAccount int

  /* Inserting end of year transactions --> (revenue - expense) = Profit and loss       */

  set @FirstPeriod          = Coalesce(( select min(PK_dxPeriod) from dxPeriod 
                                        where Coalesce( AccountingPeriod/100,FK_dxAccountingYear) =@AccountingYear ),-1);
  set @LastPeriod           = Coalesce(( select max(PK_dxPeriod) from dxPeriod 
                                        where Coalesce( AccountingPeriod/100,FK_dxAccountingYear) =@AccountingYear ),-1);
  set @EndDate              = ( select EndDate from dxPeriod where PK_dxPeriod = @LastPeriod );
  set @SystemCurrency       = ( select FK_dxCurrency__System from dxAccountConfiguration );
  set @ProfitAndLossAccount = ( select FK_dxAccount__ProfitAndLoss from dxAccountConfiguration );

  Delete from dxAccountTransaction where EndOfYearTransaction  = 1 and FK_dxPeriod >=  @FirstPeriod ; 
 
  Insert into dxEntry (  KindOfDocument,  PrimaryKeyValue )
  select  0 , PK_dxPeriod from dxPeriod where PK_dxPeriod = @LastPeriod
     and  ( not exists ( select 1 from dxEntry where KindOfDocument = 0 and PrimaryKeyValue = @LastPeriod )) ;
  set @Entry = ( select PK_dxEntry from dxEntry where KindOfDocument = 0 and PrimaryKeyValue = @LastPeriod );
 
  insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT , CT ,FK_dxCurrency, EndOfYearTransaction,KindOfDocument,PrimaryKeyValue )
  select  @Entry , @EndDate , 70 , @LastPeriod , t.FK_dxAccount , 'Renversement des écritures de fin d''année',sum(t.CT),sum(t.DT), t.FK_dxCurrency , 1 ,0, @LastPeriod  from dxAccountTransaction t
   inner join dxAccount a on (a.PK_dxAccount = t.FK_dxAccount )        
   where a.FK_dxAccountType <> 1 
    and  t.FK_dxPeriod between @FirstPeriod and @LastPeriod
  group by t.FK_dxAccount,t.FK_dxCurrency
  Having  Abs( sum(t.CT)-sum(t.DT) ) > 0.000001  ;

    insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT , CT ,FK_dxCurrency, EndOfYearTransaction,KindOfDocument,PrimaryKeyValue )
    select  @Entry , @EndDate , 70 , @LastPeriod ,  @ProfitAndLossAccount  ,'Renversement des écritures de fin d''année', sum(t.DT),sum(t.CT), @SystemCurrency  , 1 ,0, @LastPeriod  from dxAccountTransaction t
     inner join dxAccount a on (a.PK_dxAccount = t.FK_dxAccount )
     where a.FK_dxAccountType <> 1
       and t.FK_dxPeriod between @FirstPeriod and @LastPeriod
       and t.EndOfYearTransaction = 0
    group by t.EndOfYearTransaction
    Having  Abs( sum(t.CT)-sum(t.DT) ) > 0.000001  ;

  update dxAccountTransaction  set DT = Abs(DT-CT) , CT = 0.0        where DT-CT >  0.0 and FK_dxPeriod = @LastPeriod  and EndOfYearTransaction = 1;
  update dxAccountTransaction  set DT = 0.0        , CT = Abs(CT-DT) where DT-CT <= 0.0 and FK_dxPeriod = @LastPeriod  and EndOfYearTransaction = 1;
GO
