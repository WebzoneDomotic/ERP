SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: François Baillargé, Marcel Dubé
-- Create date: 27 novembre 2011
-- Description:	Read Scan Batch
-- =============================================
CREATE PROCEDURE [dbo].[pdxReadScanBatch]
  (@PK_dxInventoryAdjustment INT, @RecountVersion INT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We start by clearing ajustment details
	DELETE FROM dxInventoryAdjustmentDetail WHERE FK_dxInventoryAdjustment = @PK_dxInventoryAdjustment;

	-- Update Scanbatch items to link them to the current inventory adjustment
	UPDATE dxScanBatch SET FK_dxInventoryAdjustment = @PK_dxInventoryAdjustment, RecountVersion = @RecountVersion
   WHERE FK_dxInventoryAdjustment IS NULL;

    -- Insert products/lots that were scanned in the current version and not already linked to an adjustment
    INSERT INTO dxInventoryAdjustmentDetail(FK_dxInventoryAdjustment, FK_dxWarehouse, FK_dxLocation,
                                            FK_dxProduct, Lot, FK_dxScaleUnit, ScanQuantity, InStockQuantity, Quantity)
		SELECT @PK_dxInventoryAdjustment, SB.FK_dxWarehouse, SB.FK_dxLocation,
			   SB.FK_dxProduct, SB.Lot, P.FK_dxScaleUnit, dbo.fdxBankersRound(Coalesce(SUM(SB.Quantity), 0),6),
			   dbo.fdxBankersRound(Coalesce(PL.InStockQuantity, 0),6) InStockQty,
			   dbo.fdxBankersRound(Coalesce(SUM(SB.Quantity), 0) - Coalesce(PL.InStockQuantity, 0),6)
		FROM dxScanBatch SB
		     LEFT JOIN dxProductLot PL ON PL.FK_dxWarehouse = SB.FK_dxWarehouse and
		                                  PL.FK_dxProduct  = SB.FK_dxProduct and
		                                  PL.FK_dxLocation = SB.FK_dxLocation AND
		                                  PL.Lot = RTRIM(SB.Lot)
		     LEFT JOIN dxWarehouse  W  ON W.PK_dxWarehouse = SB.FK_dxWarehouse
		     LEFT JOIN dxProduct    P  ON P.PK_dxProduct   = SB.FK_dxProduct
		WHERE ( (FK_dxInventoryAdjustment IS NULL) OR (FK_dxInventoryAdjustment = @PK_dxInventoryAdjustment) )

		--AND
		--			SB.PK_dxScanBatch NOT IN (SELECT SB1.PK_dxScanBatch
		--								FROM dxScanBatch SB1
  -- 							   WHERE SB1.FK_dxWarehouse = SB.FK_dxWarehouse
		--							   and SB1.FK_dxLocation  = SB.FK_dxLocation
		--								 and SB1.FK_dxProduct   = SB.FK_dxProduct
		--								 and SB1.Lot = SB.Lot
  --                   and SB1.RecountVersion <
		--								  	  (SELECT MAX(RecountVersion) FROM dxScanBatch SB1
  -- 									        WHERE SB1.FK_dxWarehouse = SB.FK_dxWarehouse
		--								  	      and SB1.FK_dxLocation  = SB.FK_dxLocation
		--								          and SB1.FK_dxProduct   = SB.FK_dxProduct
		--									        and SB1.Lot            = SB.Lot))
		GROUP BY SB.FK_dxWarehouse, SB.FK_dxLocation, SB.FK_dxProduct, SB.Lot, P.FK_dxScaleUnit,PL.InStockQuantity;

	-- Insert other lots of the scanned products that are in the invetory
	  INSERT INTO dxInventoryAdjustmentDetail(FK_dxInventoryAdjustment, FK_dxWarehouse, FK_dxLocation,
	                                          FK_dxProduct, Lot, ScanQuantity, FK_dxScaleUnit, InStockQuantity, Quantity)
		SELECT @PK_dxInventoryAdjustment
		     , PL.FK_dxWarehouse
		     , PL.FK_dxLocation
		     , PL.FK_dxProduct
		     , PL.Lot
		     , 0
		     , P.FK_dxScaleUnit
			 --, dbo.fdxBankersRound(Coalesce(SUM(PL.InStockQuantity), 0),6) InStockQty
			 --, dbo.fdxBankersRound(0 - Coalesce(SUM(PL.InStockQuantity),0), 6)
			  , dbo.fdxBankersRound(Coalesce((PL.InStockQuantity), 0),6) InStockQty
			 , dbo.fdxBankersRound(0 - Coalesce((PL.InStockQuantity),0), 6)
FROM  dxProductLot PL
LEFT JOIN dxInventoryAdjustmentDetail IAD ON IAD.FK_dxInventoryAdjustment = @PK_dxInventoryAdjustment AND
                                   PL.FK_dxWarehouse = IAD.FK_dxWarehouse and
		                                 PL.FK_dxProduct   = IAD.FK_dxProduct and
		                                 PL.FK_dxLocation  = IAD.FK_dxLocation AND
		                                 PL.Lot            = IAD.Lot
			LEFT JOIN dxProduct    P  ON P.PK_dxProduct  = PL.FK_dxProduct
		WHERE
  IAD.PK_dxInventoryAdjustmentDetail IS NULL
		--GROUP BY PL.FK_dxWarehouse, PL.FK_dxLocation, PL.FK_dxProduct, PL.Lot, P.FK_dxScaleUnit
		--HAVING Coalesce(SUM(PL.InStockQuantity), 0) > 0;
		and PL.InStockQuantity  > 0 AND
  PL.FK_dxProduct IN (SELECT FK_dxProduct FROM dxInventoryAdjustmentDetail WHERE FK_dxInventoryAdjustment = @PK_dxInventoryAdjustment)
	-- Finally we update RecountVersion of the adjustment if necessary
	UPDATE dxInventoryAdjustment SET RecountVersion = @RecountVersion
	WHERE PK_dxInventoryAdjustment = @PK_dxInventoryAdjustment AND
		  RecountVersion <> @RecountVersion;
END
GO
