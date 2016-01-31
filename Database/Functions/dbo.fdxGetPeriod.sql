SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxGetPeriod] ( @Delta int) 
--Returns period according to delta difference from current period.
returns int
as
BEGIN
  DECLARE @p int
  Set @p= ( Select Coalesce(PK_dxPeriod, -1) from dxPeriod where dbo.fdxGetDate() between StartDate and EndDate )

  While @Delta <> 0 
  begin 
     if @Delta < 0
     begin
        Set @P = ( select top 1 PK_dxPeriod from dxPeriod 
                    where StartDate < ( select StartDate from dxPeriod where PK_dxPeriod = @P ) order by StartDate Desc )
        Set @Delta = @Delta +1 ;
     end else
     begin
        Set @P = ( select top 1 PK_dxPeriod from dxPeriod
                    where StartDate > ( select StartDate from dxPeriod where PK_dxPeriod = @P ) order by StartDate Asc )
        Set @Delta = @Delta -1 ;
     end
  end
  RETURN  Coalesce(@p, -1)
END
GO
