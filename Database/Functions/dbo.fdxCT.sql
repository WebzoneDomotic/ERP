SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create  Function [dbo].[fdxCT] ( @Amount float )
RETURNS Float
-- Return 0.0 if positive else return the absolute value of this amount
AS
BEGIN
   RETURN case when @Amount < 0.0 then Round(Abs(@Amount),2) else 0.0 end
END
GO
