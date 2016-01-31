SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
CREATE Function [dbo].[fdxGetPhaseOverheadVariableCost] (
  @PK_dxProduct int ,
  @PhaseNumber int ,
  @Date Datetime,
  @DeclareQuantity Float )
RETURNS Float
BEGIN
   RETURN 0.0
END
GO
