SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetLastPeriodOfTheYear] ( @FK_dxPeriod int) 
--Returns last period of the year from current period pass to @FK_dxPeriod.
returns int
as
BEGIN
  DECLARE @R int
  Set @R = ( Select Top 1 PK_dxPeriod from dxPeriod where FK_dxAccountingYear
                 = ( Select FK_dxAccountingYear From dxPeriod where PK_dxPeriod = @FK_dxPeriod )
                 order by StartDate Desc )
  RETURN  Coalesce(@R, -1)
END
GO
