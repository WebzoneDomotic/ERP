SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create  Function [dbo].[fdxDT] ( @Amount float )
RETURNS Float
-- Return 0.0 if negative else return the @Amount
AS
BEGIN
   RETURN case when @Amount < 0.0 then 0.0 else Round(@Amount,2) end
END
GO
