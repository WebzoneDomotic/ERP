SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-10-17
-- Description:	Generate Finish Product related to a WO.
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pcxGenerateFinishProduct]  @FK_dxWorkOrder int 
--Generate Finish Product related to a WO.
as
BEGIN
   Update dxWorkOrder set QuantityToProduce = QuantityToProduce where PK_dxWorkOrder = -1
END
GO
