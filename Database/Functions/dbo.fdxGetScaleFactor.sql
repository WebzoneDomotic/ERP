SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create  Function [dbo].[fdxGetScaleFactor] ( @FK_in int, @FK_out int )
RETURNS Float
AS
BEGIN
   RETURN Coalesce( (Select top 1 Factor from dxFactorTableR 
                          where FK_dxScaleUnit__In = @FK_in and FK_dxScaleUnit__Out = @FK_out 
                       order by steps asc ), 0.0)
END
GO
