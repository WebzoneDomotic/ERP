SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetPlannedExpedition] ( @FK_dxProduct int , @Date Datetime )
returns float
-- GetPlanned Expedition
AS
BEGIN  
   Return 
   Coalesce(( Select Coalesce(SUM(cd.ProductQuantity - cd.ShippedQuantity),0.0) from dxClientOrderDetail cd
                        left outer join dxClientOrder co on ( co.PK_dxClientOrder = cd.FK_dxClientOrder )
                        where  co.Posted = 1
                          and  cd.FK_dxProduct = @FK_dxProduct
                          and  cd.closed = 0 and (cd.ProductQuantity - cd.ShippedQuantity) > 0.0
                          and  co.ExpectedDeliveryDate = @Date),0.0)
END
GO
