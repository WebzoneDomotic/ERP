SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxProductRequirement] as
Select
  pt.FK_dxProduct,
  Max(pr.ID) ProductCode,
  Max(pr.Description) ProductDescription,
  Sum(pt.Quantity) InStockQuantity,

  ( select coalesce( sum(ProductQuantity-ReceivedQuantity), 0.0) from dxPurchaseOrderDetail
    where FK_dxProduct = pt.FK_dxProduct and closed=0 and ReceivedQuantity <= Quantity )  BackOrderQuantity,

  ( select coalesce( sum(ProductQuantity-ShippedQuantity), 0.0) from dxClientOrderDetail
    where FK_dxProduct = pt.FK_dxProduct and closed=0 and ShippedQuantity <= Quantity )  ReservedQuantity,

   -1.0 * ( Sum(pt.Quantity) +
  ( select coalesce( sum(ProductQuantity-ReceivedQuantity), 0.0) from dxPurchaseOrderDetail
    where FK_dxProduct = pt.FK_dxProduct and closed=0 and ReceivedQuantity <= Quantity )  -
  ( select coalesce( sum(ProductQuantity-ShippedQuantity), 0.0) from dxClientOrderDetail
    where FK_dxProduct = pt.FK_dxProduct and closed=0 and ShippedQuantity <= Quantity ))  RequiredQuantity

From dxProductTransaction pt
left outer join dxProduct pr on (pr.PK_dxProduct = pt.FK_dxProduct )

Group by 

pt.FK_dxProduct
GO
