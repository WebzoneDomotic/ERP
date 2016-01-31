SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2010-09-21
-- Description:	Calcul des ajustements du taux de change en fin de période
-- --------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[pdxGLEntryCurrency] ( @ClosingPeriod int )
AS

  Declare @Entry int

  SET NOCOUNT ON;
  Delete from dxAccountTransaction where EndOfPeriodTransaction = 1 and FK_dxPeriod = @ClosingPeriod ;
  -- Regenerate currency transactions
  Exec pdxRecalculatePeriodCurrencyTransaction  @ClosingPeriod

  -- Recalculate the GL ... because we need it for the foreign exchange variance
  Execute pdxUpdateAccountPeriod

  -- Get GL Entry number
  Insert into dxEntry (  KindOfDocument,  PrimaryKeyValue )
      select  -1 , PK_dxPeriod from dxPeriod where PK_dxPeriod = @ClosingPeriod
         and  ( not exists ( select 1 from dxEntry where KindOfDocument = -1 and PrimaryKeyValue = @ClosingPeriod)) ;
  set @Entry  = ( select PK_dxEntry from dxEntry where KindOfDocument = -1 and PrimaryKeyValue = @ClosingPeriod);

  -- Taux d'opération pour les comptes de dépenses et de revenu
  -- Les comptes de bilan non réévalués ne doivent pas être considérés
  insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodTransaction,KindOfDocument,PrimaryKeyValue )
  Select
         @Entry, pe.EndDate , 60 , @ClosingPeriod
       , co.FK_dxAccount__ForeignExchangeExpense
       , convert ( varchar(100), '('+Convert(varchar,case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end) + ') ' +ac.Description )

       , dbo.fdxDT( (   Round(Round((gf.PeriodAmount),2)
                      - convert(Float,   Round((gl.PeriodAmount) * cd.AverageRate  ,2)
                                        -Round((gl.PeriodAmount),2)),2)))

       , dbo.fdxCT( (   Round(Round((gf.PeriodAmount),2)
                      - convert(Float, Round((gl.PeriodAmount) * cd.AverageRate ,2)
                                      -Round((gl.PeriodAmount),2)),2)))

       ,co.FK_dxCurrency__System  ,1 ,0 ,@ClosingPeriod

  From dbo.dxGL gl
  left outer join dxAccount ac on ( ac.PK_dxAccount =  gl.FK_dxAccount )
  left outer join dxPeriod  pe on ( pe.PK_dxPeriod  =  gl.FK_dxPeriod )
  left outer join dxCurrencyDetail cd on ( cd.FK_dxPeriod =  gl.FK_dxPeriod) and ( ac.FK_dxCurrency = cd.FK_dxCurrency)
  -- Récupérer le compte du taux de change
  left outer join dxGL gf on (gf.FK_dxAccount = ac.FK_dxAccount__ForeignExchangeReference) and (gf.FK_dxPeriod =  gl.FK_dxPeriod)
  left outer join dxAccountConfiguration co on ( PK_dxAccountConfiguration =1)
  Where pe.PK_dxPeriod = @ClosingPeriod
    and (ac.FK_dxAccountType <> 1)
    -- Les comptes de bilan non réévalués ne doivent pas être considérés, or (ac.FK_dxAccountType = 1 and ac.RevaluationOfBalanceSheetAccount = 0))
    and Abs(gl.PeriodAmount) > 0.001
    and (not ac.FK_dxAccount__ForeignExchangeReference is null)
    and  ABS(   Round(Round((gf.PeriodAmount),2)
              - convert(Float,  Round((gl.PeriodAmount) * cd.AverageRate,2)
                               -Round((gl.PeriodAmount),2)),2)) > 0.001

  insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodTransaction,KindOfDocument,PrimaryKeyValue )
  Select
         @Entry, pe.EndDate , 60 , @ClosingPeriod
       , ac.FK_dxAccount__ForeignExchangeReference
       , convert ( varchar(100), '('+Convert(varchar,case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end) + ') ' + ac.Description )
       , dbo.fdxCT( (   Round(Round((gf.PeriodAmount),2)
                      - convert(Float,   Round((gl.PeriodAmount) * cd.AverageRate  ,2)
                                        -Round((gl.PeriodAmount),2)),2)))

       , dbo.fdxDT( (   Round(Round((gf.PeriodAmount),2)
                      - convert(Float, Round((gl.PeriodAmount) * cd.AverageRate ,2)
                                      -Round((gl.PeriodAmount),2)),2)))
       , co.FK_dxCurrency__System  ,1 ,0 ,@ClosingPeriod

  From dbo.dxGL gl
  left outer join dxAccount ac on ( ac.PK_dxAccount =  gl.FK_dxAccount )
  left outer join dxPeriod  pe on ( pe.PK_dxPeriod  =  gl.FK_dxPeriod )
  left outer join dxCurrencyDetail cd on ( cd.FK_dxPeriod =  gl.FK_dxPeriod) and ( ac.FK_dxCurrency = cd.FK_dxCurrency)
  -- Récupérer le compte du taux de change
  left outer join dxGL gf on (gf.FK_dxAccount = ac.FK_dxAccount__ForeignExchangeReference) and (gf.FK_dxPeriod =  gl.FK_dxPeriod)
  left outer join dxAccountConfiguration co on ( PK_dxAccountConfiguration =1)
  Where pe.PK_dxPeriod = @ClosingPeriod
    and (ac.FK_dxAccountType <> 1)
    -- Les comptes de bilan non réévalués ne doivent pas être considérés, or (ac.FK_dxAccountType = 1 and ac.RevaluationOfBalanceSheetAccount = 0))
    and Abs(gl.PeriodAmount) > 0.001
    and (not ac.FK_dxAccount__ForeignExchangeReference is null)
    and  ABS(   Round(Round((gf.PeriodAmount),2)
              - convert(Float,  Round((gl.PeriodAmount) * cd.AverageRate,2)
                               -Round((gl.PeriodAmount),2)),2)) > 0.001
  -- ------------------------------------------------------------------------------------------------------------------
  --- Taux de clôture des postes de bilan avec réévaluation
  insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodTransaction,KindOfDocument,PrimaryKeyValue )
  Select
         @Entry, pe.EndDate , 60 , @ClosingPeriod
       , co.FK_dxAccount__ForeignExchangeExpense
       , convert ( varchar(100), '('+Convert(varchar,case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end) + ') ' +ac.Description )

       , dbo.fdxDT( (   Round(Round((gf.StartingPeriodAmount+gf.PeriodAmount),2)
                      - convert(Float,   Round((gl.StartingPeriodAmount+gl.PeriodAmount) * cd.ClosingRate ,2)
                                        -Round((gl.StartingPeriodAmount+gl.PeriodAmount),2)),2)))

       , dbo.fdxCT( (   Round(Round((gf.StartingPeriodAmount+gf.PeriodAmount),2)
                      - convert(Float, Round((gl.StartingPeriodAmount+gl.PeriodAmount) * cd.ClosingRate   ,2)
                                      -Round((gl.StartingPeriodAmount+gl.PeriodAmount),2)),2)))
       ,co.FK_dxCurrency__System  ,1 ,0 ,@ClosingPeriod

  From dbo.dxGL gl
  left outer join dxAccount ac on ( ac.PK_dxAccount =  gl.FK_dxAccount )
  left outer join dxPeriod  pe on ( pe.PK_dxPeriod  =  gl.FK_dxPeriod )
  left outer join dxCurrencyDetail cd on ( cd.FK_dxPeriod =  gl.FK_dxPeriod) and ( ac.FK_dxCurrency = cd.FK_dxCurrency)
  -- Récupérer le compte du taux de change
  left outer join dxGL gf on (gf.FK_dxAccount = ac.FK_dxAccount__ForeignExchangeReference) and (gf.FK_dxPeriod =  gl.FK_dxPeriod)
  left outer join dxAccountConfiguration co on ( PK_dxAccountConfiguration =1)
  Where pe.PK_dxPeriod = @ClosingPeriod
    and ((ac.FK_dxAccountType = 1) and (ac.RevaluationOfBalanceSheetAccount = 1))
    and Abs(gl.StartingPeriodAmount+gl.PeriodAmount) > 0.001
    and (not ac.FK_dxAccount__ForeignExchangeReference is null)
    and  ABS(   Round(Round((gf.StartingPeriodAmount+gf.PeriodAmount),2)
              - convert(Float, Round((gl.StartingPeriodAmount+gl.PeriodAmount) * cd.ClosingRate,2)
                          -Round((gl.StartingPeriodAmount+gl.PeriodAmount),2)),2)) > 0.001

  insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodTransaction,KindOfDocument,PrimaryKeyValue )
  Select
         @Entry, pe.EndDate , 60 , @ClosingPeriod
       , ac.FK_dxAccount__ForeignExchangeReference
       , convert ( varchar(100), '('+Convert(varchar,case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end) + ') ' + ac.Description )
       , dbo.fdxCT( (   Round(Round((gf.StartingPeriodAmount+gf.PeriodAmount),2)
                      - convert(Float,   Round((gl.StartingPeriodAmount+gl.PeriodAmount) * cd.ClosingRate  ,2)
                                        -Round((gl.StartingPeriodAmount+gl.PeriodAmount),2)),2)))

       , dbo.fdxDT( (   Round(Round((gf.StartingPeriodAmount+gf.PeriodAmount),2)
                      - convert(Float, Round((gl.StartingPeriodAmount+gl.PeriodAmount) * cd.ClosingRate ,2)
                                      -Round((gl.StartingPeriodAmount+gl.PeriodAmount),2)),2)))
       , co.FK_dxCurrency__System  ,1 ,0 ,@ClosingPeriod

  From dbo.dxGL gl
  left outer join dxAccount ac on ( ac.PK_dxAccount =  gl.FK_dxAccount )
  left outer join dxPeriod  pe on ( pe.PK_dxPeriod  =  gl.FK_dxPeriod )
  left outer join dxCurrencyDetail cd on ( cd.FK_dxPeriod =  gl.FK_dxPeriod) and ( ac.FK_dxCurrency = cd.FK_dxCurrency)
  -- Récupérer le compte du taux de change
  left outer join dxGL gf on (gf.FK_dxAccount = ac.FK_dxAccount__ForeignExchangeReference) and (gf.FK_dxPeriod =  gl.FK_dxPeriod)
  left outer join dxAccountConfiguration co on ( PK_dxAccountConfiguration =1)
  Where pe.PK_dxPeriod = @ClosingPeriod
    and ((ac.FK_dxAccountType = 1) and (ac.RevaluationOfBalanceSheetAccount = 1))
    and Abs(gl.StartingPeriodAmount+gl.PeriodAmount) > 0.001
    and (not ac.FK_dxAccount__ForeignExchangeReference is null)
    and  ABS(   Round(Round((gf.StartingPeriodAmount+gf.PeriodAmount),2)
              - convert(Float, Round((gl.StartingPeriodAmount+gl.PeriodAmount) * cd.ClosingRate ,2)
                          -Round((gl.StartingPeriodAmount+gl.PeriodAmount),2)),2)) > 0.001
GO
