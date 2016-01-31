SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create  PROCEDURE [dbo].[pdxGLEntryUpdateForTheYear]  @AccountingYear int
AS
Begin
    Declare  @LastPeriodOfTheYear int
            ,@FirstPeriodOfTheYear int

    set @FirstPeriodOfTheYear = Coalesce(( select min(PK_dxPeriod) from dxPeriod
                                            where Coalesce( AccountingPeriod/100,FK_dxAccountingYear) =@AccountingYear ),-1);
    set @LastPeriodOfTheYear  = Coalesce(( select max(PK_dxPeriod) from dxPeriod
                                            where Coalesce( AccountingPeriod/100,FK_dxAccountingYear) =@AccountingYear ),-1);

    -- ------------------------------------------------------------------------------------
    --  Updating the account until last period of the year
    update GL
        set gl.StartingPeriodAmount       =  ( select Coalesce( Sum(at.Amount),0.0) from dxAccountTransaction at
                                                where at.FK_dxAccount =GL.FK_dxAccount and at.FK_dxPeriod < GL.FK_dxPeriod )
          , gl.StartingPeriodBudgetAmount = (  select Coalesce( Sum(g.PeriodBudgetAmount),0.0) from dxGL g
                                                where g.FK_dxAccount =GL.FK_dxAccount and g.FK_dxPeriod < GL.FK_dxPeriod )
    from dxGL gl
    where gl.FK_dxPeriod between @FirstPeriodOfTheYear and @LastPeriodOfTheYear;

    update gl
      set gl.PeriodAmount = ( select Coalesce( sum(Amount), 0.0 ) from dxAccountTransaction at
                               where at.FK_dxAccount =GL.FK_dxAccount
                                 and at.FK_dxPeriod = GL.FK_dxPeriod
                                 and at.EndOfYearTransaction = 0 )
    from dxGL gl
    where gl.FK_dxPeriod between @FirstPeriodOfTheYear and @LastPeriodOfTheYear;

    update gl
      set gl.EndingPeriodAmount       = StartingPeriodAmount + PeriodAmount
        , gl.EndingPeriodBudgetAmount = StartingPeriodBudgetAmount + PeriodBudgetAmount
     from dxGL gl
    where gl.FK_dxPeriod between @FirstPeriodOfTheYear and @LastPeriodOfTheYear;

End
GO
