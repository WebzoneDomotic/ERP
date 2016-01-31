SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-10-25
-- Description:	Création d'une réception à partir du No. PO
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pdxCreateReceptionFromPO]  @PK_dxPurchaseOrder int
as
BEGIN
	Declare @PK_dxReception int

	Insert into [dbo].[dxReception] (
		   [FK_dxVendor]
		  ,[TransactionDate]
		  ,[VendorPackingSlipNo]
		  ,[Description]
		  ,[Note]
		  ,[Posted] )
	SELECT
		   [FK_dxVendor]
		  ,dbo.fdxGetDateNoTime(GetDate())
		  ,''
		  ,[Description]
		  ,[Note]
		  ,0
	  FROM [dbo].[dxPurchaseOrder]
	Where Posted = 1
	  and Closed = 0
	  and PK_dxPurchaseOrder =  @PK_dxPurchaseOrder
	-- Get Reception PK
	Set @PK_dxReception = SCOPE_IDENTITY()
	-- Insert Details
	INSERT INTO [dbo].[dxReceptionDetail] (
		   FK_dxReception
		  ,[FK_dxPurchaseOrder]
		  ,[FK_dxPurchaseOrderDetail]
		  ,[FK_dxWarehouse]
		  ,[FK_dxLocation]
		  ,[FK_dxProduct]
		  ,[Lot]
		  ,[Description]
		  ,[Quantity]
		  ,[FK_dxScaleUnit__Quantity]
		  ,[ProductQuantity]
		  ,[FK_dxScaleUnit]
		  ,[CurrencyRate]
		  )
	  Select
		   @PK_dxReception
		  ,pd.[FK_dxPurchaseOrder]
		  ,pd.[PK_dxPurchaseOrderDetail]
		  ,( Select Coalesce(pd.FK_dxWarehouse, pr.FK_dxWarehouse__Reception, su.FK_dxWarehouse__Reception) From dxProduct pr, dxSetup su where pr.PK_dxProduct = FK_dxProduct)
		  ,( Select Coalesce(pd.FK_dxLocation, pr.FK_dxLocation__Reception , su.FK_dxLocation__Reception ) From dxProduct pr, dxSetup su where pr.PK_dxProduct = FK_dxProduct)
	    ,pd.[FK_dxProduct]
		  ,Case when po.RMA = 1 then pd.Lot else '0' end
		  ,pd.[Description]
		  ,pd.[Quantity] * (([ProductQuantity]-[ReceivedQuantity]) /[ProductQuantity])
		  ,pd.[FK_dxScaleUnit__Quantity]
		  ,pd.[ProductQuantity] * (([ProductQuantity]-[ReceivedQuantity]) /[ProductQuantity])
		  ,pd.[FK_dxScaleUnit]
		  ,1.0
	  FROM [dxPurchaseOrderDetail] pd
    left join dxPurchaseOrder po on ( po.PK_dxPurchaseOrder = pd.FK_dxPurchaseOrder )
	  Where FK_dxPurchaseOrder =  @PK_dxPurchaseOrder
		and pd.Closed = 0
		and (abs([Quantity])-abs([ReceivedQuantity]) > 0.0)
		and (([Quantity] > 0.0) or (([Quantity] < 0.0) and ( po.RMA = 1 )))
	 -- Return Reception PK
	  Select @PK_dxReception as  PK_dxReception
END
GO
