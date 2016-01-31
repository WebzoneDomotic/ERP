SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-12-02
-- Description:	Création d' un OF selon les rework
-- --------------------------------------------------------------------------------------------
Create procedure [dbo].[pdxCreateWOFromRework]   @PK_dxDeclarationDismantling  int = -1
as
begin
   Insert into dxWorkOrder ( WorkOrderDate , WorkOrderStatus, FK_dxProduct, Lot, QuantityToProduce, FK_dxDeclarationDismantling )
   Select
        de.TransactionDate
      , 0 -- Planned
      , di.FK_dxProduct
      , Case when di.Lot in('0','') then [dbo].[fdxGenerateLotNumber] ( -1, 'DXWORKORDER', 0) else di.Lot end
      , di.Quantity
      , di.PK_dxDeclarationDismantling
      from dxDeclarationDismantling di
    left outer join dxDeclaration de on ( de.PK_dxDeclaration = di.FK_dxDeclaration )
    left outer join dxProduct     pr on ( pr.PK_dxProduct = di.FK_dxProduct )
    where Not di.FK_dxProduct is null
      and (pr.InventoryItem = 1)
      and (di.ReworkRequired = 1) -- Exclude MTO Client Orders
      and (de.Posted = 1)
      and (di.Posted = 1)
      and PK_dxDeclarationDismantling = @PK_dxDeclarationDismantling
      and Not exists ( Select 1 from dxWorkOrder wo where wo.FK_dxDeclarationDismantling = @PK_dxDeclarationDismantling )
end
GO
