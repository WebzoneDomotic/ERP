SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxGLEntryUpdate]  @FK_dxAccount int , @FK_dxPeriod int
AS
Begin
    Declare @LastPeriodToUpdate int
    -- -----------------Start calculationg from period----------------------------------------

    -- Get Last period to update
    Set @LastPeriodToUpdate = Coalesce((Select PK_dxPeriod from dxPeriod where getdate() between StartDate and EndDate), @FK_dxPeriod)
    -- Last Period to update should not be lower then Period to Update
    if @LastPeriodToUpdate < @FK_dxPeriod set @LastPeriodToUpdate = @FK_dxPeriod

    -- ----------------------------------------------------------------------------------------
    -- Updating the GL
    update gl
        set gl.StartingPeriodAmount       =  ( select Coalesce( Sum(at.Amount),0.0) from dxAccountTransaction at
                                                where at.FK_dxAccount = GL.FK_dxAccount and at.FK_dxPeriod < GL.FK_dxPeriod )
          , gl.StartingPeriodBudgetAmount =  ( select Coalesce( Sum(g.PeriodBudgetAmount),0.0) from dxGL g
                                                where g.FK_dxAccount = GL.FK_dxAccount and g.FK_dxPeriod < GL.FK_dxPeriod )
     from dxGL gl
    where gl.FK_dxAccount = @FK_dxAccount
      and gl.FK_dxPeriod between @FK_dxPeriod and @LastPeriodToUpdate;

    update gl
      set gl.PeriodAmount = ( select Coalesce( sum(Amount), 0.0 ) from dxAccountTransaction at
                               where at.FK_dxAccount =GL.FK_dxAccount
                                 and at.FK_dxPeriod = GL.FK_dxPeriod
                                 and at.EndOfYearTransaction = 0 )
     from dxGL gl
    where gl.FK_dxAccount = @FK_dxAccount
      and gl.FK_dxPeriod between @FK_dxPeriod and @LastPeriodToUpdate;

    update gl
      set gl.EndingPeriodAmount       = StartingPeriodAmount + PeriodAmount
        , gl.EndingPeriodBudgetAmount = StartingPeriodBudgetAmount + PeriodBudgetAmount
     from dxGL gl
    where gl.FK_dxAccount = @FK_dxAccount
      and gl.FK_dxPeriod between @FK_dxPeriod and @LastPeriodToUpdate;
End
GO
