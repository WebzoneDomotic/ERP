SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
CREATE  Function [dbo].[fdxGetStandardOverheadVariableCost] ( @PK_dxProduct int, @Date Datetime, @DeclareQuantity Float )
RETURNS Float
-- Return Standard Overhead Variable Cost at a specific date
AS
BEGIN
   RETURN 0.0
END
GO
