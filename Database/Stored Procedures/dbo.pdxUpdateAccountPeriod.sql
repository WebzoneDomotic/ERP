SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
CREATE Procedure [dbo].[pdxUpdateAccountPeriod]
as
Begin
  Declare  @Account int, @Period int
  Declare CR_ActPerToUpdate Cursor LOCAL FAST_FORWARD for Select Distinct FK_dxAccount, FK_dxPeriod from dxAccountPeriodToUpdate
  SET NOCOUNT ON

  Open CR_ActPerToUpdate
  Fetch Next FROM CR_ActPerToUpdate INTO @Account , @Period
  -- For each line of the document we recalculate the amount
  While @@FETCH_STATUS = 0
  Begin
     Execute [dbo].[pdxGLEntryUpdate] @FK_dxAccount = @Account, @FK_dxPeriod = @Period
     Fetch Next FROM CR_ActPerToUpdate INTO @Account , @Period
  end
  -- Close cursor and free ressource
  CLOSE CR_ActPerToUpdate
  DEALLOCATE CR_ActPerToUpdate

  -- Flush the accumulated account buffer...
  Delete from dxAccountPeriodToUpdate
End
GO
