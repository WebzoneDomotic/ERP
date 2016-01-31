SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-03-11
-- Description:	Retoure un niveau de délai entre 1 et 3 selon la date ADate en comparaison avec la date courante
-- 1 est le moins de délai  et le 3 plus de délai
-- --------------------------------------------------------------------------------------------
create  Function [dbo].[fdxGetDateDelay] ( @ADate Datetime )
RETURNS Integer
AS
BEGIN
    Declare @Delay int
    Declare @DiFF  int
    set @Delay = 2 
    Set @DiFF = DateDiFF ( dd, @ADate , dbo.fdxGetDateNoTime(getdate()))
    if @DiFF <= 1      set @Delay = 0 else
    if @DiFF <= 2      set @Delay = 1 else
    if @DiFF <= 1000   set @Delay = 2 
    RETURN @Delay 
END
GO
