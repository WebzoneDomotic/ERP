SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-12-02
-- Description:	Création d' un OF selon les commandes MTO
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxCreateWOFromMTO]
as
begin
   Insert into dxWorkOrder ( WorkOrderDate , WorkOrderStatus, FK_dxProduct, Lot, QuantityToProduce, FK_dxClientOrderDetail)
   Select
        dbo.fdxGetPrevNextWorkDay(DateAdd( dd, -pr.LeadTimeInDays, cd.ExpectedDeliveryDate ),-1)
      , 0 -- Planned
      , cd.FK_dxProduct
      , Case when cd.Lot in('0','') then [dbo].[fdxGenerateLotNumber] ( -1, 'DXWORKORDER', 0) else cd.Lot end
      ,(cd.ProductQuantity - cd.ShippedQuantity)
      , cd.PK_dxClientOrderDetail
      from dxClientOrderDetail cd
    left outer join dxClientOrder co on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
    left outer join dxProduct     pr on ( pr.PK_dxProduct = cd.FK_dxProduct )
    where Not FK_dxProduct is null
      and (pr.InventoryItem = 1)
      and (co.MakeToOrder = 1) -- Exclude MTO Client Orders
      --and (co.OnHold = 0)
      and (co.Posted = 1)
      and (cd.Closed = 0)
      and (cd.ProductQuantity - cd.ShippedQuantity) > 0.00000001
      and cd.[FK_dxLocation__Reserved] is null
      and Not exists ( Select 1 from dxWorkOrder wo where wo.FK_dxClientOrderDetail = cd.PK_dxClientOrderDetail)
end
GO
