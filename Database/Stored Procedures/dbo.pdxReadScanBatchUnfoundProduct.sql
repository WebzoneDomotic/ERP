SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[pdxReadScanBatchUnfoundProduct] (@PK_dxInventoryAdjustment INT)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  -- Insert other product that are in the inventory and not in the adjustment
  INSERT INTO dxInventoryAdjustmentDetail(FK_dxInventoryAdjustment, FK_dxWarehouse, FK_dxLocation,
                                          FK_dxProduct, Lot, ScanQuantity, FK_dxScaleUnit, InStockQuantity, Quantity, UnfoundProduct)
	SELECT @PK_dxInventoryAdjustment, PL.FK_dxWarehouse, PL.FK_dxLocation, PL.FK_dxProduct, PL.Lot, 0, P.FK_dxScaleUnit,
		dbo.fdxBankersRound(Coalesce(SUM(PL.InStockQuantity), 0),6) InStockQty, dbo.fdxBankersRound(0 - Coalesce(SUM(PL.InStockQuantity),0), 6), 1
	FROM dxProductLot PL
	LEFT JOIN dxProduct  P ON  P.PK_dxProduct  = PL.FK_dxProduct
	WHERE NOT EXISTS (SELECT 1 FROM dxInventoryAdjustmentDetail IAD2
			           WHERE IAD2.FK_dxInventoryAdjustment = @PK_dxInventoryAdjustment
				         and IAD2.FK_dxProduct   = PL.FK_dxProduct)
	GROUP BY PL.FK_dxWarehouse, PL.FK_dxLocation, PL.FK_dxProduct, PL.Lot, P.FK_dxScaleUnit
	HAVING Coalesce(SUM(PL.InStockQuantity), 0) > 0
   Order by 4
END
GO
