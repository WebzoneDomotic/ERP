SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-03-05
-- Description:	Custom MRP 
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pcxMRP] @MRPStartDate Datetime, @NumberOfPeriod int
--Custom MRP
as
BEGIN
   Update dxWorkOrder set QuantityToProduce = QuantityToProduce where PK_dxWorkOrder = -1
END
GO
