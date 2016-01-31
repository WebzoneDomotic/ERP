SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 15 avril 2012
-- Description:	Création des OF
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxRecalculatePeriodCurrencyTransaction]  @FK_dxPeriod int
as
Begin
  SET NOCOUNT ON

  -- Flush all the foreign exchange transactions for the period
  -- and regen the transactions
  Delete from dxAccountTransaction where FK_dxJournal =60 and FK_dxPeriod = @FK_dxPeriod
  -- -------------------------------------------------------------------------------------------------
  -- Generate a foreign exchange transaction  if it is the case
  -- -------------------------------------------------------------------------------------------------
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodTransaction,KindOfDocument,PrimaryKeyValue, CurrencyRate )
  Select
         gl.FK_dxEntry, gl.TransactionDate , 60 , gl.FK_dxPeriod
       , co.FK_dxAccount__ForeignExchangeExpense
       , convert ( varchar(100), gl.Description )
       , Round(case when
                gl.Amount - Round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2) > 0.001 then
            Abs(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2)) else 0.0 end ,2)
       , Round(case when
                gl.Amount - Round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2) < -0.001 then
            Abs(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2)) else 0.0 end,2)
       ,co.FK_dxCurrency__System  ,0 ,gl.KindOfDocument , gl.PrimaryKeyValue
       ,case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end

  From dxAccountTransaction gl
  left join dxAccount ac on ( ac.PK_dxAccount =  gl.FK_dxAccount )
  left join dxPeriod  pe on ( pe.PK_dxPeriod  =  gl.FK_dxPeriod )
  left join dxCurrencyDetail cd on ( cd.FK_dxPeriod =  gl.FK_dxPeriod) and ( ac.FK_dxCurrency = cd.FK_dxCurrency)
  -- Récupérer le compte du taux de change
  left outer join dxAccountTransaction gf on (gf.FK_dxAccount = ac.FK_dxAccount__ForeignExchangeReference) and (gf.FK_dxPeriod =  gl.FK_dxPeriod)
  left outer join dxAccountConfiguration co on ( PK_dxAccountConfiguration =1)
  Where pe.PK_dxPeriod = gl.FK_dxPeriod
    and Abs(gl.Amount) > 0.001
    and (not ac.FK_dxAccount__ForeignExchangeReference is null)
    -- Exclusion des comptes de bilan non réévalués
    and (not( ac.FK_dxAccountType = 1 and ac.RevaluationOfBalanceSheetAccount = 0 ))
    and gl.EndOfYearTransaction = 0
    and  Abs(Round(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2),2)) > 0.001
    and gl.FK_dxPeriod = @FK_dxPeriod

  -- ----------------------------------------------------------------------------------------------------
  Insert into dxAccountTransaction ( FK_dxEntry, TransactionDate, FK_dxJournal, FK_dxPeriod, FK_dxAccount , Description, DT ,CT ,FK_dxCurrency, EndOfPeriodTransaction,KindOfDocument,PrimaryKeyValue, CurrencyRate  )
  Select
         gl.FK_dxEntry, gl.TransactionDate , 60 , gl.FK_dxPeriod
       , ac.FK_dxAccount__ForeignExchangeReference
       , convert ( varchar(100),  gl.Description )
       , Round(case when
                gl.Amount - Round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2) < -0.001 then
            Abs(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2)) else 0.0 end,2)
       , Round(case when
                gl.Amount - Round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2) > 0.001 then
            Abs(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2)) else 0.0 end,2)
       ,co.FK_dxCurrency__System  ,0 ,gl.KindOfDocument , gl.PrimaryKeyValue
       ,case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end

  From dxAccountTransaction gl
  left join dxAccount ac on ( ac.PK_dxAccount =  gl.FK_dxAccount )
  left join dxPeriod  pe on ( pe.PK_dxPeriod  =  gl.FK_dxPeriod )
  left  join dxCurrencyDetail cd on ( cd.FK_dxPeriod =  gl.FK_dxPeriod) and ( ac.FK_dxCurrency = cd.FK_dxCurrency)
  -- Récupérer le compte du taux de change
  left outer join dxAccountTransaction gf on (gf.FK_dxAccount = ac.FK_dxAccount__ForeignExchangeReference) and (gf.FK_dxPeriod =  gl.FK_dxPeriod)
  left outer join dxAccountConfiguration co on ( PK_dxAccountConfiguration =1)
  Where pe.PK_dxPeriod = gl.FK_dxPeriod
    and Abs(gl.Amount) > 0.001
    and (not ac.FK_dxAccount__ForeignExchangeReference is null)
    -- Exclusion des comptes de bilan non réévalués
    and (not( ac.FK_dxAccountType = 1 and ac.RevaluationOfBalanceSheetAccount = 0 ))
    and gl.EndOfYearTransaction = 0
    and  Abs(Round(gl.Amount - round( gl.Amount * case when ac.FK_dxAccountType =1 then cd.ClosingRate else cd.AverageRate end ,2),2)) > 0.001
    and gl.FK_dxPeriod = @FK_dxPeriod

  Exec [dbo].[pdxValidateEntry] @FK_dxPeriod
  Exec [dbo].[pdxUpdateAccountPeriod]

  SET NOCOUNT OFF
End
GO
