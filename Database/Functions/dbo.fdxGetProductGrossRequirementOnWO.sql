SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetProductGrossRequirementOnWO] ( @FK_dxProduct int )
returns float
as
begin
Return (
Select
      Coalesce(Round(Sum((QuantityToProduce-ProducedQuantity) * ad.NetQuantity * (100+ad.PctOfWasteQuantity)/100.0),4),0.0)
  from dxWorkOrder wo
      left join dxAssembly aa       on ( aa.FK_dxProduct = wo.FK_dxProduct )
      left join dxAssemblyDetail ad on (aa.PK_dxAssembly = ad.FK_dxAssembly)
      left join dxProduct  pr       on (pr.PK_dxProduct  = ad.FK_dxProduct )
      where aa.PK_dxAssembly = dbo.fdxGetCurrentAssembly(  aa.FK_dxProduct , wo.WorkOrderDate )
        and ad.NetQuantity > 0.0
        and wo.WorkOrderStatus between 1 and 3
        and (wo.QuantityToProduce - wo.ProducedQuantity) > 0
        and ad.FK_dxProduct = @FK_dxProduct
   )
end
GO
